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

from ..Objects import TableContainer
from .ExecuteCommand import ExecuteCommand


class CalcCorrSsd(ExecuteCommand):
    """ """
    command_name = "CALC_CORR_SSD"

    def create_result(self, keywords):
        """Initialize the result.

        Arguments:
            keywords (dict): Keywords arguments of user's keywords.
        """
        self._result = TableContainer()

    def post_exec(self, keywords):
        """Post exec of the command.

        Arguments:
            keywords (dict): User's keywords.
        """
        self._result.update()


CALC_CORR_SSD = CalcCorrSsd.run
