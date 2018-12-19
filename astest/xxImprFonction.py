import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

MA = code_aster.Mesh()

RAMPE=DEFI_FONCTION(NOM_PARA='INST',
                    VALE=(0.0,0.0,1000.0,1000.0,),)

IMPR_FONCTION(COURBE=_F(FONCTION=RAMPE,),)

test.assertTrue( True )

FIN()
