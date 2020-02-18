# coding: utf-8

import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

rank = code_aster.getMPIRank()
print("Nb procs", code_aster.getMPINumberOfProcs())
print("Rank", code_aster.getMPIRank())

pMesh2 = code_aster.ParallelMesh()
pMesh2.readMedFile("xxParallelMesh001a")
del pMesh2

pMesh = code_aster.ParallelMesh()
pMesh.readMedFile("xxParallelMesh001a")
pMesh.debugPrint(rank+30)

model = code_aster.Model(pMesh)
test.assertEqual(model.getType(), "MODELE_SDASTER")
model.addModelingOnAllMesh(code_aster.Physics.Mechanics,
                           code_aster.Modelings.Tridimensional)
model.build()

testMesh = model.getMesh()
test.assertEqual(testMesh.getType(), "MAILLAGE_P")

model.debugPrint(rank+30)

acier = DEFI_MATERIAU(ELAS = _F(E = 2.e11,
                                NU = 0.3,),)
acier.debugPrint(8)

affectMat = code_aster.MaterialOnMesh(pMesh)

testMesh2 = affectMat.getMesh()
test.assertEqual(testMesh2.getType(), "MAILLAGE_P")

affectMat.addMaterialOnAllMesh(acier)
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
