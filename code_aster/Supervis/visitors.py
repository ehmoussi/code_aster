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

"""
:py:mod:`visitors` --- Visitors of syntax objects
*************************************************

This module provides visitors of syntax objects (commands and keywords).

"""


class EnumVisitor(object):
    """This object automatically replace *enum-like* keywords by their
    numerical values.

    NB: The syntax is supposed to be valid before being called!

    Attributes:
        _parent_context (dict): Context of the parent used to evaluate block
            conditions.
    """

    def __init__(self):
        """Initialization"""
        self._parent_context = []
        self._changed = None

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
        self._changed = None
        enum = step.definition.get('enum')
        typ = step.definition.get('typ')
        if not enum or typ != "TXM":
            return
        into = step.definition.get('into')
        conv = dict(zip(into, enum))
        if isinstance(skwValue, (list, tuple)):
            value = [conv[val_i] for val_i in skwValue]
        else:
            value = conv[skwValue]
        self._changed = value

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
                # NB: block conditions are evaluated with the original values
                kwd = step.getKeyword(key, userOrig, ctxt)
                if not kwd:
                    continue
                kwd.accept(self, value)
                if self._changed is not None:
                    userOcc[key] = self._changed
                    self._changed = None


def replace_enum(command, keywords):
    """Automatically set/replace the user's keywords according to the
    command description.

    NB: The syntax is supposed to be valid before being called!

    As looping on commands keywords may cost and that *enum-like* keywords are
    only used in a few commands, this call has to be added in the *exec_*
    method of these commands.

    Arguments:
        command (Command): Command object to be checked.
        keywords (dict): Dict of keywords.
            *None* values are removed from the user dict.
    """
    visit = EnumVisitor()
    if not isinstance(keywords, dict):
        raise TypeError("'dict' object is expected")
    command.accept(visit, keywords)
