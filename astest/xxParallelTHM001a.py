# coding: utf-8

import code_aster
from code_aster.Commands import *
import os

test = code_aster.TestCase()

code_aster.init()
nProc = code_aster.getMPINumberOfProcs()
parallel= (nProc>1)

if (parallel):
    MAIL = code_aster.ParallelMesh()
    MAIL.readMedFile("xxParallelTHM001a")
else:
    MAIL = code_aster.Mesh()
    MAIL.readMedFile("xxParallelTHM001a.med")


MODELE = AFFE_MODELE(
                    AFFE=_F(MODELISATION='3D_THM', PHENOMENE='MECANIQUE', TOUT='OUI'),
                    MAILLAGE=MAIL
)

#  LISTE DES INSTANTS DE CALCUL
LI = DEFI_LIST_REEL(DEBUT=0.0, INTERVALLE=_F(JUSQU_A=100.0, NOMBRE=1))

# DEFINITION DES FONCTIONS DE COMPORTEMENT :
# VISCOSITE LIQUIDE ET GAZ : UNITE : PA.S
UN = DEFI_CONSTANTE(VALE=1.0)

ZERO = DEFI_CONSTANTE(VALE=0.0)

# PERMEABILITE INTRINSEQUE, RELATIVE DU LIQUIDE, RELATIVE DU GAZ
# UNITE INTRINSEQUE : METRES CARRES , UNITE RELATIVE : SANS
KINT = DEFI_CONSTANTE(VALE=3e-16)

PERMLIQ = DEFI_CONSTANTE(VALE=1.0)

DPERMLI = DEFI_CONSTANTE(VALE=0.0)

PERMGAZ = DEFI_CONSTANTE(VALE=1.0)

DPERGSA = DEFI_CONSTANTE(VALE=0.0)

DPERGPG = DEFI_CONSTANTE(VALE=0.0)

# COEFFICIENT DE FICK
# UNITE METRES CARRES PAR SECONDES
FICK = DEFI_CONSTANTE(VALE=1e-07)

DFICKTE = DEFI_CONSTANTE(VALE=0.0)

DFICKPG = DEFI_CONSTANTE(VALE=0.0)

DCONDLI = DEFI_CONSTANTE(VALE=0.0)

CONDGAZ = DEFI_CONSTANTE(VALE=0.02)

DCONDGA = DEFI_CONSTANTE(VALE=0.0)

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
                                     BIOT_COEF=1.,
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


resnonl = STAT_NON_LINE(
                        CHAM_MATER=CHMAT0,
                        METHODE='NEWTON',
                        COMPORTEMENT=_F(
                                        RELATION='KIT_THM',
                                        RELATION_KIT=('ELAS', 'LIQU_SATU', 'HYDR_UTIL')
                        ),
                        EXCIT=_F(CHARGE=CHAR0),
                        INCREMENT=_F(LIST_INST=LI),
                        MODELE=MODELE,
                        NEWTON=_F(MATRICE='TANGENTE', REAC_ITER=1,),
                        INFO=2,
)

# if parallel:
#     rank = code_aster.getMPIRank()
#     resnonl.printMedFile('/tmp/par_%d.resu.med'%rank)
# else:
#     resnonl.printMedFile('/tmp/seq.resu.med')

# at least it pass here!
test.assertTrue(True)
test.printSummary()

FIN()
