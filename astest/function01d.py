# coding: utf-8

import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

SIYY = DEFI_FONCTION(NOM_PARA='EPSI',
                     PROL_DROITE='LINEAIRE',
                     PROL_GAUCHE='LINEAIRE',
                     VALE=(
                     0.001404,  2.719E+08,
                     0.006134,  3.459E+08,
                     0.014044,  3.789E+08,
                     0.029764,  4.036E+08,
                     0.050504,  4.242E+08,
                     0.106404,  5.276E+08,
                     )
                     )
SIYY.Trace()

TABF1 = CREA_TABLE(FONCTION=_F(FONCTION=SIYY,
                               PARA=('EPSI', 'SIYY',),
                               ),
                   )

F2 = RECU_FONCTION(TABLE=TABF1,
                   PARA_Y='SIYY', INTERPOL='LIN',
                   PARA_X='EPSI',)

DIFF = CALC_FONCTION(COMB=(
    _F(FONCTION=SIYY, COEF=1.),
                          _F(FONCTION=F2,   COEF=-1.),
),)
TOLE = 1.E-10

TEST_FONCTION(VALEUR=(_F(VALE_CALC=0.0,
                         VALE_REFE=0.0,
                         CRITERE='ABSOLU',
                         VALE_PARA=2.E-3,
                         REFERENCE='SOURCE_EXTERNE',
                         PRECISION=1.E-10,
                         FONCTION=DIFF,),
                      _F(VALE_CALC=0.0,
                         VALE_REFE=0.0,
                         CRITERE='ABSOLU',
                         VALE_PARA=0.014,
                         REFERENCE='SOURCE_EXTERNE',
                         PRECISION=1.E-10,
                         FONCTION=DIFF,),
                      _F(VALE_CALC=0.0,
                         VALE_REFE=0.0,
                         CRITERE='ABSOLU',
                         VALE_PARA=0.025,
                         REFERENCE='SOURCE_EXTERNE',
                         PRECISION=1.E-10,
                         FONCTION=DIFF,),
                      _F(VALE_CALC=0.0,
                         VALE_REFE=0.0,
                         CRITERE='ABSOLU',
                         VALE_PARA=0.095,
                         REFERENCE='SOURCE_EXTERNE',
                         PRECISION=1.E-10,
                         FONCTION=DIFF,),
                      ),
              )

test.assertEqual(DIFF(2.e-3), 0.)
test.assertEqual(DIFF(0.014), 0.)
test.assertEqual(DIFF(0.025), 0.)
test.assertEqual(DIFF(0.095), 0.)

test.printSummary()

FIN()
