#!/usr/bin/python
# coding: utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
# This file is part of code_aster.
#
# code_aster is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# code_aster is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with code_aster.  If not, see <http://www.gnu.org/licenses/>.
# --------------------------------------------------------------------

import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

K = 516.2E6
G = 238.2E6
YOUNG   = 9.*K*G /(3.*K+G)
POISSON = (3.*K-2.*G) /(6.*K+2.*G)

MATE1=DEFI_MATERIAU(ELAS=_F(E=YOUNG, NU=POISSON, RHO=2500., ALPHA=0.),
                    HUJEUX=_F(N        = 0.4,
                              BETA     = 24.,
                              D        = 2.5,
                              B        = 0.2,
                              PHI      = 33.,
                              ANGDIL   = 33.,
                              PCO      = -1.E6,
                              PREF     = -1.E6,
                              AMON     = 0.008,
                              ACYC     = 0.0001,
                              CMON     = 0.2,
                              CCYC     = 0.1,
                              RD_ELA   = 0.005,
                              RI_ELA   = 0.001,
                              RHYS     = 0.05,
                              RMOB     = 0.9,
                              XM       = 1.,
                              RD_CYC   = 0.005,
                              RI_CYC   = 0.001,
                              DILA     = 1.0,),)


# declaration des tables (TABLE_RESU) qui sortiront de la macro
TABTD    = CO('TTD')
TABTND   = CO('TTND')
TABCISA1 = CO('TCISA1')
TABCISA2 = CO('TCISA2')
TABTNDC1 = CO('TTNDC1')
TABTNDC2 = CO('TTNDC2')
TABTNDD1 = CO('TTNDD1')
TABTNDD2 = CO('TTNDD2')
TDA1     = CO('TTDA1')
TDA2     = CO('TTDA2')
TDNA1    = CO('TTDNA1')
TDNA2    = CO('TTDNA2')
TABOED1  = CO('TOEDC1')
TABISO1  = CO('TISO1')


# creation de courbes de reference (TABLE_REF) bidon pour couverture de code
tabbid1 = CREA_TABLE(LISTE=(_F(PARA='TYPE'    , LISTE_K=['P-Q',]),
                            _F(PARA='LEGENDE' , LISTE_K=['ma_legende',]),
                            _F(PARA='ABSCISSE', LISTE_R=[0.,1.]),
                            _F(PARA='ORDONNEE', LISTE_R=[0.,1.]),),);

tabbid2 = CREA_TABLE(LISTE=(_F(PARA='TYPE'    , LISTE_K=['GAMMA-G',]),
                            _F(PARA='LEGENDE' , LISTE_K=['ma_legende',]),
                            _F(PARA='ABSCISSE', LISTE_R=[0.,1.]),
                            _F(PARA='ORDONNEE', LISTE_R=[0.,1.]),),);

