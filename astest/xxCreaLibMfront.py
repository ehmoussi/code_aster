import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

CREA_LIB_MFRONT(UNITE_MFRONT=38,UNITE_LIBRAIRIE=39)

test.assertTrue( True )

FIN()
