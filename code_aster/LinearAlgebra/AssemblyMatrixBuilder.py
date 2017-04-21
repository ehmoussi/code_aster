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
from code_aster import AssemblyMatrixDouble


def ASSE_MATRICE(**curDict):
    returnMatrix = AssemblyMatrixDouble.create()
    name = returnMatrix.getInstance().getName()
    type = returnMatrix.getInstance().getType()
    syntax = CommandSyntax("ASSE_MATRICE")

    syntax.setResult(name, type)

    syntax.define(curDict)
    numOp = 12
    python_execop(numOp)
    syntax.free()
    return returnMatrix
