#!/usr/bin/python

from math import pi

import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

fsin = FORMULE(NOM_PARA='INST', VALE='sin(INST)')

test.assertSequenceEqual(fsin.getVariables(), ['INST', ])
test.assertEqual(fsin.getExpression(), 'sin(INST)')
test.assertEqual(fsin.getContext(), "")

prop = fsin.getProperties()
test.assertEqual( prop[1:5], ['INTERPRE', '', 'TOUTRESU', 'II'] )
# fsin.debugPrint()

test.assertEqual(fsin(0.), 0.)
test.assertAlmostEqual(fsin(pi/6.), 0.5)
test.assertEqual(fsin(pi/2.), 1.)

test.printSummary()
