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
            assert typ in ("TABLE", "TABLE_CONTAINER", "TABLE_FONCTION"), typ
            if typ == "TABLE_FONCTION":
                self._result = TableOfFunctions()
            elif typ == "TABLE_CONTAINER":
                self._result = TableContainer()
            else:
                self._result = Table()

    def add_dependencies(self, keywords):
        """Register input *DataStructure* objects as dependencies.

        Arguments:
            keywords (dict): User's keywords.
        """
        super().add_dependencies(keywords)
        if keywords.get("RESU"):
            occ = keywords["RESU"]
            if occ.get("CHAM_GD"):
                self._result.removeDependency(occ["CHAM_GD"])
            if occ.get("RESULTAT"):
                self._result.removeDependency(occ["RESULTAT"])


CREA_TABLE = TableCreation.run