CALC_ESSAI_GEOMECA(INFO=1,
                   MATER=MATE1,
                   COMPORTEMENT=_F(RELATION='HUJEUX',
                                ITER_INTE_MAXI=20,
                                RESI_INTE_RELA=1.E-8,
                                ALGO_INTE = 'SPECIFIQUE',
                                ITER_INTE_PAS = -5,),

                   CONVERGENCE=_F(RESI_GLOB_RELA = 1.E-6,
                                  ITER_GLOB_MAXI = 20,),

                   ESSAI_TRIA_DR_M_D = _F(PRES_CONF   = 5.E+4,
                                 EPSI_IMPOSE = 0.2,
                                 TABLE_REF   = tabbid1,
                                 TABLE_RESU  = TABTD,
                                 COULEUR     = 1,
                                 MARQUEUR    = 1,
                                 STYLE       = 1,
                                 PREFIXE_FICHIER = 'test1',),

                   ESSAI_TRIA_ND_M_D = _F(PRES_CONF   = 5.E+4,
                                  EPSI_IMPOSE = 0.02,
                                  TABLE_REF   = tabbid1,
                                  TABLE_RESU  = TABTND,
                                 COULEUR     = 1,
                                 MARQUEUR    = 1,
                                 STYLE       = 1,
                                 PREFIXE_FICHIER = 'test2',),

                   ESSAI_TRIA_ND_C_F = _F(PRES_CONF   = 3.E4,
                                    SIGM_IMPOSE = -1.5E+4, # le 1er chgt est en traction
                                    NB_CYCLE    =  3,
                                    UN_SUR_K    =  1.E-12,
                                    CRIT_LIQUEFACTION='RU_MAX',
                                    ARRET_LIQUEFACTION='OUI',
                                    TYPE_CHARGE  ='TRIANGULAIRE',
                                    VALE_CRIT   = .8,
                                    TABLE_REF   = tabbid1,
                                    TABLE_RESU  = (TABTNDC1,TABTNDC2),
                                 COULEUR_NIV2   = 1,
                                 MARQUEUR_NIV2  = 1,
                                 STYLE_NIV2     = 1,
                                 PREFIXE_FICHIER = 'test3',),

                   ESSAI_TRIA_DR_C_D = (_F(PRES_CONF   = 5.E4,
                                  EPSI_MAXI   = 0.02,
                                  EPSI_MINI   = -0.02,
                                  NB_CYCLE    = 2,
                                  NB_INST     = 25,
                                  TYPE_CHARGE = 'TRIANGULAIRE',
                                  TABLE_RESU  = (TDA1,TDA2),
                                  GRAPHIQUE   = ('P-Q','EPS_AXI-Q','EPS_VOL-Q',
                                          'EPS_AXI-EPS_VOL','P-EPS_VOL','EPSI-E'),
                                 COULEUR_NIV2   = 1,
                                 MARQUEUR_NIV2  = 1,
                                 STYLE_NIV2     = 1,
                                 PREFIXE_FICHIER= 'test4', ),

                                         _F(PRES_CONF   = 5.E4,
                                  EPSI_MAXI   = 0.02,
                                  EPSI_MINI   = 0,
                                  NB_CYCLE    =  2,
                                  NB_INST     = 25,
                                  TYPE_CHARGE  ='TRIANGULAIRE',
                                  TABLE_RESU= (TDNA1,TDNA2),
                                  GRAPHIQUE =   ('P-Q','EPS_AXI-Q','EPS_VOL-Q',
                                          'EPS_AXI-EPS_VOL','P-EPS_VOL','EPSI-E'),
                                  COULEUR_NIV2   = 2,
                                  MARQUEUR_NIV2  = 2,
                                  STYLE_NIV2     = 2,
                                  PREFIXE_FICHIER= 'test5',),
                                  ),

                   ESSAI_CISA_DR_C_D = _F(PRES_CONF   = 5.E+4,
                                     GAMMA_IMPOSE = 3.9E-4 ,
                                     NB_CYCLE    = 1,
                                     TYPE_CHARGE ='TRIANGULAIRE',
                                     TABLE_REF   = tabbid2,
                                     TABLE_RESU  = (TABCISA1,TABCISA2),
                                     GRAPHIQUE   = ('GAMMA-SIGXY','G-D','GAMMA-G','GAMMA-D'),
                                     COULEUR_NIV2   = 1,
                                     MARQUEUR_NIV2  = 1,
                                     STYLE_NIV2     = 1,
                                     PREFIXE_FICHIER= 'test6',),

                   ESSAI_OEDO_DR_C_F = _F( PRES_CONF   = 5.E4,
                                      SIGM_IMPOSE = (8.E4,10.E4,11.E4,),
                                      SIGM_DECH   = 6.E4,
                                      TYPE_CHARGE ='TRIANGULAIRE',
                                      TABLE_RESU  = TABOED1,
                                      GRAPHIQUE   = ('P-EPS_VOL','SIG_AXI-EPS_VOL'),
                                      COULEUR     = 1,
                                      MARQUEUR    = 1,
                                      STYLE       = 1,
                                      PREFIXE_FICHIER= 'test7',),

                   ESSAI_ISOT_DR_C_F = _F( PRES_CONF   = 1.E5,
                                      SIGM_IMPOSE = (3.E5,3.4E5),
                                      SIGM_DECH   = 1.E5,
                                      TYPE_CHARGE ='TRIANGULAIRE',
                                      TABLE_RESU  = TABISO1,
                                      GRAPHIQUE   = ('P-EPS_VOL'),
                                      COULEUR     = 1,
                                      MARQUEUR    = 1,
                                      STYLE       = 1,
                                      PREFIXE_FICHIER= 'test8',),

                   ESSAI_TRIA_ND_C_D = _F(PRES_CONF   = 3.e+4,
                                    EPSI_MAXI   = 5.e-3,  # en compression
                                    EPSI_MINI   = -5.e-3, # en extension
                                    NB_CYCLE    = 3,
                                    UN_SUR_K    = 1.e-12,
                                    KZERO       = 1.,
                                    RU_MAX      =.8,
                                    NB_INST     = 25,
                                    TABLE_RESU  = (TABTNDD1,TABTNDD2),
                                    GRAPHIQUE   = ('INST-P','INST-Q','INST-EPS_AXI','INST-EPS_LAT',
                                                   'INST-RU','INST-SIG_AXI','INST-SIG_LAT','INST-EPS_VOL','P-Q',
                                                   'EPS_AXI-Q','INST-V1','INST-V23',
                                                   'NCYCL-DEPSI','DEPSI-RU_MAX','DEPSI-E_SUR_EMAX','DEPSI-DAMPING',
                                                   ),
                                    NOM_CMP     = ('V1','V23',),
                                    TYPE_CHARGE    = 'SINUSOIDAL',
                                    COULEUR_NIV2   = 1,
                                    MARQUEUR_NIV2  = 1,
                                    STYLE_NIV2     = 1,
                                    PREFIXE_FICHIER= 'test9',),
                                         )

