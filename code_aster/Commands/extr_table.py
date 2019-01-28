# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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

from ..Objects import Function, FunctionComplex, Surface
from ..Objects import ElementaryVectorDisplacementDouble, ElementaryVectorTemperatureDouble
from ..Objects import Table
from ..Objects import GeneralizedAssemblyMatrixDouble
from ..Objects import ElementaryMatrixDisplacementDouble, ElementaryMatrixTemperatureDouble
from ..Objects import Surface
from ..Objects import MechanicalModeContainer
from ..Objects import PCFieldOnMeshDouble, FieldOnElementsDouble, FieldOnNodesDouble
from .ExecuteCommand import ExecuteCommand


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
            self._result = ElementaryVectorDisplacementDouble()
        elif typeResu == 'VECT_ELEM_TEMP_R':
            self._result = ElementaryVectorTemperatureDouble()
        elif typeResu == 'FONCTION_SDASTER':
            self._result = Function()
        elif typeResu == 'FONCTION_C':
            self._result = FunctionComplex()
        elif typeResu == 'TABLE_SDASTER':
            self._result  = Table()
        elif typeResu == 'MATR_ASSE_GENE_R':
            self._result = GeneralizedAssemblyMatrixDouble()
        elif typeResu == 'MATR_ELEM_DEPL_R':
            self._result = ElementaryMatrixDisplacementDouble()
        elif typeResu == 'MATR_ELEM_TEMP_R':
            self._result = ElementaryMatrixTemperatureDouble()
        elif typeResu == 'NAPPE_SDASTER':
            self._result = Surface()
        elif typeResu == 'MODE_MECA':
            self._result = MechanicalModeContainer()
        elif typeResu == 'CARTE_SDASTER':
            self._result = PCFieldOnMeshDouble()
        elif typeResu == 'CHAM_ELEM':
            self._result = FieldOnElementsDouble()
        elif typeResu == 'CHAM_NO_SDASTER':
            self._result = FieldOnNodesDouble()
        else:
            raise NotImplementedError()

EXTR_TABLE = ExtrTable.run
