import code_aster
from code_aster.Commands import *

test = code_aster.TestCase()

code_aster.init()

# extracted from zzzz100a

dfc1 = DEFI_FONCTION(NOM_PARA='INST',
                     NOM_RESU='FREQ',
                     VALE_C=(5., 2., 4.,
                             1., 3., 4.,
                             0., 1., 2.,),
                     VERIF='NON')

test.assertEqual(dfc1.getType(), "FONCTION_C")
prop = dfc1.getProperties()
test.assertSequenceEqual( prop[:5], ['FONCT_C', 'LIN LIN', 'INST', 'FREQ', 'EE'] )

test.assertEqual(dfc1.size(), 3)
test.assertEqual(dfc1(1.), 3 + 4j)
test.assertEqual(dfc1(0.5), 2 + 3j)

frmcpx = FORMULE(NOM_PARA='X', VALE_C='complex(X, 2.*X)')

labs = DEFI_LIST_REEL(VALE=(0., 1., 2., 3.))

fctcpx = CALC_FONC_INTERP(FONCTION=frmcpx,
                          LIST_PARA=labs,
                          NOM_PARA='X', )

test.assertEqual(fctcpx.getType(), "FONCTION_C")
prop = fctcpx.getProperties()
test.assertSequenceEqual( prop[:5], ['FONCT_C', 'LIN LIN', 'X', 'TOUTRESU', 'EE'] )

IMPR_FONCTION(COURBE=_F(FONCTION=frmcpx,
                        LIST_PARA=labs,
                        PARTIE='IMAG',),
              UNITE=6,)

IMPR_FONCTION(COURBE=_F(FONCTION=fctcpx,
                        LIST_PARA=labs,
                        PARTIE='IMAG',),
              UNITE=6,)

test.assertEqual(fctcpx(1.), 1 + 2j)
test.assertEqual(fctcpx(3.), 3 + 6j)

TEST_FONCTION(VALEUR=(_F(VALE_CALC_C=(1 + 2j),
                         VALE_REFE_C=('RI', 1.0, 2.0),
                         VALE_PARA=1.0,
                         REFERENCE='ANALYTIQUE',
                         FONCTION=fctcpx,),
                      _F(VALE_CALC_C=(3 + 6j),
                         VALE_REFE_C=('RI', 3.0, 6.0),
                         VALE_PARA=3.0,
                         REFERENCE='ANALYTIQUE',
                         FONCTION=fctcpx,)))

FIN()
