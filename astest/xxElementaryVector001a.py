#!/usr/bin/python
# coding: utf-8

import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

# test inspire de zzzz104b

MAIL = code_aster.Mesh()
MAIL.readMedFile("zzzz104a.mmed")


MOD=AFFE_MODELE(MAILLAGE=MAIL,
                  AFFE=_F(GROUP_MA='POUTRE',
                          PHENOMENE='MECANIQUE',
                          MODELISATION='D_PLAN',),)


BETON=DEFI_MATERIAU(ELAS=_F(E=200000000000.0,
                            NU=0.3,
                            ALPHA = 0.02),
                   )

CHMAT=AFFE_MATERIAU(MAILLAGE=MAIL,
                       AFFE=_F(TOUT='OUI',
                               MATER=BETON,),
                   )

# 1ère résolution avec dualisation des conditions aux limites
BLOQ=AFFE_CHAR_MECA(MODELE=MOD,
                    DDL_IMPO=(_F(GROUP_MA=('ENCNEG',),DX=1.0,DY=2.0,),
                               _F(GROUP_MA=('ENCPOS',),DY=3.0,),
                            ),);

rigiel    = CALC_MATR_ELEM(MODELE=MOD, CHAM_MATER=CHMAT, OPTION='RIGI_MECA', CHARGE=BLOQ)
vecel     = CALC_VECT_ELEM(CHARGE=BLOQ, INST=1.0, CHAM_MATER=CHMAT, OPTION='CHAR_MECA')
numeddl   = NUME_DDL(MATR_RIGI = rigiel)
matass    = ASSE_MATRICE(MATR_ELEM=rigiel , NUME_DDL=numeddl)
vecass    = ASSE_VECTEUR(VECT_ELEM=vecel, NUME_DDL=numeddl)

monSolver = code_aster.MumpsSolver( code_aster.Renumbering.Metis )
monSolver.matrixFactorization(matass)
resu1 = monSolver.solveDoubleLinearSystem( matass, vecass )
y1=resu1.EXTR_COMP().valeurs


# 2ème résolution avec élimination des conditions aux limites (charge "cinématique")
bloq=AFFE_CHAR_CINE(MODELE=MOD,
                    MECA_IMPO=(_F(GROUP_MA=('ENCNEG',),DX=1.0,DY=2.0,),
                               _F(GROUP_MA=('ENCPOS',),DY=3.0,),
                            ),);

rigiel    = CALC_MATR_ELEM(MODELE=MOD, CHAM_MATER=CHMAT, OPTION='RIGI_MECA')
numeddl   = NUME_DDL(MATR_RIGI = rigiel)
matass    = ASSE_MATRICE(MATR_ELEM=rigiel , NUME_DDL=numeddl, CHAR_CINE=bloq )
vecass    = CREA_CHAMP(TYPE_CHAM='NOEU_DEPL_R', NUME_DDL=numeddl, OPERATION='AFFE', MAILLAGE=MAIL,
                       AFFE=_F(TOUT='OUI', NOM_CMP=('DX','DY','DZ',),  VALE=(0.,0.,0.,),),);
vcine     = CALC_CHAR_CINE(NUME_DDL=numeddl, CHAR_CINE=bloq)

monSolver = code_aster.MumpsSolver( code_aster.Renumbering.Metis )
monSolver.matrixFactorization(matass)
resu2=monSolver.solveDoubleLinearSystemWithKinematicsLoad(matass, vcine, vecass)
y2=resu2.EXTR_COMP().valeurs


# Comparaison des 2 solutions
[test.assertAlmostEqual(y1[i], y2[i]) for i,_ in enumerate(y1)]
test.printSummary()

FIN()
