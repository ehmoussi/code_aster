#!/usr/bin/python

from math import sin

import code_aster

fun = code_aster.Function()
fun.setParameterName("INST")
fun.setResultName("TEMP")
fun.setInterpolation("LIN LOG")

try:
    fun.setInterpolation("invalid")
    raise AssertionError("invalid assignment should have failed")
except ValueError:
    pass

fun.setExtrapolation("CC")

n = 10
valx = [1. * i for i in range( n )]
valy = [sin(i) for i in valx]

fun.setValues(valx, valy)

fun.debugPrint( 6 )

values = fun.getValuesAsArray()
assert values.shape == ( n, 2 )

# read-only view
view = fun.getValuesAsArray(copy=False)
try:
    view[1, 0] = 1.
    raise AssertionError("assignment should have failed")
except ValueError:
    pass

view = fun.getValuesAsArray(copy=False, writeable=True)
assert view.shape == ( n, 2 )

view[:, 1] = [i**2 for i in range( n )]
fun.debugPrint( 6 )

del fun
# view must not be used now, it points on invalid data.
assert values[0, 0] == 0.
