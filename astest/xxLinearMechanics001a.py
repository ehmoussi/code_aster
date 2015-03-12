
import code_aster
from code_aster.Commands import *

mail1 = LIRE_MAILLAGE( FORMAT = "MED" )

model = AFFE_MODELE( MAILLAGE = mail1,
                     AFFE = _F( MODELISATION = "3D",
                                PHENOMENE = "MECANIQUE", 
                                TOUT = "OUI", ), )

MATER1 = DEFI_MATERIAU( ELAS = _F( E = 200000.0,
                                   NU = 0.3, ), )

AFFMAT = AFFE_MATERIAU( MAILLAGE = mail1,
                        AFFE = _F(TOUT = 'OUI',
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
                                    RENUM = "METIS", ),
                      )

resu.debugPrint()
