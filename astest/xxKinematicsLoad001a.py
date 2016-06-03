#!/usr/bin/python
# coding: utf-8

import code_aster
from code_aster.Commands import *


test = code_aster.TestCase()

mail1 = code_aster.Mesh()

# Relecture du fichier MED
mail1.readMedFile("fort.20")

model = AFFE_MODELE( MAILLAGE = mail1,
                     AFFE = _F( MODELISATION = "3D",
                                PHENOMENE = "MECANIQUE",
                                TOUT = "OUI", ), )

load = AFFE_CHAR_CINE( MODELE = model,
                       MECA_IMPO = ( _F( GROUP_MA = "Bas", DX = 0. ),
                                     _F( GROUP_MA = "Bas", DY = 0. ),
                                     _F( GROUP_MA = "Bas", DZ = 0. ), ), )

load2 = AFFE_CHAR_CINE( MODELE = model,
                        MECA_IMPO = ( _F( GROUP_MA = "Haut", DZ = 1. ), ), )

# at least check that it passes here
test.assertTrue( True )
test.printSummary()
