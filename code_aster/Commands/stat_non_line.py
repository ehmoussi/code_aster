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

from code_aster.RunManager.AsterFortran import python_execop
from code_aster.Supervis.libCommandSyntax import CommandSyntax
from code_aster import StaticNonLinearAnalysis
from code_aster import NonLinearEvolutionContainer


def STAT_NON_LINE(**curDict):
    returnAnalysis = NonLinearEvolutionContainer.create()
    name = returnAnalysis.getName()
    type = returnAnalysis.getType()

    syntax = CommandSyntax("STAT_NON_LINE")
    syntax.setResult(name, type)
    syntax.define(curDict)

    numOp = 70
    python_execop(numOp)
    syntax.free()

    localSolver=StaticNonLinearAnalysis.create()
    localSolver.setSupportModel(curDict["MODELE"])
    localSolver.setMaterialOnMesh(curDict["CHAM_MATER"])
    localSolver.setLoadStepManager(curDict["INCREMENT"]["LIST_INST"])
    if (len(curDict['EXCIT']) == 1):
        localSolver.addStandardExcitation(curDict["EXCIT"]["CHARGE"],curDict["EXCIT"]["TYPE_CHARGE"],curDict["EXCIT"]["FONC_MULT"])
    else:
        (localSolver.addStandardExcitation(load["CHARGE"],curDict["EXCIT"]["TYPE_CHARGE"],curDict["EXCIT"]["FONC_MULT"]) for load in curDict["EXCIT"])

    return returnAnalysis
