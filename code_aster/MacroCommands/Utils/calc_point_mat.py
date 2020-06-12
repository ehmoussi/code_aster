# coding=utf-8
#
# Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
# This file is part of code_aster.
#
# code_aster is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# code_aster is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with code_aster.  If not, see <http://www.gnu.org/licenses/>.

# person_in_charge: nicolas.sellenet@edf.fr

from ...Objects import Table
from ...Supervis import ExecuteCommand
from .calc_point_mat_cata import CALC_POINT_MAT_CATA


class CalcPointMat(ExecuteCommand):
    """Command that defines a class:`~code_aster.Objects.Table"""
    command_name = "CALC_POINT_MAT"
    command_cata = CALC_POINT_MAT_CATA

    def create_result(self, keywords):
        """Create the result.

        Arguments:
            keywords (dict): Keywords arguments of user's keywords.
        """
        self._result = Table()

CALC_POINT_MAT = CalcPointMat.run
