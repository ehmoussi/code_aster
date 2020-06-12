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


class ExtrResu(ExecuteCommand):
    """Command EXTR_RESU
    """
    command_name = "EXTR_RESU"

    def create_result(self, keywords):
        """Initialize the result.

        Arguments:
            keywords (dict): Keywords arguments of user's keywords.
        """
        if keywords["RESULTAT"].getType() == "EVOL_ELAS":
            self._result = type(keywords["RESULTAT"])()
        else:
            self._result = type(keywords["RESULTAT"])()

    def post_exec(self, keywords):
        """Execute the command.

        Arguments:
            keywords (dict): User's keywords.
        """
        resultat = keywords["RESULTAT"]
        if resultat != None:
            if resultat.getModel() is not None:
                self._result.appendModelOnAllRanks(resultat.getModel())
            if resultat.getMaterialField() is not None:
                self._result.appendMaterialFieldOnAllRanks(resultat.getMaterialField())
            self._result.update()

EXTR_RESU = ExtrResu.run
