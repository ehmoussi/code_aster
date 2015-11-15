#!/usr/bin/python
# coding: utf-8

import numpy as np

import code_aster


assert type(fsin) is code_aster.Function, ctxt.keys()
assert type(fcos) is code_aster.Function, ctxt.keys()

fsin.debugPrint( 6 )
assert fsin.size() == 10, fsin.size()
assert fcos.size() == 20, fcos.size()

# continue...
# check Function.abs()
fabs = fsin.abs()
fabs.debugPrint( 6 )

arrabs = fabs.getValuesAsArray(copy=False)
assert np.alltrue( arrabs[:, 1] ) >= 0., arrabs
