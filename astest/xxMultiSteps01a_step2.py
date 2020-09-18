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
from code_aster.Commands import *

code_aster.init("--test", "--continue")
# POURSUITE()

test = code_aster.TestCase()

test.assertTrue(isinstance(fsin, code_aster.Function))
test.assertTrue(isinstance(fcos, code_aster.Function))

fsin.debugPrint(6)
test.assertEqual(fsin.size(), 10)
test.assertEqual(fcos.size(), 20)

# continue...
# check Function.abs()
fabs = fsin.abs()
fabs.debugPrint( 6 )

arrabs = fabs.getValuesAsArray()
test.assertTrue( np.alltrue( arrabs[:, 1] >= 0. ) )

# Warning: xxMultiSteps01a_imp has not been imported in this session
# so it is "replayed", a new 'fcos' object is created.
from xxMultiSteps01a_imp import fcos as fcos2
test.assertNotEqual(fcos.getName(), fcos2.getName())

# 'form' was created during the first import, not now
from xxMultiSteps01a_imp import form
test.assertEqual(form(1.), 2.)

test.printSummary()

FIN()
