# coding: utf-8

# Copyright (C) 1991 - 2018  EDF R&D                www.code-aster.org
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

from ..Objects import FullTransientResultsContainer
from ..Objects import FullHarmonicResultsContainer
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
        base = keywords["BASE_CALCUL"]
        typ  = keywords["TYPE_CALCUL"]
        if base == "PHYS" and typ == "TRAN":
            self._result = FullTransientResultsContainer()
        elif base == "PHYS" and typ == "HARM":
            self._result = FullHarmonicResultsContainer()
        elif base == "GENE" and typ == "TRAN":
            self._result = TransientGeneralizedResultsContainer()
        elif base == "GENE" and typ == "HARM":
            self._result = HarmoGeneralizedResultsContainer()
        else:
            raise NotImplementedError("Types of analysis {0!r} and {0!r} not yet "
                                      "implemented".format(typ, base))

    def post_exec(self, keywords):
        """Execute the command.

        Arguments:
            keywords (dict): User's keywords.
        """
        if keywords["BASE_CALCUL"] == "PHYS":
            self._result.appendModelOnAllRanks(keywords["MATR_MASS"].getDOFNumbering().getSupportModel())
            self._result.update()
        if keywords["BASE_CALCUL"] == "GENE":
            dofNum = keywords["MATR_RIGI"].getGeneralizedDOFNumbering()
            if isinstance(self._result, HarmoGeneralizedResultsContainer):
                self._result.setGeneralizedDOFNumbering(dofNum)


DYNA_VIBRA = VibrationDynamics.run
