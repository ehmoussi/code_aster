#!/usr/bin/python
# coding: utf-8

import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

MA = code_aster.Mesh()
MA.readMedFile("zzzz314a.mmed")

FISS0=DEFI_FOND_FISS(MAILLAGE=MA,
                     SYME='NON',
                     FOND_FISS=_F(GROUP_NO='FOND',),
                     LEVRE_SUP=_F(GROUP_MA='LEVR_SUP',),
                     LEVRE_INF=_F(GROUP_MA='LEVR_INF',),)

# Test trivial
test.assertTrue( True )

FIN()