test.assertEqual(TTD.getType(), "TABLE_SDASTER")
test.assertEqual(TTND.getType(), "TABLE_SDASTER")
test.assertEqual(TCISA1.getType(), "TABLE_SDASTER")
test.assertEqual(TCISA2.getType(), "TABLE_SDASTER")
test.assertEqual(TTNDC1.getType(), "TABLE_SDASTER")
test.assertEqual(TTNDC2.getType(), "TABLE_SDASTER")
test.assertEqual(TTNDD1.getType(), "TABLE_SDASTER")
test.assertEqual(TTNDD2.getType(), "TABLE_SDASTER")
test.assertEqual(TTDA1.getType(), "TABLE_SDASTER")
test.assertEqual(TTDA2.getType(), "TABLE_SDASTER")
test.assertEqual(TTDNA1.getType(), "TABLE_SDASTER")
test.assertEqual(TTDNA2.getType(), "TABLE_SDASTER")
test.assertEqual(TOEDC1.getType(), "TABLE_SDASTER")
test.assertEqual(TISO1.getType(), "TABLE_SDASTER")

FORMU1 = FORMULE(VALE='3.*P', NOM_PARA='P',);

FORMU2 = FORMULE(VALE='3.*P_1', NOM_PARA='P_1',);

TABTND2  = CALC_TABLE(TABLE=TTND,
                      ACTION= _F(OPERATION='OPER',
                                 NOM_PARA='TRSIG',
                                 FORMULE=FORMU1),);

TABTNDC3 = CALC_TABLE(TABLE=TTNDC1,
                      ACTION= _F(OPERATION='OPER',
                                 NOM_PARA='TRSIG',
                                 FORMULE=FORMU2),);
IMPR_TABLE(TABLE=TABTNDC3,);


# pour l'essai 'TD' -> valeurs de reference de ssnv197a ('TRACE' pour sigma et epsilon)
#
# 1) TRIAXIAL MONTONE DRAINE
# ------------------------------
TEST_TABLE(CRITERE='RELATIF',
           REFERENCE='SOURCE_EXTERNE',
           PRECISION=0.02,
           VALE_CALC= 115500.855933,
           VALE_REFE=117640,
           NOM_PARA='Q',
           TABLE=TTD,
           FILTRE=_F(CRITERE='ABSOLU',
                     PRECISION=9.0E-05,
                     NOM_PARA='EPS_AXI',
                     VALE=1.E-2,),);

TEST_TABLE(CRITERE='RELATIF',
           REFERENCE='SOURCE_EXTERNE',
           PRECISION=0.02,
           VALE_CALC= 155452.336341,
           VALE_REFE=157072,
           NOM_PARA='Q',
           TABLE=TTD,
           FILTRE=_F(CRITERE='ABSOLU',
                     PRECISION=9.0E-05,
                     NOM_PARA='EPS_AXI',
                     VALE=0.02,),);

TEST_TABLE(CRITERE='RELATIF',
           REFERENCE='SOURCE_EXTERNE',
           PRECISION=1.E-2,
           VALE_CALC= 199977.841621,
           VALE_REFE=200850,
           NOM_PARA='Q',
           TABLE=TTD,
           FILTRE=_F(CRITERE='ABSOLU',
                     PRECISION=9.0E-05,
                     NOM_PARA='EPS_AXI',
                     VALE=0.05,),);

