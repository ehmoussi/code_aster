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

from Contrib.calc_forc_ajou import CALC_FORC_AJOU as CATA_CALC_FORC_AJOU

from ..Objects import GeneralizedAssemblyVectorDouble
from .ExecuteCommand import ExecuteCommand


class CalcForcAjou(ExecuteCommand):
    """Command that defines aclass:`~code_aster.Objects.GeneralizedAssemblyVectorDouble`
    """
    command_name = "CALC_FORC_AJOU"
    command_cata = CATA_CALC_FORC_AJOU

    def create_result(self, keywords):
        """Initialize the result.

        Arguments:
            keywords (dict): Keywords arguments of user's keywords.
        """
        self._result = GeneralizedAssemblyVectorDouble()


CALC_FORC_AJOU = CalcForcAjou.run
