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

from ..Objects import (ElementaryMatrixDisplacementComplex,
                       ElementaryMatrixDisplacementReal,
                       ElementaryMatrixPressureComplex,
                       ElementaryMatrixTemperatureReal)
from ..Supervis import ExecuteCommand


class ComputeElementaryMatrix(ExecuteCommand):

    """Command that creates evolutive results."""
    command_name = "CALC_MATR_ELEM"

    def create_result(self, keywords):
        """Initialize the result.

        Arguments:
            keywords (dict): Keywords arguments of user's keywords.
        """
        myOption = keywords["OPTION"]
        if myOption in ('AMOR_MECA', 'AMOR_MECA_ABSO', 'IMPE_MECA',
                        'MASS_FLUI_STRU', 'MASS_MECA', 'MASS_MECA_DIAG',
                        'MECA_GYRO', 'ONDE_FLUI', 'RIGI_FLUI_STRU', 'RIGI_GEOM',
                        'RIGI_GYRO', 'RIGI_MECA', 'RIGI_ROTA'):
            self._result = ElementaryMatrixDisplacementReal()
        elif myOption == "RIGI_MECA_HYST":
            self._result = ElementaryMatrixDisplacementComplex()
        elif myOption in ("RIGI_THER", "MASS_THER"):
            self._result = ElementaryMatrixTemperatureReal()
        elif myOption in ("RIGI_ACOU", "MASS_ACOU", "AMOR_ACOU"):
            self._result = ElementaryMatrixPressureComplex()

    def post_exec(self, keywords):
        """Store references to ElementaryMatrix objects.

        Arguments:
            keywords (dict): Keywords arguments of user's keywords, changed
                in place.
        """
        self._result.setModel(keywords['MODELE'])
        charge = keywords.get("CHARGE")
        if charge is not None:
            for curLoad in charge:
                curFED = curLoad.getFiniteElementDescriptor()
                self._result.addFiniteElementDescriptor(curFED)
        chamMater = keywords.get("CHAM_MATER")
        if chamMater is not None:
            self._result.setMaterialField(chamMater)
        self._result.update()

CALC_MATR_ELEM = ComputeElementaryMatrix.run
