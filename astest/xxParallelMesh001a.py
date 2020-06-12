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

code_aster.init()

test = code_aster.TestCase()

rank = code_aster.getMPIRank()
print("Nb procs", code_aster.getMPINumberOfProcs())
print("Rank", code_aster.getMPIRank())

pMesh2 = code_aster.ParallelMesh()
pMesh2.readMedFile("xxParallelMesh001a")
pMesh2=DEFI_GROUP(reuse =pMesh2,MAILLAGE=pMesh2,CREA_GROUP_NO=_F(TOUT_GROUP_MA='OUI'))
del pMesh2

pMesh = code_aster.ParallelMesh()
pMesh.readMedFile("xxParallelMesh001a")
pMesh.debugPrint(rank+30)

model = code_aster.Model(pMesh)
test.assertEqual(model.getType(), "MODELE_SDASTER")
model.addModelingOnMesh(code_aster.Physics.Mechanics,
                           code_aster.Modelings.Tridimensional)
model.build()

testMesh = model.getMesh()
test.assertEqual(testMesh.getType(), "MAILLAGE_P")

model.debugPrint(rank+30)

acier = DEFI_MATERIAU(ELAS = _F(E = 2.e11,
                                NU = 0.3,),)
acier.debugPrint(8)

affectMat = code_aster.MaterialField(pMesh)

testMesh2 = affectMat.getMesh()
test.assertEqual(testMesh2.getType(), "MAILLAGE_P")

affectMat.addMaterialsOnMesh(acier)
affectMat.buildWithoutExternalVariable()

charCine = code_aster.KinematicsMechanicalLoad()
charCine.setModel(model)
charCine.addImposedMechanicalDOFOnNodes(code_aster.PhysicalQuantityComponent.Dx, 0., "COTE_B")
charCine.build()

study = code_aster.StudyDescription(model, affectMat)
dProblem = code_aster.DiscreteProblem(study)
matr_elem = dProblem.computeMechanicalStiffnessMatrix()

monSolver = code_aster.MumpsSolver(code_aster.Renumbering.Metis)

numeDDL = code_aster.ParallelDOFNumbering()
numeDDL.setElementaryMatrix(matr_elem)
numeDDL.computeNumbering()
numeDDL.debugPrint(rank+30)

matrAsse = code_aster.AssemblyMatrixDisplacementReal()
matrAsse.appendElementaryMatrix(matr_elem)
matrAsse.setDOFNumbering(numeDDL)
matrAsse.addKinematicsLoad(charCine)
matrAsse.build()
matrAsse.debugPrint(rank+30)

retour = matrAsse.getDOFNumbering()
test.assertEqual(retour.isParallel(), True)

test.printSummary()

FIN()
