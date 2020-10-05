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

code_aster.init("--test")
nProc = code_aster.getMPINumberOfProcs()
parallel= (nProc>1)

test = code_aster.TestCase()

if (parallel):
    MAIL = code_aster.ParallelMesh()
    MAIL.readMedFile("xxParallelMechanicalLoad004a/%d.med"%rank, True)
    # os.system('echo "-mat_view :/tmp/par.txt:ascii_matlab " > ~/.petscrc')
    # os.system('echo "-ksp_view_rhs ascii:/tmp/rhs_par.txt " >> ~/.petscrc')
    # os.system('echo "-ksp_view_solution ascii:/tmp/sol_par.txt  " >> ~/.petscrc')
else:
    MAIL = code_aster.Mesh()
    MAIL.readMedFile("xxParallelMechanicalLoad004a.med")
    # os.system('echo "-mat_view :/tmp/seq.txt:ascii_matlab " > ~/.petscrc')
    # os.system('echo "-ksp_view_rhs ascii:/tmp/rhs_seq.txt  " >> ~/.petscrc')
    # os.system('echo "-ksp_view_solution ascii:/tmp/sol_seq.txt  " >> ~/.petscrc')


MODELE = AFFE_MODELE(
                    AFFE=_F(MODELISATION='3D', PHENOMENE='MECANIQUE', TOUT='OUI'),
                    DISTRIBUTION=_F(METHODE='CENTRALISE',),
                    MAILLAGE=MAIL
)

# ###################################
#  LISTE DES INSTANTS DE CALCUL
# ###################################
LI = DEFI_LIST_REEL(DEBUT=0.0, INTERVALLE=_F(JUSQU_A=100.0, NOMBRE=1))

MAT = DEFI_MATERIAU(ELAS=_F(ALPHA=8e-06, E=225000000.0, NU=0.0, RHO=2000.0),
                    )

CHMAT0 = AFFE_MATERIAU(AFFE=_F(GROUP_MA='VOLUME', MATER=MAT), MAILLAGE=MAIL)

CHAR0 =  AFFE_CHAR_CINE(
    MECA_IMPO=(
                _F(DX=0.0, DY=0.0, DZ=0.0, GROUP_MA=('Zinf', )),
    ),
    MODELE=MODELE
)

CHAR1 =  AFFE_CHAR_MECA(
  DDL_IMPO=(
              _F(DX=0.0, DY=0.0, DZ=0.0, GROUP_NO=('Zinf', )),
  ),
  MODELE=MODELE
)

char_meca = AFFE_CHAR_MECA(MODELE=MODELE,
                           LIAISON_DDL=_F(GROUP_NO=("A", "B"),
                                          DDL=('DX','DX'),
                                          COEF_MULT=(1.0,-1.0),
                                          COEF_IMPO=0,),
                           )

CHAR2=AFFE_CHAR_MECA(MODELE=MODELE,
                    PESANTEUR=_F(GRAVITE=9.81,
                     DIRECTION=(0.,0.,-1.,),)
                     )

MESTAT = STAT_NON_LINE(
                        CHAM_MATER=CHMAT0,
                        METHODE='NEWTON',
                        COMPORTEMENT=_F(
                                        RELATION='ELAS',
                        ),
                        CONVERGENCE=_F(RESI_GLOB_RELA=1e-6),
                        EXCIT=(_F(CHARGE=CHAR1),_F(CHARGE=CHAR2),_F(CHARGE=char_meca),),
                        INCREMENT=_F(LIST_INST=LI),
                        MODELE=MODELE,
                        NEWTON=_F(MATRICE='TANGENTE', REAC_ITER=1,MATR_RIGI_SYME='NON',),
                    #    SOLVEUR=_F(MATR_DISTRIBUEE='NON', METHODE='MUMPS',),
                        SOLVEUR=_F(MATR_DISTRIBUEE='NON', METHODE='PETSC', PRE_COND='SANS', RESI_RELA=1.e-12,),
                        INFO=2,
)

