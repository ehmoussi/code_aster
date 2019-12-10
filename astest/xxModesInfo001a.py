# coding: utf-8

import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

# LECTURE MAILLAGE ET AFFECTATION MATERIAU/MODELE
MAYA=code_aster.Mesh()
MAYA.readMedFile("forma11c.mmed")

STRUC=AFFE_MODELE(MAILLAGE=MAYA,
                  AFFE=_F(GROUP_MA='TOUT',
                          PHENOMENE='MECANIQUE',
                          MODELISATION='DKT',),);
ACIER=DEFI_MATERIAU(ELAS=_F(E=2.7600000000E10,
                            NU=0.16600000000000001,
                            RHO=2244.0,),);
MATER=AFFE_MATERIAU(MAILLAGE=MAYA,
                    AFFE=_F(GROUP_MA='TOUT',
                            MATER=ACIER,),);
CARA=AFFE_CARA_ELEM(MODELE=STRUC,
                    COQUE=_F(GROUP_MA='TOUT',
                             EPAIS=0.30499999999999999,),);

# AFFECTATION CL
FIXA=AFFE_CHAR_MECA(MODELE=STRUC,
                    DDL_IMPO=_F(GROUP_NO='FIXA',
                                DX=0.0,
                                DY=0.0,
                                DZ=0.0,
                                DRX=0.0,
                                DRY=0.0,
                                DRZ=0.0,),);

# CALCULS DES MATRICES DE MASSE ET DE RIGIDITE
K_ELEM=CALC_MATR_ELEM(OPTION='RIGI_MECA',
                      MODELE=STRUC,
                      CHAM_MATER=MATER,
                      CARA_ELEM=CARA,
                      CHARGE=FIXA,);
M_ELEM=CALC_MATR_ELEM(OPTION='MASS_MECA',
                      MODELE=STRUC,
                      CHAM_MATER=MATER,
                      CARA_ELEM=CARA,
                      CHARGE=FIXA,);
NUMERO=NUME_DDL(MATR_RIGI=K_ELEM,);
K_ASSE=ASSE_MATRICE(MATR_ELEM=K_ELEM,
                    NUME_DDL=NUMERO,);
M_ASSE=ASSE_MATRICE(MATR_ELEM=M_ELEM,
                    NUME_DDL=NUMERO,);

#--------------------------------------------------------------------
# ANALYSE MODALE
# QUESTION PRELIMINAIRE: PESER LE MODELE ET EVALUER LE NBRE DE MODES

TABL_MAS=POST_ELEM(MODELE=STRUC,
                   CHAM_MATER=MATER,
                   CARA_ELEM=CARA,
                   MASS_INER=_F(TOUT='OUI',),);

IMPR_TABLE(TABLE=TABL_MAS,);

NB_MODES=INFO_MODE(MATR_RIGI=K_ASSE,
                   MATR_MASS=M_ASSE,
                   FREQ=(0.,4.0,));



# TEST_TABLE UNIQUEMENT POUR FAIRE CAS TEST
TEST_TABLE(
           VALE_CALC_I=86,
           NOM_PARA='NB_MODE',
           TABLE=NB_MODES,
           )

# FIN DE LA QUESTION 0.
#FIN();

test.printSummary()

FIN()
