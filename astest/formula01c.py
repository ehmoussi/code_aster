import code_aster
from code_aster.Commands import *

test = code_aster.TestCase()

code_aster.init()

# extracted from zzzz100a
frmcpx = FORMULE(NOM_PARA='X', VALE_C='complex(X, 2.*X)')

labs = DEFI_LIST_REEL(VALE=(0., 1., 2., 3.))

fctcpx = CALC_FONC_INTERP(FONCTION=frmcpx,
                          LIST_PARA=labs,
                          NOM_PARA='X', )

IMPR_FONCTION(COURBE=_F(FONCTION=frmcpx,
                        LIST_PARA=labs,
                        PARTIE='IMAG',),
              UNITE=6,)

# TEST_FONCTION(VALEUR=(_F(VALE_CALC_C=(1 + 2j),
#                          VALE_REFE_C=('RI', 1.0, 2.0),
#                          VALE_PARA=1.0,
#                          REFERENCE='ANALYTIQUE',
#                          FONCTION=fctcpx,),
#                       _F(VALE_CALC_C=(3 + 6j),
#                          VALE_REFE_C=('RI', 3.0, 6.0),
#                          VALE_PARA=3.0,
#                          REFERENCE='ANALYTIQUE',
#                          FONCTION=fctcpx,)))


test.assertEqual(fctcpx(1.), 1 + 2j)
test.assertEqual(fctcpx(3.), 3 + 6j)

FIN()
