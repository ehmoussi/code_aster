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
import numpy as np

import code_aster
from code_aster.Commands import *

code_aster.init("--test")

test = code_aster.TestCase()

fsin = code_aster.Function()
fsin.setParameterName("INST")
fsin.setResultName("TEMP")

# values assignment
n = 10
valx = np.arange(n) * 2. * pi / n
valy = np.sin(valx)

fsin.setValues(valx, valy)
fsin.debugPrint(6)

# check that imported objects will be saved
from xxMultiSteps01a_imp import fcos
fcos.debugPrint(6)

code_aster.saveObjects()

# after the backup Code_Aster objects must be None
test.assertIsNone(fcos)
test.assertIsNone(fsin)

test.printSummary()

FIN()
