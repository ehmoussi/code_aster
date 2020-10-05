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

test = code_aster.TestCase()

code_aster.init("--test")

nProc = code_aster.getMPINumberOfProcs()
parallel= (nProc>1)

if (parallel):
    Mesh = code_aster.ParallelMesh()
else:
    Mesh = code_aster.Mesh()

Mesh.readMedFile("xxParallelMechanicalLoad001o.med")

DEFI_GROUP( reuse=Mesh, MAILLAGE=Mesh,
                   CREA_GROUP_MA=(
                        _F(  NOM = 'TOUT', TOUT = 'OUI'),
                   ),
                   CREA_GROUP_NO=(
                        _F(  NOM = 'F1_NO', GROUP_MA = 'F1'),
                        _F(  NOM = 'F2_NO', GROUP_MA = 'F2'),
                        _F(  NOM = 'F3_NO', GROUP_MA = 'F3'),
                   ))


model = AFFE_MODELE(MAILLAGE = Mesh,
                    AFFE = _F(MODELISATION = "D_PLAN",
                              PHENOMENE = "MECANIQUE",
                              TOUT = "OUI",),)

char_cin = AFFE_CHAR_CINE(MODELE=model,
                          MECA_IMPO=(_F(GROUP_NO="N2",
                                        DX=0.,DY=0.,),
                                     _F(GROUP_NO="N4",
                                        DX=0.,DY=0.,),),)

char_meca = AFFE_CHAR_MECA(MODELE=model,
                           LIAISON_DDL=_F(GROUP_NO=("N1", "N3"),
                                          DDL=('DX','DX'),
                                          COEF_MULT=(1.0,-1.0),
                                          COEF_IMPO=0,),
                           DDL_IMPO=_F(GROUP_NO="N1",DX=1.0),)

MATER1 = DEFI_MATERIAU(ELAS=_F(E=200000.0,
                               NU=0.3,),)

AFFMAT = AFFE_MATERIAU(MAILLAGE=Mesh,
                       AFFE=_F(TOUT='OUI',
                               MATER=MATER1,),)

LI = DEFI_LIST_REEL(DEBUT=0.0, INTERVALLE=_F(JUSQU_A=1.0, NOMBRE=1),)


resu =  MECA_STATIQUE(MODELE=model,
                           CHAM_MATER=AFFMAT,
                           EXCIT=(_F(CHARGE=char_cin,),
                            _F(CHARGE=char_meca,),),
                           LIST_INST=LI,
                         )

CALC_CHAMP(reuse=resu,
           RESULTAT=resu,
           CONTRAINTE=('SIEF_NOEU'),)

if(parallel):
    if(Mesh.hasGroupOfNodes("N1", local=True)):
        TEST_RESU(
            RESU=(_F(
                CRITERE='RELATIF',
                GROUP_NO='N1',
                NOM_CHAM='DEPL',
                NOM_CMP='DY',
                NUME_ORDRE=1,
                PRECISION=1.e-6,
                REFERENCE='AUTRE_ASTER',
                RESULTAT=resu,
                VALE_CALC=-0.1656392388099706,
                VALE_REFE=-0.1656392,
            ),

            _F(
                CRITERE='RELATIF',
                GROUP_NO='N1',
                NOM_CHAM='DEPL',
                NOM_CMP='DX',
                NUME_ORDRE=1,
                PRECISION=1.e-6,
                REFERENCE='AUTRE_ASTER',
                RESULTAT=resu,
                VALE_CALC=0.9999999999999999,
                VALE_REFE=1.0,
            ),
        ),)

    if(Mesh.hasGroupOfNodes("N3", local=True)):
        TEST_RESU(
            RESU=(
            _F(
            CRITERE='RELATIF',
            GROUP_NO='N3',
            NOM_CHAM='SIEF_NOEU',
            NOM_CMP='SIXX',
            NUME_ORDRE=1,
            PRECISION=1.e-6,
            REFERENCE='AUTRE_ASTER',
            RESULTAT=resu,
            VALE_CALC=110776.65299053668,
            VALE_REFE=110776.653,
        ),
            _F(
            CRITERE='RELATIF',
            GROUP_NO='N3',
            NOM_CHAM='SIEF_NOEU',
            NOM_CMP='SIXY',
            NUME_ORDRE=1,
            PRECISION=1.e-6,
            REFERENCE='AUTRE_ASTER',
            RESULTAT=resu,
            VALE_CALC=-53501.845246685734,
            VALE_REFE=-53501.845,
        ),
            _F(
            CRITERE='RELATIF',
            GROUP_NO='N3',
            NOM_CHAM='SIEF_NOEU',
            NOM_CMP='SIYY',
            NUME_ORDRE=1,
            PRECISION=1.e-6,
            REFERENCE='AUTRE_ASTER',
            RESULTAT=resu,
            VALE_CALC=11071.480114632101,
            VALE_REFE=11071.480,
        ),),
        )
else:
    TEST_RESU(
        RESU=(_F(
            CRITERE='RELATIF',
            GROUP_NO='N1',
            NOM_CHAM='DEPL',
            NOM_CMP='DY',
            NUME_ORDRE=1,
            PRECISION=1.e-6,
            REFERENCE='AUTRE_ASTER',
            RESULTAT=resu,
            VALE_CALC=-0.1656392388099706,
            VALE_REFE=-0.1656392,
        ),

        _F(
            CRITERE='RELATIF',
            GROUP_NO='N1',
            NOM_CHAM='DEPL',
            NOM_CMP='DX',
            NUME_ORDRE=1,
            PRECISION=1.e-6,
            REFERENCE='AUTRE_ASTER',
            RESULTAT=resu,
            VALE_CALC=0.9999999999999999,
            VALE_REFE=1.0,
        ),

        _F(
            CRITERE='RELATIF',
            GROUP_NO='N3',
            NOM_CHAM='SIEF_NOEU',
            NOM_CMP='SIXX',
            NUME_ORDRE=1,
            PRECISION=1.e-6,
            REFERENCE='AUTRE_ASTER',
            RESULTAT=resu,
            VALE_CALC=110776.65299053668,
            VALE_REFE=110776.653,
        ),

        _F(
            CRITERE='RELATIF',
            GROUP_NO='N3',
            NOM_CHAM='SIEF_NOEU',
            NOM_CMP='SIXY',
            NUME_ORDRE=1,
            PRECISION=1.e-6,
            REFERENCE='AUTRE_ASTER',
            RESULTAT=resu,
            VALE_CALC=-53501.845246685734,
            VALE_REFE=-53501.845,
        ),

        _F(
            CRITERE='RELATIF',
            GROUP_NO='N3',
            NOM_CHAM='SIEF_NOEU',
            NOM_CMP='SIYY',
            NUME_ORDRE=1,
            PRECISION=1.e-6,
            REFERENCE='AUTRE_ASTER',
            RESULTAT=resu,
            VALE_CALC=11071.480114632101,
            VALE_REFE=11071.480,
        ),

        )
    )


FIN()
