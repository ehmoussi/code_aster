# coding: utf-8

# Copyright (C) 1991 - 2016  EDF R&D                www.code-aster.org
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

from code_aster.RunManager.AsterFortran import python_execop
from code_aster.Supervis.libCommandSyntax import CommandSyntax
from code_aster import EvolutiveLoad
from code_aster import EvolutiveThermalLoad


def CREA_RESU(**curDict):
    returnRC = None
    if curDict["TYPE_RESU"] == "EVOL_CHAR":
        returnRC = EvolutiveLoad.create()
    elif curDict["TYPE_RESU"] == "EVOL_THER":
        returnRC = EvolutiveThermalLoad.create()
    else:
        raise NameError("Not yet implemented")
    name = returnRC.getName()
    type = returnRC.getType()

    syntax = CommandSyntax("CREA_RESU")
    syntax.setResult(name, type)
    syntax.define(curDict)

    numOp = 124
    python_execop(numOp)
    syntax.free()

    return returnRC
