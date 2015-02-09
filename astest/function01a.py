#!/usr/bin/python

from math import sin

import code_aster

fun = code_aster.Function()
fun.setParameterName("INST")
fun.setResultName("TEMP")
fun.setInterpolation("LIN LOG")

try:
    fun.setInterpolation("invalid")
except ValueError:
    pass
fun.setExtrapolation("CC")

n = 10
valx = [1. * i for i in range( n )]
valy = [sin(i) for i in valx]

fun.setValues(valx, valy)

fun.debugPrint(6)

values = fun.getValuesAsArray()
assert values.shape == ( n, 2 )
