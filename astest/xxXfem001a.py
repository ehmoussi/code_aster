# coding: utf-8

import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

MAILLAG1 = code_aster.Mesh()
MAILLAG1.readAsterMeshFile("xxXfem001a.mail")


MO=AFFE_MODELE(MAILLAGE=MAILLAG1,
               AFFE=_F(TOUT='OUI',PHENOMENE='MECANIQUE',MODELISATION='3D'),
              );

LN = FORMULE(NOM_PARA=('X','Y','Z'),VALE='(X-3/4)**2+(Y-3/4)**2+(Z-1/4)**2-19/16');

FISS=DEFI_FISS_XFEM(MAILLAGE=MAILLAG1,
                    TYPE_DISCONTINUITE='INTERFACE',
                    DEFI_FISS=_F(FONC_LN=LN),
                    INFO=1);
CHERR = RAFF_XFEM(FISSURE=FISS)
MODELEK=MODI_MODELE_XFEM(MODELE_IN=MO,
                         FISSURE=FISS,
                         INFO=1);
test.assertEqual(MODELEK.getType(), "MODELE_SDASTER")


MA_XFEM=POST_MAIL_XFEM(MODELE = MODELEK);

test.assertEqual(MA_XFEM.getType(), "MAILLAGE_SDASTER")


test.printSummary()

FIN()
