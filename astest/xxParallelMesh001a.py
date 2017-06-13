
import code_aster
from code_aster.Commands import *

rank = code_aster.getMPIRank()
print "Nb procs", code_aster.getMPINumberOfProcs()
print "Rank", code_aster.getMPIRank()

pMesh = code_aster.ParallelMesh.create()
pMesh.readMedFile("xxParallelMesh001a")
pMesh.debugPrint(rank+30)