TEST_TABLE(CRITERE='RELATIF',
           REFERENCE='SOURCE_EXTERNE',
           PRECISION=1.E-2,
           VALE_CALC= 206821.489992,
           VALE_REFE=207649,
           NOM_PARA='Q',
           TABLE=TTD,
           FILTRE=_F(CRITERE='ABSOLU',
                     PRECISION=9.0E-05,
                     NOM_PARA='EPS_AXI',
                     VALE=0.1,),);

TEST_TABLE(CRITERE='RELATIF',
           REFERENCE='SOURCE_EXTERNE',
           PRECISION=1.E-2,
           VALE_CALC= 184853.725484,
           VALE_REFE=185854,
           NOM_PARA='Q',
           TABLE=TTD,
           FILTRE=_F(CRITERE='ABSOLU',
                     PRECISION=9.0E-05,
                     NOM_PARA='EPS_AXI',
                     VALE=0.2,),);

TEST_TABLE(CRITERE='RELATIF',
           REFERENCE='SOURCE_EXTERNE',
           PRECISION=0.02,
           VALE_CALC=0.00377684326669,
           VALE_REFE=3.82E-3,
           NOM_PARA='EPS_VOL',
           TABLE=TTD,
           FILTRE=_F(CRITERE='ABSOLU',
                     PRECISION=9.0E-05,
                     NOM_PARA='EPS_AXI',
                     VALE=1.E-2,),);

TEST_TABLE(CRITERE='RELATIF',
           REFERENCE='SOURCE_EXTERNE',
           PRECISION=0.02,
           VALE_CALC=0.0043381789108,
           VALE_REFE=4.341E-3,
           NOM_PARA='EPS_VOL',
           TABLE=TTD,
           FILTRE=_F(CRITERE='ABSOLU',
                     PRECISION=9.0E-05,
                     NOM_PARA='EPS_AXI',
                     VALE=0.02,),);

TEST_TABLE(CRITERE='RELATIF',
           REFERENCE='SOURCE_EXTERNE',
           PRECISION=0.03,
           VALE_CALC=-0.0109036033376,
           VALE_REFE=-0.0107,
           NOM_PARA='EPS_VOL',
           TABLE=TTD,
           FILTRE=_F(CRITERE='ABSOLU',
                     PRECISION=9.0E-05,
                     NOM_PARA='EPS_AXI',
                     VALE=0.1,),);

TEST_TABLE(CRITERE='RELATIF',
           REFERENCE='SOURCE_EXTERNE',
           PRECISION=0.05,
           VALE_CALC=-0.0323655458668,
           VALE_REFE=-0.03191,
           NOM_PARA='EPS_VOL',
           TABLE=TTD,
           FILTRE=_F(CRITERE='ABSOLU',
                     PRECISION=9.0E-05,
                     NOM_PARA='EPS_AXI',
                     VALE=0.2,),);

# pour l'essai 'TRIA_ND_M_D' -> valeurs de reference de wtnv133a ('VMIS','TRACE')
#
# 2) TRIAXIAL MONTONE NON DRAINE
# ------------------------------
TEST_TABLE(CRITERE='RELATIF',
           REFERENCE='SOURCE_EXTERNE',
           PRECISION=0.03,
           VALE_CALC=31411.243778049,
           VALE_REFE=31547,
           NOM_PARA='Q',
           TABLE=TTND,
           FILTRE=_F(CRITERE='ABSOLU',
                     PRECISION=9.0E-05,
                     NOM_PARA='EPS_AXI',
                     VALE=1.E-3,),);

TEST_TABLE(CRITERE='RELATIF',
           REFERENCE='SOURCE_EXTERNE',
           PRECISION=0.02,
           VALE_CALC= 40024.894670361,
           VALE_REFE=40129,
           NOM_PARA='Q',
           TABLE=TTND,
           FILTRE=_F(CRITERE='ABSOLU',
                     PRECISION=9.0E-05,
                     NOM_PARA='EPS_AXI',
                     VALE=2.E-3,),);

TEST_TABLE(CRITERE='RELATIF',
           REFERENCE='SOURCE_EXTERNE',
           PRECISION=1.E-2,
           VALE_CALC= 51860.129621658,
           VALE_REFE=51937,
           NOM_PARA='Q',
           TABLE=TTND,
           FILTRE=_F(CRITERE='ABSOLU',
                     PRECISION=9.0E-05,
                     NOM_PARA='EPS_AXI',
                     VALE=5.0E-3,),);

