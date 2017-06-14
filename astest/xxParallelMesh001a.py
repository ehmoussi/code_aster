
import code_aster
from code_aster.Commands import *

test = code_aster.TestCase()

rank = code_aster.getMPIRank()
print "Nb procs", code_aster.getMPINumberOfProcs()
print "Rank", code_aster.getMPIRank()

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
