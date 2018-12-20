#!/usr/bin/python
# coding: utf-8

import code_aster
from code_aster.Commands import *

import numpy as NP
pi = NP.pi

code_aster.init()

test = code_aster.TestCase()

# lecture du maillage
mail=code_aster.Mesh()
mail.readAsterMeshFile("sdll124a.mail")

# ---------------------
# DEFINITION DU MATERIAU
# ---------------------
acier=DEFI_MATERIAU(ELAS=_F(E=2.e11,
                            NU=0.3,
                            RHO=7800.,),)

# ---------------------
# AFFECTATION DU MODELE
# ---------------------
modele=AFFE_MODELE(MAILLAGE=mail,
                   AFFE=(_F(GROUP_MA='ROTOR',
                            PHENOMENE='MECANIQUE',
                            MODELISATION='POU_D_T',),
                         _F(GROUP_MA=('DISQ1','DISQ2','DISQ3','PALIER1','PALIER2'),
                            PHENOMENE='MECANIQUE',
                            MODELISATION='DIS_TR',),),)

# -----------------------
# AFFECTATION DU MATERIAU
# -----------------------
chmat=AFFE_MATERIAU(MAILLAGE=mail,
                    AFFE=_F(GROUP_MA='ROTOR',
                            MATER=acier,),)

# --------------------------------
# DEF DES SECTIONS et des RAIDEURS
# --------------------------------
cara=AFFE_CARA_ELEM(MODELE=modele,
                    POUTRE=_F(GROUP_MA='ROTOR',
                              SECTION='CERCLE',
                              CARA='R',
                              VALE=0.05,),
                    DISCRET=(_F(CARA='M_TR_D_N',
                                GROUP_MA='DISQ1',
                                REPERE='LOCAL',
                                VALE=(1.458013e+01,1.232021e-01,
                                6.463858e-02,6.463858e-02,0,0,0,0,0,0,),),
                             _F(CARA='K_TR_D_N',
                                GROUP_MA='DISQ1',
                                REPERE='LOCAL',
                                VALE=(0,0,0,0,0,0,),),
                             _F(CARA='A_TR_D_N',
                                GROUP_MA='DISQ1',
                                REPERE='LOCAL',
                                VALE=(0,0,0,0,0,0,),),
                             _F(CARA='M_TR_D_N',
                                GROUP_MA='DISQ2',
                                REPERE='LOCAL',
                                VALE=(4.594579e+01,9.763481e-01,
                                4.977461e-01,4.977461e-01,0,0,0,0,0,0,),),
                             _F(CARA='K_TR_D_N',
                                GROUP_MA='DISQ2',
                                REPERE='LOCAL',
                                VALE=(0,0,0,0,0,0,),),
                             _F(CARA='A_TR_D_N',
                                GROUP_MA='DISQ2',
                                REPERE='LOCAL',
                                VALE=(0,0,0,0,0,0,),),
                             _F(CARA='M_TR_D_N',
                                GROUP_MA='DISQ3',
                                REPERE='LOCAL',
                                VALE=(5.513495e+01,1.171618e+00,
                                6.023493e-01,6.023493e-01,0,0,0,0,0,0,),),
                             _F(CARA='K_TR_D_N',
                                GROUP_MA='DISQ3',
                                REPERE='LOCAL',
                                VALE=(0,0,0,0,0,0,),),
                             _F(CARA='A_TR_D_N',
                                GROUP_MA='DISQ3',
                                REPERE='LOCAL',
                                VALE=(0,0,0,0,0,0,),),
                             _F(GROUP_MA='PALIER1',
                                   CARA='K_TR_D_N',
                                   VALE=(7.000000E+07,5.000000E+07,0.,0.,0.,0. ) ),
                             _F(GROUP_MA='PALIER1',
                                   CARA='A_TR_D_N',
                                   VALE=(7.000000E+02,5.000000E+02,0.,0.,0.,0.,),),
                             _F(GROUP_MA='PALIER2',
                                   CARA='K_TR_D_N',
                                   VALE=(7.000000E+07,5.000000E+07,0.,0.,0.,0. ) ),
                             _F(GROUP_MA='PALIER2',
                                   CARA='A_TR_D_N',
                                   VALE=(7.000000E+02,5.000000E+02,0.,0.,0.,0.,),),
                           ),
                      ORIENTATION=_F(GROUP_MA=('DISQ1','DISQ2','DISQ3'),
                                      CARA='ANGL_NAUT',
                                      VALE=(0.,-90.,0.,),),
                        )

