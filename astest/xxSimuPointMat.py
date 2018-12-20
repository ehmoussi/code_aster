import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

SOL=DEFI_MATERIAU(ELAS=_F(E=620000000.0, NU=0.3, ALPHA=0.),
                  MOHR_COULOMB=_F(
                            PHI      = 33.,
                            ANGDIL   = 27.,
                            COHESION = 1.0E+3,),);

                            
COEF0=DEFI_FONCTION(NOM_PARA    = 'INST',
                    PROL_DROITE = 'CONSTANT',
                    VALE=( 0.0, 0.,
                           100., 0.,),);

                          
COEFH=DEFI_FONCTION(NOM_PARA    = 'INST',
                    PROL_DROITE = 'CONSTANT',
                    VALE=( 0.0, -50.E+3,
                           100., -50.E+3,),);

                           
COEFV=DEFI_FONCTION(NOM_PARA    = 'INST',
                    PROL_DROITE = 'CONSTANT',
                    VALE=( 0.0, -3.*50.E+3,
                           100., -3.*50.E+3,),);

COEXY=DEFI_FONCTION(NOM_PARA='INST',
                    PROL_DROITE='CONSTANT',
                    VALE=( 0.0, 0.0,
                           100., -.0001),);

TEMPS1 = code_aster.TimeStepManager()
TEMPS1.setTimeList( [10.*n for n in range(5)] )
TEMPS1.build()

TSIGPERT=SIMU_POINT_MAT(INFO=2,
                  COMPORTEMENT=_F(RELATION='MOHR_COULOMB',
                               TYPE_MATR_TANG='PERTURBATION',
                               VALE_PERT_RELA=1.E-10,),
                  MATER=SOL,
                  INCREMENT=_F(LIST_INST=TEMPS1,
                               INST_INIT=0.,
                               INST_FIN =40.,),
                  NEWTON=_F(MATRICE='TANGENTE',
                            REAC_ITER=1,
                            PREDICTION='ELASTIQUE'),
                  CONVERGENCE=_F(RESI_GLOB_RELA = 1.E-10,
                                 ITER_GLOB_MAXI = 50,),
                  SIGM_IMPOSE=_F(SIXX=COEFV,
                                 SIYY=COEFH,
                                 SIZZ=COEFH,),
                  EPSI_IMPOSE=_F(EPXY=COEXY,
                                 EPXZ=COEF0,
                                 EPYZ=COEF0,),
                  SIGM_INIT=_F(SIXX=-3.*50.E+3,
                               SIYY=-50.E+3,
                               SIZZ=-50.E+3,),
                  EPSI_INIT=_F(EPXX=0.,
                               EPYY=0.,
                               EPZZ=0.,
                               EPXY=0.,
                               EPXZ=0.,
                               EPYZ=0.,),);

test.assertTrue( True )

FIN()
