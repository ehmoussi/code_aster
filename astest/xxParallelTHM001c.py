# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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
import os

# test = petsc04c en parallèle = xxFieldsplit001d
# mais sans préciser l'option de PETSC

test = code_aster.TestCase()

code_aster.init()
nProc = code_aster.getMPINumberOfProcs()
parallel= (nProc>1)

if (parallel):
    MAIL = code_aster.ParallelMesh()
    MAIL.readMedFile("xxFieldsplit001a")
else:
    MAIL = code_aster.Mesh()
    MAIL.readMedFile("petsc04a.mmed")


DEFI_GROUP( reuse=MAIL, MAILLAGE=MAIL,
                   CREA_GROUP_MA=(
                        _F(  NOM = 'TOUT', TOUT = 'OUI'),
                        _F(  NOM = 'Y_MA', UNION = ('Yinf', 'Ysup')),
                   ),
                   CREA_GROUP_NO=(
                        _F(  NOM = 'Ysup_NO', GROUP_MA = 'Ysup'),
                        _F(  NOM = 'Zsup_NO', GROUP_MA = 'Zsup'),
                        _F(  GROUP_MA = 'Zinf'),
                        _F(  TOUT_GROUP_MA = 'OUI'),
                   ))

DEFI_GROUP( reuse=MAIL, MAILLAGE=MAIL,
                   CREA_GROUP_MA=(
                        _F(  NOM = 'Yinf2', INTERSEC = ('Yinf', 'Y_MA')),
                        _F(  NOM = 'Ysup2', DIFFE = ('Y_MA', 'Yinf')),
                        _F(  NOM = 'Ysup3', DIFFE = ('Y_MA', 'Yinf')),
                   ),
                   CREA_GROUP_NO=(
                        _F(  NOM = 'Sup_NO', UNION = ('Ysup','Zsup')),
                        _F(  NOM = 'Inter_NO', INTERSEC = ('Ysup','Zsup'),),
                   ))

DEFI_GROUP( reuse=MAIL, MAILLAGE=MAIL,
                   DETR_GROUP_MA=(
                        _F(  NOM = 'Ysup3', ),
                   ),
                   DETR_GROUP_NO=(
                        _F(  NOM = 'Sup_NO',),
                   ))

MODELE = AFFE_MODELE(
                    AFFE=_F(MODELISATION='3D_THM', PHENOMENE='MECANIQUE', TOUT='OUI'),
                    DISTRIBUTION=_F(METHODE='CENTRALISE'),
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
                                     BIOT_COEF=1.e-12,
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
                _F(DX=0.0, DY=0.0, DZ=0.0, GROUP_NO=('Zinf', )),
                _F(DX=0.0, DY=0.0, DZ=0.0, GROUP_MA=('Y_MA')),
                _F(DX=0.0, DY=0.0, DZ=0.0, GROUP_MA=('Xsup', 'Xinf')),
                _F(DX=0.0, DY=0.0, DZ=0.001, GROUP_NO=('Zsup_NO', )),
    ),
    MODELE=MODELE
)

RAMPE=DEFI_FONCTION(NOM_PARA='INST',
                    VALE=(0.0,0.0,
                          100.0,1.0,
                          ),
                    PROL_DROITE='LINEAIRE',
                    PROL_GAUCHE='LINEAIRE',)

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
                        SOLVEUR=_F(METHODE='PETSC',),
                        INFO=2,
)

# ajouter TEST_RESU comme petsc04c
if MAIL.hasLocalGroupOfNodes('N_test') :
    TEST_RESU(
       RESU=_F(
       CRITERE='ABSOLU',
       GROUP_NO='N_test',
       NOM_CHAM='DEPL',
       NOM_CMP='DX',
       NUME_ORDRE=1,
       PRECISION=1.e-6,
       REFERENCE='AUTRE_ASTER',
        RESULTAT=resnonl,
        VALE_CALC=7.98054127843E-06,
        VALE_REFE=7.98054129752E-06,
    ))

elif MAIL.hasLocalGroupOfNodes('N_test2') :
    TEST_RESU(
       RESU=_F(
       CRITERE='ABSOLU',
       GROUP_NO='N_test2',
       NOM_CHAM='DEPL',
       NOM_CMP='DX',
       NUME_ORDRE=1,
       PRECISION=1.e-6,
       REFERENCE='AUTRE_ASTER',
        RESULTAT=resnonl,
        VALE_CALC=3.46633156137E-05,
        VALE_REFE=3.46633156137E-05,
    ))


# if parallel:
#     rank = code_aster.getMPIRank()
#     resnonl.printMedFile('/tmp/par_%d.resu.med'%rank)
# else:
#     resnonl.printMedFile('/tmp/seq.resu.med')

# at least it pass here!
test.printSummary()

FIN()
