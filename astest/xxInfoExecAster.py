import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

TCPU=INFO_EXEC_ASTER(LISTE_INFO='TEMPS_RESTANT')

test.assertTrue( True )

FIN()
