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

pMesh = LIRE_MAILLAGE(UNITE=20, FORMAT="MED", PARTITIONNEUR="PTSCOTCH", INFO_MED=3)

model = AFFE_MODELE(MAILLAGE=pMesh,
                    AFFE=_F(MODELISATION='D_PLAN', PHENOMENE='MECANIQUE', TOUT='OUI'),)

rank = code_aster.getMPIRank()
nbproc = code_aster.getMPINumberOfProcs()

if nbproc == 2:
    nbNodes = [112,118]
    nbCells = [104,56]
elif nbproc == 3:
    nbNodes = [72,90,100]
    nbCells = [56,65,53]
elif nbproc == 4:
    nbNodes = [73, 69, 76, 80]
    nbCells = [78, 38, 32, 34]

test.assertEqual(pMesh.getDimension(), 2)
test.assertEqual(pMesh.getNumberOfNodes(), nbNodes[rank])
test.assertEqual(pMesh.getNumberOfCells(), nbCells[rank])
test.assertTrue(pMesh.isParallel())

test.printSummary()


FIN()
