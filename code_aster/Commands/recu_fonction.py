# coding=utf-8
#
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

# person_in_charge: mathieu.courtois@edf.fr

from ..Objects import Function
from .ExecuteCommand import ExecuteCommand


class ExtractFunction(ExecuteCommand):
    """Execute legacy operator RECU_FONCTION."""
    command_name = "RECU_FONCTION"

    def create_result(self, keywords):
        """Create the result.

        Arguments:
            keywords (dict): Keywords arguments of user's keywords.
        """
        self._result = Function.create()

RECU_FONCTION = ExtractFunction.run