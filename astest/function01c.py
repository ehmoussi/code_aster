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
from math import sin, pi
import os

import code_aster
from code_aster.Commands import *

code_aster.init("--test")

test = code_aster.TestCase()

n = 10
valx = np.arange(n) * 2. * pi / n
valy = np.sin(valx)

DEBUT()

fsin = DEFI_FONCTION(NOM_PARA="INST",
                     NOM_RESU="TEMP",
                     ABSCISSE=valx,
                     ORDONNEE=valy,)
fsin.debugPrint()

test.assertEqual(fsin.getProperties(),
                 ['FONCTION', 'LIN LIN', 'INST', 'TEMP', 'EE', '00000001'])
test.assertEqual(len(fsin.Absc()), n)
test.assertEqual(len(fsin.Ordo()), n)

test.assertAlmostEqual(fsin(0.), 0.)
test.assertAlmostEqual(fsin(0.62831853), 5.87785252e-01)

ftest = CALC_FONC_INTERP(FONCTION=fsin,
                         VALE_PARA=valx)
ftest.debugPrint()


IMPR_FONCTION(COURBE=_F(FONCTION=fsin),
              FORMAT='XMGRACE', UNITE=44)
test.assertTrue(os.path.exists('fort.44'))


# in '.resu' file
size_ini = os.stat('fort.8').st_size
IMPR_FONCTION(COURBE=_F(FONCTION=fsin))

size_end = os.stat('fort.8').st_size
test.assertTrue(size_end - size_ini > 400)

test.printSummary()

FIN()
