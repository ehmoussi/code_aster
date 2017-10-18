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

# person_in_charge: mathieu.courtois@edf.fr
from ..Objects import Function
from ..Utilities import compat_listr8
from .ExecuteCommand import ExecuteCommand


class FunctionInterpolation(ExecuteCommand):
    """Command that interpolates functions and formulas to create a new
    :py:class:`~code_aster.Objects.Function`."""
    command_name = "CALC_FONC_INTERP"

    def adapt_syntax(self, keywords):
        """Hook to adapt syntax from a old version or for compatibility reasons.

        Arguments:
            keywords (dict): Keywords arguments of user's keywords, changed
                in place.
        """
        compat_listr8(keywords, "", "LIST_PARA", "VALE_PARA")
        compat_listr8(keywords, "", "LIST_PARA_FONC", "VALE_PARA_FONC")

    def create_result(self, keywords):
        """Initialize the result object.

        Arguments:
            keywords (dict): Keywords arguments of user's keywords.
        """
        self._result = Function.create()


CALC_FONC_INTERP = FunctionInterpolation()
