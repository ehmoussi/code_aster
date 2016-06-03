#!/usr/bin/python
# coding: utf-8

from math import pi
import numpy as np

import code_aster


test = code_aster.TestCase()

fsin = code_aster.Function()
fsin.setParameterName("INST")
fsin.setResultName("TEMP")

# values assignment
n = 10
valx = np.arange( n ) * 2. * pi / n
valy = np.sin( valx )

fsin.setValues(valx, valy)
fsin.debugPrint( 6 )

# check that imported objects will be saved
from xxMultiSteps01a_imp import fcos
fcos.debugPrint( 6 )

code_aster.saveObjects()

# after the backup Code_Aster objects must be None
test.assertIsNone( fcos )
test.assertIsNone( fsin )

test.printSummary()
