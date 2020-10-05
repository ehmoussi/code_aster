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

rank = code_aster.getMPIRank()

pMesh2 = code_aster.ParallelMesh()
pMesh2.readMedFile("xxParallelMechanicalLoad001c/%d.med"%rank, True)

model = AFFE_MODELE(MAILLAGE = pMesh2,
                    AFFE = _F(MODELISATION = "D_PLAN",
                              PHENOMENE = "MECANIQUE",
                              TOUT = "OUI",),)

char_cin = AFFE_CHAR_CINE(MODELE=model,
                          MECA_IMPO=(_F(GROUP_NO="N2",
                                        DX=0.,DY=0.,DZ=0.,),
                                     _F(GROUP_NO="N4",
                                        DX=0.,DY=0.,DZ=0.,),),)

char_meca = AFFE_CHAR_MECA(MODELE=model,
                           LIAISON_SOLIDE=_F(GROUP_NO=("N1", "N3")),
                           DDL_IMPO=_F(GROUP_NO="N1",DX=1.0)
                                          )
char_meca.debugPrint(10+rank)

MATER1 = DEFI_MATERIAU(ELAS=_F(E=200000.0,
                               NU=0.3,),)

AFFMAT = AFFE_MATERIAU(MAILLAGE=pMesh2,
                       AFFE=_F(TOUT='OUI',
                               MATER=MATER1,),)

resu = MECA_STATIQUE(CHAM_MATER=AFFMAT,
                     MODELE=model,
                     EXCIT=(_F(CHARGE=char_cin,),
                            _F(CHARGE=char_meca,),),
                     SOLVEUR=_F(METHODE='PETSC',
                                PRE_COND='SANS',
                                RESI_RELA=1.E-10,),)
resu.debugPrint(10+rank)

resu.printMedFile("test"+str(rank)+".med")

MyFieldOnNodes = resu.getRealFieldOnNodes("DEPL", 1)
sfon = MyFieldOnNodes.exportToSimpleFieldOnNodes()
sfon.debugPrint(10+rank)
sfon.updateValuePointers()

if rank == 0:
    test.assertAlmostEqual(sfon.getValue(1, 2), 0.4245510586973997)
elif rank == 1:
    test.assertAlmostEqual(sfon.getValue(1, 2), 0.4245510586973997)

FIN()
