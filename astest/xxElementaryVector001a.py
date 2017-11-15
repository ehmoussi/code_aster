#!/usr/bin/python
# coding: utf-8

import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

# test inspire de zzzz104b

MAIL = code_aster.Mesh.create()
MAIL.readMedFile("xxElementaryVector001a.med")


MOD=AFFE_MODELE(MAILLAGE=MAIL,
                  AFFE=_F(GROUP_MA='POUTRE',
                          PHENOMENE='MECANIQUE',
                          MODELISATION='D_PLAN',),)


BETON=DEFI_MATERIAU(ELAS=_F(E=200000000000.0,
                            NU=0.3,
                            ALPHA = 0.02),
                   )

TEMP1=CREA_CHAMP(OPERATION='AFFE',
                 TYPE_CHAM='NOEU_TEMP_R',
                 MAILLAGE=MAIL,
                 AFFE=_F( GROUP_MA='POUTRE',
                          NOM_CMP = ('TEMP',),
                          VALE =50.,
                        )
                )


CHMAT=AFFE_MATERIAU(MAILLAGE=MAIL,
                       AFFE=_F(TOUT='OUI',
                               MATER=BETON,),
                   )

BLOQ=AFFE_CHAR_MECA(MODELE=MOD,
                     DDL_IMPO=(_F(GROUP_MA=('ENCNEG',),
                                  DX=0.0,
                                  DY=0.0,
                                  ),
                               _F(GROUP_MA=('ENCPOS',),
                                  DY=0.0,
                                  ),
                                ),
                               );


rigiel    = CALC_MATR_ELEM(MODELE=MOD, CHAM_MATER=CHMAT, OPTION='RIGI_MECA', CHARGE=BLOQ)
vecel     = CALC_VECT_ELEM(CHARGE=BLOQ, INST=1.0, CHAM_MATER=CHMAT, OPTION='CHAR_MECA')
numeddl   = NUME_DDL(MATR_RIGI = rigiel)
matass    = ASSE_MATRICE(MATR_ELEM=rigiel , NUME_DDL=numeddl)

#matass    = FACTORISER(reuse=matass, MATR_ASSE=matass)
#matass.factorization()