# ------------------
# CONDITIONS AUX LIMITES
# ------------------
blocage=AFFE_CHAR_MECA(MODELE=modele,
                        DDL_IMPO=(_F(GROUP_NO='PALIER1',
                                     DZ=0.0,),
                                  _F(NOEUD='N7',
                                     DRZ=0.0,),),)

# --------------------------------
#MATRICES ASSEMBLEES K, M
# --------------------------------
ASSEMBLAGE(MODELE=modele,
                CHAM_MATER=chmat,
                CARA_ELEM=cara,
                CHARGE=blocage,
                NUME_DDL=CO('NUMEDDL'),
                MATR_ASSE=(_F(MATRICE=CO('RIGIDITE'),
                              OPTION='RIGI_MECA',),
                           _F(MATRICE=CO('MASSE'),
                              OPTION='MASS_MECA',),
                           _F(MATRICE=CO('AMOR'),
                              OPTION='AMOR_MECA',),),)

GYELEM=CALC_MATR_ELEM(OPTION='MECA_GYRO',
                      MODELE=modele,
                      CHAM_MATER=chmat,
                      CARA_ELEM=cara,)

GYASS=ASSE_MATRICE(MATR_ELEM=GYELEM,
                   NUME_DDL=NUMEDDL,)

DEBV=0.0
FINV=30000
PASV = 10000.0
VIT=NP.arange(DEBV,FINV+1,PASV)
nbF=15
nbF_camp=11
nbV=len(VIT)

# --------------------------------------------------------------
# APPEL MACRO DE CALCUL DES FREQUENCES ET DES MODES EN ROTATION
# --------------------------------------------------------------

L_VITROT=[VIT[ii] * pi / 30. for ii in xrange(nbV)]
Methode = 'QZ'
# Methode = 'SORENSEN'

l_mod=CALC_MODE_ROTATION(MATR_RIGI =RIGIDITE,
                 MATR_MASS   =MASSE,
                 MATR_AMOR=AMOR,
                 MATR_GYRO =GYASS,
                 VITE_ROTA =L_VITROT,
                 METHODE  =Methode,
                 CALC_FREQ=_F(OPTION='PLUS_PETITE',NMAX_FREQ=nbF),
                 VERI_MODE=_F(STOP_ERREUR='NON'))

test.assertEqual(l_mod.getType(), "TABLE_SDASTER")

# Echec avec EXTR_TABLE

# lmod = [None] * nbV
# for ii in xrange(0, nbV):
#     lmod[ii] = EXTR_TABLE(TYPE_RESU='MODE_MECA',
#                           TABLE=l_mod,
#                           NOM_PARA='NOM_SD',
#                           FILTRE=_F(NOM_PARA='NUME_VITE', VALE_I=ii),)

# #VITESSE DE ROTATION OMEGA=0
# TEST_RESU(RESU=(_F(NUME_ORDRE=1,
#                    PARA='FREQ',
#                    REFERENCE='SOURCE_EXTERNE',
#                    RESULTAT=lmod_0,
#                    VALE_CALC=60.606682908,
#                    VALE_REFE=60.614800000000002,
#                    CRITERE='RELATIF',
#                    PRECISION=1.E-3,),
#                 _F(NUME_ORDRE=1,
#                    PARA='AMOR_REDUIT',
#                    REFERENCE='SOURCE_EXTERNE',
#                    RESULTAT=lmod_0,
#                    VALE_CALC= 5.03072913E-04,
#                    VALE_REFE=5.0328000000000005E-4,
#                    CRITERE='RELATIF',
#                    PRECISION=1.E-3,),
#                 _F(NUME_ORDRE=2,
#                    PARA='FREQ',
#                    REFERENCE='SOURCE_EXTERNE',
#                    RESULTAT=lmod_0,
#                    VALE_CALC=63.016350148,
#                    VALE_REFE=63.026000000000003,
#                    CRITERE='RELATIF',
#                    PRECISION=1.E-3,),
#                 _F(NUME_ORDRE=2,
#                    PARA='AMOR_REDUIT',
#                    REFERENCE='SOURCE_EXTERNE',
#                    RESULTAT=lmod_0,
#                    VALE_CALC= 3.98639882E-04,
#                    VALE_REFE=3.9881999999999998E-4,
#                    CRITERE='RELATIF',
#                    PRECISION=1.E-3,),
#                 _F(NUME_ORDRE=3,
#                    PARA='FREQ',
#                    REFERENCE='SOURCE_EXTERNE',
#                    RESULTAT=lmod_0,
#                    VALE_CALC=169.445675635,
#                    VALE_REFE=169.49000000000001,
#                    CRITERE='RELATIF',
#                    PRECISION=1.E-3,),
#                 _F(NUME_ORDRE=3,
#                    PARA='AMOR_REDUIT',
#                    REFERENCE='SOURCE_EXTERNE',
#                    RESULTAT=lmod_0,
#                    VALE_CALC= 3.11997825E-03,
#                    VALE_REFE=3.1232E-3,
#                    CRITERE='RELATIF',
#                    PRECISION=2.E-3,),
#                 _F(NUME_ORDRE=4,
#                    PARA='FREQ',
#                    REFERENCE='SOURCE_EXTERNE',
#                    RESULTAT=lmod_0,
#                    VALE_CALC=185.494534563,
#                    VALE_REFE=185.56299999999999,
#                    CRITERE='RELATIF',
#                    PRECISION=1.E-3,),
#                 _F(NUME_ORDRE=4,
#                    PARA='AMOR_REDUIT',
#                    REFERENCE='SOURCE_EXTERNE',
#                    RESULTAT=lmod_0,
#                    VALE_CALC= 2.84968479E-03,
#                    VALE_REFE=2.8533E-3,
#                    CRITERE='RELATIF',
#                    PRECISION=2.E-3,),
#                 ),
#           )

