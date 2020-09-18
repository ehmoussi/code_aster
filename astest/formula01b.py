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

from math import pi

import numpy

import code_aster
from code_aster.Commands import *

test = code_aster.TestCase()

code_aster.init("--test")

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