TEST_TABLE(CRITERE='RELATIF',
           REFERENCE='SOURCE_EXTERNE',
           PRECISION=1.E-2,
           VALE_CALC= 68198.882927012,
           VALE_REFE=68286,
           NOM_PARA='Q',
           TABLE=TTND,
           FILTRE=_F(CRITERE='ABSOLU',
                     PRECISION=9.0E-05,
                     NOM_PARA='EPS_AXI',
                     VALE=1.E-2,),);

TEST_TABLE(CRITERE='RELATIF',
           REFERENCE='SOURCE_EXTERNE',
           PRECISION=1.E-2,
           VALE_CALC= 1.0306911556257E+05,
           VALE_REFE=103161,
           NOM_PARA='Q',
           TABLE=TTND,
           FILTRE=_F(CRITERE='ABSOLU',
                     PRECISION=9.0E-05,
                     NOM_PARA='EPS_AXI',
                     VALE=0.02,),);

TEST_TABLE(CRITERE='RELATIF',
           REFERENCE='SOURCE_EXTERNE',
           PRECISION=1.E-2,
           VALE_CALC=1.3890131117129E+05,
           VALE_REFE=138887,
           NOM_PARA='TRSIG',
           TABLE=TABTND2,
           FILTRE=_F(CRITERE='ABSOLU',
                     PRECISION=9.0E-05,
                     NOM_PARA='EPS_AXI',
                     VALE=1.E-3,),)

TEST_TABLE(CRITERE='RELATIF',
           REFERENCE='SOURCE_EXTERNE',
           PRECISION=1.E-2,
           VALE_CALC=1.3379834150962E+05,
           VALE_REFE=133789,
           NOM_PARA='TRSIG',
           TABLE=TABTND2,
           FILTRE=_F(CRITERE='ABSOLU',
                     PRECISION=9.0E-05,
                     NOM_PARA='EPS_AXI',
                     VALE=2.E-3,),);

TEST_TABLE(CRITERE='RELATIF',
           REFERENCE='SOURCE_EXTERNE',
           PRECISION=1.E-2,
           VALE_CALC=1.2492427512831E+05,
           VALE_REFE=124952,
           NOM_PARA='TRSIG',
           TABLE=TABTND2,
           FILTRE=_F(CRITERE='ABSOLU',
                     PRECISION=9.0E-05,
                     NOM_PARA='EPS_AXI',
                     VALE=5.0E-3,),);

TEST_TABLE(CRITERE='RELATIF',
           REFERENCE='SOURCE_EXTERNE',
           PRECISION=1.E-2,
           VALE_CALC=1.3668159447046E+05,
           VALE_REFE=136801,
           NOM_PARA='TRSIG',
           TABLE=TABTND2,
           FILTRE=_F(CRITERE='ABSOLU',
                     PRECISION=9.0E-05,
                     NOM_PARA='EPS_AXI',
                     VALE=1.E-2,),);

TEST_TABLE(CRITERE='RELATIF',
           REFERENCE='SOURCE_EXTERNE',
           PRECISION=1.E-2,
           VALE_CALC=1.8582118665747E+05,
           VALE_REFE=185971,
           NOM_PARA='TRSIG',
           TABLE=TABTND2,
           FILTRE=_F(CRITERE='ABSOLU',
                     PRECISION=9.0E-05,
                     NOM_PARA='EPS_AXI',
                     VALE=0.02,),);

# pour l'essai 'TRIA_ND_C_F' -> valeurs de reference de wtnv134b ('TRACE')
#
# 3) TRIAXIAL CYCLIQUE NON DRAINE A CONTRAINTE IMPOSEE
# ------------------------------
TEST_TABLE(CRITERE='RELATIF',
           REFERENCE='SOURCE_EXTERNE',
           PRECISION=1.E-2,
           VALE_CALC=80248.8596737,
           VALE_REFE=8.0193699999999997E4,
           NOM_PARA='TRSIG',
           TABLE=TABTNDC3,
           FILTRE=_F(CRITERE='ABSOLU',
                     PRECISION=9.0E-05,
                     NOM_PARA='INST_1',
                     VALE=10.0,),);

