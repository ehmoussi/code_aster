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

from ..Objects import (AssemblyMatrixDisplacementComplex,
                       AssemblyMatrixDisplacementReal,
                       AssemblyMatrixPressureComplex,
                       AssemblyMatrixTemperatureReal,
                       ElementaryMatrixDisplacementComplex,
                       ElementaryMatrixDisplacementReal,
                       ElementaryMatrixPressureComplex,
                       ElementaryMatrixTemperatureReal)
from ..Supervis import ExecuteCommand


class AssembleMatrixOperator(ExecuteCommand):
    """Execute legacy operator ASSE_MATRICE."""
    command_name = "ASSE_MATRICE"

    def create_result(self, keywords):
        """Create the result.

        Arguments:
            keywords (dict): Keywords arguments of user's keywords.
        """
        matrElem = keywords['MATR_ELEM']
        if isinstance(matrElem, ElementaryMatrixDisplacementReal):
            self._result = AssemblyMatrixDisplacementReal()
        elif isinstance(matrElem, ElementaryMatrixDisplacementComplex):
            self._result = AssemblyMatrixDisplacementComplex()
        elif isinstance(matrElem, ElementaryMatrixTemperatureReal):
            self._result = AssemblyMatrixTemperatureReal()
        elif isinstance(matrElem, ElementaryMatrixPressureComplex):
            self._result = AssemblyMatrixPressureComplex()
        else:
            raise TypeError("Type not authorized")

    def post_exec(self, keywords):
        """Store references to ElementaryMatrix objects.

        Arguments:
            keywords (dict): Keywords arguments of user's keywords, changed
                in place.
        """
        self._result.appendElementaryMatrix(keywords['MATR_ELEM'])
        self._result.setDOFNumbering(keywords['NUME_DDL'])

ASSE_MATRICE = AssembleMatrixOperator.run
