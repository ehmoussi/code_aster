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

from ..Objects import Function
from ..Objects import ElementaryVector
from ..Objects import Table
from ..Objects import GeneralizedAssemblyMatrixDouble
from ..Objects import AssemblyMatrixDouble
from ..Objects import Surface
from ..Objects import MechanicalModeContainer
from ..Objects import PCFieldOnMeshDouble, FieldOnElementsDouble
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
        
        if keywords['TYPE_RESU'] == 'VECT_ELEM_DEPL_R':
            self._result = ElementaryVector()
        elif keywords['TYPE_RESU'] == 'FONCTION_SDASTER':
            self._result = Function()
        elif keywords['TYPE_RESU'] == 'TABLE_SDASTER':
            self.result  = Table()
        elif keywords['TYPE_RESU'] =='MATR_ASSE_GENE_R':
            self.result = GeneralizedAssemblyMatrixDouble()
        elif keywords['TYPE_RESU'] =='MATR_ELEM_DEPL_R':
            self.result = AssemblyMatrixDouble()
        elif keywords['TYPE_RESU'] =='NAPPE_SDASTER':
            self.result = Surface()
        elif keywords['TYPE_RESU'] =='MODE_MECA':
            self.result = MechanicalModeContainer()
        elif keywords['TYPE_RESU'] =='CARTE_SDASTER':
            self.result = PCFieldOnMeshDouble()
        elif keywords['TYPE_RESU'] =='CHAM_ELEM':
            self.result = FieldOnElementsDouble()
        else:
            raise NotImplementedError()

EXTR_TABLE = ExtrTable.run
