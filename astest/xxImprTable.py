import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

LISTE=DEFI_LIST_REEL(DEBUT=0.,INFO=1,
                        INTERVALLE=_F(JUSQU_A=10.,
                                      NOMBRE=100,),)

TX=CREA_TABLE(LISTE=_F(LISTE_R=LISTE.getValuesAsArray(),PARA=('X')))

IMPR_TABLE(TABLE=TX)

test.assertTrue( True )

FIN()
