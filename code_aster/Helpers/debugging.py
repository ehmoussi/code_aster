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

# person_in_charge: mathieu.courtois@edf.fr

"""
:py:mod:`debugging` --- Debugging utilities
*******************************************

This module defines some convenient utilities that **are not intended to
be used in production**.

Check for dependency between datastructures
===========================================

To enable a hook called after each command add this line
in :file:`code_aster/Commands/operator.py`:

.. code-block:: python

    # replace "hook_function" by the function to be used
    from ..Helpers.debugging import hook_function
    ExecuteCommand.register_hook(hook_function)

"""

import os
import os.path as osp
import re

from ..Cata.Language.SyntaxUtils import force_list
from ..Objects import DataStructure
from .LogicalUnit import LogicalUnitFile

SKIPPED = object()


class DataStructureFilter:
    """This object store the path to *DataStructure* objects that are
    referenced in a dump.

    Arguments:
        current (str): Name of the current result.
        dump (str): Text dump of a *DataStructure*.
    """

    def __init__(self, current, dump):
        """Initialization"""
        self._parent_context = []
        self._current = current
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
            if (isinstance(i, DataStructure) and i.getName() != self._current
                    and i.getName() in self._dump):
                keep.append(i)
        if keep and not islist:
            keep = keep[0]
        self._keep = keep or SKIPPED

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
            for key, value in userOcc.items():
                self._path.append(key)
                # NB: block conditions are evaluated with the original values
                kwd = step.getKeyword(key, userOrig, ctxt)
                if not kwd:
                    continue
                kwd.accept(self, value)
                if self._keep is not None:
                    if self._keep is not SKIPPED:
                        self.paths.append(self._path[:])
                    self._keep = None
                self._path.pop(-1)


def dump_datastructure(obj):
    """Return a dump (IMPR_CO) of a *DataStructure*.

    Arguments:
        obj (DataStructure): Object to be dumped.

    Returns:
        str: Output of IMPR_CO/debugPrint.
    """
    filename = "dump-27406.txt"
    dumpfile = LogicalUnitFile.open(filename)
    obj.debugPrint(dumpfile.unit)
    dumpfile.release()
    with open(filename, "rb") as fobj:
        dump = fobj.read().decode('ascii', errors='replace')
    os.remove(filename)
    return dump


def track_dependencies(inst, keywords):
    """Hook that tracks commands dependencies.

    Arguments:
        inst (function): the *ExecuteCommand* instance.
        keywords (dict): User keywords.
    """
    cata = inst._cata
    result = inst._result
    if not isinstance(result, DataStructure):
        return

    dump = dump_datastructure(result)
    visitor = DataStructureFilter(result.getName(), dump)
    cata.accept(visitor, keywords)
    if not visitor.paths:
        return

    paths = ["/".join(path) for path in visitor.paths]
    print("#27406:", inst.command_name, " ".join(paths))


def check_dependencies(inst, _):
    """Hook that check dependencies

    Arguments:
        inst (function): the *ExecuteCommand* instance.
    """
    if not hasattr(check_dependencies, "_storage"):
        check_dependencies._storage = {}

    result = inst._result
    if not isinstance(result, DataStructure):
        return

    # keep all created DS
    # TODO use regular expression instead '[0-9a-f]{8}'
    # and check if they still exist?
    name = result.getName()
    typ = result.getType()
    if not check_dependencies._storage.get(name):
        check_dependencies._storage[name] = typ

    def _check_deps(stack, obj):
        """Push dependencies of `obj` in `stack` recursively."""
        for dep in obj.getDependencies():
            if dep not in stack:
                stack.append(dep)
                _check_deps(stack, dep)

    deps = []
    _check_deps(deps, result)
    # print("#27406:", name, typ, len(deps))
    all_deps = [i.getName() for i in deps]

    dump = dump_datastructure(result)
    dump_deps = [i for i in check_dependencies._storage.keys()
                 if i != name and i in dump]
    direct_deps = [i.getName() for i in result.getDependencies()]

    printed = False
    missed = sorted(list(set(dump_deps).difference(direct_deps)))
    if missed:
        missed_all = sorted(list(set(dump_deps).difference(all_deps)))
        missed = sorted(list(set(missed).difference(missed_all)))
        printed = True
        if missed:
            print("#27406:", name, typ, "missing direct dep to", missed,
                  "current:", direct_deps)
        if missed_all:
            print("#27406:", name, typ, "ERROR missing recursive dep to", missed_all)
        # else:
        #     print("#27406:", name, typ, "INFO direct deps:", direct_deps)
    nodirect = sorted(list(set(direct_deps).difference(dump_deps)))
    if nodirect:
        printed = True
        print("#27406:", name, typ, "unnecessary direct dep to", nodirect)
    if not printed:
        print("#27406:", name, typ)


# used to force to show children commands
# from ..Utilities import ExecutionParameter, Options
# ExecutionParameter().enable(Options.ShowChildCmd)
