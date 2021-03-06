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

import os
import code_aster
from code_aster.Commands import *
test = code_aster.TestCase()

code_aster.init("--test")

rank = code_aster.getMPIRank()
nProc = code_aster.getMPINumberOfProcs()
parallel= (nProc>1)

if parallel:
    pMesh2 = code_aster.ParallelMesh()
    pMesh2.readMedFile("xxParallelMechanicalLoad001b/%d.med"%rank, True)
else:
    pMesh2 = code_aster.Mesh()
    pMesh2.readMedFile("xxNotParallelMechanicalLoad001b.med")

double = False
if double: oui = "OUI"
else: oui = "NON"

model = AFFE_MODELE(MAILLAGE = pMesh2,
                    AFFE = _F(MODELISATION = "D_PLAN_INCO_UPG",
                              PHENOMENE = "MECANIQUE",
                              TOUT = "OUI",),
                    DISTRIBUTION=_F(METHODE='CENTRALISE',),)

char_cin = AFFE_CHAR_CINE(MODELE=model,
                          MECA_IMPO=(_F(GROUP_NO="N2",
                                        DX=0.,DY=0.,DZ=0.,),
                                     _F(GROUP_NO="N4",
                                        DX=0.,DY=0.,DZ=0.,),),)

char_meca = AFFE_CHAR_MECA(MODELE=model,
                           LIAISON_DDL=_F(GROUP_NO=("N1", "N3"),
                                          DDL=('PRES','PRES'),
                                          COEF_MULT=(2.0,3.0),
                                          COEF_IMPO=0,),
                           DDL_IMPO=(_F(GROUP_NO="N1",PRES=200000.0),
                                          ),
                           DOUBLE_LAGRANGE=oui,
                           )
#char_meca.debugPrint(10+rank)

MATER1 = DEFI_MATERIAU(ELAS=_F(E=200000.0,
                               NU=0.4999999,),)

AFFMAT = AFFE_MATERIAU(MAILLAGE=pMesh2,
                       AFFE=_F(TOUT='OUI',
                               MATER=MATER1,),)

resu = MECA_STATIQUE(CHAM_MATER=AFFMAT,
                     MODELE=model,
                     EXCIT=(_F(CHARGE=char_cin,),
                            _F(CHARGE=char_meca,),),
                     )
#resu.debugPrint(10+rank)
#if rank == 0:
    #os.system("cp fort.10 /home/H85256/resu0.txt")
#elif rank == 1:
    #os.system("cp fort.11 /home/H85256/resu1.txt")

#resu.printMedFile("test"+str(rank)+".med")
#from shutil import copyfile
#if double:
    #filename = "test_double"+str(rank)+".med"
#else:
    #filename = "test_simple"+str(rank)+".med"
#copyfile("test"+str(rank)+".med", "/home/H85256/"+filename)

MyFieldOnNodes = resu.getRealFieldOnNodes("DEPL", 1)
sfon = MyFieldOnNodes.exportToSimpleFieldOnNodes()
#sfon.debugPrint(10+rank)
sfon.updateValuePointers()

if parallel:
    # DX displacement on nodes "N1" and "N3", comparison with sequential results
    if rank == 0:
        test.assertAlmostEqual(sfon.getValue(1, 0), 0.839160376798051, 6)
        #os.system("cp fort.11 /home/H85256/par0.txt")
    elif rank == 1:
        test.assertAlmostEqual(sfon.getValue(1, 0), 1.0771272190278451, 6)
        #os.system("cp fort.12 /home/H85256/par1.txt")
else:
    test.assertAlmostEqual(sfon.getValue(2, 0), 0.839160376798051)
    test.assertAlmostEqual(sfon.getValue(3, 0), 1.0771272190278451)
    #os.system("cp fort.11 /home/H85256/seq.txt")

FIN()
