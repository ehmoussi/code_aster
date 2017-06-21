
import code_aster
from code_aster.Commands import *

test = code_aster.TestCase()

rank = code_aster.getMPIRank()
print "Nb procs", code_aster.getMPINumberOfProcs()
print "Rank", code_aster.getMPIRank()

pMesh2 = code_aster.ParallelMesh.create()
pMesh2.readMedFile("xxParallelMesh001a")
del pMesh2

pMesh = code_aster.ParallelMesh.create()
pMesh.readMedFile("xxParallelMesh001a")
pMesh.debugPrint(rank+30)

model = code_aster.Model.create()
test.assertEqual(model.getType(), "MODELE")
model.setSupportMesh(pMesh)
model.addModelingOnAllMesh(code_aster.Physics.Mechanics,
                           code_aster.Modelings.Tridimensional)
model.build()

testMesh = model.getSupportMesh()
test.assertEqual(testMesh.getType(), "MAILLAGE_P")

model.debugPrint(rank+30)

acier = code_aster.Material.create()

elas = code_aster.ElasMaterialBehaviour.create()
elas.setDoubleValue("E", 2.e11)
elas.setDoubleValue("Nu", 0.3)

acier.addMaterialBehaviour(elas)
acier.build()
acier.debugPrint(8)

affectMat = code_aster.MaterialOnMesh.create()
affectMat.setSupportMesh(pMesh)

testMesh2 = affectMat.getSupportMesh()
test.assertEqual(testMesh2.getType(), "MAILLAGE_P")

affectMat.addMaterialOnAllMesh(acier)
affectMat.build()

charCine = code_aster.KinematicsLoad.create()
charCine.setSupportModel(model)
charCine.addImposedMechanicalDOFOnNodes(code_aster.PhysicalQuantityComponent.Dx, 0., "COTE_B")
charCine.build()

study = code_aster.StudyDescription.create(model, affectMat)
study.addKinematicsLoad(charCine)
dProblem = code_aster.DiscreteProblem.create(study)
matr_elem = dProblem.computeMechanicalRigidityMatrix()

monSolver = code_aster.LinearSolver.create(code_aster.LinearSolverName.Mumps,
                                            code_aster.Renumbering.Metis)

numeDDL = code_aster.ParallelDOFNumbering.create()
numeDDL.setElementaryMatrix(matr_elem)
numeDDL.computeNumerotation()
numeDDL.debugPrint(rank+30)

matrAsse = code_aster.AssemblyMatrixDouble.create()
matrAsse.setElementaryMatrix(matr_elem)
matrAsse.setDOFNumbering(numeDDL)
matrAsse.build()

test.printSummary()
