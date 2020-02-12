# coding=utf-8
# --------------------------------------------------------------------
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
# --------------------------------------------------------------------

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

from ..Objects import (AsFloat, AsInteger, ElementaryMatrixDisplacementReal,
                       ElementaryMatrixTemperatureReal,
                       ElementaryVectorDisplacementReal,
                       ElementaryVectorTemperatureReal,
                       FieldOnCellsReal, FieldOnNodesReal, Function,
                       FunctionComplex, GeneralizedAssemblyMatrixReal,
                       DataField, ModeResult,
                       PCFieldOnMeshReal, Surface, Table)
from ..Supervis import ExecuteCommand


class ExtrTable(ExecuteCommand):
    """Command that defines :class:`~code_aster.Objects.Function`.
    """
    command_name = "EXTR_TABLE"

    def create_result(self, keywords):
        """Initialize the result.

        Arguments:
            keywords (dict): Keywords arguments of user's keywords.
        """
        typeResu = keywords['TYPE_RESU']
        if typeResu == 'VECT_ELEM_DEPL_R':
            self._result = ElementaryVectorDisplacementReal()
        elif typeResu == 'VECT_ELEM_TEMP_R':
            self._result = ElementaryVectorTemperatureReal()
        elif typeResu == 'FONCTION_SDASTER':
            self._result = Function()
        elif typeResu == 'FONCTION_C':
            self._result = FunctionComplex()
        elif typeResu == 'TABLE_SDASTER':
            self._result  = Table()
        elif typeResu == 'MATR_ASSE_GENE_R':
            self._result = GeneralizedAssemblyMatrixReal()
        elif typeResu == 'MATR_ELEM_DEPL_R':
            self._result = ElementaryMatrixDisplacementReal()
        elif typeResu == 'MATR_ELEM_TEMP_R':
            self._result = ElementaryMatrixTemperatureReal()
        elif typeResu == 'NAPPE_SDASTER':
            self._result = Surface()
        elif typeResu == 'MODE_MECA':
            self._result = ModeResult()
        elif typeResu == 'CARTE_SDASTER':
            self._result = PCFieldOnMeshReal()
        elif typeResu == 'CHAM_ELEM':
            self._result = FieldOnCellsReal()
        elif typeResu == 'CHAM_NO_SDASTER':
            self._result = FieldOnNodesReal()
        elif typeResu == 'CHAM_GD_SDASTER':
            self._result = DataField()
        elif typeResu == 'ENTIER':
            self._result = AsInteger()
        elif typeResu == 'REEL':
            self._result = AsFloat()
        else:
            raise NotImplementedError()

EXTR_TABLE = ExtrTable.run
