#!/usr/bin/python

import numpy as np

import code_aster
from code_aster.Commands import DEFI_LIST_REEL

code_aster.init()

test = code_aster.TestCase()

values = DEFI_LIST_REEL(VALE=(0., 1., 2., 3.))
test.assertEqual(len(values), 4)
test.assertAlmostEqual(np.max(values - np.arange(4.)), 0.)

values = DEFI_LIST_REEL(VALE=np.array((0., 1., 2., 3.)))
test.assertEqual(len(values), 4)
test.assertAlmostEqual(np.max(values - np.arange(4.)), 0.)

values = DEFI_LIST_REEL(DEBUT=0.,
                        INTERVALLE=_F(JUSQU_A=3., NOMBRE=3))
test.assertEqual(len(values), 4)
test.assertAlmostEqual(np.max(values - np.arange(4.)), 0.)

values = DEFI_LIST_REEL(DEBUT=0.,
                        INTERVALLE=_F(JUSQU_A=3., PAS=1.))
test.assertEqual(len(values), 4)
test.assertAlmostEqual(np.max(values - np.arange(4.)), 0.)

values = DEFI_LIST_REEL(DEBUT=0.,
                        INTERVALLE=(_F(JUSQU_A=2., NOMBRE=2),
                                    _F(JUSQU_A=3., NOMBRE=1)))
test.assertEqual(len(values), 4)
test.assertAlmostEqual(np.max(values - np.arange(4.)), 0.)

test.printSummary()

code_aster.close()
