#!/usr/bin/python
# coding: utf-8

import numpy as np

import code_aster

# users will usually load all objects in the current context
#code_aster.loadObjects( globals() )

ctxt = {}
code_aster.loadObjects( ctxt )

assert type(ctxt['fsin']) is code_aster.Function, ctxt.keys()

fsin = ctxt['fsin']
fsin.debugPrint( 6 )
assert fsin.size() == 10, fsin.size()

# continue...
# check Function.abs()
fabs = fsin.abs()
fabs.debugPrint( 6 )

arrabs = fabs.getValuesAsArray(copy=False)
assert np.alltrue( arrabs[:, 1] ) >= 0., arrabs
