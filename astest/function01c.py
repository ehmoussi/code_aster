
import numpy as np
from math import sin, pi
import os

import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

n = 10
valx = np.arange(n) * 2. * pi / n
valy = np.sin(valx)

DEBUT()

fsin = DEFI_FONCTION(NOM_PARA="INST",
                     NOM_RESU="TEMP",
                     ABSCISSE=valx,
                     ORDONNEE=valy,)
fsin.debugPrint()

test.assertEqual(fsin.getProperties(),
                 ['FONCTION', 'LIN LIN', 'INST', 'TEMP', 'EE', '00000001'])
test.assertEqual(len(fsin.Absc()), n)
test.assertEqual(len(fsin.Ordo()), n)

test.assertAlmostEqual(fsin(0.), 0.)
test.assertAlmostEqual(fsin(0.62831853), 5.87785252e-01)

ftest = CALC_FONC_INTERP(FONCTION=fsin,
                         VALE_PARA=valx)
ftest.debugPrint()


IMPR_FONCTION(COURBE=_F(FONCTION=fsin),
              FORMAT='XMGRACE', UNITE=44)
test.assertTrue(os.path.exists('fort.44'))


# in '.resu' file
size_ini = os.stat('fort.8').st_size
IMPR_FONCTION(COURBE=_F(FONCTION=fsin))

size_end = os.stat('fort.8').st_size
test.assertTrue(size_end - size_ini > 400)

test.printSummary()

FIN()
