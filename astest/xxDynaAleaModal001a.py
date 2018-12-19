#!/usr/bin/python
# coding: utf-8

import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

MAYA=code_aster.Mesh()
MAYA.readAsterMeshFile("sdll106a.mail")

MAYA=DEFI_GROUP( reuse=MAYA,   MAILLAGE=MAYA,
  CREA_GROUP_MA=_F(  NOM = 'TOUT', TOUT = 'OUI'))

MATER=DEFI_MATERIAU(   ELAS=_F(
                                RHO = 7000.,
                                 NU = 0.3,
                                 E = 2.E+11)
                         )

CHAMPMAT=AFFE_MATERIAU(  MAILLAGE=MAYA,
                             AFFE=_F( TOUT = 'OUI',
                                   MATER = MATER)
                            )

POUTRE=AFFE_MODELE( MAILLAGE=MAYA,
                     AFFE=_F( TOUT = 'OUI',
                           MODELISATION = 'POU_D_T',
                           PHENOMENE = 'MECANIQUE')
                             )

CARA=AFFE_CARA_ELEM( MODELE=POUTRE,
     POUTRE=_F(
       GROUP_MA = 'TOUT',

              SECTION = 'RECTANGLE',
                CARA = ('HZ','HY',),
                VALE = (0.001, 0.001,))
                              )

CLIM=AFFE_CHAR_MECA( MODELE=POUTRE,DDL_IMPO=(
              _F( GROUP_NO = 'NOEUDDL',  DZ = 0.),
              _F( NOEUD = ('P1', 'P9',), DX = 0., DY = 0., DZ = 0., DRX = 0., DRY = 0.,
                                             DRZ = 0.))
                    )

MATELE_K=CALC_MATR_ELEM( MODELE=POUTRE,  CARA_ELEM=CARA,
                              CHAM_MATER=CHAMPMAT,  OPTION='RIGI_MECA',
                              CHARGE=CLIM)

MATELE_M=CALC_MATR_ELEM( MODELE=POUTRE,  CARA_ELEM=CARA,
                              CHAM_MATER=CHAMPMAT,  OPTION='MASS_MECA',
                              CHARGE=CLIM)

NUM=NUME_DDL( MATR_RIGI=MATELE_K)

MATASK=ASSE_MATRICE(MATR_ELEM=MATELE_K,NUME_DDL=NUM)

MATASM=ASSE_MATRICE(MATR_ELEM=MATELE_M,NUME_DDL=NUM)

#**********************************************************************
#**  VECTEUR ASSEMBLE REPRESENTANT LA FONCTION DE FORME    ************
#**********************************************************************

EFF1=AFFE_CHAR_MECA( MODELE=POUTRE,FORCE_NODALE=(
                     _F( NOEUD = ('P4', ),
                                   FY = 0.5),
                     _F( NOEUD = ('P5', ),
                                   FY = 1.),
                     _F( NOEUD = ('P6', ),
                                   FY = 0.5))
                            )

VECT1=CALC_VECT_ELEM(    OPTION='CHAR_MECA',
                              CHARGE=EFF1         )

VECTASS1=ASSE_VECTEUR(    VECT_ELEM=VECT1,
                               NUME_DDL=NUM       )

#**********************************************************************
#**  CALCUL MODAL        **********************************************
#**********************************************************************

MODES=CALC_MODES(MATR_RIGI=MATASK,
                 OPTION='BANDE', SOLVEUR=_F(METHODE='MULT_FRONT'),
                 CALC_FREQ=_F(FREQ=(0.1,300.,),
                              ),
                 MATR_MASS=MATASM,
                 )


#**********************************************************************
#**DEFINITION DE  L INTERSPECTRE D EXCITATION**************************
#**********************************************************************
INTEREX1=DEFI_INTE_SPEC(   DIMENSION=1,
                            CONSTANT=_F(  NUME_ORDRE_I = 1,
                                       NUME_ORDRE_J = 1,
                                       VALE_R = 1.,
                                       FREQ_MIN = 0.,
                                       FREQ_MAX = 25.)
                          )

#**********************************************************************
#***** INTERSPECTRE REPONSE A LA DSP REPARTIE SUR UNE FONCTION DE FORME
#**********************************************************************

DYNALEA1=DYNA_ALEA_MODAL(
          BASE_MODALE=_F(
             MODE_MECA = MODES,
             NUME_ORDRE = (1, 2,),
             AMOR_REDUIT = (0.05, 0.05,)),
           EXCIT=_F(  INTE_SPEC = INTEREX1,
                   NUME_ORDRE_I = 1,
                   NUME_ORDRE_J = 1,
                   CHAM_NO = VECTASS1),
              REPONSE=_F(
             FREQ_MIN = 4.,
             FREQ_MAX = 14.,
             PAS = 2.)
                      )

INTERRE1=REST_SPEC_PHYS(         MODE_MECA=MODES,
                                    NUME_ORDRE=( 1,  2, ),
                                INTE_SPEC_GENE=DYNALEA1,
                                      NOM_CHAM='DEPL',
                                         NOEUD=( 'P2',   'P3',   'P4',  ),
                                       NOM_CMP=('DY', 'DY', 'DY', ),
                                        OPTION='TOUT_TOUT'  )

