#!/usr/bin/python
# coding: utf-8

import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

# lecture du maillage
MAIL1=code_aster.Mesh()
MAIL1.readMedFile("sdlx103a.23")

MAIL2=code_aster.Mesh()
MAIL2.readMedFile("sdlx103a.mmed")

MAILLAGE=ASSE_MAILLAGE(MAILLAGE_1=MAIL1,
                       MAILLAGE_2=MAIL2,
                       OPERATION ='SOUS_STR',)

MAILLAGE=DEFI_GROUP(reuse =MAILLAGE,
                    MAILLAGE=MAILLAGE,
                    CREA_GROUP_NO=_F(GROUP_MA=('SBAS','SBAS1','SBAS2','SLATE1')),
                    )

MODELE=AFFE_MODELE(MAILLAGE=MAILLAGE,
                   AFFE=(_F(GROUP_MA='POU_D_T',
                            PHENOMENE='MECANIQUE',
                            MODELISATION='POU_D_T',),
                         _F(GROUP_MA='MASSES',
                            PHENOMENE='MECANIQUE',
                            MODELISATION='DIS_TR',),
                         _F(GROUP_MA='SBAS',
                            PHENOMENE='MECANIQUE',
                            MODELISATION='DST',),),)
# FIN DE DEFINITION DU MODELE.
#
# ----------------------------------------------------------------------
#  DEFINITION DES MATERIAUX
#  DEFINITION DES MATERIAUX "UTILISATEURS"

MAT_1=DEFI_MATERIAU(ELAS=_F(E=31000000000.0,
                            NU=0.16,
                            RHO=0.0,
                            ALPHA=0.0,),)
#

CHAMPMAT=AFFE_MATERIAU(MAILLAGE=MAILLAGE,
                       AFFE=(_F(GROUP_MA='MAT_1',
                                MATER=MAT_1,),
                             _F(GROUP_MA='SBAS',
                                MATER=MAT_1,),),)
#
# ----------------------------------------------------------------------
#       CONDITIONS LIMITES
                      
CL_RIGID=AFFE_CHAR_MECA(MODELE=MODELE,
                                    LIAISON_SOLIDE=(_F(GROUP_NO=('PA0','SBAS1',),),
                                                   _F(GROUP_NO=('PB0','SBAS2',),),
                                                  ),
                                    )

# FIN CONDITIONS LIMITES
#
#
# AFFECTATION DES CARACTERISTIQUES ELEMENTAIRES

