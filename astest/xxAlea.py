#!/usr/bin/python
# coding: utf-8

import code_aster
from math import pi

from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()


#*********************************************************************#
# *****LECTURE DU MAILLAGE********************************************#
#*********************************************************************#
MA1=LIRE_MAILLAGE(FORMAT="ASTER", )
MA1=DEFI_GROUP(MAILLAGE=MA1,reuse=MA1,CREA_GROUP_NO=_F(NOM='PA1',NOEUD=('PA1')))

MO1=AFFE_MODELE(  MAILLAGE=MA1,
       AFFE=_F(                TOUT = 'OUI',
                            PHENOMENE = 'MECANIQUE',
                            MODELISATION = 'POU_D_T'))

#*********************************************************************#
# *****AFFECTATION D ELEMENTS SUR LES MAILLES*************************#
#*********************************************************************#
CARELEM1=AFFE_CARA_ELEM(   MODELE=MO1,POUTRE=(
     _F(  GROUP_MA = 'GRMAPRIM',
              SECTION = 'RECTANGLE',
                CARA = ('HZ','HY',), VALE = (0.1, 0.1,)),
     _F(  GROUP_MA = 'GRMASEC',
              SECTION = 'RECTANGLE',
                CARA = ('HZ','HY',), VALE = (0.001, 0.001,)))
                         )

#*********************************************************************#
# *****CONDITIONS AUX LIMITES:ON LIE STRUCTURE PRIMAIRE ET SECONDAIRE*#
#*********************************************************************#
CHARGE1=AFFE_CHAR_MECA(
             MODELE=MO1,DDL_IMPO=(
            _F( TOUT = 'OUI',
                     DZ = 0.0,
                     DRX = 0.0),
            _F( NOEUD = ('PA1',),
                     DX = 0.0,
                     DY = 0.0,
                     DRZ = 0.0)),LIAISON_DDL=(
            _F(
                     NOEUD = ('PA11', 'PB11',),
                     DDL = ('DY', 'DY',),
                     COEF_MULT = (1., -1.,),
                     COEF_IMPO = 0.),
            _F(
                     NOEUD = ('PA11', 'PB11',),
                     DDL = ('DX', 'DX',),
                     COEF_MULT = (1., -1.,),
                     COEF_IMPO = 0.),
            _F(
                     NOEUD = ('PA21', 'PB21',),
                     DDL = ('DY', 'DY',),
                     COEF_MULT = (1., -1.,),
                     COEF_IMPO = 0.),
            _F(
                     NOEUD = ('PA21', 'PB21',),
                     DDL = ('DX', 'DX',),
                     COEF_MULT = (1., -1.,),
                     COEF_IMPO = 0.),
            _F(
                     NOEUD = ('PA31', 'PB31',),
                     DDL = ('DY', 'DY',),
                     COEF_MULT = (1., -1.,),
                     COEF_IMPO = 0.),
            _F(
                     NOEUD = ('PA31', 'PB31',),
                     DDL = ('DX', 'DX',),
                     COEF_MULT = (1., -1.,),
                     COEF_IMPO = 0.))
                                 )

#*********************************************************************#
# *****MATERIAU ******************************************************#
#*********************************************************************#
MAT_LAMA=DEFI_MATERIAU(   ELAS=_F(  E = 2.1E11,
                                 NU = 0.3,
                                RHO = 2000.)
                         )

MAT_LAMB=DEFI_MATERIAU(   ELAS=_F(  E = 2.1E11,
                                 NU = 0.3,
                                RHO = 1000.)
                         )

CHMATR1=AFFE_MATERIAU(
           MAILLAGE=MA1,AFFE=(
              _F(
                     GROUP_MA = 'GRMAPRIM',
                     MATER = MAT_LAMA),
              _F(
                     GROUP_MA = 'GRMASEC',
                     MATER = MAT_LAMB))
         )

#
#*********************************************************************#
# *****MATRICES ELEMENTAIRES ET ASSEMBLAGE****************************#
#*********************************************************************#
MELR1=CALC_MATR_ELEM(  MODELE=MO1,
                    CHAM_MATER=CHMATR1,
                        CHARGE=CHARGE1,
                       OPTION='RIGI_MECA',
                        CARA_ELEM=CARELEM1  )

