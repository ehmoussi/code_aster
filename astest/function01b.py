#!/usr/bin/python

from math import sin, pi
import numpy as np

import code_aster
from code_aster.Commands import *


tps = DEFI_LIST_REEL(VALE=(0,0.5,1,),)
assert tps.size == 3

tps = DEFI_LIST_REEL(DEBUT=0,
                     INTERVALLE=_F(JUSQU_A=3,
                                   NOMBRE=3,),)
assert tps.size == 4

tps = DEFI_LIST_REEL(DEBUT=0.0,
                     INTERVALLE=_F(JUSQU_A=1.0,
                                   NOMBRE=10,),)
assert tps.size == 11
assert tps.max() == 1.0


tps = DEFI_LIST_REEL(DEBUT=0.0,
                     INTERVALLE=_F(JUSQU_A=10.0,
                                   PAS=0.7,),)
assert tps.size == 16
assert tps.max() == 10.0

tps = DEFI_LIST_REEL(DEBUT=0.0,
                     INTERVALLE=_F(JUSQU_A=10.0,
                                   PAS=0.9999,),)
assert tps.size == 12
assert tps.max() == 10.0

# check last step
tps = DEFI_LIST_REEL(DEBUT=0.0,
                     INTERVALLE=_F(JUSQU_A=10.0,
                                   PAS=0.999999,),)
assert tps.size == 11
assert tps.max() == 10.0

tps = DEFI_LIST_REEL(DEBUT=0.0,
                     INTERVALLE=_F(JUSQU_A=10.0,
                                   PAS=1.01),)
assert tps.size == 11
assert tps.max() == 10.0

tps = DEFI_LIST_REEL(DEBUT=0.0,
                     INTERVALLE=_F(JUSQU_A=10.0,
                                   PAS=1.000001),)
assert tps.size == 11
assert tps.max() == 10.0

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
