import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

one=DEFI_CONSTANTE(VALE=1.0,)

DETRUIRE(INFO=1,CONCEPT=_F(NOM=one))

one=DEFI_CONSTANTE(VALE=1.0,)

test.assertTrue( True )

FIN()
