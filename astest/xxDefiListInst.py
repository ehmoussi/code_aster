import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

L_INST=DEFI_LIST_REEL(DEBUT=0.0, INTERVALLE=_F(JUSQU_A=1,NOMBRE=10,),)

DEFLIST1=DEFI_LIST_INST(DEFI_LIST=_F(LIST_INST=L_INST,),)

test.assertTrue( True )

FIN()
