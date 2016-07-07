# coding: utf-8

import code_aster
from code_aster.Commands import *

test = code_aster.TestCase()

mail1 = LIRE_MAILLAGE( FORMAT = "MED" )

model = AFFE_MODELE( MAILLAGE = mail1,
                     AFFE = _F( MODELISATION = "3D",
                                PHENOMENE = "MECANIQUE",
                                TOUT = "OUI", ), )

MATER1 = DEFI_MATERIAU( ELAS = _F( E = 200000.0,
                                   NU = 0.3, ), )

AFFMAT = AFFE_MATERIAU( MAILLAGE = mail1,
                        AFFE = _F( TOUT = 'OUI',
                                   MATER = MATER1, ), )

load = AFFE_CHAR_CINE( MODELE = model,
                       MECA_IMPO = ( _F( GROUP_MA = "Bas", DX = 0. ),
                                     _F( GROUP_MA = "Bas", DY = 0. ),
                                     _F( GROUP_MA = "Bas", DZ = 0. ), ), )

load2 = AFFE_CHAR_CINE( MODELE = model,
                        MECA_IMPO = ( _F( GROUP_MA = "Haut", DZ = 1. ), ), )

resu = MECA_STATIQUE( MODELE = model,
                      CHAM_MATER = AFFMAT,
                      EXCIT = ( _F( CHARGE = load, ),
                                _F( CHARGE = load2, ), ),
                      SOLVEUR = _F( METHODE = "MUMPS",
                                    RENUM = "METIS", ), )

resu.debugPrint()

# Debut du TEST_RESU
MyFieldOnNodes = resu.getRealFieldOnNodes("DEPL", 0)
sfon = MyFieldOnNodes.exportToSimpleFieldOnNodes()
#sfon.debugPrint()
sfon.updateValuePointers()

test.assertAlmostEqual(sfon.getValue(5, 3), -0.159403241003)

test.printSummary()
# Fin du TEST_RESU
