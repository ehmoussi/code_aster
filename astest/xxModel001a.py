#!/usr/bin/python
# coding: utf-8

import code_aster
from code_aster.Commands import *


test = code_aster.TestCase()

mail1 = LIRE_MAILLAGE( FORMAT = "MED" )

model = AFFE_MODELE( MAILLAGE = mail1,
                     AFFE = _F( MODELISATION = "3D",
                                PHENOMENE = "MECANIQUE",
                                TOUT = "OUI", ), )

# at least check that it passes here
test.assertTrue( True )
test.printSummary()
