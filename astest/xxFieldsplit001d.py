# coding: utf-8

import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

#parallel=False
parallel = True

if parallel:
    MAIL = code_aster.ParallelMesh()
    MAIL.readMedFile("xxFieldsplit001a")
else:
    MAIL = code_aster.Mesh()
    MAIL.readMedFile("xxFieldsplit001a.mmed")


MODELE = AFFE_MODELE(
                    AFFE=_F(MODELISATION='3D_THM', PHENOMENE='MECANIQUE', TOUT='OUI'),
                    MAILLAGE=MAIL,
                    DISTRIBUTION=_F(METHODE='CENTRALISE'),
                    )

#
# ###################################
#  LISTE DES INSTANTS DE CALCUL
# ###################################
LI = DEFI_LIST_REEL(DEBUT=0.0, INTERVALLE=_F(JUSQU_A=100.0, NOMBRE=2))

# ###########################################
#
# DEFINITION DES FONCTIONS DE COMPORTEMENT :
# VISCOSITE LIQUIDE ET GAZ : UNITE : PA.S
UN = DEFI_CONSTANTE(VALE=1.0)

ZERO = DEFI_CONSTANTE(VALE=0.0)

#
#
#
# PERMEABILITE INTRINSEQUE, RELATIVE DU LIQUIDE, RELATIVE DU GAZ
# UNITE INTRINSEQUE : METRES CARRES , UNITE RELATIVE : SANS
KINT = DEFI_CONSTANTE(VALE=3e-16)

PERMLIQ = DEFI_CONSTANTE(VALE=1.0)

DPERMLI = DEFI_CONSTANTE(VALE=0.0)

PERMGAZ = DEFI_CONSTANTE(VALE=1.0)

DPERGSA = DEFI_CONSTANTE(VALE=0.0)

DPERGPG = DEFI_CONSTANTE(VALE=0.0)

#
# COEFFICIENT DE FICK
# UNITE METRES CARRES PAR SECONDES
FICK = DEFI_CONSTANTE(VALE=1e-07)

DFICKTE = DEFI_CONSTANTE(VALE=0.0)

DFICKPG = DEFI_CONSTANTE(VALE=0.0)

DCONDLI = DEFI_CONSTANTE(VALE=0.0)

CONDGAZ = DEFI_CONSTANTE(VALE=0.02)

DCONDGA = DEFI_CONSTANTE(VALE=0.0)

#
# CONDUCTIVITES DU SOLIDE, DU LIQUIDE, DU GAZ
# UNITES : WATTS PAR METRE CARRE
CONDHOMO = DEFI_CONSTANTE(VALE=1.7)

DCONDHO = DEFI_CONSTANTE(VALE=0.0)

CONDLIQ = DEFI_CONSTANTE(VALE=3e-16)

THMALP1 = DEFI_CONSTANTE(VALE=0.0001)

ARGILE0 = DEFI_MATERIAU(
                        COMP_THM='LIQU_SATU',
                        ELAS=_F(ALPHA=8e-06, E=225000000.0, NU=0.0, RHO=2000.0),
                        THM_DIFFU=_F(
                            BIOT_COEF=1e-12,
                            CP=2850000.0,
                            D_PERM_LIQU_SATU=ZERO,
                            D_PERM_PRES_GAZ=DPERGPG,
                            D_PERM_SATU_GAZ=DPERGSA,
                            D_SATU_PRES=ZERO,
                            LAMB_T=CONDHOMO,
                            PERM_GAZ=PERMGAZ,
                            PERM_IN=KINT,
                            PERM_LIQU=UN,
                            PESA_X=0.0,
                            PESA_Y=0.0,
                            PESA_Z=0.0,
                            RHO=1600.0,
                            R_GAZ=8.315,
                            SATU_PRES=UN
                        ),
                        THM_GAZ=_F(CP=1.0, D_VISC_TEMP=ZERO, MASS_MOL=0.02896, VISC=UN),
                        THM_INIT=_F(PORO=0.4, PRE1=0.0, PRE2=0.0, PRES_VAPE=1.0, TEMP=273.0),
                        THM_LIQU=_F(
                            ALPHA=THMALP1,
                            CP=2850000.0,
                            D_VISC_TEMP=ZERO,
                            RHO=1000.0,
                            UN_SUR_K=3.77e-09,
                            VISC=UN
                        )
)

CHMAT0 = AFFE_MATERIAU(AFFE=_F(GROUP_MA='VOLUME', MATER=ARGILE0), MAILLAGE=MAIL)

CHAR0 =  AFFE_CHAR_CINE(
    MECA_IMPO=(
                _F(DX=0.0, DY=0.0, DZ=0.0, GROUP_MA=('Zinf', )),
                _F(DX=0.0, DY=0.0, DZ=0.0, GROUP_MA=('Yinf', 'Ysup')),
                _F(DX=0.0, DY=0.0, DZ=0.0, GROUP_MA=('Xsup', 'Xinf')),
                _F(DX=0.0, DY=0.0, DZ=0.001, GROUP_MA=('Zsup', )),
    ),
    MODELE=MODELE
    )
RAMPE=DEFI_FONCTION(NOM_PARA='INST',
                    VALE=(0.0,0.0,
                          100.0,1.0,
                          ),
                    PROL_DROITE='LINEAIRE',
                    PROL_GAUCHE='LINEAIRE',);



