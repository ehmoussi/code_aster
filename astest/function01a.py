#!/usr/bin/python

from math import sin, pi
import numpy as np

import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

fsin = code_aster.Function()
fsin.setParameterName("INST")
fsin.setResultName("TEMP")
fsin.setInterpolation("LIN LOG")
test.assertEqual( fsin.getType(), "FONCTION_SDASTER" )

with test.assertRaises(RuntimeError):
    fsin.setInterpolation("invalid")

fsin.setExtrapolation("CC")

# check properties assignment
prop = fsin.getProperties()
test.assertEqual( prop[1:5], ['LIN LOG', 'INST', 'TEMP', 'CC'] )

# values assignment
n = 10
valx = np.arange( n ) * 2. * pi / n
valy = np.sin( valx )

fsin.setValues(valx, valy)
fsin.debugPrint( 6 )

# check Function.abs()
fabs = fsin.abs()
arrabs = fabs.getValuesAsArray()
test.assertTrue( np.alltrue( arrabs[:, 1] >= 0. ) )

values = fsin.getValuesAsArray()
test.assertEqual( values.shape, ( n, 2 ) )

DF1=DEFI_FONCTION(NOM_PARA='INST', NOM_RESU='DEPL',
                  VERIF='CROISSANT',  PROL_DROITE='LINEAIRE',
                  ABSCISSE=(0., 1., 2.),  ORDONNEE=(0., 1., 3.)             )

DF2=DEFI_FONCTION(  NOM_PARA='INST',  NOM_RESU='DEPL',
                         INTERPOL='LOG',
                         PROL_GAUCHE='LINEAIRE',
                         VALE=( 3., 3., 4., 4.,  5., 5., )               )
print "getName", DF1.getName(), DF2.getName()
# DF1.debugPrint()

DN1=DEFI_NAPPE( NOM_PARA='AMOR', NOM_RESU='ACCE',
                VERIF='CROISSANT',  INTERPOL='LOG',
                PROL_DROITE='CONSTANT', PROL_GAUCHE='CONSTANT',
                PARA=( 0.01,  0.02, ), FONCTION=( DF1,  DF2, ) )

values2 = DN1.exportValuesToPython()
test.assertEqual( values2[1][0], [3.0, 4.0, 5.0] )

parameters = DN1.exportParametersToPython()
test.assertEqual( parameters, [0.01, 0.02] )

# DN1.debugPrint()
test.printSummary()

FIN()
