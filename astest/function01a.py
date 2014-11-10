#!/usr/bin/python

from math import sin

import code_aster

fun = code_aster.Function()
fun.setParameterName("INST")
fun.setResultName("TEMP")

# valx = code_aster.VectorDouble(10)
# valy = code_aster.VectorDouble(10)
# for i in range(10):
#     valx[i] = 1. * i
#     valy[i] = sin(1. * i)
valx = [1. * i for i in range(10)]
valy = [sin(i) for i in valx]

fun.setValues(valx, valy)

fun.build()
fun.debugPrint(6)