TEST_TABLE(CRITERE='RELATIF',
           REFERENCE='SOURCE_EXTERNE',
           PRECISION=1.E-2,
           VALE_CALC=74082.3328647,
           VALE_REFE=7.4078100000000006E4,
           NOM_PARA='TRSIG',
           TABLE=TABTNDC3,
           FILTRE=_F(CRITERE='ABSOLU',
                     PRECISION=9.0E-05,
                     NOM_PARA='INST_1',
                     VALE=30.0,),);

TEST_TABLE(CRITERE='RELATIF',
           REFERENCE='SOURCE_EXTERNE',
           PRECISION=1.E-2,
           VALE_CALC=66135.3309862,
           VALE_REFE=6.6250100000000006E4,
           NOM_PARA='TRSIG',
           TABLE=TABTNDC3,
           FILTRE=_F(CRITERE='ABSOLU',
                     PRECISION=9.0E-05,
                     NOM_PARA='INST_1',
                     VALE=50.0,),);

TEST_TABLE(CRITERE='RELATIF',
           REFERENCE='SOURCE_EXTERNE',
           PRECISION=0.02,
           VALE_CALC=52899.8158266,
           VALE_REFE=52999,
           NOM_PARA='TRSIG',
           TABLE=TABTNDC3,
           FILTRE=_F(CRITERE='ABSOLU',
                     PRECISION=9.0E-05,
                     NOM_PARA='INST_1',
                     VALE=70.,),);

TEST_TABLE(CRITERE='RELATIF',
           REFERENCE='SOURCE_EXTERNE',
           PRECISION=0.02,
           VALE_CALC=45514.9807902,
           VALE_REFE=4.5671900000000001E4,
           NOM_PARA='TRSIG',
           TABLE=TABTNDC3,
           FILTRE=_F(CRITERE='ABSOLU',
                     PRECISION=9.0E-05,
                     NOM_PARA='INST_1',
                     VALE=84.8,),);


# pour l'essai 'TD_A' -> non regression
#
# 4) TRIAXIAL CYCLIQUE ALTERNE DRAINE A DEF IMPOSEE
# ------------------------------
TEST_TABLE(CRITERE='RELATIF',
           REFERENCE='AUTRE_ASTER',
           VALE_CALC= -155765.435121,
           VALE_REFE= -155765.435121,
           NOM_PARA='Q_1',
           TABLE=TTDA1,
           FILTRE=_F(CRITERE='ABSOLU',
                     PRECISION=9.0E-05,
                     NOM_PARA='INST_1',
                     VALE=10.0,),);

TEST_TABLE(CRITERE='RELATIF',
           REFERENCE='AUTRE_ASTER',
           VALE_CALC= 42472.9966488,
           VALE_REFE= 42472.9966488,
           NOM_PARA='Q_1',
           TABLE=TTDA1,
           FILTRE=_F(CRITERE='ABSOLU',
                     PRECISION=9.0E-05,
                     NOM_PARA='INST_1',
                     VALE=30.0,),);

TEST_TABLE(CRITERE='RELATIF',
           REFERENCE='AUTRE_ASTER',
           VALE_CALC= -153999.977332,
           VALE_REFE= -153999.977332,
           NOM_PARA='Q_1',
           TABLE=TTDA1,
           FILTRE=_F(CRITERE='ABSOLU',
                     PRECISION=9.0E-05,
                     NOM_PARA='INST_1',
                     VALE=50.0,),);


# pour l'essai 'TD_NA' -> non regression

#
# 5) TRIAXIAL CYCLIQUE NON ALTERNE DRAINE A DEF IMPOSEE
# ------------------------------
TEST_TABLE(CRITERE='RELATIF',
           REFERENCE='AUTRE_ASTER',
           VALE_REFE=-155765.435121,
           VALE_CALC=-155765.435121,
           NOM_PARA='Q_1',
           TABLE=TTDNA1,
           FILTRE=_F(CRITERE='ABSOLU',
                     PRECISION=9.0E-05,
                     NOM_PARA='INST_1',
                     VALE=10.,),);

TEST_TABLE(CRITERE='RELATIF',
           REFERENCE='AUTRE_ASTER',
           VALE_REFE=36611.9233256,
           VALE_CALC=36611.9233256,
           NOM_PARA='Q_1',
           TABLE=TTDNA1,
           FILTRE=_F(CRITERE='ABSOLU',
                     PRECISION=9.0E-05,
                     NOM_PARA='INST_1',
                     VALE=30.0,),);

