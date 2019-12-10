# coding: utf-8

import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()


ENTHAL=DEFI_FONCTION(        NOM_PARA='TEMP',
                                   VALE=(    0.0,       0.0,
                                          1000.0,    1000.0, ),
           PROL_DROITE='LINEAIRE',    PROL_GAUCHE='LINEAIRE')

CONDUC=DEFI_FONCTION(        NOM_PARA='TEMP',
                                    VALE=(  0.0,      0.000001,
                                         1000.0,      0.000001, ),
        PROL_DROITE='CONSTANT',      PROL_GAUCHE='CONSTANT' )

MATCAV=DEFI_MATERIAU(  THER_NL=_F(  LAMBDA = CONDUC,
                                    BETA = ENTHAL))

# lecture du maillage
CAVITE=code_aster.Mesh()
CAVITE.readMedFile("tplv102a.mmed")

CAVITE=DEFI_GROUP( reuse=CAVITE,  MAILLAGE=CAVITE,CREA_GROUP_NO=(
                         _F(  GROUP_MA = 'C1'),
                         _F( GROUP_MA = 'C2'),
                         _F(  GROUP_MA = 'C3'),
                         _F( GROUP_MA = 'C4'),
                         _F( GROUP_MA = 'D2'),
                         _F( GROUP_MA = 'D3'))
                      )

CHMAT=AFFE_MATERIAU(  MAILLAGE=CAVITE,
                        AFFE=_F(  TOUT = 'OUI', MATER = MATCAV) )

MODCAV=AFFE_MODELE(  MAILLAGE=CAVITE,
                     AFFE=_F( TOUT = 'OUI', MODELISATION = 'PLAN',
                                      PHENOMENE = 'THERMIQUE'))

CHAVI=CREA_CHAMP( OPERATION='AFFE', TYPE_CHAM='NOEU_DEPL_R',
MAILLAGE=CAVITE,
     AFFE=_F(   TOUT = 'OUI', NOM_CMP = ('DX', 'DY',), VALE = (0.3827, 0.9239,))
                       )

CHTIMP=AFFE_CHAR_THER(   MODELE=MODCAV,TEMP_IMPO=(
                           _F( GROUP_NO = 'D2', TEMP = 0.0),
                           _F( GROUP_NO = 'C4', TEMP = 1.0),
                           _F( GROUP_NO = 'C1', TEMP = 1.0)),
                          CONVECTION=_F( VITESSE = CHAVI)
                       )

RESU=THER_NON_LINE_MO(   MODELE=MODCAV,
                                CHAM_MATER=CHMAT,
                               EXCIT=_F( CHARGE = CHTIMP),
                                CONVERGENCE=_F( CRIT_TEMP_RELA = 1.E-4,
                                             CRIT_ENTH_RELA = 1.E-3,
                                             ITER_GLOB_MAXI = 30)
                            )

T=CREA_CHAMP( OPERATION='EXTR',  TYPE_CHAM='NOEU_TEMP_R',
                   RESULTAT=RESU,   NOM_CHAM='TEMP', NUME_ORDRE=0 )

TEST_RESU(CHAM_NO=(_F(NOEUD='N31',
                      CRITERE='ABSOLU',
                      NOM_CMP='TEMP',
                      PRECISION=1.25E-3,
                      CHAM_GD=T,
                      VALE_CALC=1.001232765,
                      VALE_REFE=1.0,
                      REFERENCE='ANALYTIQUE',),
                   _F(NOEUD='N29',
                      REFERENCE='ANALYTIQUE',
                      CRITERE='ABSOLU',
                      NOM_CMP='TEMP',
                      CHAM_GD=T,
                      VALE_CALC=0.9998579313,
                      VALE_REFE=1.0,
                      PRECISION=2.E-4,),
                   _F(NOEUD='N27',
                      CRITERE='ABSOLU',
                      NOM_CMP='TEMP',
                      PRECISION=3.E-3,
                      CHAM_GD=T,
                      VALE_CALC=0.998142584,
                      VALE_REFE=1.0,
                      REFERENCE='ANALYTIQUE',),
                   _F(NOEUD='N25',
                      CRITERE='ABSOLU',
                      NOM_CMP='TEMP',
                      PRECISION=0.1,
                      CHAM_GD=T,
                      VALE_CALC=0.907836008,
                      VALE_REFE=1.0,
                      REFERENCE='ANALYTIQUE',),
                   _F(NOEUD='N23',
                      CRITERE='ABSOLU',
                      NOM_CMP='TEMP',
                      PRECISION=0.012,
                      CHAM_GD=T,
                      VALE_CALC=-0.011479657,
                      VALE_REFE=0.0,
                      REFERENCE='ANALYTIQUE',),
                   _F(NOEUD='N1',
                      CRITERE='ABSOLU',
                      NOM_CMP='TEMP',
                      CHAM_GD=T,
                      VALE_CALC=0.0,
                      VALE_REFE=0.0,
                      REFERENCE='ANALYTIQUE',),
                   ),
          )

FIN()
