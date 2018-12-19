#!/usr/bin/python

from math import cos, pi

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

n = 12
valx = numpy.arange(n) * 2. * pi / n

ftest = CALC_FONC_INTERP(FONCTION=fsin,
                         VALE_PARA=valx)
ftest.debugPrint()

test.assertEqual(ftest(0.), 0.)
test.assertAlmostEqual(ftest(pi / 6.), 0.5)
test.assertEqual(ftest(pi / 2.), 1.)

# check for formula with context
f2x = FORMULE(NOM_PARA='INST', VALE='cst * INST', cst=2)
test.assertEqual(f2x(2.5), 5.)

fsin2 = FORMULE(NOM_PARA='INST', VALE='fsin(INST)**2', fsin=fsin)
test.assertEqual(fsin2(0.), 0.)
test.assertAlmostEqual(fsin2(pi / 6.), 0.25)
test.assertEqual(fsin2(pi / 2.), 1.)


def fcos2(var):
    """Cosinus"""
    return cos(var) ** 2

fone = FORMULE(NOM_PARA='INST', VALE='fsin2(INST) + fcos2(INST)',
               fsin2=fsin2, fcos2=fcos2)
test.assertEqual(fone(0.), 1.)
test.assertEqual(fone(pi / 6.), 1.)
test.assertEqual(fone(12.3456), 1.)

test.printSummary()

FIN()
