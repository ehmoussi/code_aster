# coding: utf-8

import code_aster
from code_aster.Commands import *

code_aster.init("--continue")

test = code_aster.TestCase()

test.assertTrue(MAIL.hasGroupOfCells("BLOK"))
test.assertTrue(MAIL.hasGroupOfCells("VOL"))

support = MODELE.getMesh()
test.assertTrue(support.hasGroupOfCells("VOL"))
del support

asse = ASSEMBLAGE(MODELE=MODELE,
                  CHAM_MATER=CHMAT,
                  CHARGE=BLOCAGE,
                  NUME_DDL=CO('NUMEDDL'),
                  MATR_ASSE=(_F(MATRICE=CO('K1'),
                                OPTION='RIGI_MECA',),
                             _F(MATRICE=CO('M1'),
                                OPTION='MASS_MECA',),),)
test.assertIsNone(asse)

# 1. Calcul de reference avec les matrices "completes" :
#--------------------------------------------------------
MODE1 = CALC_MODES(OPTION='BANDE',
                   MATR_RIGI=K1,
                   MATR_MASS=M1,
                   CALC_FREQ=_F(FREQ=(10., 250.)),
                   VERI_MODE=_F(SEUIL=1e-03)
                   )

TEST_RESU(RESU=_F(RESULTAT=MODE1, NUME_MODE=2,
                  PARA='FREQ', VALE_CALC=85.631015163879, ))

test.printSummary()

FIN()
