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

from ..Objects import FieldOnElementsDouble, MatchingMeshes
from ..Supervis import ExecuteCommand


class FieldProjector(ExecuteCommand):
    """Command that allows to project fields."""
    command_name = "PROJ_CHAMP"

    def create_result(self, keywords):
        """Initialize the result.

        Arguments:
            keywords (dict): Keywords arguments of user's keywords.
        """
        methode = keywords.get("METHODE")
        resultat = keywords.get("RESULTAT")
        chamGd = keywords.get("CHAM_GD")
        if resultat is None and chamGd is None:
            self._result = MatchingMeshes()
            return
        if resultat is not None:
            self._result = type(keywords["RESULTAT"])()
            return
        if chamGd != None and methode == "SOUS_POINT":
            self._result = FieldOnElementsDouble()
            return
        else:
            self._result = type(chamGd)()
            return
        raise NameError("Type not allowed")

    def post_exec(self, keywords):
        """Execute the command.

        Arguments:
            keywords (dict): User's keywords.
        """
        dofNum = keywords.get("NUME_DDL")
        if dofNum is not None:
            self._result.addFieldOnNodesDescription(dofNum.getFieldOnNodesDescription())

        if "RESULTAT" in keywords:
            if "MODELE_2" in keywords:
                self._result.appendModelOnAllRanks(keywords["MODELE_2"])
            if "MAILLAGE_2" in keywords:
                self._result.setMesh(keywords["MAILLAGE_2"])
            self._result.update()
        elif "CHAM_GD" in keywords:
            pass
        else:
            if "MAILLAGE_1" in keywords:
                self._result.setFirstMesh(keywords["MAILLAGE_1"])



PROJ_CHAMP = FieldProjector.run
