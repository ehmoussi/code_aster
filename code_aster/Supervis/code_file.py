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
This module defines the visitor used to print the keywords in the CODE file.
"""

import os

import libaster

from ..Cata.Language.SyntaxObjects import IDS
from ..Cata.SyntaxUtils import value_is_sequence
from ..Objects import DataStructure
from ..Utilities import force_list, is_float, is_int

EMPTY = '--'
FCODE = "fort.15"


def track_coverage(command, name, keywords):
    """Track used keywords into the '.code' file.

    Arguments:
        command (*SyntaxObjects.Command*): Description object of the command
        name (str): Command name
        keywords (dict): Dict of keywords.
    """
    cover = CodeVisitor(name)
    command.accept(cover, keywords)
    libaster.affich('CODE', cover.get_text())


class CodeVisitor:
    """Object that prints the text of the used keywords.

    Default keywords should have been added before.

    Arguments:
        name (str): Command name
    """
    fname = "TEST"

    def __init__(self, name):
        """Initialization"""
        self.cmdname = name
        self.mcfact = EMPTY
        self.mcsimp = None
        self.value = ''
        self.args = []

    def add_args(self):
        """Add the keyword"""
        self.args.append(
            (self.fname, self.cmdname, self.mcfact, self.mcsimp, self.value))

    def get_text(self):
        """Return the text"""
        fmt = '%s %s %s %s %s'
        lines = [fmt % args for args in self.args]
        return os.linesep.join(lines)

    def visitCommand(self, step, userDict=None):
        """Visit a Command object

        Arguments:
            step (*Command*): Command object
            userDict (dict): Keywords
        """
        self._visitComposite(step, userDict)

    def visitMacro(self, step, userDict=None):
        """Visit a Macro object

        Arguments:
            step (*Macro*): Macro object
            userDict (dict): Keywords
        """
        self.visitCommand(step, userDict)

    def visitBloc(self, step, userDict=None):
        """Visit a Bloc object - should not occur

        Arguments:
            step (*Bloc*): Bloc object
            userDict (dict): Keywords
        """
        pass

    def visitFactorKeyword(self, step, userDict=None):
        """Visit a FactorKeyword object

        Arguments:
            step (*Command*): Command object
            userDict (dict): Keywords.
        """
        self._visitComposite(step, userDict)
        self.mcfact = EMPTY

    def visitSimpleKeyword(self, step, skwValue):
        """Visit a SimpleKeyword object

        Arguments:
            step (*SimpleKeyword*): SimpleKeyword object
            skwValue (misc): Keyword value(s)
        """
        if step.definition.get("statut") == "c":
            return
        self.value = ''
        if not value_is_sequence(skwValue):
            skwValue = [skwValue]
        as_list = step.is_list() and step.definition.get("into") is not None
        svalues = []
        is_default = True
        default = step.definition.get("defaut")
        for value in skwValue:
            repr_value = ''
            if is_float(value):
                repr_value = str(value)
            elif is_int(value):
                repr_value = str(value)
            elif type(value) in (str, str):
                repr_value = repr(value)
            svalues.append(repr_value)
            try:
                if value != default:
                    is_default = False
            except ValueError:
                pass
        if as_list and len(svalues) == 1:
            svalues.append("")
        self.value = ", ".join(svalues)
        if as_list:
            self.value = "(%s)" % self.value
        if step.definition.get("into") is None:
            if not is_default:
                self.value = ''
        self.add_args()

    def _visitComposite(self, step, userDict):
        """Loop of subobjects contained in a composite object  (containing BLOC,
        FACT and SIMP objects).

        Arguments:
            step (misc): a composite object
            userDict (dict): Keywords
        """
        if step.undefined(userDict):
            return
        if isinstance(userDict, dict):
            userDict = [userDict]
        elif isinstance(userDict, (list, tuple)):
            pass
        else:
            raise TypeError("Type 'dict' or 'tuple' is expected")

        for userOcc in userDict:
            for key, value in userOcc.items():
                kwd = step.getKeyword(key, userOcc)
                if kwd.getCataTypeId() == IDS.simp:
                    self.mcsimp = key
                elif kwd.getCataTypeId() == IDS.fact:
                    self.mcfact = key
                else:
                    raise TypeError(type(kwd))
                kwd.accept(self, value)
