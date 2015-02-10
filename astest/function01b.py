#!/usr/bin/python

from math import sin, pi
import numpy as np

import code_aster
from code_aster.Commands import *

# values assignment
n = 10
valx = np.arange( n ) * 2. * pi / n
valy = np.sin( valx )

fsin = DEFI_FONCTION(NOM_PARA="INST",
                     NOM_RESU="TEMP",
                     ABSCISSE=valx,
                     ORDONNEE=valy,
                     INTERPOL=("LIN", "LOG"),)

fsin = DEFI_FONCTION(NOM_PARA="INST",
                     NOM_RESU="TEMP",
                     VALE_PARA=valx,
                     VALE_FONC=valy,
                     INTERPOL=("LIN", "LOG"),)

values = []
for x, y in zip(valx, valy):
    values.extend([x, y])

fsin = DEFI_FONCTION(NOM_PARA="INST",
                     NOM_RESU="TEMP",
                     VALE=values,
                     INTERPOL=("LIN", "LOG"),)

try:
    fsin = DEFI_FONCTION(NOM_PARA="INST",
                         NOM_RESU="TEMP",
                         ABSCISSE=valx,
                         ORDONNEE=np.arange( n - 1. ),
                         INTERPOL=("LIN", "LOG"),)
    raise AssertionError("should have failed!")
except RuntimeError:
    pass

try:
    bad_type = valy.tolist()
    bad_type[5] = "a"
    fsin = DEFI_FONCTION(NOM_PARA="INST",
                         NOM_RESU="TEMP",
                         ABSCISSE=valx,
                         ORDONNEE=bad_type,
                         INTERPOL=("LIN", "LOG"),)
    raise AssertionError("should have failed!")
except TypeError:
    pass