myOptions=""" -fieldsplit_TEMP_ksp_max_it 2  -fieldsplit_TEMP_ksp_monitor  -fieldsplit_TEMP_ksp_converged_reason  -fieldsplit_TEMP_ksp_rtol 1.e-3  -fieldsplit_TEMP_ksp_type fgmres  -fieldsplit_TEMP_pc_type jacobi  -fieldsplit_DXDYDZPRE1_fieldsplit_PRE1_ksp_max_it 2  -fieldsplit_DXDYDZPRE1_fieldsplit_PRE1_ksp_monitor  -fieldsplit_DXDYDZPRE1_fieldsplit_PRE1_ksp_converged_reason  -fieldsplit_DXDYDZPRE1_fieldsplit_PRE1_ksp_rtol 1.e-3  -fieldsplit_DXDYDZPRE1_fieldsplit_PRE1_ksp_type fgmres  -fieldsplit_DXDYDZPRE1_fieldsplit_PRE1_pc_type jacobi  -fieldsplit_DXDYDZPRE1_fieldsplit_DXDYDZ_ksp_monitor  -fieldsplit_DXDYDZPRE1_fieldsplit_DXDYDZ_ksp_converged_reason  -fieldsplit_DXDYDZPRE1_fieldsplit_DXDYDZ_ksp_rtol 1e-3  -fieldsplit_DXDYDZPRE1_fieldsplit_DXDYDZ_ksp_max_it 10  -fieldsplit_DXDYDZPRE1_fieldsplit_DXDYDZ_ksp_type gmres  -fieldsplit_DXDYDZPRE1_fieldsplit_DXDYDZ_pc_type gamg  -fieldsplit_DXDYDZPRE1_fieldsplit_DXDYDZ_pc_gamg_threshold -1  -fieldsplit_DXDYDZPRE1_ksp_monitor  -fieldsplit_DXDYDZPRE1_ksp_converged_reason  -fieldsplit_DXDYDZPRE1_ksp_max_it 3  -fieldsplit_DXDYDZPRE1_ksp_rtol 1.e-3  -fieldsplit_DXDYDZPRE1_ksp_type fgmres  -fieldsplit_DXDYDZPRE1_pc_fieldsplit_schur_factorization_type upper  -fieldsplit_DXDYDZPRE1_pc_fieldsplit_schur_precondition a11  -fieldsplit_DXDYDZPRE1_pc_fieldsplit_type schur  -fieldsplit_DXDYDZPRE1_pc_type fieldsplit  -ksp_converged_reason  -ksp_type fgmres  -ksp_view  -ksp_converged_reason    -pc_fieldsplit_type multiplicative -log_view -on_error_attach_debugger"""

MESTAT = STAT_NON_LINE(
                        CHAM_MATER=CHMAT0,
                        COMPORTEMENT=_F(
                                        RELATION='KIT_THM',
                                        RELATION_KIT=('ELAS', 'LIQU_SATU', 'HYDR_UTIL')
                        ),
                        CONVERGENCE=_F(RESI_GLOB_RELA=1e-06),
                        EXCIT=_F(CHARGE=CHAR0,FONC_MULT=RAMPE,),
                        INCREMENT=_F(LIST_INST=LI),
                        MODELE=MODELE,
                        NEWTON=_F(MATRICE='TANGENTE', REAC_ITER=1,),
                        SOLVEUR=_F(MATR_DISTRIBUEE='OUI', METHODE='PETSC', PRE_COND='FIELDSPLIT',RESI_RELA=1.e-8,
                                   NOM_CMP=('DX','DY','DZ','PRE1','TEMP',), PARTITION_CMP=(3,1,1,), OPTION_PETSC=myOptions),
                        INFO=1,
)


if MAIL.hasLocalGroupOfNodes('N_test') : 
    tab = POST_RELEVE_T( ACTION =_F( 
                    INTITULE  = 'dx',
                        RESULTAT=MESTAT, 
                        NUME_ORDRE=2,
                        GROUP_NO='N_test',
                        NOM_CHAM   = 'DEPL',
                        NOM_CMP   = 'DX',
                        OPERATION = 'EXTRACTION' ,) , 
                      )
  
    TEST_TABLE(TABLE=tab,
           NOM_PARA='DX',
           VALE_CALC=7.98054127843E-06,
           VALE_REFE=7.98054127843E-06,
           PRECISION=1.E-6,
           REFERENCE='AUTRE_ASTER',)

elif MAIL.hasLocalGroupOfNodes('N_test2') :  
    tab2 = POST_RELEVE_T( ACTION =_F( 
                    INTITULE  = 'dx',
                        RESULTAT=MESTAT, 
                        NUME_ORDRE=2,
                        GROUP_NO='N_test2',
                        NOM_CHAM   = 'DEPL',
                        NOM_CMP   = 'DX',
                        OPERATION = 'EXTRACTION' ,) , 
                      )
  
    TEST_TABLE(TABLE=tab2,
           NOM_PARA='DX',
           VALE_CALC=3.46633156137E-05,
           VALE_REFE=3.46633156137E-05,
           PRECISION=1.E-6,
           REFERENCE='AUTRE_ASTER',)


# at least it pass here!

test.printSummary()

# if parallel:
#     rank = code_aster.getMPIRank()
#     MESTAT.printMedFile('/tmp/par_%d.resu.med'%rank)
# else:
#     MESTAT.printMedFile('/tmp/seq.resu.med')

FIN()