CARA_ELE=AFFE_CARA_ELEM(MODELE=MODELE,
                        POUTRE=(_F(GROUP_MA='SEC_1',
                                   SECTION='GENERALE',
                                   CARA=('A','IZ','IY','AY','AZ','JX','EZ','EY','RY','RZ','RT',),
                                   VALE=(59.5,341.33,341.33,1./0.93,1./0.93,682.7,0.0,0.0,1.0,1.0,1.0,),),
                                _F(GROUP_MA='SEC_2',
                                   SECTION='GENERALE',
                                   CARA=('A','IZ','IY','AY','AZ','JX','EZ','EY','RY','RZ','RT',),
                                   VALE=(8.28,39.51,54.77,2.94,1.47,94.3,0.0,0.0,1.0,1.0,1.0,),),
                                _F(GROUP_MA='SEC_3',
                                   SECTION='GENERALE',
                                   CARA=('A','IZ','IY','AY','AZ','JX','EZ','EY','RY','RZ','RT',),
                                   VALE=(63.19,341.33,341.33,1./0.99,1./0.99,682.7,0.0,0.0,1.0,1.0,1.0,),),
                                _F(GROUP_MA='SEC_4',
                                   SECTION='GENERALE',
                                   CARA=('A','IZ','IY','AY','AZ','JX','EZ','EY','RY','RZ','RT',),
                                   VALE=(19.78,148.34,149.14,2.13,2.11,297.5,0.0,0.0,1.0,1.0,1.0,),),
                                _F(GROUP_MA='SEC_5',
                                   SECTION='GENERALE',
                                   CARA=('A','IZ','IY','AY','AZ','JX','EZ','EY','RY','RZ','RT',),
                                   VALE=(64.0,341.33,341.33,1.0,1.0,682.7,0.0,0.0,1.0,1.0,1.0,),),
                                ),
                        COQUE=_F(GROUP_MA='SBAS',
                                 ANGL_REP=(45.,45.,),
                                 EPAIS=0.001,),
                        DISCRET=(_F(MAILLE=('MASA1','MBSA1',),
                                    CARA='M_TR_D_N',
                                    VALE=(79250.0,410720.0,482340.0,893060.0,0.0,0.0,0.0,0.0,0.0,0.0,),),
                                 _F(MAILLE=('MASA1','MBSA1',),
                                    CARA='K_TR_D_N',
                                    VALE=(0.0,0.0,0.0,0.0,0.0,0.0,),),
                                 _F(MAILLE=('MASA2','MBSA2',),
                                    CARA='M_TR_D_N',
                                    VALE=(104090.0,574750.0,694040.0,1268790.0,0.0,0.0,0.0,0.0,0.0,0.0,),),
                                 _F(MAILLE=('MASA2','MBSA2',),
                                    CARA='K_TR_D_N',
                                    VALE=(0.0,0.0,0.0,0.0,0.0,0.0,),),
                                 _F(MAILLE=('MASA3','MBSA3',),
                                    CARA='M_TR_D_N',
                                    VALE=(156710.0,1020850.0,1071220.0,2092070.0,0.0,0.0,0.0,0.0,0.0,0.0,),),
                                 _F(MAILLE=('MASA3','MBSA3',),
                                    CARA='K_TR_D_N',
                                    VALE=(0.0,0.0,0.0,0.0,0.0,0.0,),),
                                 _F(MAILLE=('MASA4','MBSA4',),
                                    CARA='M_TR_D_N',
                                    VALE=(316970.0,1846700.0,1844020.0,3690720.0,0.0,0.0,0.0,0.0,0.0,0.0,),),
                                 _F(MAILLE=('MASA4','MBSA4',),
                                    CARA='K_TR_D_N',
                                    VALE=(0.0,0.0,0.0,0.0,0.0,0.0,),),
                                 ),);
# FIN DE AFFE_CARA_ELEM  ------------
#


CHA2=AFFE_CHAR_MECA(MODELE=MODELE,
                    FORCE_NODALE=_F(NOEUD='NA1',
                                    FY=10000.0,),)


TBSOL = DEFI_SOL_MISS(
   TITRE="SOL DU TEST NUPEC",
   MATERIAU=(
      _F(E=1.1788e8,  NU=0.386, RHO=1.77e3, AMOR_HYST=0.10),
      _F(E=1.9027e8,  NU=0.279, RHO=1.77e3, AMOR_HYST=0.10),
      _F(E=2.0700e8,  NU=0.265, RHO=1.77e3, AMOR_HYST=0.10),
      _F(E=2.2419e8,  NU=0.251, RHO=1.77e3, AMOR_HYST=0.10),
      _F(E=2.4867e8,  NU=0.272, RHO=1.77e3, AMOR_HYST=0.10),
      _F(E=9.7776e7,  NU=0.120, RHO=1.94e3, AMOR_HYST=0.10),
      _F(E=6.1493e8,  NU=0.371, RHO=1.94e3, AMOR_HYST=0.10),
      _F(E=1.0151e9,  NU=0.415, RHO=1.94e3, AMOR_HYST=0.04),
      _F(E=1.019e10,  NU=0.386, RHO=2.21e3, AMOR_HYST=0.04),
      _F(E=1.501e10,  NU=0.343, RHO=2.21e3, AMOR_HYST=0.04),
   ),
   COUCHE_AUTO=(_F(
               SURF='NON',HOMOGENE='NON',
               NUME_MATE=(1,2,3,4,5,6,7,8,9,),
               NUME_MATE_SUBSTRATUM = 10,
               EPAIS_PHYS=(1.,1.,1.,1.,1.,0.5,2.5,3.,14.,),
               GROUP_NO='SLATE1',
               NOMBRE_RECEPTEUR=2,
               GROUP_MA_INTERF='SBAS',
               MAILLAGE=MAILLAGE,
               # On met le decalage a non pour retrouver la definition manuelle
               DECALAGE_AUTO='NON',
   ),),
   INFO=2,   
)

