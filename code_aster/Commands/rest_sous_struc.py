# coding: utf-8

# Copyright (C) 1991 - 2017  EDF R&D                www.code-aster.org
#
# This file is part of Code_Aster.
#
# Code_Aster is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 2 of the License, or
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

from ..Objects import FullTransientResultsContainer, MechanicalModeContainer
from ..Objects import NonLinearEvolutionContainer
from .ExecuteCommand import ExecuteCommand


class RestSousStrucOper(ExecuteCommand):
    """Command that allows to project fields."""
    command_name = "REST_SOUS_STRUC"

    def create_result(self, keywords):
        """Initialize the result.

        Arguments:
            keywords (dict): Keywords arguments of user's keywords.
        """
        resu_gene = keywords.get("RESU_GENE")
        resultat = keywords.get("RESULTAT")
        if resu_gene != None:
            if resu_gene.getType() == "TRAN_GENE":
                self._result = FullTransientResultsContainer()
            if resu_gene.getType() == "MODE_GENE":
                self._result = MechanicalModeContainer()
            if resu_gene.getType() == "MODE_CYCL":
                self._result = MechanicalModeContainer()
            if resu_gene.getType() == "HARM_GENE":
                raise NotImplementedError("Unsupported type")

        if resultat != None:
            if resultat.getType() == "EVOL_NOLI":
                self._result = NonLinearEvolutionContainer()
            if resultat.getType() == "DYNA_TRANS":
                self._result = FullTransientResultsContainer()
            if resultat.getType() == "MODE_MECA":
                self._result = MechanicalModeContainer()


REST_SOUS_STRUC = RestSousStrucOper.run
