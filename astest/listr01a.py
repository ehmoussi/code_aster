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

import numpy as np

import code_aster
from code_aster.Commands import DEFI_LIST_REEL

code_aster.init("--test")

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
