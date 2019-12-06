# coding: utf-8

import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

MAILLA = code_aster.Mesh()
MAILLA.readMedFile("xxMechanicalLoad001a.mmed")

MODELE=AFFE_MODELE(MAILLAGE=MAILLA,
            AFFE=_F(GROUP_MA='CALCUL', PHENOMENE='MECANIQUE', MODELISATION='DKT'));


MATER=DEFI_MATERIAU(ELAS=_F(E=2.1E11, NU=0.30, RHO=7800.0));



CHAMPMAT=AFFE_MATERIAU(MAILLAGE=MAILLA, AFFE=_F(GROUP_MA='CALCUL', MATER=MATER));

########################################################################
#
#        PLAQUE APPUYEE SUR SES BORDS, DECOUPEE EN 4 PARTIES
#   SOUS-STRUCTURATION CLASSIQUE - INTERFACES TYPE CRAIG-BAMPTON
########################################################################


# SOUS-STRUCTURE ENCASTREE - INTERFACE TYPE CRAIG-BAMPTON

CHARGE=AFFE_CHAR_MECA(MODELE=MODELE,
                      DDL_IMPO=(_F(GROUP_NO='DROITE',
                                   DX=0.0,
                                   DY=0.0,
                                   DZ=0.0,
                                   DRX=0.0,
                                   DRY=0.0,
                                   DRZ=0.0),
                                _F(GROUP_NO='GAUCHE',
                                   DX=0.0,
                                   DY=0.0,
                                   DZ=0.0,
                                   DRX=0.0,
                                   DRY=0.0,
                                   DRZ=0.0),
                                _F(GROUP_NO='APPUI_1',
                                   DX=0.0,
                                   DY=0.0,
                                   DZ=0.0),
                                _F(GROUP_NO='APPUI_2',
                                   DX=0.0,
                                   DY=0.0,
                                   DZ=0.0)));

CHARGC=AFFE_CHAR_MECA_C(MODELE=MODELE,
                      DDL_IMPO=(_F(GROUP_NO='DROITE',
                                   DX=0.0,
                                   DY=0.0,
                                   DZ=0.0,
                                   DRX=0.0,
                                   DRY=0.0,
                                   DRZ=0.0),
                                _F(GROUP_NO='GAUCHE',
                                   DX=0.0,
                                   DY=0.0,
                                   DZ=0.0,
                                   DRX=0.0,
                                   DRY=0.0,
                                   DRZ=0.0),
                                _F(GROUP_NO='APPUI_1',
                                   DX=0.0,
                                   DY=0.0,
                                   DZ=0.0),
                                _F(GROUP_NO='APPUI_2',
                                   DX=0.0,
                                   DY=0.0,
                                   DZ=0.0)));

test.assertEqual(CHARGE.getType(), "CHAR_MECA")
test.assertEqual(CHARGC.getType(), "CHAR_MECA")

test.printSummary()

FIN()
