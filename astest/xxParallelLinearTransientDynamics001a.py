# coding: utf-8

import code_aster
from code_aster.Commands import *
import numpy as np
# from mpi4py import MPI

code_aster.init()

test = code_aster.TestCase()

# parallel=False
parallel=True

if (parallel):
    MA = code_aster.ParallelMesh()
    MA.readMedFile( "xxParallelLinearTransientDynamics001a" )
else:
    MA = code_aster.Mesh()
    MA.readMedFile("xxParallelLinearTransientDynamics001a.med")

MO=AFFE_MODELE(MAILLAGE=MA,DISTRIBUTION=_F(METHODE='CENTRALISE'),
               AFFE=(
                    _F(TOUT='OUI', PHENOMENE='MECANIQUE', MODELISATION='3D',),
                    _F(GROUP_MA = ('COTE_H'),PHENOMENE = 'MECANIQUE',
                        MODELISATION = '3D_ABSO')),
                   )

MAT=DEFI_MATERIAU(ELAS=_F(E=1000., NU=0.3, RHO=1000, AMOR_ALPHA=0.1, AMOR_BETA=0.1),)

CHMAT=AFFE_MATERIAU(MAILLAGE=MA, AFFE=_F(TOUT='OUI', MATER=MAT,),)

sinus = FORMULE(VALE='sin(4*INST*pi*2.)',
                NOM_PARA='INST',)

ONDE=AFFE_CHAR_MECA_F(  MODELE=MO,
              ONDE_PLANE=_F( DIRECTION = (0., 0., 1.), TYPE_ONDE = 'P',
                 FONC_SIGNAL = sinus,
                 DIST=0.,
                 DIST_REFLECHI=0.5,
                 GROUP_MA= ('COTE_H',),)
                          )

KEL=CALC_MATR_ELEM(OPTION='RIGI_MECA', MODELE=MO, CHAM_MATER=CHMAT)
MEL=CALC_MATR_ELEM(OPTION='MASS_MECA', MODELE=MO, CHAM_MATER=CHMAT)
CEL=CALC_MATR_ELEM(OPTION='AMOR_MECA', MODELE=MO, CHAM_MATER=CHMAT, RIGI_MECA=KEL, MASS_MECA=MEL,)


NUMEDDL=NUME_DDL(MATR_RIGI=KEL,)


STIFFNESS=ASSE_MATRICE(MATR_ELEM=KEL, NUME_DDL=NUMEDDL)

DAMPING=ASSE_MATRICE(MATR_ELEM=CEL, NUME_DDL=NUMEDDL)

MASS=ASSE_MATRICE(MATR_ELEM=MEL, NUME_DDL=NUMEDDL)

LISTINST=DEFI_LIST_REEL(DEBUT=0., INTERVALLE=(_F(JUSQU_A=1,NOMBRE=10,),),);

DYNA=DYNA_VIBRA(TYPE_CALCUL='TRAN',BASE_CALCUL='PHYS',
                        MODELE=MO,
                        MATR_MASS=MASS,
                        MATR_RIGI=STIFFNESS,
                        MATR_AMOR=DAMPING,
                        EXCIT=(
                          _F(  CHARGE = ONDE),
                          ),
                        OBSERVATION=(_F(CRITERE='RELATIF',
                                 EVAL_CHAM='VALE',
                                 EVAL_CMP='VALE',
                                 GROUP_NO='EXT_0',
                                 NOM_CHAM='DEPL',
                                 NOM_CMP='DX',
                                 OBSE_ETAT_INIT='OUI',
                                 PAS_OBSE=1,
                                 PRECISION=1e-06),
                                 _F(CRITERE='RELATIF',
                                 EVAL_CHAM='VALE',
                                 EVAL_CMP='VALE',
                                 GROUP_NO='EXT_1',
                                 NOM_CHAM='DEPL',
                                 NOM_CMP='DX',
                                 OBSE_ETAT_INIT='OUI',
                                 PAS_OBSE=1,
                                 PRECISION=1e-06),),
                        SOLVEUR=_F(METHODE='PETSC', PRE_COND='GAMG',),
                        INCREMENT=_F( LIST_INST = LISTINST),
                        ARCHIVAGE=_F( LIST_INST = LISTINST),
                        SCHEMA_TEMPS=_F(SCHEMA='NEWMARK',),
                        INFO=2,
                        )

# depl=DYNA.getRealFieldOnNodes("DEPL",10)
# v=depl.EXTR_COMP()

# total=np.sum(v.valeurs)

# global_sum = np.zeros(1)

# MPI.COMM_WORLD.Reduce(np.array(total), global_sum, op=MPI.SUM)
# print global_sum[0]

test.assertTrue(True)

FIN()
