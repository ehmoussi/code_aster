#!/usr/bin/python

from math import sin, pi
import numpy as np

import code_aster
from code_aster.Commands import *


test = code_aster.TestCase()

fsin = code_aster.Function()
fsin.setParameterName("INST")
fsin.setResultName("TEMP")
fsin.setInterpolation("LIN LOG")
test.assertEqual( fsin.getType(), "FONCTION" )

with test.assertRaises(ValueError):
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
arrabs = fabs.getValuesAsArray(copy=False)
test.assertTrue( np.alltrue( arrabs[:, 1] >= 0. ) )

values = fsin.getValuesAsArray()
test.assertEqual( values.shape, ( n, 2 ) )

# read-only view
view = fsin.getValuesAsArray(copy=False)
with test.assertRaises(ValueError):
    view[1, 0] = 1.

# change values of fsin that becomes fcos
view = fsin.getValuesAsArray(copy=False, writeable=True)
test.assertEqual( view.shape, ( n, 2 ) )
view[:, 1] = np.cos( valx )
fcos = fsin
del fsin
fcos.debugPrint( 6 )

# view must not be used now, it points on invalid data
test.assertEqual( values[0, 0], 0. )

DF1=DEFI_FONCTION(  NOM_PARA='INST',  NOM_RESU='DEPL',
                         VERIF='CROISSANT',  PROL_DROITE='LINEAIRE',
                         VALE_PARA=(0., 1., 2.),  VALE_FONC=(0., 1., 3.)             )

DF2=DEFI_FONCTION(  NOM_PARA='INST',  NOM_RESU='DEPL',
                         INTERPOL='LOG',
                         PROL_GAUCHE='LINEAIRE',
                         VALE=( 3., 3., 4., 4.,  5., 5., )               )
print "getName", DF1.getName(), DF2.getName()
DF1.debugPrint()

DN1=DEFI_NAPPE( NOM_PARA='AMOR', NOM_RESU='ACCE',
                VERIF='CROISSANT',  INTERPOL='LOG',
                PROL_DROITE='CONSTANT', PROL_GAUCHE='CONSTANT',
                PARA=( 0.01,  0.02, ), FONCTION=( DF1,  DF2, ) )
DN1.debugPrint()
test.printSummary()