TEST_TABLE(CRITERE='RELATIF',
           REFERENCE='AUTRE_ASTER',
           VALE_REFE=-142893.051492,
           VALE_CALC=-142893.051492,
           NOM_PARA='Q_1',
           TABLE=TTDNA1,
           FILTRE=_F(CRITERE='ABSOLU',
                     PRECISION=9.0E-05,
                     NOM_PARA='INST_1',
                     VALE=50.0,),);

# pour l'essai 'CISA_C' -> non regression
#
# 6) CISAILLEMENT CYCLIQUE ALTERNE DRAINE A DEF IMPOSEE
# ------------------------------

TEST_TABLE(CRITERE='RELATIF',
           REFERENCE='AUTRE_ASTER',
           VALE_CALC=-10024.272811318,
           VALE_REFE=-10024.272811318,
           NOM_PARA='SIG_XY_1',
           TABLE=TCISA1,
           FILTRE=_F(CRITERE='ABSOLU',
                     PRECISION=9.0E-05,
                     NOM_PARA='INST_1',
                     VALE=10.0,),);

TEST_TABLE(CRITERE='RELATIF',
           REFERENCE='AUTRE_ASTER',
           VALE_CALC=10051.6335408,
           VALE_REFE=10051.6335408,
           NOM_PARA='SIG_XY_1',
           TABLE=TCISA1,
           FILTRE=_F(CRITERE='ABSOLU',
                     PRECISION=9.0E-05,
                     NOM_PARA='INST_1',
                     VALE=30.0,),);

TEST_TABLE(CRITERE='RELATIF',
           REFERENCE='NON_DEFINI',
           PRECISION=1.E-2,
           VALE_CALC=-10001.5537192,
           VALE_REFE=-9954.1399999999994,
           NOM_PARA='SIG_XY_1',
           TABLE=TCISA1,
           FILTRE=_F(CRITERE='ABSOLU',
                     PRECISION=9.0E-05,
                     NOM_PARA='INST_1',
                     VALE=50.0,),);

# pour l'essai 'OEDO_C' -> non regression
#
# 8) OEDOMETRE CYCLIQUE NON ALTERNE DRAINE A DEF IMPOSEE
# ------------------------------
TEST_TABLE(CRITERE='RELATIF',
           REFERENCE='AUTRE_ASTER',
           VALE_CALC=0.000848266671093,
           VALE_REFE= 0.000848266671093,
           NOM_PARA='EPS_VOL_1',
           TABLE=TOEDC1,
           FILTRE=_F(CRITERE='ABSOLU',
                     PRECISION=9.0E-05,
                     NOM_PARA='INST_1',
                     VALE=10.0,),);

TEST_TABLE(CRITERE='RELATIF',
           REFERENCE='AUTRE_ASTER',
           VALE_CALC=49721.6864955,
           VALE_REFE= 49721.6864955,
           NOM_PARA='SIG_LAT_1',
           TABLE=TOEDC1,
           FILTRE=_F(CRITERE='ABSOLU',
                     PRECISION=9.0E-05,
                     NOM_PARA='INST_1',
                     VALE=10.0,),);

TEST_TABLE(CRITERE='RELATIF',
           REFERENCE='AUTRE_ASTER',
           VALE_CALC=0.00168699886496,
           VALE_REFE= 0.00168714233218,
           NOM_PARA='EPS_VOL_1',
           TABLE=TOEDC1,
           FILTRE=_F(CRITERE='ABSOLU',
                     PRECISION=9.0E-05,
                     NOM_PARA='INST_1',
                     VALE=50.0,),);

TEST_TABLE(CRITERE='RELATIF',
           REFERENCE='AUTRE_ASTER',
           VALE_CALC=53988.8266339,
           VALE_REFE= 53981.1605469,
           NOM_PARA='SIG_LAT_1',
           TABLE=TOEDC1,
           FILTRE=_F(CRITERE='ABSOLU',
                     PRECISION=9.0E-05,
                     NOM_PARA='INST_1',
                     VALE=50.0,),);

TEST_TABLE(CRITERE='RELATIF',
           REFERENCE='AUTRE_ASTER',
           VALE_CALC=0.00214837913658,
           VALE_REFE= 0.00214894009601,
           NOM_PARA='EPS_VOL_1',
           TABLE=TOEDC1,
           FILTRE=_F(CRITERE='ABSOLU',
                     PRECISION=9.0E-05,
                     NOM_PARA='INST_1',
                     VALE=90.0,),);

