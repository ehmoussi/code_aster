# coding: utf-8

# Copyright (C) 1991 - 2019  EDF R&D                www.code-aster.org
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

from ..Objects import FullTransientResultsContainer, AssemblyMatrixPressureComplex
from ..Objects import FullAcousticHarmonicResultsContainer, FullHarmonicResultsContainer
from ..Objects import TransientGeneralizedResultsContainer, HarmoGeneralizedResultsContainer
from .ExecuteCommand import ExecuteCommand


class VibrationDynamics(ExecuteCommand):
    """Command to solve linear vibration dynamics problem, on physical or modal bases, for harmonic or transient analysis."""
    command_name = "DYNA_VIBRA"

    def create_result(self, keywords):
        """Initialize the result.

        Arguments:
            keywords (dict): Keywords arguments of user's keywords.
        """
        print("init")
        if keywords.get("reuse") != None:
            self._result = keywords["reuse"]
        else:
            base = keywords["BASE_CALCUL"]
            typ = keywords["TYPE_CALCUL"]
            matrRigi = keywords["MATR_RIGI"]
            if base == "PHYS":
                if typ == "TRAN":
                    self._result = FullTransientResultsContainer()
                    return
                if isinstance(matrRigi, AssemblyMatrixPressureComplex):
                    self._result = FullAcousticHarmonicResultsContainer()
                    return
                self._result = FullHarmonicResultsContainer()
            else:
                if typ == "TRAN":
                    self._result = TransientGeneralizedResultsContainer()
                else:
                    self._result = HarmoGeneralizedResultsContainer()

    def post_exec(self, keywords):
        """Execute the command.

        Arguments:
            keywords (dict): User's keywords.
        """
        print("post")
        if keywords["BASE_CALCUL"] == "PHYS":
            massMatrix = keywords["MATR_MASS"]
            dofn = massMatrix.getDOFNumbering()
            self._result.appendModelOnAllRanks(dofn.getModel())
            self._result.setDOFNumbering(dofn)
            self._result.update()
        if keywords["BASE_CALCUL"] == "GENE":
            stiffnessMatrix = keywords["MATR_RIGI"]
            dofGeneNum = stiffnessMatrix.getGeneralizedDOFNumbering()
            if isinstance(self._result, HarmoGeneralizedResultsContainer) or \
               isinstance(self._result, TransientGeneralizedResultsContainer):
                self._result.setGeneralizedDOFNumbering(dofGeneNum)
            else:
                raise Exception("Unknown result type")


DYNA_VIBRA = VibrationDynamics.run
