# coding=utf-8

import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()


MAIL=code_aster.Mesh()
MAIL.readMedFile("zzzz351a.mmed")

MODELE=AFFE_MODELE(MAILLAGE=MAIL,
                   AFFE=_F(TOUT='OUI', PHENOMENE='MECANIQUE', MODELISATION='3D',),);

MAT=DEFI_MATERIAU(ELAS=_F(E=200.e9, NU=0.3, RHO=8000.0,),);

CHMAT=AFFE_MATERIAU(MAILLAGE=MAIL,
                    AFFE=_F(TOUT='OUI', MATER=MAT,),);

BLOCAGE=AFFE_CHAR_MECA(MODELE=MODELE,
                       DDL_IMPO=_F(GROUP_MA='BLOK',
                                   DX=0.0,
                                   DY=0.0,
                                   DZ=0.0,),);

ASSEMBLAGE (    MODELE=MODELE,
                CHAM_MATER=CHMAT,
                CHARGE=BLOCAGE,
                NUME_DDL=CO('NUMEDDL'),
                MATR_ASSE=(_F(MATRICE=CO('K1'),
                              OPTION='RIGI_MECA',),
                           _F(MATRICE=CO('M1'),
                              OPTION='MASS_MECA',),),);

test.assertEqual(K1.getType(), "MATR_ASSE_DEPL_R")
test.assertEqual(M1.getType(), "MATR_ASSE_DEPL_R")
test.assertEqual(NUMEDDL.getType(), "NUME_DDL_SDASTER")


MODE1=CALC_MODES( OPTION='BANDE',
                  MATR_RIGI=K1,
                  MATR_MASS=M1,
                  CALC_FREQ=_F( FREQ=(10., 250.) ),
                  VERI_MODE=_F( SEUIL=1e-03 )
                 )

TEST_RESU(RESU=_F(RESULTAT=MODE1, NUME_MODE=2, PARA='FREQ', VALE_CALC= 85.631015163879, ))



test.printSummary()

FIN()
