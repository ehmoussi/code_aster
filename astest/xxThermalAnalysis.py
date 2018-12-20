#!/usr/bin/python
# coding: utf-8

import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

MAIL=code_aster.Mesh()
MAIL.readMedFile("forma02a.mmed")

MAIL=MODI_MAILLAGE(reuse =MAIL,
                   MAILLAGE=MAIL,
                   ORIE_PEAU_3D=_F(GROUP_MA='SURFINT',),);

MATER=DEFI_MATERIAU(ELAS=_F(E=204000000000.0,
                            NU=0.3,
                            ALPHA=1.096e-05,),
                    THER=_F(LAMBDA=54.6,
                            RHO_CP=3710000.0,),);

MODTH=AFFE_MODELE(MAILLAGE=MAIL,
                  AFFE=_F(TOUT='OUI',
                          PHENOMENE='THERMIQUE',
                          MODELISATION='3D',),);

CHMATER=AFFE_MATERIAU(MAILLAGE=MAIL,
                      AFFE=_F(TOUT='OUI',
                              MATER=MATER,),);

F_TEMP=DEFI_FONCTION(NOM_PARA='INST',VALE=(0,20,
                           10,70,
                           ),);

CHARTH=AFFE_CHAR_THER_F(MODELE=MODTH,
                        TEMP_IMPO=_F(GROUP_MA='SURFINT',
                                     TEMP=F_TEMP,),);

LINST=DEFI_LIST_REEL(VALE=(0,5,10,),);

F_MULT=DEFI_FONCTION(NOM_PARA='INST',VALE=(0,1,
                           10,1,
                           ),);

TEMPE=THER_LINEAIRE(MODELE=MODTH,
                    CHAM_MATER=CHMATER,
                    EXCIT=_F(CHARGE=CHARTH,
                             FONC_MULT=F_MULT,),
                    INCREMENT=_F(LIST_INST=LINST,),
                    ETAT_INIT=_F(VALE=20,),);

test.assertEqual(TEMPE.getType(), "EVOL_THER")

test.printSummary()

FIN()
