import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

SIG_PRET = 30.0
R_GOUJON =  6.0
F_RESULT = -SIG_PRET*3.14*R_GOUJON*R_GOUJON/2.0

CIBLE=DEFI_FONCTION(
   NOM_PARA='INST',
   NOM_RESU='DZ',
   VALE=( 0.0 , 0.0 ,
          1.0 , F_RESULT ,),
)

RECAL=MACR_RECAL(
   UNITE_ESCL=3,
   PARA_OPTI=_F(NOM_PARA='DEPL_R__',
                VALE_INI=0.004, VALE_MIN=0.004, VALE_MAX=0.012,),
   COURBE=_F(FONC_EXP=CIBLE, NOM_FONC_CALC='REACF',
             PARA_X='INST', PARA_Y='DZ'),
)

test.assertTrue( True )

FIN()
