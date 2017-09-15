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
from code_aster.Cata import Commands, checkSyntax
from code_aster.RunManager.AsterFortran import python_execop
from code_aster.Supervis.libCommandSyntax import CommandSyntax
from code_aster.Utilities import compat_listr8
from code_aster import Function


def CALC_FONC_INTERP(**kwargs):
    """Interpolate functions and formulas."""
    compat_listr8(kwargs, None, "LIST_PARA", "VALE_PARA")
    compat_listr8(kwargs, None, "LIST_PARA_FONC", "VALE_PARA_FONC")
    checkSyntax(Commands.CALC_FONC_INTERP, kwargs)

    result = Function.create()
    name = result.getName()
    syntax = CommandSyntax("CALC_FONC_INTERP")

    syntax.setResult(name, "FONCTION")

    syntax.define(kwargs)
    numOp = 134
    python_execop(numOp)
    syntax.free()
    return result
