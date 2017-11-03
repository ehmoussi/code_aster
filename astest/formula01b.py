from math import pi

import numpy

import code_aster
from code_aster.Commands import *

test = code_aster.TestCase()

DEBUT()

n = 100000
# valx = DEFI_LIST_REEL(DEBUT=0,
#                       INTERVALLE=_F(JUSQU_A=2. * pi,
#                                     NOMBRE=6 * n,),)
valx = numpy.arange(0., 2. * pi, 2. * pi / (6 * n))

fsin = FORMULE(NOM_PARA='INST', VALE='sin(INST)')

ftest = CALC_FONC_INTERP(FONCTION=fsin,
                         VALE_PARA=valx)

test.assertEqual(ftest(0.), 0.)
test.assertAlmostEqual(ftest(pi / 6.), 0.5)
test.assertEqual(ftest(pi / 2.), 1.)

FIN()
