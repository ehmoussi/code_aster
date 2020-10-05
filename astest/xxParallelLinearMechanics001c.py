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

rank = code_aster.getMPIRank()
pMesh = code_aster.ParallelMesh()
pMesh.readMedFile("xxParallelMesh001a/%d.med"%rank, True)

monModel = code_aster.Model(pMesh)
monModel.addModelingOnMesh(code_aster.Physics.Mechanics,
                              code_aster.Modelings.Tridimensional)
monModel.build()

testMesh = monModel.getMesh()
test.assertEqual(testMesh.getType(), "MAILLAGE_P")

acier = DEFI_MATERIAU(ELAS = _F(E = 2.e11,
                                NU = 0.3,),)

affectMat = code_aster.MaterialField(pMesh)
affectMat.addMaterialsOnMesh( acier )
affectMat.buildWithoutExternalVariable()

testMesh2 = affectMat.getMesh()
test.assertEqual(testMesh2.getType(), "MAILLAGE_P")

charCine = code_aster.KinematicsMechanicalLoad()
charCine.setModel(monModel)
charCine.addImposedMechanicalDOFOnNodes(code_aster.PhysicalQuantityComponent.Dx, 0., "COTE_B")
charCine.addImposedMechanicalDOFOnNodes(code_aster.PhysicalQuantityComponent.Dy, 0., "COTE_B")
charCine.addImposedMechanicalDOFOnNodes(code_aster.PhysicalQuantityComponent.Dz, 0., "COTE_B")
charCine.build()

charMeca = AFFE_CHAR_MECA(MODELE=monModel, DOUBLE_LAGRANGE="NON",
                           DDL_IMPO=_F(GROUP_NO=("COTE_H"),
                                       DZ=1.0,),)

monSolver = code_aster.MumpsSolver(code_aster.Renumbering.Metis)

mecaStatique = code_aster.LinearStaticAnalysis(monModel, affectMat)
mecaStatique.addKinematicsLoad(charCine)
mecaStatique.addParallelMechanicalLoad(charMeca)
mecaStatique.setLinearSolver(monSolver)

resu = mecaStatique.execute()

resu.printMedFile("fort."+str(rank+40)+".med")

MyFieldOnNodes = resu.getRealFieldOnNodes("DEPL", 1)
sfon = MyFieldOnNodes.exportToSimpleFieldOnNodes()
sfon.updateValuePointers()

val = [0.134202362865, 0.134202362865, 0.154144849556, 0.154144849556]
test.assertAlmostEqual(sfon.getValue(4, 1), val[rank])

test.printSummary()

FIN()
