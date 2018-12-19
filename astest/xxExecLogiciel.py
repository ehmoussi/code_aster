import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

EXEC_LOGICIEL(LOGICIEL='ls -la', SHELL='OUI')

EXEC_LOGICIEL(LOGICIEL='pwd', SHELL='NON')

test.assertTrue( True )

FIN()