MESTAT = CALC_CHAMP(reuse=MESTAT,RESULTAT=MESTAT,CONTRAINTE=('SIEF_NOEU'))

# if (parallel):
#    rank = code_aster.getMPIRank()
#    myFile='par.txt'
#    os.system("sed 's/Mat_.*\=/par\ \=/g' /tmp/par.txt > /tmp/par_clean.txt && mv /tmp/par_clean.txt /tmp/par.txt")
#    if (rank==0): os.system( """grep -v %% /tmp/%s | grep -v zzz | grep -v \] | grep -v Mat | awk '{print $3}' | LANG=en_US.UTF-8  sort -g > /tmp/%s_sorted"""%(myFile,myFile) )
#    if (rank==0): os.system( """grep -v Object /tmp/rhs_par.txt | grep -v type | grep -v Process | LANG=en_US.UTF-8  sort -g > /tmp/rhs_par_sorted.txt  """)
#    if (rank==0): os.system( """grep -v Object /tmp/sol_par.txt | grep -v type | grep -v Process | LANG=en_US.UTF-8  sort -g > /tmp/sol_par_sorted.txt  """)
# else:
#    myFile='seq.txt'
#    os.system("sed 's/Mat_.*\=/seq\ \=/g' /tmp/seq.txt > /tmp/seq_clean.txt && mv /tmp/seq_clean.txt /tmp/seq.txt")
#    os.system("grep -v %% /tmp/%s | grep -v zzz | grep -v \] | grep -v Mat | awk '{print $3}' | LANG=en_US.UTF-8  sort -g > /tmp/%s_sorted"%(myFile,myFile))
#    os.system( """grep -v Object /tmp/rhs_seq.txt | grep -v type | grep -v Process | LANG=en_US.UTF-8  sort -g > /tmp/rhs_seq_sorted.txt  """)
#    os.system( """grep -v Object /tmp/sol_seq.txt | grep -v type | grep -v Process | LANG=en_US.UTF-8  sort -g > /tmp/sol_seq_sorted.txt  """)

# if (parallel):
#     rank = code_aster.getMPIRank()
#     if (rank==0): os.system( """cp fort.11 /tmp/ddl0.txt """ )
#     if (rank==1): os.system( """cp fort.12 /tmp/ddl1.txt """ )
# else:
#     os.system( """cp fort.11 /tmp/ddl_seq.txt """ )

## To post-process the matrices :
## cd /tmp
## cat ddl0.txt ddl1.txt    > ddl_par.txt
## LANG=en_US.UTF-8  sort -g ddl_seq.txt > ddl_seq_sorted.txt
## LANG=en_US.UTF-8  sort -g ddl_par.txt > ddl_par_sorted.txt
## uniq ddl_seq_sorted.txt > ddl_seq_sorted_uniq.txt
## uniq ddl_par_sorted.txt > ddl_par_sorted_uniq.txt
## meld ddl_seq_sorted_uniq.txt ddl_par_sorted_uniq.txt


# if parallel:
#     rank = code_aster.getMPIRank()
#     MESTAT.printMedFile('/tmp/par_%d.resu.med'%rank)
# else:
#     MESTAT.printMedFile('/tmp/seq.resu.med')

TEST_RESU(
    RESU=(_F(
        CRITERE='ABSOLU',
        GROUP_NO='A',
        NOM_CHAM='DEPL',
        NOM_CMP='DZ',
        NUME_ORDRE=1,
        PRECISION=1.e-6,
        REFERENCE='AUTRE_ASTER',
        RESULTAT=MESTAT,
        VALE_CALC=-1.09e-5,
        VALE_REFE=-1.09e-5,
    ),
    _F(
        CRITERE='ABSOLU',
        GROUP_NO='B',
        NOM_CHAM='SIEF_NOEU',
        NOM_CMP='SIZZ',
        NUME_ORDRE=1,
        PRECISION=1.e-6,
        REFERENCE='AUTRE_ASTER',
        RESULTAT=MESTAT,
        VALE_CALC=-9809.9999999,
        VALE_REFE=-9809.9999999,
    ),)
)

test.printSummary()


FIN()
