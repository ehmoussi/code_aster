import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

MA = code_aster.Mesh()
MA.readMedFile("perfe03a.mmed")

TABG=RECU_TABLE(CO=MA,
                NOM_TABLE='CARA_GEOM')

test.assertTrue( True )

FIN()
