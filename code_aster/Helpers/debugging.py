# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
# This file is part of code_aster.
#
# code_aster is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# code_aster is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with code_aster.  If not, see <http://www.gnu.org/licenses/>.
# --------------------------------------------------------------------

# person_in_charge: mathieu.courtois at edf.fr

"""
:py:mod:`debugging` --- Debugging utilities
*******************************************

These module defines some convenient utilities that **are not intended to
be used in production**.
"""

import os
import os.path as osp
import re

from ..Cata.Language.SyntaxObjects import _F
from ..Cata.Language.SyntaxUtils import force_list, mixedcopy
from ..Objects import DataStructure
from .LogicalUnit import LogicalUnitFile

DEL = object()


class DataStructureFilter(object):
    """This object store the path to *DataStructure* objects that are
    referenced in a dump.

    Arguments:
        dump (str): Text dump of a *DataStructure*.
    """

    def __init__(self, dump):
        """Initialization"""
        self._parent_context = []
        self._dump = dump
        self._keep = None
        self._path = []
        self.paths = []

    def set_parent_context(self, context):
        """Set the parent context.

        If the checker is directly called on a keyword (without checking the
        command itself) the values defined upper may be required to evaluate
        blocks conditions but the parent context has not been filled.

        This parent context could be an optional argument in visit* functions.
        """
        self._parent_context.append(context)

    def visitCommand(self, step, userDict=None):
        """Visit a Command object"""
        self._parent_context.append(userDict)
        self._visitComposite(step, userDict)
        self._parent_context.pop()

    def visitMacro(self, step, userDict=None):
        """Visit a Macro object"""
        self.visitCommand(step, userDict)

    def visitBloc(self, step, userDict=None):
        """Visit a Bloc object"""
        pass

    def visitFactorKeyword(self, step, userDict=None):
        """Visit a FactorKeyword object"""
        # debug_message2("checking factor with", userDict)
        self._visitComposite(step, userDict)

    def visitSimpleKeyword(self, step, skwValue):
        """Visit a SimpleKeyword object"""
        islist = type(skwValue) in (list, tuple)
        skwValue = force_list(skwValue)
        keep = []
        for i in skwValue:
            if isinstance(i, DataStructure) and i.getName() in self._dump:
                keep.append(i)
        if keep and not islist:
            keep = keep[0]
        self._keep = keep or DEL

    def _visitComposite(self, step, userDict=None):
        """Visit a composite object (containing BLOC, FACT and SIMP objects)
        """
        if isinstance(userDict, dict):
            userDict = [userDict]
        # loop on occurrences filled by the user
        for userOcc in userDict:
            userOrig = userOcc.copy()
            ctxt = self._parent_context[-1] if self._parent_context else {}
            # loop on keywords provided by the user
            todel = []
            for key, value in userOcc.items():
                self._path.append(key)
                if len(self._path) == 2 and type(value) in (list, tuple):
                    self._path.append(len(value))
                # NB: block conditions are evaluated with the original values
                kwd = step.getKeyword(key, userOrig, ctxt)
                if not kwd:
                    continue
                kwd.accept(self, value)
                if self._keep is not None:
                    if self._keep is DEL:
                        todel.append(key)
                    else:
                        self.paths.append(self._path[:])
                        userOcc[key] = self._keep
                    self._keep = None
                if len(self._path) == 3:
                    self._path.pop(-1)
                self._path.pop(-1)
            for key in todel:
                del userOcc[key]


TEMPLATE = '''
    def add_references(self, keywords):
        """Add references to linked *DataStructure* objects.

        Arguments:
            keywords (dict): Keywords arguments of user's keywords.
        """
${references}
'''

REF = " " * 8 + '''self._result.addDependency(${arg})'''


def track_dependencies(inst, keywords):
    """Hook that tracks commands dependencies.

    Arguments:
        inst (function): the *ExecuteCommand* instance.
        keywords (dict): User keywords.

    Returns:
        dict: pairs of name per corresponding Python instance.
    """
    cata = inst._cata
    result = inst._result
    if not result:
        return

    dumpfile = LogicalUnitFile.open("dump.txt")
    result.debugPrint(dumpfile.unit)
    dumpfile.release()
    with open("dump.txt", "r") as fobj:
        dump = fobj.read()

    visitor = DataStructureFilter(dump)
    onlyds = mixedcopy(keywords)
    cata.accept(visitor, onlyds)

    defs = []
    while visitor.paths:
        path = visitor.paths.pop(0)
        key1 = path.pop(0)
        root = 'keywords["{0}"]'.format(key1)
        if not path:
            defs.append(root)
        elif len(path) == 1:
            key2 = path.pop(0)
            defs.append(root + "[{0}]".format(key2))
        else:
            key2, size = path
            for i in range(size):
                defs.append(root + '[{0}]["{1}"]'.format(i, key2))

    print("DBGREF:", defs)
