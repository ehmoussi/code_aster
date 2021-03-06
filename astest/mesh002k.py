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

pMesh = LIRE_MAILLAGE(UNITE=20, FORMAT="MED", PARTITIONNEUR="PTSCOTCH")

model = AFFE_MODELE(MAILLAGE=pMesh,
                    AFFE=_F(MODELISATION='3D', PHENOMENE='MECANIQUE', TOUT='OUI'),)

rank = code_aster.getMPIRank()
nbproc = code_aster.getMPINumberOfProcs()

if nbproc == 2:
    nbNodes = [84, 87]
    nbCells = [358,381]
elif nbproc == 3:
    nbNodes = [64,64,85]
    nbCells = [257,252,330]
elif nbproc == 4:
    nbNodes = [60,64,66,58]
    nbCells = [221,232,253,220]

test.assertEqual(pMesh.getDimension(), 3)
test.assertEqual(pMesh.getNumberOfNodes(), nbNodes[rank])
test.assertEqual(pMesh.getNumberOfCells(), nbCells[rank])
test.assertTrue(pMesh.isParallel())

test.printSummary()


FIN()
3
