# coding: utf-8

from math import pi
import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

So=1/(2.*pi)
INTKTJ1=DEFI_INTE_SPEC(    DIMENSION=1,
                         KANAI_TAJIMI=_F(  NUME_ORDRE_I = 1,
                                        NUME_ORDRE_J = 1,
                                        FREQ_MIN = 0.,
                                        FREQ_MAX = 50.,
                                        PAS = 1.,
                                        AMOR_REDUIT = 0.6,
                                        FREQ_MOY = 5.,
                                        VALE_R = So,
                                        INTERPOL = 'LIN',
                                        PROL_GAUCHE = 'CONSTANT',
                                        PROL_DROITE = 'CONSTANT')
                       )

# Test trivial
test.assertTrue( True )

FIN()
