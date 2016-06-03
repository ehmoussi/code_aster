#!/usr/bin/python

from math import sin, pi
import numpy as np

import code_aster
from code_aster.Commands import *


test = code_aster.TestCase()

tps = DEFI_LIST_REEL(VALE=(0,0.5,1,),)
test.assertEqual( tps.size, 3 )

tps = DEFI_LIST_REEL(DEBUT=0,
                     INTERVALLE=_F(JUSQU_A=3,
                                   NOMBRE=3,),)
test.assertEqual( tps.size, 4 )

tps = DEFI_LIST_REEL(DEBUT=0.0,
                     INTERVALLE=_F(JUSQU_A=1.0,
                                   NOMBRE=10,),)
test.assertEqual( tps.size, 11 )
test.assertAlmostEqual( tps.max(), 1.0 )


tps = DEFI_LIST_REEL(DEBUT=0.0,
                     INTERVALLE=_F(JUSQU_A=10.0,
                                   PAS=0.7,),)
test.assertEqual( tps.size, 16 )
test.assertAlmostEqual( tps.max(), 10.0 )

tps = DEFI_LIST_REEL(DEBUT=0.0,
                     INTERVALLE=_F(JUSQU_A=10.0,
                                   PAS=0.9999,),)
test.assertEqual( tps.size, 12 )
test.assertAlmostEqual( tps.max(), 10.0 )

# check last step
tps = DEFI_LIST_REEL(DEBUT=0.0,
                     INTERVALLE=_F(JUSQU_A=10.0,
                                   PAS=0.999999,),)
test.assertEqual( tps.size, 11 )
test.assertAlmostEqual( tps.max(), 10.0 )

tps = DEFI_LIST_REEL(DEBUT=0.0,
                     INTERVALLE=_F(JUSQU_A=10.0,
                                   PAS=1.01),)
test.assertEqual( tps.size, 11 )
test.assertAlmostEqual( tps.max(), 10.0 )

tps = DEFI_LIST_REEL(DEBUT=0.0,
                     INTERVALLE=_F(JUSQU_A=10.0,
                                   PAS=1.000001),)
test.assertEqual( tps.size, 11 )
test.assertAlmostEqual( tps.max(), 10.0 )

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

with test.assertRaisesRegexp(RuntimeError, "length.*must be equal"):
    fsin = DEFI_FONCTION(NOM_PARA="INST",
                         NOM_RESU="TEMP",
                         ABSCISSE=valx,
                         ORDONNEE=np.arange( n - 1. ),
                         INTERPOL=("LIN", "LOG"),)

with test.assertRaisesRegexp(TypeError, "str"):
    bad_type = valy.tolist()
    bad_type[5] = "a"
    fsin = DEFI_FONCTION(NOM_PARA="INST",
                         NOM_RESU="TEMP",
                         ABSCISSE=valx,
                         ORDONNEE=bad_type,
                         INTERPOL=("LIN", "LOG"),)

test.printSummary()
