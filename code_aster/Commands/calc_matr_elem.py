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

from ..Objects import ElementaryMatrix
from .ExecuteCommand import ExecuteCommand

class ComputeElementaryMatrix(ExecuteCommand):
    """Command that creates evolutive results."""
    command_name = "CALC_MATR_ELEM"

    def create_result(self, keywords):
        """Initialize the result.

        Arguments:
            keywords (dict): Keywords arguments of user's keywords.
        """
        myOption=keywords["OPTION"]
        if myOption == "RIGI_MECA"        : myType = "DEPL_R"
        elif myOption == "RIGI_FLUI_STRU"   : myType = "DEPL_R"
        elif myOption == "MASS_MECA"        : myType = "DEPL_R"
        elif myOption == "MASS_FLUI_STRU"   : myType = "DEPL_R"
        elif myOption == "RIGI_GEOM"        : myType = "DEPL_R"
        elif myOption == "RIGI_ROTA"        : myType = "DEPL_R"
        elif myOption == "MECA_GYRO"        : myType = "DEPL_R"
        elif myOption == "RIGI_GYRO"        : myType = "DEPL_R"
        elif myOption == "AMOR_MECA"        : myType = "DEPL_R"
        elif myOption == "IMPE_MECA"        : myType = "DEPL_R"
        elif myOption == "ONDE_FLUI"        : myType = "DEPL_R"
        elif myOption == "AMOR_MECA_ABSO"   : myType = "DEPL_R"
        elif myOption == "RIGI_MECA_HYST"   : myType = "DEPL_C"
        elif myOption == "RIGI_THER"        : myType = "TEMP_R"
        elif myOption == "MASS_THER"        : myType = "TEMP_R"
        elif myOption == "MASS_MECA_DIAG"   : myType = "DEPL_R"
        elif myOption == "RIGI_ACOU"        : myType = "PRES_C"
        elif myOption == "MASS_ACOU"        : myType = "PRES_C"
        elif myOption == "AMOR_ACOU"        : myType = "PRES_C"

        self._result=ElementaryMatrix.create(myType)

CALC_MATR_ELEM = ComputeElementaryMatrix.run
