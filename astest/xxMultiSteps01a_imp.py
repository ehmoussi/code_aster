#!/usr/bin/python
# coding: utf-8

from math import pi
import numpy as np

import code_aster

fcos = code_aster.Function()
fcos.setParameterName("INST")
fcos.setResultName("TEMP")

# values assignment
n = 20
valx = np.arange( n ) * 2. * pi / n
valy = np.cos( valx )

fcos.setValues(valx, valy)