#**********************************************************************
#**** DEFINITION DE LA MATRICE INTERSPECTRALE 6 6 POUR LE CALCUL*******
#***** DE VERIFICATION                                          *******
#**********************************************************************
INTEREX2=DEFI_INTE_SPEC(    DIMENSION=3,CONSTANT=(
                            _F(  NUME_ORDRE_I = 1,
                                       NUME_ORDRE_J = 1,
                                       VALE_R = 0.25,
                                       FREQ_MIN = 0.,
                                       FREQ_MAX = 25.),
                            _F(  NUME_ORDRE_I = 2,
                                       NUME_ORDRE_J = 2,
                                       VALE_R = 1.,
                                       FREQ_MIN = 0.,
                                       FREQ_MAX = 25.),
                            _F(  NUME_ORDRE_I = 3,
                                       NUME_ORDRE_J = 3,
                                       VALE_R = 0.25,
                                       FREQ_MIN = 0.,
                                       FREQ_MAX = 25.),
                            _F(  NUME_ORDRE_I = 1,
                                       NUME_ORDRE_J = 2,
                                       VALE_R = 0.5,
                                       FREQ_MIN = 0.,
                                       FREQ_MAX = 25.),
                            _F(  NUME_ORDRE_I = 1,
                                       NUME_ORDRE_J = 3,
                                       VALE_R = 0.25,
                                       FREQ_MIN = 0.,
                                       FREQ_MAX = 25.),
                            _F(  NUME_ORDRE_I = 2,
                                       NUME_ORDRE_J = 3,
                                       VALE_R = 0.5,
                                       FREQ_MIN = 0.,
                                       FREQ_MAX = 25.))
                           )

#**********************************************************************
#*** INTERSPECTRE REPONSE CALCULE POUR VERIFICATION *******************
#**********************************************************************

DYNALEA2=DYNA_ALEA_MODAL(
          BASE_MODALE=_F(
             MODE_MECA = MODES,
             NUME_ORDRE = (1, 2,),
             AMOR_REDUIT = (0.05, 0.05,)),
           EXCIT=_F(
             INTE_SPEC = INTEREX2,
             NUME_ORDRE_I = ( 1, 2, 3, ),
             NUME_ORDRE_J = ( 1, 2, 3, ),
             GRANDEUR = 'EFFO',
             NOEUD = ('P4', 'P5', 'P6',),
             NOM_CMP = ('DY', 'DY', 'DY',)),
              REPONSE=_F(
             FREQ_MIN = 4.,
             FREQ_MAX = 14.,
             PAS = 2.)
                           )

INTERRE2=REST_SPEC_PHYS(         MODE_MECA=MODES,
                                    NUME_ORDRE=( 1,  2, ),
                                INTE_SPEC_GENE=DYNALEA2,
                                      NOM_CHAM='DEPL',
                                         GROUP_NO='RESTIT',
                                       NOM_CMP='DY',
                                        OPTION='TOUT_TOUT'  )

REP1=RECU_FONCTION(    INTE_SPEC=INTERRE1,
                   NOEUD_I = 'P3',
                   NOM_CMP_I = 'DY',
                      )

REP2=RECU_FONCTION(    INTE_SPEC=INTERRE2,
                   NOEUD_I = 'P3',
                   NOM_CMP_I = 'DY',
                      )

TEST_FONCTION(VALEUR=(_F(VALE_REFE=0.040298,
                         VALE_CALC=0.04029858,
                         REFERENCE='AUTRE_ASTER',
                         VALE_PARA=4.0,
                         FONCTION=REP1,),
                      _F(VALE_REFE=0.092971,
                         VALE_CALC=0.09297108,
                         REFERENCE='AUTRE_ASTER',
                         VALE_PARA=6.0,
                         FONCTION=REP1,),
                      _F(VALE_REFE=0.95164,
                         VALE_CALC=0.95164637,
                         REFERENCE='AUTRE_ASTER',
                         VALE_PARA=8.0,
                         FONCTION=REP1,),
                      _F(VALE_REFE=0.17617,
                         VALE_CALC=0.17617679,
                         REFERENCE='AUTRE_ASTER',
                         VALE_PARA=10.0,
                         FONCTION=REP1,),
                      _F(VALE_REFE=0.026695,
                         VALE_CALC=0.02669547,
                         REFERENCE='AUTRE_ASTER',
                         VALE_PARA=12.0,
                         FONCTION=REP1,),
#########
                      _F(VALE_REFE=0.040298,
                         VALE_CALC=0.04029858,
                         REFERENCE='AUTRE_ASTER',
                         VALE_PARA=4.0,
                         FONCTION=REP2,),
                      _F(VALE_REFE=0.092971,
                         VALE_CALC=0.09297108,
                         REFERENCE='AUTRE_ASTER',
                         VALE_PARA=6.0,
                         FONCTION=REP2,),
                      _F(VALE_REFE=0.95164,
                         VALE_CALC=0.95164637,
                         REFERENCE='AUTRE_ASTER',
                         VALE_PARA=8.0,
                         FONCTION=REP2,),
                      _F(VALE_REFE=0.17617,
                         VALE_CALC=0.17617679,
                         REFERENCE='AUTRE_ASTER',
                         VALE_PARA=10.0,
                         FONCTION=REP2,),
                      _F(VALE_REFE=0.026695,
                         VALE_CALC=0.02669547,
                         REFERENCE='AUTRE_ASTER',
                         VALE_PARA=12.0,
                         FONCTION=REP2,),
                      ),
              )

test.assertEqual(DYNALEA1.getType(), "INTERSPECTRE")

test.printSummary()

FIN()
