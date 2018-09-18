#!/usr/bin/python
# coding: utf-8

import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

#parallel=False
parallel=True

if (parallel):
    MA = code_aster.ParallelMesh()
    MA.readMedFile( "xxParallelNonlinearMechanics001a" )
else:
    MA = code_aster.Mesh()
    MA.readMedFile("xxParallelNonlinearMechanics001a.med")

MO=AFFE_MODELE(MAILLAGE=MA,DISTRIBUTION=_F(METHODE='CENTRALISE'),
               AFFE=(
                   _F(TOUT='OUI', PHENOMENE='MECANIQUE', MODELISATION='3D',),
                   _F(GROUP_MA = ('COTE_H','COTE_B'),PHENOMENE = 'MECANIQUE',
                    MODELISATION = '3D_ABSO')),
                   )

MAT=DEFI_MATERIAU(ELAS=_F(E=1., NU=0.3, RHO=1, AMOR_ALPHA=0.1, AMOR_BETA=0.1),)

CHMAT=AFFE_MATERIAU(MAILLAGE=MA, AFFE=_F(TOUT='OUI', MATER=MAT,),)

CHA1=AFFE_CHAR_CINE(MODELE=MO, MECA_IMPO=_F(GROUP_MA="COTE_H", DX=0.0,DY=0.0,DZ=0.0,))
CHA2=AFFE_CHAR_CINE(MODELE=MO, MECA_IMPO=_F(GROUP_MA="COTE_B", DX=0.0,DY=0.0,DZ=0.01,))

vitex=DEFI_FONCTION( NOM_PARA='INST', INTERPOL = 'LIN',
                    PROL_DROITE='LINEAIRE',
                    ABSCISSE=[0,1],  ORDONNEE=[0,1])

ONDE=AFFE_CHAR_MECA_F(  MODELE=MO,
              ONDE_PLANE=_F( DIRECTION = (0., 1., 0.), TYPE_ONDE = 'SH', #'P', #'S',
                 FONC_SIGNAL = vitex,
                 DIST=-10., #-2000.,
                 DIST_REFLECHI=0.,
                 GROUP_MA= ('COTE_H','COTE_B'),)
                          )

KEL=CALC_MATR_ELEM(OPTION='RIGI_MECA', MODELE=MO, CHAM_MATER=CHMAT)
MEL=CALC_MATR_ELEM(OPTION='MASS_MECA', MODELE=MO, CHAM_MATER=CHMAT)
CEL=CALC_MATR_ELEM(OPTION='AMOR_MECA', MODELE=MO, CHAM_MATER=CHMAT, RIGI_MECA=KEL, MASS_MECA=MEL,)


NUMEDDL=NUME_DDL(MATR_RIGI=KEL,)


STIFFNESS=ASSE_MATRICE(MATR_ELEM=KEL, NUME_DDL=NUMEDDL)

DAMPING=ASSE_MATRICE(MATR_ELEM=CEL, NUME_DDL=NUMEDDL)

MASS=ASSE_MATRICE(MATR_ELEM=MEL, NUME_DDL=NUMEDDL)

LISTINST=DEFI_LIST_REEL(DEBUT=0., INTERVALLE=(_F(JUSQU_A=10,NOMBRE=10,),),);

print CHA1.getType()

DYNA=DYNA_VIBRA(TYPE_CALCUL='TRAN',BASE_CALCUL='PHYS',
                        MODELE=MO,
                        MATR_MASS=MASS,
                        MATR_RIGI=STIFFNESS,
                        MATR_AMOR=DAMPING,
                        EXCIT=(
                          _F(  CHARGE = ONDE),
                        #   _F(  CHARGE = CHA1),
                        #   _F(  CHARGE = CHA2, ),
                          ),
                        SOLVEUR=_F(METHODE='PETSC', PRE_COND='GAMG',),
                        INCREMENT=_F( LIST_INST = LISTINST),
                        ARCHIVAGE=_F( LIST_INST = LISTINST),
                        SCHEMA_TEMPS=_F(SCHEMA='NEWMARK',),
                        INFO=2,
                        )

test.assertTrue(True)
