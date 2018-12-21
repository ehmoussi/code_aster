#!/usr/bin/python
# coding: utf-8

import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

MESH = code_aster.Mesh()
MESH.readMedFile("sdll110a.mmed")

MESH=MODI_MAILLAGE(reuse=MESH, MAILLAGE=MESH,ABSC_CURV=_F(NOEUD_ORIG='N_01_001',TOUT='OUI'))

MESH=DEFI_GROUP(reuse=MESH,
                MAILLAGE=MESH,
                CREA_GROUP_NO=(_F(NOM='GR_NO_INIT',
                                  NOEUD='N_02_001',),
                               _F(NOM='GR_NO_FIN',
                                  NOEUD='N_02_060',),),
                CREA_GROUP_MA=_F(NOM='POUTRE',
                                 TOUT='OUI',),);

MODELE=AFFE_MODELE(  MAILLAGE=MESH,
                     AFFE=_F(  GROUP_MA = 'POUTRE',
                            PHENOMENE = 'MECANIQUE',
                            MODELISATION = 'POU_D_T')
)

CARA=AFFE_CARA_ELEM(   MODELE=MODELE,
                       POUTRE=_F(  GROUP_MA = 'POUTRE',
                                SECTION = 'CERCLE',
                                CARA = ( 'R','EP',),
                                VALE = ( 7.939000E-03,
                                            3.176000E-03, ))
)
PROFVIT1=DEFI_FONC_FLUI(MAILLAGE=MESH,
                        GROUP_NO_INIT='GR_NO_INIT',
                        NOEUD_FIN='N_02_060',
                        VITE=_F(PROFIL='UNIFORME',
                                VALE=1.000000E+00),);

TYPEFLUI=DEFI_FLUI_STRU(
               FAISCEAU_TRANS=_F(
             COUPLAGE = 'OUI',
             CARA_ELEM = CARA,
             COEF_MASS_AJOU = 2.071110E+00,
             NOM_CMP = 'DX',
             TYPE_PAS = 'CARRE_LIGN',
             TYPE_RESEAU = 1001,
             PAS = 1.500000E+00,
             PROF_VITE_FLUI = PROFVIT1),
                           INFO=2)

FONC_CM=FONC_FLUI_STRU(  TYPE_FLUI_STRU=TYPEFLUI)
test.assertEqual(TYPEFLUI.getType(), "TYPE_FLUI_STRU")
test.assertEqual(FONC_CM.getType(), "FONCTION_SDASTER")

test.printSummary()

FIN()