MELM1=CALC_MATR_ELEM(  MODELE=MO1,
                    CHAM_MATER=CHMATR1,
                        CHARGE=CHARGE1,
                       OPTION='MASS_MECA',
                        CARA_ELEM=CARELEM1  )

#
NUM1=NUME_DDL(  MATR_RIGI=MELR1 )

MATASSR1=ASSE_MATRICE(MATR_ELEM=MELR1,NUME_DDL=NUM1)

MATASSM1=ASSE_MATRICE(MATR_ELEM=MELM1,NUME_DDL=NUM1)

#*********************************************************************#
# *****CALCUL DE MODES PROPRES ET IMPRESSION FORMAT IDEAS*************#
#*********************************************************************#

FREQ1=CALC_MODES(MATR_RIGI=MATASSR1,
                 #OPTION='AJUSTE', #SOLVEUR=_F(METHODE='MULT_FRONT'),
                 CALC_FREQ=_F(NMAX_FREQ=10,
                              #FREQ=(0.1,3000.0,),
                              ),
                 MATR_MASS=MATASSM1,
                 #SOLVEUR_MODAL=_F(NMAX_ITER_INV=30,
                  #                ),
                 VERI_MODE =_F(STOP_ERREUR ="NON" ),
            
                 )


#*********************************************************************#
# *****CALCUL DE MODES STATIQUES; IMPRESSION FORMAT IDEAS*************#
#*********************************************************************#
MODESTA1=MODE_STATIQUE(  MATR_RIGI=MATASSR1,
                         MATR_MASS=MATASSM1,
                         MODE_STAT=_F(  GROUP_NO = 'PA1',
                                   AVEC_CMP = 'DY')
                  )

#*********************************************************************#
# *****DEFINITION   INTERSPECTRE EXCITATION***************************#
#*********************************************************************#
So=1/(2.*pi)
INTKTJ1=DEFI_INTE_SPEC(    DIMENSION=1,
                        INFO=2,
                         KANAI_TAJIMI=_F(  NUME_ORDRE_I = 1,
                                        NUME_ORDRE_J = 1,
                                        FREQ_MIN = 0.,
                                        FREQ_MAX = 50.,
                                        PAS = 1.,
                                        AMOR_REDUIT = 0.6,
                                        FREQ_MOY = 5.,
                                        VALE_R = So,
                                        INTERPOL = 'LIN',
                                        PROL_GAUCHE = 'CONSTANT',
                                        PROL_DROITE = 'CONSTANT')
                       )

STADE=POST_DYNA_ALEA(TITRE='POST_DYNA_ALEA concept', 
                     INTERSPECTRE=_F(
                          INTE_SPEC=INTKTJ1,
                          NUME_ORDRE_J = 1,
                          NUME_ORDRE_I = 1,
                          DUREE =10.,),
                      ) 
test.assertEqual(STADE.getType(), "TABLE_SDASTER")

TEST_TABLE(CRITERE='RELATIF',
           VALE_CALC=5.5220842862402,
           NOM_PARA='ECART',
           TABLE=STADE,
           FILTRE=(_F(NOM_PARA='NUME_ORDRE_I',
                      VALE_I=1,),
                   _F(NOM_PARA='NUME_ORDRE_J',
                      VALE_I=1,),
                   ),
           )
TEST_TABLE(CRITERE='RELATIF',
           VALE_CALC=3.3761135643154998,
           NOM_PARA='FACT_PIC',
           TABLE=STADE,
           FILTRE=(_F(NOM_PARA='NUME_ORDRE_I',
                      VALE_I=1,),
                   _F(NOM_PARA='NUME_ORDRE_J',
                      VALE_I=1,),
                   ),
           )

TEST_TABLE(CRITERE='RELATIF',
           VALE_CALC=18.643183662068999,
           NOM_PARA='MAX_MOY',
           TABLE=STADE,
           FILTRE=(_F(NOM_PARA='NUME_ORDRE_I',
                      VALE_I=1,),
                   _F(NOM_PARA='NUME_ORDRE_J',
                      VALE_I=1,),
                   ),
           )

GENE_KT=GENE_FONC_ALEA(INTE_SPEC=INTKTJ1,
                       FREQ_INIT=0.,
                       FREQ_FIN=50.,
                       NB_TIRAGE=20,
                       NB_POIN=2048,
                       INFO=2,);