test.assertEqual(TBSOL.getType(), "TABLE_SDASTER")

# CALC_MISS non fonctionnel

# dyph = DYNA_LINE(MODELE=MODELE,
#                  CHAM_MATER=CHAMPMAT,
#                  CARA_ELEM=CARA_ELE,
#                  CHARGE=CL_RIGID,
#                  TYPE_CALCUL="HARM",
#                  BASE_CALCUL="GENE",
#                  BANDE_ANALYSE=600.0,
#                  FREQ = (12.25, 12.50, 12.75),
#                  ISS="OUI",
#                  TABLE_SOL=TBSOL,
#                  GROUP_MA_INTERF='SBAS',
#                  GROUP_NO_INTERF='ENCASTRE',
#                  AMORTISSEMENT=_F(TYPE_AMOR="MODAL",
#                                   AMOR_REDUIT=0.01),
#                  PARAMETRE=_F(
#                      #LIST_FREQ = (12.25, 12.50, 12.75),
#                      Z0= 5.0,
#                      AUTO='OUI',OPTION_DREF='OUI',COEF_OFFSET=10,
#                      # Valeurs en manuel :
#                      #DREF=1.0,
#                      #ALGO = 'REGU',
#                      #OFFSET_MAX=20,
#                      #OFFSET_NB=200,
#                  ),
#                  EXCIT=(_F(CHARGE=CHA2,
#                            COEF_MULT=1.,),
#                  ),
# )

# DYA1_2=RECU_FONCTION(RESULTAT=dyph,
#                      NOM_CHAM='DEPL',
#                      NOM_CMP='DY',
#                      NOEUD='NA1',)

# MDYA1_2=CALC_FONCTION(EXTRACTION=_F(FONCTION=DYA1_2,
#                                     PARTIE='MODULE',),)

# DYB1_2=RECU_FONCTION(RESULTAT=dyph,
#                      NOM_CHAM='DEPL',
#                      NOM_CMP='DY',
#                      NOEUD='NB1',)

# MDYB1_2=CALC_FONCTION(EXTRACTION=_F(FONCTION=DYB1_2,
#                                     PARTIE='MODULE',),)

# TEST_FONCTION(VALEUR=(
#                       _F(VALE_CALC=2.907041408808E-05,
#                          VALE_REFE=2.9122999999999999E-05,
#                          VALE_PARA=12.5,
#                          REFERENCE='NON_DEFINI',
#                          PRECISION=3.0000000000000001E-3,
#                          FONCTION=MDYA1_2,
#                          ),
#                       _F(VALE_CALC=2.907041408808E-05,
#                          VALE_REFE=2.7583E-05,
#                          VALE_PARA=12.5,
#                          REFERENCE='SOURCE_EXTERNE',
#                          PRECISION=0.059999999999999998,
#                          FONCTION=MDYA1_2,),
#                       _F(VALE_CALC=1.926759718802E-05,
#                          VALE_REFE=1.8048000000000001E-05,
#                          VALE_PARA=12.5,
#                          REFERENCE='SOURCE_EXTERNE',
#                          PRECISION=0.070000000000000007,
#                          FONCTION=MDYB1_2,),
#                       ),
#               )


test.printSummary()
