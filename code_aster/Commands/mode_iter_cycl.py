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

# person_in_charge: natacha.bereux  at edf.fr


from code_aster.RunManager.AsterFortran import python_execop
from code_aster.Supervis.libCommandSyntax import CommandSyntax
from code_aster import CyclicSymmetryMode


def MODE_ITER_CYCL(**curDict):
    returnCyclicMode = CyclicSymmetryMode.create()
    name = returnCyclicMode.getName()
    type = returnCyclicMode.getType()

    syntax = CommandSyntax("MODE_ITER_CYCL")
    syntax.setResult(name, type)
    syntax.define(curDict)

    numOp = 80
    python_execop(numOp)
    syntax.free()
#   TODO  returnCyclicMode.setSupportMesh(curDict["MAILLAGE"])
    returnCyclicMode.setModalBasis(curDict["BASE_MODALE"])

    return returnCyclicMode
