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

# Warning: xxMultiSteps01a_imp has not been imported in this session
# so it is "replayed", a new 'fcos' object is created.
from xxMultiSteps01a_imp import fcos as fcos2
test.assertNotEqual(fcos.getName(), fcos2.getName())

# 'form' was created during the first import, not now
from xxMultiSteps01a_imp import form
test.assertEqual(form(1.), 2.)

test.printSummary()

FIN()
