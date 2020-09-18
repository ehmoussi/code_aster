# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
# This file is part of code_aster.
#
# code_aster is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# code_aster is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with code_aster.  If not, see <http://www.gnu.org/licenses/>.
# --------------------------------------------------------------------

from math import sin, pi
import numpy as np

import code_aster
from code_aster.Commands import *

code_aster.init("--test", ERREUR=_F(ERREUR_F='EXCEPTION'))

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
                     INTERPOL=("LIN", "LIN"),)

lvalx = DEFI_LIST_REEL(VALE=valx)
lvaly = DEFI_LIST_REEL(VALE=valy)

fsin = DEFI_FONCTION(NOM_PARA="INST",
                     NOM_RESU="TEMP",
                     VALE_PARA=lvalx,
                     VALE_FONC=lvaly,
                     INTERPOL=("LIN", "LIN"),)

values = []
for x, y in zip(valx, valy):
    values.extend([x, y])

fsin = DEFI_FONCTION(NOM_PARA="INST",
                     NOM_RESU="TEMP",
                     VALE=values,
                     INTERPOL=("LIN", "LIN"),)

with test.assertRaisesRegex(code_aster.AsterError, "listes.*longueurs"):
    fsin = DEFI_FONCTION(NOM_PARA="INST",
                         NOM_RESU="TEMP",
                         ABSCISSE=valx,
                         ORDONNEE=np.arange( n - 1. ),
                         INTERPOL=("LIN", "LIN"),)

with test.assertRaisesRegex(code_aster.AsterError, "Unexpected type.*str"):
    bad_type = valy.tolist()
    bad_type[5] = "a"
    fsin = DEFI_FONCTION(NOM_PARA="INST",
                         NOM_RESU="TEMP",
                         ABSCISSE=valx,
                         ORDONNEE=bad_type,
                         INTERPOL=("LIN", "LOG"),)

test.printSummary()

FIN()
