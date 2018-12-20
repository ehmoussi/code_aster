
#!/usr/bin/python
# coding: utf-8

import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()


#----------------------------------------------
#            MAILLAGE
#----------------------------------------------

MAIL=LIRE_MAILLAGE(FORMAT='ASTER',);


# Cas Hexa27

MODL27=AFFE_MODELE(MAILLAGE=MAIL,
                   AFFE=_F(GROUP_MA='Hexa27',
                           PHENOMENE='MECANIQUE',
                           MODELISATION='3D',),);


CHAM27_2=LIRE_CHAMP(UNITE=80,
                    FORMAT='MED',
                    NOM_MED='CHAM27_1',
                    TYPE_CHAM='NOEU_DEPL_R',
                    NOM_CMP_IDEM='OUI',
                    MAILLAGE=MAIL,);

IMPR_RESU(FORMAT='RESULTAT',
          RESU=_F(CHAM_GD=CHAM27_2,),);

TEST_RESU(CHAM_NO=(_F(CHAM_GD=CHAM27_2,
                        NOM_CMP='DX',
                        NOEUD='N1',
                        VALE_CALC=1.),
                     _F(CHAM_GD=CHAM27_2,
                        NOM_CMP='DX',
                        NOEUD='N2',
                        VALE_CALC=2.),
                     _F(CHAM_GD=CHAM27_2,
                        NOM_CMP='DX',
                        NOEUD='N3',
                        VALE_CALC=3.),
                     _F(CHAM_GD=CHAM27_2,
                        NOM_CMP='DX',
                        NOEUD='N4',
                        VALE_CALC=4.),),);


test.printSummary()

FIN()
