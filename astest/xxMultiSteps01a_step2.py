#!/usr/bin/python
# coding: utf-8

import numpy as np

import code_aster


test = code_aster.TestCase()

test.assertTrue( type(fsin) is code_aster.Function )
test.assertTrue( type(fcos) is code_aster.Function )

fsin.debugPrint( 6 )
test.assertEqual( fsin.size(), 10 )
test.assertEqual( fcos.size(), 20 )

# continue...
# check Function.abs()
fabs = fsin.abs()
fabs.debugPrint( 6 )

arrabs = fabs.getValuesAsArray(copy=False)
test.assertTrue( np.alltrue( arrabs[:, 1] >= 0. ) )
