#!/usr/bin/python
# coding: utf-8

import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

MA0 = LIRE_MAILLAGE(FORMAT = 'MED', UNITE=20);

MA  = CREA_MAILLAGE(MAILLAGE  = MA0,
            LINE_QUAD = _F(TOUT='OUI'),);

MOD = AFFE_MODELE(MAILLAGE = MA,
                  AFFE     = (_F(TOUT='OUI',
                                 PHENOMENE    ='MECANIQUE',
                                 MODELISATION = 'D_PLAN_HM_SI',),),
                  VERI_JACOBIEN = 'NON',);

RESUREF = LIRE_RESU(TYPE_RESU  = 'EVOL_NOLI',
                    FORMAT     = 'MED',
                    MODELE     = MOD,
                    FORMAT_MED = (_F(NOM_RESU = 'U_9',
                                     NOM_CHAM = 'SIEF_ELGA'),) ,
                    UNITE      = 21,
                    TOUT_ORDRE = 'OUI',);

test.assertEqual(RESUREF.getType(), "EVOL_NOLI")
test.assertTrue( True )
test.printSummary()

FIN()
