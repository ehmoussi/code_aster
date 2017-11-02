#!/usr/bin/python

from math import pi

import numpy

import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

fsin = FORMULE(NOM_PARA='INST', VALE='sin(INST)')

with test.assertRaises(RuntimeError):
    fsin.setContext(None)

test.assertSequenceEqual(fsin.getVariables(), ['INST', ])
test.assertEqual(fsin.getExpression(), 'sin(INST)')
test.assertTrue(fsin.getContext().has_key("sin"))
test.assertTrue(fsin.getContext().has_key("pow"))

prop = fsin.getProperties()
test.assertEqual(prop[1:5], ['INTERPRE', '', 'TOUTRESU', 'II'])

test.assertEqual(fsin(0.), 0.)
test.assertAlmostEqual(fsin(pi / 6.), 0.5)
test.assertEqual(fsin(pi / 2.), 1.)

n = 10
valx = numpy.arange(n) * 2. * pi / n

# ftest = CALC_FONC_INTERP(FONCTION=fsin,
#                          VALE_PARA=valx)
# ftest.debugPrint()

# test.assertEqual(ftest(0.), 0.)
# test.assertAlmostEqual(ftest(pi / 6.), 0.5)
# test.assertEqual(ftest(pi / 2.), 1.)

test.printSummary()
