# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
# This file is part of code_aster.
#
# code_aster is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# code_aster is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with code_aster.  If not, see <http://www.gnu.org/licenses/>.
# --------------------------------------------------------------------

from math import cos, pi

import numpy

import code_aster
from code_aster.Commands import *

code_aster.init("--test")

test = code_aster.TestCase()

fsin = FORMULE(NOM_PARA='INST', VALE='sin(INST)')

with test.assertRaises(RuntimeError):
    fsin.setContext(None)

test.assertSequenceEqual(fsin.getVariables(), ['INST', ])
test.assertEqual(fsin.getExpression(), 'sin(INST)')
test.assertTrue("sin" in fsin.getContext())
test.assertTrue("pow" in fsin.getContext())

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
