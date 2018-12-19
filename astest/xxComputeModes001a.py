#!/usr/bin/python
# coding: utf-8

import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

MAIL = code_aster.Mesh()
MAIL.readMedFile("forma02b.mmed")

MODELE=AFFE_MODELE(MAILLAGE=MAIL,
                   AFFE=_F(TOUT='OUI',
                           PHENOMENE='MECANIQUE',
                           MODELISATION='3D',),);

MAT=DEFI_MATERIAU(ELAS=_F(E=204000000000.0,
                          NU=0.3,
                          RHO=7800.0,),);

CHMAT=AFFE_MATERIAU(MAILLAGE=MAIL,
                    AFFE=_F(TOUT='OUI',
                            MATER=MAT,),);

BLOCAGE=AFFE_CHAR_MECA(MODELE=MODELE,
                       DDL_IMPO=_F(GROUP_MA='BASE',
                                   DX=0.0,
                                   DY=0.0,
                                   DZ=0.0,),);

ASSEMBLAGE(MODELE=MODELE,
                CHAM_MATER=CHMAT,
                CHARGE=BLOCAGE,
                NUME_DDL=CO('NUMEDDL'),
                MATR_ASSE=(_F(MATRICE=CO('RIGIDITE'),
                              OPTION='RIGI_MECA',),
                           _F(MATRICE=CO('MASSE'),
                              OPTION='MASS_MECA',),),);

MODES=CALC_MODES(MATR_RIGI=RIGIDITE,
                 OPTION='PLUS_PETITE',
                 CALC_FREQ=_F(NMAX_FREQ=10,
                              ),
                 MATR_MASS=MASSE,
                 )


TEST_RESU(RESU=_F(NUME_ORDRE=1,
                  PARA='FREQ',
                  RESULTAT=MODES,
                  VALE_CALC=8.92046162697,
                  ),
          )

test.assertEqual(MODES.getType(), "MODE_MECA")

BAMODA=DEFI_BASE_MODALE( 
                    RITZ=( _F( MODE_MECA=MODES),),);

test.assertEqual(BAMODA.getType(), "MODE_MECA")

MAC=MAC_MODES(BASE_1=BAMODA,
              BASE_2=BAMODA,
              MATR_ASSE=MASSE,
              );

test.assertEqual(MAC.getType(), "TABLE_SDASTER")

IMPR_CO(CONCEPT=_F(NOM=BAMODA))

test.printSummary()

FIN()
