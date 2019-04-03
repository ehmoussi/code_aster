# coding: utf-8

# Copyright (C) 1991 - 2019  EDF R&D                www.code-aster.org
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
from ..Objects import NonLinearEvolutionContainer, FullHarmonicResultsContainer
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
                self._result = FullHarmonicResultsContainer()

        if resultat != None:
            if resultat.getType() == "EVOL_NOLI":
                self._result = NonLinearEvolutionContainer()
            if resultat.getType() == "DYNA_TRANS":
                self._result = FullTransientResultsContainer()
            if resultat.getType() == "MODE_MECA":
                self._result = MechanicalModeContainer()

    def post_exec(self, keywords):
        """Execute the command.

        Arguments:
            keywords (dict): User's keywords.
        """
        sousStruc = keywords.get("SOUS_STRUC")
        if sousStruc is not None:
            resuGene = keywords.get("RESU_GENE")
            if resuGene is not None:
                dofNum = resuGene.getGeneralizedDOFNumbering()
                print(dofNum.getName())
                modeleGene = dofNum.getGeneralizedModel()
                if modeleGene is not None:
                    macroElem = modeleGene.getDynamicMacroElementFromName(sousStruc)
                    mat = macroElem.getDampingMatrix()
                    if mat is None: mat = macroElem.getImpedanceDampingMatrix()
                    if mat is None: mat = macroElem.getImpedanceMatrix()
                    if mat is None: mat = macroElem.getImpedanceMassMatrix()
                    if mat is None: mat = macroElem.getImpedanceStiffnessMatrix()

                    if mat is None: mat = macroElem.getMassMatrix()
                    if mat is None: mat = macroElem.getComplexStiffnessMatrix()
                    if mat is None: mat = macroElem.getDoubleStiffnessMatrix()
                    if mat is not None:
                        modele = mat.getDOFNumbering().getSupportModel()
                        self._result.appendModelOnAllRanks(modele)


REST_SOUS_STRUC = RestSousStrucOper.run