test.assertEqual(GENE_KT.getType(), "INTERSPECTRE")

FONCT1=RECU_FONCTION(INTE_SPEC=GENE_KT,
                     NUME_ORDRE = 1,
                     INTERPOL='LIN',
                     PROL_DROITE='CONSTANT',
                     PROL_GAUCHE='EXCLU',
                    );
                           
test_KT=INFO_FONCTION(ECART_TYPE=_F(FONCTION=FONCT1 ),);    
    
TEST_TABLE(CRITERE='RELATIF',
           REFERENCE='AUTRE_ASTER',
           PRECISION=1.E-2,
           VALE_CALC=5.5198815616958,
           VALE_REFE=5.5220799999999999,
           NOM_PARA='ECART_TYPE ',
           TABLE=test_KT,)
                        
#*********************************************************************#
# *****CALCUL D INTERSPECTRE REPONSE: ACCE --> ACCE *****************#
# *****                               MVT ABSOLU    *****************#
# *****  INTERRE1= CALCUL COMPLET ***********************************#
#*********************************************************************#

DYNALEA1=DYNA_ALEA_MODAL(
          BASE_MODALE=_F(
             MODE_MECA = FREQ1,
             BANDE = (0., 35.,),
             AMOR_UNIF = 0.05),
        MODE_STAT=MODESTA1,
           EXCIT=_F(
             DERIVATION = 2,
             INTE_SPEC = INTKTJ1,
             NUME_ORDRE_I = 1,
             NUME_ORDRE_J = 1,
             NOEUD = 'PA1',
             NOM_CMP = 'DY'),
               REPONSE=_F(
             DERIVATION = 2,
             FREQ_MIN = 0.,
             FREQ_MAX = 30.,
             PAS = 5.)
                             )

INTERRE1=REST_SPEC_PHYS(         MODE_MECA=FREQ1,
                                         BANDE=( 0., 35., ),
                              INTE_SPEC_GENE=DYNALEA1,
                                   MODE_STAT=MODESTA1,
                               EXCIT=_F(   NOEUD = 'PA1',
                                        NOM_CMP = 'DY'),
                                   MOUVEMENT='ABSOLU',
                                    NOM_CHAM='ACCE',
                                       NOEUD=( 'PB15', 'PB25', 'PB31', ),
                                     NOM_CMP=('DY', 'DY', 'DY',  ),
                                      OPTION='TOUT_TOUT'   )

test.assertEqual(INTERRE1.getType(), "INTERSPECTRE")



REP1=RECU_FONCTION(    INTE_SPEC=INTERRE1,
                            NOEUD_I = 'PB25',
                            NOEUD_J = 'PB25',
                            NOM_CMP_I = 'DY',
                      )


TEST_FONCTION(VALEUR=_F(VALE_CALC=3.691335875781,
                        VALE_REFE=3.6913,
                        REFERENCE='AUTRE_ASTER',
                        VALE_PARA=5.0,
                        PRECISION=1.E-2,
                        FONCTION=REP1,),
              )

TEST_FONCTION(VALEUR=_F(VALE_CALC=75.43911340159,
                        VALE_REFE=75.438999999999993,
                        REFERENCE='AUTRE_ASTER',
                        VALE_PARA=10.0,
                        PRECISION=1.E-2,
                        FONCTION=REP1,),
              )

TEST_FONCTION(VALEUR=_F(VALE_CALC=1.677695255021,
                        VALE_REFE=1.6776,
                        REFERENCE='AUTRE_ASTER',
                        VALE_PARA=15.0,
                        PRECISION=1.E-2,
                        FONCTION=REP1,),
              )

TEST_FONCTION(VALEUR=_F(VALE_CALC=1.136675355994,
                        VALE_REFE=1.1367,
                        REFERENCE='AUTRE_ASTER',
                        VALE_PARA=20.0,
                        PRECISION=1.E-2,
                        FONCTION=REP1,),
              )

TEST_FONCTION(VALEUR=_F(VALE_CALC=0.29269300232027,
                        VALE_REFE=0.29260000000000003,
                        REFERENCE='AUTRE_ASTER',
                        VALE_PARA=25.0,
                        PRECISION=1.E-2,
                        FONCTION=REP1,),
              )


test.printSummary()

FIN()
