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

from ..Objects import NonLinearEvolutionContainer
from ..Supervis import ExecuteCommand


class NonLinearStaticAnalysis(ExecuteCommand):
    """Command that defines :class:`~code_aster.Objects.NonLinearEvolutionContainer`.
    """
    command_name = "STAT_NON_LINE"

    def create_result(self, keywords):
        """Initialize the result.

        Arguments:
            keywords (dict): Keywords arguments of user's keywords.
        """
        if keywords.get("reuse") != None:
            self._result = keywords["reuse"]
        else:
            self._result = NonLinearEvolutionContainer()

    def post_exec(self, keywords):
        """Execute the command.

        Arguments:
            keywords (dict): User's keywords.
        """
        self._result.appendModelOnAllRanks(keywords["MODELE"])
        self._result.appendMaterialOnMeshOnAllRanks(keywords["CHAM_MATER"])
        caraElem = keywords.get("CARA_ELEM")
        if caraElem is not None:
            self._result.appendElementaryCharacteristicsOnAllRanks(caraElem)
        self._result.update()

STAT_NON_LINE = NonLinearStaticAnalysis.run
