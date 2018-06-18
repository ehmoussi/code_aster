# coding: utf-8

# Copyright (C) 1991 - 2018  EDF R&D                www.code-aster.org
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

from ..Objects import AssemblyMatrixDisplacementDouble
from ..Objects import GeneralizedAssemblyMatrixDouble, GeneralizedAssemblyMatrixComplex
from .ExecuteCommand import ExecuteCommand


class ProjMatrBase(ExecuteCommand):
    """Command that defines :class:`~code_aster.Objects.GeneralizedAssemblyMatrix`.
    """
    command_name = "PROJ_MATR_BASE"

    def create_result(self, keywords):
        """Initialize the result.
        
        Arguments:
            keywords (dict): Keywords arguments of user's keywords.
        """
        if keywords.has_key("MATR_ASSE_GENE"):
            self._result = type(keywords["MATR_ASSE_GENE"])()
        else:
            if type(keywords["MATR_ASSE"]) == AssemblyMatrixDisplacementDouble:
                self._result = GeneralizedAssemblyMatrixDouble()
            else:
                self._result = GeneralizedAssemblyMatrixComplex()

PROJ_MATR_BASE = ProjMatrBase.run
