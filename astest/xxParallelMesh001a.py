
import code_aster
from code_aster.Commands import *

print "Nb procs", code_aster.getMPINumberOfProcs()
print "Rank", code_aster.getMPIRank()

pMesh = code_aster.ParallelMesh.create()
pMesh.readMedFile("xxParallelMesh001a")
pMesh.debugPrint()
