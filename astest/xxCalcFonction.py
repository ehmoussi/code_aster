import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

LBNSNL1=DEFI_FONCTION(  NOM_RESU='ACCE',  NOM_PARA='INST',
                             PROL_GAUCHE='EXCLU',  PROL_DROITE='EXCLU',
                             VALE=(
      0.00000E+00,   9.98700E-02,   1.00000E-02,   6.60700E-02,
      2.00000E-02,  -5.65000E-03,   3.00000E-02,  -9.46800E-02,)
                          )

ACCELERO=CALC_FONCTION( COMB=_F( FONCTION = LBNSNL1, COEF = 2.45) )

test.assertTrue( True )

FIN()
