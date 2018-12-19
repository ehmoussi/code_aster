##!/usr/bin/python
# coding: utf-8

import code_aster
from math import pi

from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()


n_mode = 15
tau = 0.01
t_fin = 0.013
pas = 2.5E-7

M = LIRE_MAILLAGE(FORMAT='MED',);

M=DEFI_GROUP(reuse=M,
             MAILLAGE=M,
             CREA_GROUP_NO=(_F(OPTION = 'NOEUD_ORDO',
                               NOM = 'LEVSUP',
                               GROUP_MA = 'LEVSUP',),
                            _F(OPTION = 'NOEUD_ORDO',
                               NOM = 'LEVINF',
                               GROUP_MA = 'LEVINF',),
                            _F(NOM = 'COT_INF',
                               GROUP_MA = 'COT_INF',),),
            );

MO=AFFE_MODELE(MAILLAGE=M,
               AFFE=_F(TOUT = 'OUI',
                       PHENOMENE='MECANIQUE',
                       MODELISATION='C_PLAN',),
              );

M = MODI_MAILLAGE(reuse = M,
                  MAILLAGE = M,
                  MODI_MAILLE = _F(OPTION = 'NOEUD_QUART',
                                   GROUP_NO_FOND = 'PF',),
                 );

MA=DEFI_MATERIAU(ELAS=_F(E=200.0E+9,
                         NU=0.3,
                         ALPHA = 0.,
                         RHO=7800,),);

CM=AFFE_MATERIAU(MAILLAGE=M,
                 AFFE=_F(TOUT='OUI',
                         MATER=MA,
                         ),);

BLOCAGE=AFFE_CHAR_MECA(MODELE=MO,
                       DDL_IMPO=(_F(GROUP_MA='COT_SUP',
                                    DX = 0,),
                                 _F(GROUP_MA='COT_SUP',
                                    DY = 0,),),
                      );

CHAR=AFFE_CHAR_MECA(MODELE=MO,
                    FORCE_NODALE=_F(GROUP_NO='COT_INF',
                                  FX=-1000,),
                    );

RAMPE=DEFI_FONCTION(NOM_PARA='INST',
                    VALE=(0.0,0.0,
                          tau,1.0,
                          0.2, 1.0,),
                    PROL_DROITE='CONSTANT',
                    PROL_GAUCHE='LINEAIRE',);

#################################
#  CONSTRUCTION DES MATRICES
#################################

MRIGI=CALC_MATR_ELEM(OPTION='RIGI_MECA',
                     MODELE=MO,
                     CHAM_MATER=CM,
                     CHARGE=BLOCAGE);

MMASSE=CALC_MATR_ELEM(OPTION='MASS_MECA',
                      MODELE=MO,
                      CHAM_MATER=CM,
                      CHARGE=BLOCAGE,);

MAMOR=CALC_MATR_ELEM(OPTION='AMOR_MECA',
                     MODELE=MO,
                     RIGI_MECA = MRIGI,
                     MASS_MECA = MMASSE,
                     CHAM_MATER=CM,
                     CHARGE=BLOCAGE,);

VCHA=CALC_VECT_ELEM(OPTION='CHAR_MECA',
                    CHARGE =(BLOCAGE,CHAR),);

NUM=NUME_DDL(MODELE= MO,
             CHARGE=(BLOCAGE,CHAR),);

RIG_ASS=ASSE_MATRICE(MATR_ELEM=MRIGI,
                     NUME_DDL=NUM,);

MA_ASS=ASSE_MATRICE(MATR_ELEM=MMASSE,
                    NUME_DDL=NUM,);

AMO_ASS=ASSE_MATRICE(MATR_ELEM=MAMOR,
                    NUME_DDL=NUM,);

VE_ASS=ASSE_VECTEUR(VECT_ELEM=VCHA,
                    NUME_DDL=NUM,);


##################################
#  CALCUL DES MODES PROPRES ET DES K_MODAUX
##################################

MODE=CALC_MODES(MATR_RIGI=RIG_ASS,
                MATR_MASS=MA_ASS,
                CALC_FREQ=_F(NMAX_FREQ=n_mode,
                             ),
                )


# MODE=NORM_MODE(reuse=MODE,
#                MODE=MODE,
#                NORME='MASS_GENE',);

FISS=DEFI_FOND_FISS(MAILLAGE=M,
                    FOND_FISS=_F(GROUP_NO = 'PF',),
                    LEVRE_SUP=_F(GROUP_MA = 'LEVSUP'),
                    LEVRE_INF=_F(GROUP_MA = 'LEVINF'),
                   )

# VALEURS DE REF DE K1 SUR 5 PREMIERS MODES
# (VOIR SDLS114A)
K1_ref = [-1.90387E+10, -1.15558E+11, 7.96724E+10, -1.17741E+11, 1.70753E+11]
K1_reg = [-1.9038714866638E+10, -1.1555795319447E+11, 7.9672432337416E+10,
          -1.177406508046E+11, 1.7075333962439E+11 ]

# validation du mot-cle NUME_ORDRE
#-----------------------------------------

PK1 = POST_K1_K2_K3(RESULTAT=MODE,
                    FOND_FISS=FISS,
                    NUME_ORDRE=(1,2,3,4,5),);

test.assertEqual(PK1.getType(), "TABLE_ASTERSD")



test.printSummary()

FIN()
