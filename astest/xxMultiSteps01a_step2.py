# coding: utf-8

import numpy as np
import code_aster
from code_aster.Commands import *

code_aster.init("--continue")
# POURSUITE()

test = code_aster.TestCase()

test.assertTrue(isinstance(fsin, code_aster.Function))
test.assertTrue(isinstance(fcos, code_aster.Function))

fsin.debugPrint(6)
test.assertEqual(fsin.size(), 10)
test.assertEqual(fcos.size(), 20)

# continue...
# check Function.abs()
fabs = fsin.abs()
fabs.debugPrint( 6 )

arrabs = fabs.getValuesAsArray()
test.assertTrue( np.alltrue( arrabs[:, 1] >= 0. ) )

test.printSummary()

FIN()
