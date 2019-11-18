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

# person_in_charge: mathieu.courtois@edf.fr

from ..Objects import Function
from .ExecuteCommand import ExecuteCommand


class ConstantAsFunction(ExecuteCommand):
    """Command that creates a :py:class:`~code_aster.Objects.Function`."""
    command_name = "DEFI_CONSTANTE"

    def create_result(self, keywords):
        """Initialize the result object.

        Arguments:
            keywords (dict): Keywords arguments of user's keywords.
        """
        self._result = Function()

    def exec_(self, keywords):
        """Execute the command.

        Arguments:
            keywords (dict): User's keywords.
        """
        funct = self._result

        value = None
        if type(keywords['VALE']) is tuple:
            value = list(keywords['VALE'])
        else:
            value = [keywords['VALE'],]
        funct.setValues([1.], value)
        funct.setResultName(keywords['NOM_RESU'])
        funct.setParameterName("TOUTPARA")
        funct.setInterpolation("LIN LIN")
        funct.setExtrapolation("CC")
        funct.setAsConstant()


DEFI_CONSTANTE = ConstantAsFunction.run
