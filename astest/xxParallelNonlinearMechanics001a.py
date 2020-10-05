# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
# This file is part of code_aster.
#
# code_aster is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# code_aster is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with code_aster.  If not, see <http://www.gnu.org/licenses/>.
# --------------------------------------------------------------------

import code_aster
from code_aster.Commands import *

code_aster.init("--test")

test = code_aster.TestCase()

# parallel=False
parallel = True

if parallel:
    monMaillage = code_aster.ParallelMesh()
    monMaillage.readMedFile("xxParallelNonlinearMechanics001a/%d.med"%rank, True)
else:
    monMaillage = code_aster.Mesh()
    monMaillage.readMedFile("xxParallelNonlinearMechanics001a.med")

monModel = code_aster.Model(monMaillage)
monModel.addModelingOnMesh(
    code_aster.Physics.Mechanics, code_aster.Modelings.Tridimensional)
monModel.build()

YOUNG = 200000.0
POISSON = 0.3

acier = DEFI_MATERIAU(ELAS = _F(E = YOUNG,
                                NU = POISSON,),)

affectMat = code_aster.MaterialField(monMaillage)
affectMat.addMaterialsOnMesh(acier)
affectMat.buildWithoutExternalVariable()

charMeca1 = code_aster.KinematicsMechanicalLoad()
charMeca1.setModel(monModel)
charMeca1.addImposedMechanicalDOFOnCells(
    code_aster.PhysicalQuantityComponent.Dx, 0., "COTE_B")
charMeca1.addImposedMechanicalDOFOnCells(
    code_aster.PhysicalQuantityComponent.Dy, 0., "COTE_B")
charMeca1.addImposedMechanicalDOFOnCells(
    code_aster.PhysicalQuantityComponent.Dz, 0., "COTE_B")
charMeca1.build()

charMeca2 = code_aster.KinematicsMechanicalLoad()
charMeca2.setModel(monModel)
charMeca2.addImposedMechanicalDOFOnCells(
    code_aster.PhysicalQuantityComponent.Dy, 0.1, "COTE_H")
charMeca2.addImposedMechanicalDOFOnCells(
    code_aster.PhysicalQuantityComponent.Dz, 0.1, "COTE_H")
charMeca2.build()

# Define the nonlinear method that will be used
monSolver = code_aster.PetscSolver(code_aster.Renumbering.Sans)
monSolver.setPreconditioning(code_aster.Preconditioning.Ml)

# Define a nonlinear Analysis
statNonLine = code_aster.NonLinearStaticAnalysis()
statNonLine.addStandardExcitation(charMeca1)
statNonLine.addStandardExcitation(charMeca2)
statNonLine.setModel(monModel)
statNonLine.setMaterialField(affectMat)
statNonLine.setLinearSolver(monSolver)

temps = [0., 0.5, 1.]
timeList = code_aster.TimeStepManager()
timeList.setTimeList(temps)

error1 = code_aster.EventError()
action1 = code_aster.SubstepingOnError()
action1.setAutomatic(False)
error1.setAction(action1)
timeList.addErrorManager(error1)
timeList.build()
# timeList.debugPrint( 6 )
statNonLine.setLoadStepManager(timeList)
# Run the nonlinear analysis
resu = statNonLine.execute()
test.assertEqual(resu.getType(), "EVOL_NOLI")
# resu.debugPrint( 6 )

# at least it pass here!
test.printSummary()

# if parallel:
#     rank = code_aster.getMPIRank()
#     resu.printMedFile('/tmp/par_%d.resu.med'%rank)
# else:
#     resu.printMedFile('/tmp/seq.resu.med')

FIN()