# #VITESSE DE ROTATION OMEGA=30000
# TEST_RESU(RESU=(_F(NUME_ORDRE=1,
#                    PARA='FREQ',
#                    REFERENCE='SOURCE_EXTERNE',
#                    RESULTAT=lmod_3,
#                    VALE_CALC=54.077591152,
#                    VALE_REFE=54.112000000000002,
#                    CRITERE='RELATIF',
#                    PRECISION=1.E-3,),
#                 _F(NUME_ORDRE=1,
#                    PARA='AMOR_REDUIT',
#                    REFERENCE='SOURCE_EXTERNE',
#                    RESULTAT=lmod_3,
#                    VALE_CALC= 2.62739163E-04,
#                    VALE_REFE=2.6624E-4,
#                    CRITERE='RELATIF',
#                    PRECISION=0.014,),
#                 _F(NUME_ORDRE=2,
#                    PARA='FREQ',
#                    REFERENCE='SOURCE_EXTERNE',
#                    RESULTAT=lmod_3,
#                    VALE_CALC=68.083027535,
#                    VALE_REFE=68.122,
#                    CRITERE='RELATIF',
#                    PRECISION=1.E-3,),
#                 _F(NUME_ORDRE=2,
#                    PARA='AMOR_REDUIT',
#                    REFERENCE='SOURCE_EXTERNE',
#                    RESULTAT=lmod_3,
#                    VALE_CALC= 6.55325422E-04,
#                    VALE_REFE=6.5256000000000005E-4,
#                    CRITERE='RELATIF',
#                    PRECISION=6.0000000000000001E-3,),
#                 _F(NUME_ORDRE=3,
#                    PARA='FREQ',
#                    REFERENCE='SOURCE_EXTERNE',
#                    RESULTAT=lmod_3,
#                    VALE_CALC=154.268992037,
#                    VALE_REFE=154.65000000000001,
#                    CRITERE='RELATIF',
#                    PRECISION=3.0000000000000001E-3,),
#                 _F(NUME_ORDRE=3,
#                    PARA='AMOR_REDUIT',
#                    REFERENCE='SOURCE_EXTERNE',
#                    RESULTAT=lmod_3,
#                    VALE_CALC= 3.08984015E-03,
#                    VALE_REFE=3.0441999999999999E-3,
#                    CRITERE='RELATIF',
#                    PRECISION=0.017000000000000001,),
#                 _F(NUME_ORDRE=4,
#                    PARA='FREQ',
#                    REFERENCE='SOURCE_EXTERNE',
#                    RESULTAT=lmod_3,
#                    VALE_CALC=195.655606313,
#                    VALE_REFE=196.0,
#                    CRITERE='RELATIF',
#                    PRECISION=2.E-3,),
#                 _F(NUME_ORDRE=4,
#                    PARA='AMOR_REDUIT',
#                    REFERENCE='SOURCE_EXTERNE',
#                    RESULTAT=lmod_3,
#                    VALE_CALC= 2.70654792E-03,
#                    VALE_REFE=2.7612000000000001E-3,
#                    CRITERE='RELATIF',
#                    PRECISION=0.02,),
#                 ),
#           )

test.printSummary()

FIN()
