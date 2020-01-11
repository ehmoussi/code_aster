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

from ..Objects import (EvolutiveLoad, EvolutiveThermalLoad,
                       FieldOnNodesComplex, FieldOnNodesDouble,
                       FourierElasContainer, FourierTherContainer,
                       FullHarmonicResultsContainer,
                       FullTransientResultsContainer,
                       InputVariableEvolutionContainer,
                       LinearDisplacementEvolutionContainer,
                       MechanicalModeComplexContainer, MechanicalModeContainer,
                       MultElasContainer, NonLinearEvolutionContainer)
from ..Supervis import ExecuteCommand


class ResultCreator(ExecuteCommand):
    """Command that creates evolutive results."""
    command_name = "CREA_RESU"

    def create_result(self, keywords):
        """Initialize the result.

        Arguments:
            keywords (dict): Keywords arguments of user's keywords.
        """
        if "reuse" in keywords:
            self._result = keywords["reuse"]
        else:
            typ = keywords["TYPE_RESU"]
            if typ == "EVOL_CHAR":
                self._result = EvolutiveLoad()
            elif typ == "EVOL_THER":
                self._result = EvolutiveThermalLoad()
            elif typ == "EVOL_NOLI":
                self._result = NonLinearEvolutionContainer()
            elif typ == "EVOL_ELAS":
                self._result = LinearDisplacementEvolutionContainer()
            elif typ == "EVOL_VARC":
                self._result = InputVariableEvolutionContainer()
            elif typ == "FOURIER_ELAS":
                self._result = FourierElasContainer()
            elif typ == "FOURIER_THER":
                self._result = FourierElasContainer()
            elif typ == "MULT_ELAS":
                self._result = MultElasContainer()
            elif typ == "MODE_MECA":
                self._result = MechanicalModeContainer()
            elif typ == "MODE_MECA_C":
                self._result = MechanicalModeComplexContainer()
            elif typ == "DYNA_TRANS":
                self._result = FullTransientResultsContainer()
            elif typ == "DYNA_HARMO":
                self._result = FullHarmonicResultsContainer()
            else:
                raise NotImplementedError("Type of result {0!r} not yet "
                                        "implemented".format(typ))

    def post_exec(self, keywords):
        """Execute the command.

        Arguments:
            keywords (dict): User's keywords.
        """
        fkw = keywords.get("AFFE")
        if fkw is not None:
            if type(fkw) not in (list, tuple): fkw = fkw,
            for occ in fkw:
                chamGd = occ.get("CHAM_GD")
                if chamGd is not None:
                    isFieldOnNodesDouble = isinstance(chamGd, FieldOnNodesDouble)
                    isFieldOnNodesComplex = isinstance(chamGd, FieldOnNodesComplex)
                    if isFieldOnNodesDouble or isFieldOnNodesComplex:
                        mesh = chamGd.getMesh()
                        if mesh is not None:
                            self._result.setMesh(mesh)
                            break
        if fkw is None:
            fkw = keywords.get("ASSE")
        if fkw is None:
            fkw = keywords.get("PREP_VRC2")
        if fkw is None:
            fkw = keywords.get("PREP_VRC1")
        if fkw is not None:
            chamMater = fkw[0].get("CHAM_MATER")
            if chamMater is not None:
                self._result.appendMaterialOnMeshOnAllRanks(chamMater)

            modele = fkw[0].get("MODELE")
            chamGd = fkw[0].get("CHAM_GD")
            if modele is not None:
                self._result.appendModelOnAllRanks(modele)
            else:
                if chamGd is not None:
                    try:
                        modele = chamGd.getModel()
                        self._result.appendModelOnAllRanks(modele)
                    except:
                        pass
                    try:
                        mesh = chamGd.getMesh()
                        self._result.setMesh(mesh)
                    except:
                        pass

        self._result.update()


CREA_RESU = ResultCreator.run
