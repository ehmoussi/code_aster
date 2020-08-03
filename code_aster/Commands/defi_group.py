# coding: utf-8

# Copyright (C) 1991 - 2020  EDF R&D                www.code-aster.org
#
# This file is part of Code_Aster.
#
# Code_Aster is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Code_Aster is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Code_Aster.  If not, see <http://www.gnu.org/licenses/>.

# person_in_charge: nicolas.sellenet@edf.fr

from ..Supervis import ExecuteCommand
from ..Objects import ParallelMesh


class GroupDefinition(ExecuteCommand):
    """Command that defines additional groups on a
    :class:`~code_aster.Objects.Mesh`."""
    command_name = "DEFI_GROUP"

    def create_result(self, keywords):
        """Initialize the result.

        Arguments:
            keywords (dict): Keywords arguments of user's keywords.
        """
        if keywords.get("MAILLAGE"):
            self._result = keywords["MAILLAGE"]
        elif keywords.get("GRILLE"):
            self._result = keywords["GRILLE"]

    def post_exec(self, keywords):
        """Execute the command.

        Arguments:
            keywords (dict): User's keywords.
        """
        if isinstance(self._result, ParallelMesh):
            self._result._updateGlobalGroupOfCells()
            self._result._updateGlobalGroupOfNodes()



DEFI_GROUP = GroupDefinition.run
