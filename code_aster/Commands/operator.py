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
:py:mod:`operator` --- Generic operators
****************************************

The function :py:func:`define_operators` automatically creates executors objects
(:py:class:`~code_aster.Commands.ExecuteCommand.ExecuteCommand` or
:py:class:`~code_aster.Commands.ExecuteCommand.ExecuteMacro`) for operators that
are not already defined in the store.

It is mainly a transtional feature that should make work most of the *legacy*
command with few changes.
"""

from ..Cata.Commands import commandStore
from ..Cata.Syntax import Macro, Operator, Procedure
from ..Supervis.ExecuteCommand import ExecuteCommand, ExecuteMacro

UNSUPPORTED = ('FORMULE', )

def define_operators(store):
    """Add definition of operators to the given store.

    Arguments:
        store (dict): Store where the executors will be registered.
    """
    def legacy_command_factory(class_, name):
        class InheritedCommand(class_):
            """Execute legacy operator."""
            command_name = name

        return InheritedCommand.run

    for name, command in list(commandStore.items()):
        if name in store:
            continue
        if name in UNSUPPORTED:
            continue
        if isinstance(command, (Operator, Procedure)):
            store[name] = legacy_command_factory(ExecuteCommand, name)
        elif isinstance(command, Macro):
            store[name] = legacy_command_factory(ExecuteMacro, name)
