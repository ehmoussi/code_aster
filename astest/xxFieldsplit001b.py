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

code_aster.init("--test")

test = code_aster.TestCase()

#parallel=False
parallel = True

if parallel:
    rank=code_aster.getMPIRank()
    MAIL = code_aster.ParallelMesh()
    MAIL.readMedFile("xxFieldsplit001a/%d.med"%rank, True)
else:
    MAIL = code_aster.Mesh()
    MAIL.readMedFile("petsc04a.mmed")

model = AFFE_MODELE(
                    AFFE=_F(MODELISATION=('3D_INCO_UP', ), PHENOMENE='MECANIQUE', TOUT='OUI'),
                    MAILLAGE=MAIL,
                    DISTRIBUTION=_F(METHODE='CENTRALISE'),
                )

mater = DEFI_MATERIAU(ELAS=_F(E=1.0, NU=0.4999))

fieldmat = AFFE_MATERIAU(
                        AFFE=_F(MATER=(mater, ), TOUT='OUI'), MAILLAGE=MAIL, MODELE=model
                    )

listr0 = DEFI_LIST_REEL(DEBUT=0.0, INTERVALLE=_F(JUSQU_A=1.0, NOMBRE=1))

times0 = DEFI_LIST_INST(
                        DEFI_LIST=_F(LIST_INST=listr0),
                        ECHEC=_F(ACTION='DECOUPE', EVENEMENT='ERREUR', SUBD_NIVEAU=2)
                    )

myOptions=""" -fieldsplit_PRES_ksp_max_it 5  -fieldsplit_PRES_ksp_monitor  -fieldsplit_PRES_ksp_converged_reason  -fieldsplit_PRES_ksp_rtol 1.e-3  -fieldsplit_PRES_ksp_type fgmres  -fieldsplit_PRES_pc_type jacobi  -fieldsplit_DXDYDZ_ksp_monitor  -fieldsplit_DXDYDZ_ksp_converged_reason  -fieldsplit_DXDYDZ_ksp_rtol 1e-3  -fieldsplit_DXDYDZ_ksp_max_it 20  -fieldsplit_DXDYDZ_ksp_type gmres  -fieldsplit_DXDYDZ_pc_type gamg  -fieldsplit_DXDYDZ_pc_gamg_threshold -1  -ksp_monitor  -ksp_converged_reason   -ksp_type fgmres  -pc_fieldsplit_schur_factorization_type upper  -pc_fieldsplit_schur_precondition a11  -pc_fieldsplit_type schur  -log_view"""

BC = AFFE_CHAR_CINE(
                    MECA_IMPO=(
                                _F(DZ=0.0, GROUP_MA=('Zinf', )),
                                _F(DY=0.0, GROUP_MA=('Yinf', 'Ysup')),
                                _F(DX=0.0, GROUP_MA=('Xsup', 'Xinf')),
                                _F(DX=1.0, DZ=0.0, GROUP_MA=('Zsup', )),
                                _F(PRES=0.0, GROUP_NO='N_test',),
                    ),
                    MODELE=model
                )

resnonl = STAT_NON_LINE(
                        CHAM_MATER=fieldmat,
                        EXCIT=_F(CHARGE=BC, ),
                        INCREMENT=_F(LIST_INST=times0),
                        MODELE=model,
                        SOLVEUR=_F(METHODE='PETSC', PRE_COND='FIELDSPLIT',RESI_RELA=1.e-8,
                                   NOM_CMP=('DX','DY','DZ','PRES'), PARTITION_CMP=(3,1), OPTION_PETSC=myOptions),
                        INFO=2,
                    )


# ajouter TEST_RESU comme petsc04c
if MAIL.hasGroupOfNodes('N_test', True) :
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
        VALE_CALC=-0.121908649820,
        VALE_REFE=-0.121908649820,
    ))

elif MAIL.hasGroupOfNodes('N_test2', True) :
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
        VALE_CALC=0.09623615926,
        VALE_REFE=0.09623615926,
    ))


# at least it pass here!

test.printSummary()

# if parallel:
#     rank = code_aster.getMPIRank()
#     resnonl.printMedFile('/tmp/par_%d.resu.med'%rank)
# else:
#     resnonl.printMedFile('/tmp/seq.resu.med')

FIN()
