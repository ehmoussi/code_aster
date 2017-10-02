# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
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

from ..Cata.Commands import commandStore
from ..Cata.Syntax import Operator, Procedure
from .ExecuteCommand import ExecuteCommand

def define_operators(store):
    """Add definition of operators to the given store."""
    for name, command in commandStore.items():
        if store.has_key(name):
            continue
        if not isinstance(command, (Operator, Procedure)):
            continue
        store[name] = ExecuteCommand(name)
