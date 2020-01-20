# coding=utf-8
#
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

# person_in_charge: mathieu.courtois at edf.fr
# person_in_charge: mathieu.courtois@edf.fr

from ..Objects import Table, TableContainer, TableOfFunctions
from ..Supervis import ExecuteCommand


class TableCreation(ExecuteCommand):
    """Execute legacy operator CREA_TABLE."""
    command_name = "CREA_TABLE"

    def create_result(self, keywords):
        """Create the result.

        Arguments:
            keywords (dict): Keywords arguments of user's keywords.
        """
        reuse = keywords.get("reuse")
        if reuse is not None:
            self._result = reuse
        else:
            typ = keywords["TYPE_TABLE"]
            if typ == "TABLE_FONCTION":
                self._result = TableOfFunctions()
            elif typ == "TABLE_CONTENEUR":
                self._result = TableContainer()
            else:
                self._result = Table()

CREA_TABLE = TableCreation.run
