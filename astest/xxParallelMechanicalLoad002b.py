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

import os

pMesh2 = code_aster.ParallelMesh()
pMesh2.readMedFile("xxParallelMesh001a/%d.med"%rank, True)

rank = code_aster.getMPIRank()

model = AFFE_MODELE(MAILLAGE = pMesh2,
                    AFFE = _F(MODELISATION = "3D",
                              PHENOMENE = "MECANIQUE",
                              TOUT = "OUI",),
                    DISTRIBUTION=_F(METHODE='CENTRALISE',),)

char_cin = AFFE_CHAR_CINE(MODELE=model,
                          MECA_IMPO=_F(GROUP_NO="COTE_H",
                                       DX=0.,
                                       DY=0.,
                                       DZ=0.,),)

char_meca = AFFE_CHAR_MECA(MODELE=model,
                           LIAISON_DDL=_F(GROUP_NO=("A", "B"),
                                          DDL=('DX','DX'),
                                          COEF_MULT=(1.0,-1.0),
                                          COEF_IMPO=0,),
                           DDL_IMPO=_F(GROUP_NO="A",
                                       DX=1.0),)

MATER1 = DEFI_MATERIAU(ELAS=_F(E=200000.0,
                               NU=0.3,
                               RHO=1.e-3,),)

char_vol=AFFE_CHAR_MECA(MODELE=model,
                        PESANTEUR=_F(GRAVITE=9.81,
                        DIRECTION=(0.,0.,-1.,),),)

AFFMAT = AFFE_MATERIAU(MAILLAGE=pMesh2,
                       AFFE=_F(TOUT='OUI',
                               MATER=MATER1,),)

LI = DEFI_LIST_REEL(DEBUT=0.0, INTERVALLE=_F(JUSQU_A=1.0, NOMBRE=1))

resu = STAT_NON_LINE(CHAM_MATER=AFFMAT,
                     METHODE='NEWTON',
                     COMPORTEMENT=_F(RELATION='ELAS',),
                     CONVERGENCE=_F(RESI_GLOB_RELA=1.e-8),
                     EXCIT=(_F(CHARGE=char_cin,),
                            _F(CHARGE=char_vol,),
                            _F(CHARGE=char_meca,),
                            ),
                     INCREMENT=_F(LIST_INST=LI),
                     MODELE=model,
                     NEWTON=_F(MATRICE='TANGENTE', REAC_ITER=1,),
                     SOLVEUR=_F(METHODE='PETSC',RESI_RELA=1.e-5,PRE_COND='LDLT_SP'),)

MyFieldOnNodes = resu.getRealFieldOnNodes("DEPL", 2)
sfon = MyFieldOnNodes.exportToSimpleFieldOnNodes()

value = [1., 1., 0., 0.]
test.assertAlmostEqual(sfon.getValue(0, 0), value[rank])
value = [0.0712953407513, 0.0609114486676, -0.00116776983364, 0.000584732584462]
test.assertAlmostEqual(sfon.getValue(240, 0), value[rank])

test.printSummary()

FIN()
