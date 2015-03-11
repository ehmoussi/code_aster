#!/usr/bin/python

import code_aster
from code_aster.Commands import *

mail1 = LIRE_MAILLAGE( FORMAT = "MED" )

model = AFFE_MODELE( MAILLAGE = mail1,
                     AFFE = _F( MODELISATION = "3D",
                                PHENOMENE = "MECANIQUE", 
                                TOUT = "OUI", ), )
