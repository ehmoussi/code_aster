#!/usr/bin/python
# coding: utf-8

from math import pi
import numpy as np

import code_aster

fsin = code_aster.Function()
fsin.setParameterName("INST")
fsin.setResultName("TEMP")

# values assignment
n = 10
valx = np.arange( n ) * 2. * pi / n
valy = np.sin( valx )

fsin.setValues(valx, valy)
fsin.debugPrint( 6 )

from xxMultiSteps01a_imp import fcos
fcos.debugPrint( 6 )

code_aster.saveObjects()

# after the backup Code_Aster objects must not available
try:
    print fsin
    raise ValueError("object must not be available!")
except NameError:
    print "ok"
