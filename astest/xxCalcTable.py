import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

LISTE=DEFI_LIST_REEL(DEBUT=0.,INFO=1,
                        INTERVALLE=_F(JUSQU_A=10.,
                                      NOMBRE=100,),);

TX=CREA_TABLE(LISTE=_F(LISTE_R=LISTE.getValuesAsArray(),PARA=('X')))

X2 = FORMULE(VALE='X**2',NOM_PARA=('X'),)

TX2 = CALC_TABLE(TABLE = TX,
                 ACTION = _F (OPERATION = 'OPER',
                              FORMULE = X2,
                              NOM_PARA = ('X2')))

test.assertEqual(X2.userName, "X2")
test.assertEqual(TX2.userName, "TX2")
test.assertTrue( True )
