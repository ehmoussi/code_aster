#!/usr/bin/python
# coding: utf-8

import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

MASEC1 = code_aster.Mesh()
MASEC1.readGibiFile("zzzz330a.18")
MASEC1.debugPrint()

exc_ref=0.023148148

GF_REF=DEFI_GEOM_FIBRE(
           SECTION = (_F ( GROUP_FIBRE='SEC1',
                            MAILLAGE_SECT = MASEC1 , TOUT_SECT = 'OUI',
                            COOR_AXE_POUTRE = (0.,exc_ref)),
            )
            )

# Test trivial
test.assertTrue( True )

FIN()
