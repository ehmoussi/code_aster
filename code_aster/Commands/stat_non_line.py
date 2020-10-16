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

from ..Objects import NonLinearResult
from ..Supervis import ExecuteCommand


class NonLinearStaticAnalysis(ExecuteCommand):
    """Command that defines :class:`~code_aster.Objects.NonLinearResult`.
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
            self._result = NonLinearResult()

    def post_exec(self, keywords):
        """Execute the command.

        Arguments:
            keywords (dict): User's keywords.
        """
        self._result.appendModelOnAllRanks(keywords["MODELE"])
        self._result.appendMaterialFieldOnAllRanks(keywords["CHAM_MATER"])
        caraElem = keywords.get("CARA_ELEM")
        if caraElem is not None:
            self._result.appendElementaryCharacteristicsOnAllRanks(caraElem)

        if self.exception and self.exception.id_message in ("MECANONLINE5_2", ):
            return
        self._result.update()

    def add_dependencies(self, keywords):
        """Register input *DataStructure* objects as dependencies.

        Arguments:
            keywords (dict): User's keywords.
        """
        super().add_dependencies(keywords)
        self.remove_dependencies(keywords, "RESULTAT")
        self.remove_dependencies(keywords, "ETAT_INIT",
                                 ("DEPL", "SIGM", "VARI", "STRX", "COHE",
                                  "VITE", "ACCE", "EVOL_NOLI"))


STAT_NON_LINE = NonLinearStaticAnalysis.run
