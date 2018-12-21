import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

MA = code_aster.Mesh()
MA.readMedFile("zzzz395e.mmed")

IMPR_RESU(RESU = _F(MAILLAGE    = MA))

test.assertTrue( True )

FIN()
