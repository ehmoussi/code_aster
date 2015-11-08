#!/usr/bin/python
# coding: utf-8

from math import pi
import numpy as np

import code_aster
from code_aster.Commands import DEFI_LIST_REEL

fsin = code_aster.Function()
fsin.setParameterName("INST")
fsin.setResultName("TEMP")

# values assignment
n = 10
valx = np.arange( n ) * 2. * pi / n
valy = np.sin( valx )

fsin.setValues(valx, valy)
fsin.debugPrint( 6 )

code_aster.saveObjects( globals() )
