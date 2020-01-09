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

from ..Objects import (FullHarmonicResultsContainer,
                       FullTransientResultsContainer, MechanicalModeContainer,
                       NonLinearEvolutionContainer)
from ..Supervis.ExecuteCommand import ExecuteCommand


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
        if resu_gene is not None:
            if resu_gene.getType() == "TRAN_GENE":
                self._result = FullTransientResultsContainer()
            if resu_gene.getType() == "MODE_GENE":
                self._result = MechanicalModeContainer()
            if resu_gene.getType() == "MODE_CYCL":
                self._result = MechanicalModeContainer()
            if resu_gene.getType() == "HARM_GENE":
                self._result = FullHarmonicResultsContainer()

        if resultat is not None:
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
        resuGene = keywords.get("RESU_GENE")
        squelette = keywords.get("SQUELETTE")

        if sousStruc is not None:
            if resuGene is not None:
                dofNum = resuGene.getGeneralizedDOFNumbering()
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
                        modele = mat.getDOFNumbering().getModel()
                        self._result.appendModelOnAllRanks(modele)
        elif squelette is not None:
            self._result.setMesh(squelette)



REST_SOUS_STRUC = RestSousStrucOper.run
