# coding: utf-8

from math import pi

import numpy as np

import code_aster
from code_aster.Commands import FORMULE

fcos = code_aster.Function()
fcos.setParameterName("INST")
fcos.setResultName("TEMP")

# values assignment
n = 20
valx = np.arange( n ) * 2. * pi / n
valy = np.cos( valx )

fcos.setValues(valx, valy)

form = FORMULE(NOM_PARA="X", VALE="2 * X")
