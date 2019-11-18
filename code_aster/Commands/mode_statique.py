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

# person_in_charge: guillaume.drouet@edf.fr

from ..Objects import MechanicalModeContainer
from .ExecuteCommand import ExecuteCommand


class StaticModeCalculation(ExecuteCommand):
    """Command that computes static modes."""
    command_name = "MODE_STATIQUE"

    def create_result(self, keywords):
        """Initialize the solver object. The result will be created by *exec*.

        Arguments:
            keywords (dict): Keywords arguments of user's keywords.
        """
        self._result = MechanicalModeContainer()

    def post_exec(self, keywords):
        """Execute the command.

        Arguments:
            keywords (dict): User's keywords.
        """
        matrRigi = keywords["MATR_RIGI"]
        dofNum = matrRigi.getDOFNumbering()
        self._result.appendModelOnAllRanks(dofNum.getModel())

MODE_STATIQUE = StaticModeCalculation.run
