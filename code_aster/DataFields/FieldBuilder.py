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
from code_aster import PCFieldOnMeshDouble
from code_aster import FieldOnNodesDouble


def CREA_CHAMP(**curDict):
    returnField = None
    if curDict["TYPE_CHAM"][:5] == "CART_" and curDict["TYPE_CHAM"][10:] == "R":
        returnField = PCFieldOnMeshDouble.create()
    elif curDict["TYPE_CHAM"][:5] == "NOEU_" and curDict["TYPE_CHAM"][10:] == "R":
        returnField = FieldOnNodesDouble.create()
    else:
        raise NameError("Not yet implemented")
    name = returnField.getName()
    type = returnField.getType()

    syntax = CommandSyntax("CREA_CHAMP")
    syntax.setResult(name, type)
    syntax.define(curDict)

    numOp = 195
    python_execop(numOp)
    syntax.free()

    return returnField
