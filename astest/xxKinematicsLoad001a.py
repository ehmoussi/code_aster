#!/usr/bin/python

import code_aster
from code_aster.Commands import *

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
