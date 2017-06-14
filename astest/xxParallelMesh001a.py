
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

model = code_aster.ParallelModel.create()
test.assertEqual( model.getType(), "MODELE" )
model.setSupportMesh(pMesh)
model.addModelingOnAllMesh(code_aster.Physics.Mechanics,
                           code_aster.Modelings.Tridimensional)
model.build()

model.debugPrint(rank+30)

acier = code_aster.Material.create()

elas = code_aster.ElasMaterialBehaviour.create()
elas.setDoubleValue( "E", 2.e11 )
elas.setDoubleValue( "Nu", 0.3 )

acier.addMaterialBehaviour( elas )
acier.build()
acier.debugPrint( 8 )

test.printSummary()
