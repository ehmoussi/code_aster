#!/usr/bin/python

from math import sin, pi
import numpy as np

import code_aster

fsin = code_aster.Function()
fsin.setParameterName("INST")
fsin.setResultName("TEMP")
fsin.setInterpolation("LIN LOG")

try:
    fsin.setInterpolation("invalid")
    raise AssertionError("invalid assignment should have failed")
except ValueError:
    pass

fsin.setExtrapolation("CC")

# check properties assignment
prop = fsin.getProperties()
# assert prop[1:5] == ['LIN LOG', 'INST', 'TEMP', 'CC'], prop[1:5]

# values assignment
n = 10
valx = np.arange( n ) * 2. * pi / n
valy = np.sin( valx )

fsin.setValues(valx, valy)
fsin.debugPrint( 6 )

# check Function.abs()
fabs = fsin.abs()
arrabs = fabs.getValuesAsArray(copy=False)
assert np.alltrue( arrabs[:, 1] ) >= 0., arrabs

values = fsin.getValuesAsArray()
assert values.shape == ( n, 2 )

# read-only view
view = fsin.getValuesAsArray(copy=False)
try:
    view[1, 0] = 1.
    raise AssertionError("assignment should have failed")
except ValueError:
    pass

# change values of fsin that becomes fcos
view = fsin.getValuesAsArray(copy=False, writeable=True)
assert view.shape == ( n, 2 )
view[:, 1] = np.cos( valx )
fcos = fsin
del fsin
fcos.debugPrint( 6 )


# view must not be used now, it points on invalid data
assert values[0, 0] == 0.