TEST_TABLE(CRITERE='RELATIF',
           REFERENCE='AUTRE_ASTER',
           VALE_CALC=56316.5951808,
           VALE_REFE= 56319.3772981,
           NOM_PARA='SIG_LAT_1',
           TABLE=TOEDC1,
           FILTRE=_F(CRITERE='ABSOLU',
                     PRECISION=9.0E-05,
                     NOM_PARA='INST_1',
                     VALE=90.0,),);

# pour l'essai 'ISOT_C' -> comparaison avec le cas test ssnv204a
#
# 9) ESSAI ISOTROPE CYCLIQUE NON ALTERNE DRAINE A DEF IMPOSEE
# ------------------------------
TEST_TABLE(CRITERE='RELATIF',
           REFERENCE='AUTRE_ASTER',
           PRECISION=1.E-3,
           VALE_CALC= 0.0135667051679,
           VALE_REFE= 0.01356660,
           NOM_PARA='EPS_VOL_1',
           TABLE=TISO1,
           FILTRE=_F(CRITERE='ABSOLU',
                     PRECISION=9.0E-05,
                     NOM_PARA='INST_1',
                     VALE=10.0,),);

TEST_TABLE(CRITERE='RELATIF',
           REFERENCE='AUTRE_ASTER',
           PRECISION=1.E-3,
           VALE_CALC= 0.000912216068941,
           VALE_REFE= 0.00091215,
           NOM_PARA='EPS_VOL_1',
           TABLE=TISO1,
           FILTRE=_F(CRITERE='ABSOLU',
                     PRECISION=9.0E-05,
                     NOM_PARA='INST_1',
                     VALE=30.0,),);

TEST_TABLE(CRITERE='RELATIF',
           REFERENCE='AUTRE_ASTER',
           PRECISION=1.E-3,
           VALE_CALC= 0.0159168155822,
           VALE_REFE= 0.01591635,
           NOM_PARA='EPS_VOL_1',
           TABLE=TISO1,
           FILTRE=_F(CRITERE='ABSOLU',
                     PRECISION=9.0E-05,
                     NOM_PARA='INST_1',
                     VALE=50.0,),);

# pour l'essai 'ISOT_C' -> comparaison avec le cas test ssnv204a
#
# 10) ESSAI CYCLIQUE ALTERNE NON DRAINE A DEF IMPOSEE
# ------------------------------
TEST_TABLE(CRITERE='RELATIF',
           VALE_CALC= 10064.1486965,
           NOM_PARA='P_1',
           TABLE=TTNDD1,
           FILTRE=_F(CRITERE='ABSOLU',
                     PRECISION=9.0E-05,
                     NOM_PARA='INST_1',
                     VALE=20.0,),);

TEST_TABLE(CRITERE='RELATIF',
           VALE_CALC= -7514.28427045,
           NOM_PARA='Q_1',
           TABLE=TTNDD1,
           FILTRE=_F(CRITERE='ABSOLU',
                     PRECISION=9.0E-05,
                     NOM_PARA='INST_1',
                     VALE=20.0,),);

TEST_TABLE(CRITERE='RELATIF',
           VALE_CALC= -0.000189977948884,
           NOM_PARA='V23_1',
           TABLE=TTNDD1,
           FILTRE=_F(CRITERE='ABSOLU',
                     PRECISION=9.0E-05,
                     NOM_PARA='INST_1',
                     VALE=20.0,),);

TEST_TABLE(CRITERE='RELATIF',
           VALE_CALC= 25713.2501603,
           NOM_PARA='P_1',
           TABLE=TTNDD1,
           FILTRE=_F(CRITERE='ABSOLU',
                     PRECISION=9.0E-05,
                     NOM_PARA='INST_1',
                     VALE=110.0,),);

TEST_TABLE(CRITERE='RELATIF',
           VALE_CALC= -29890.4822779,
           NOM_PARA='Q_1',
           TABLE=TTNDD1,
           FILTRE=_F(CRITERE='ABSOLU',
                     PRECISION=9.0E-05,
                     NOM_PARA='INST_1',
                     VALE=110.0,),);

TEST_TABLE(CRITERE='RELATIF',
           VALE_CALC= -0.000555199619402,
           NOM_PARA='V23_1',
           TABLE=TTNDD1,
           FILTRE=_F(CRITERE='ABSOLU',
                     PRECISION=9.0E-05,
                     NOM_PARA='INST_1',
                     VALE=110.0,),);

test.printSummary()

FIN()
