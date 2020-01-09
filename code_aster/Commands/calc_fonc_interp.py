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

# person_in_charge: mathieu.courtois@edf.fr

from ..Objects import Formula, Function, FunctionComplex, Surface
from ..Supervis.ExecuteCommand import ExecuteCommand
from ..Utilities import compat_listr8


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
        intype = keywords["FONCTION"].getType()
        if intype == "FONCTION_C":
            self._result = FunctionComplex()
        elif intype == "FONCTION_SDASTER":
            self._result = Function()
        elif intype == "NAPPE_SDASTER":
            self._result = Surface()
        elif intype == "FORMULE":
            if keywords.get("NOM_PARA_FONC") != None:
                self._result = Surface()
            else:
                self._result = Function()
        elif intype == "FORMULE_C":
            self._result = FunctionComplex()
        else:
            raise TypeError


CALC_FONC_INTERP = FunctionInterpolation.run
