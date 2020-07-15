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
import numpy as np

code_aster.init()

# check ParallelMesh object API
test = code_aster.TestCase()

# MPI test
rank = code_aster.getMPIRank()
nbproc = code_aster.getMPINumberOfProcs()

test.assertEqual(nbproc, 3)

# from MED format (only this one a ParallelMesh)
mesh = code_aster.ParallelMesh()
mesh.readMedFile("mesh001b")

test.assertTrue(mesh.isParallel())
test.assertEqual(mesh.getDimension(), 3)

nbNodes = [89, 90, 109]
nbCells = [59, 54, 75]

test.assertEqual(mesh.getNumberOfNodes(), nbNodes[rank])
test.assertEqual(mesh.getNumberOfCells(), nbCells[rank])

# Link betwenn local and global numbering
globalNodesNum = mesh.getGlobalNodesNumbering()
nodesGlobFirst = [4, 44, 0]
test.assertEqual(globalNodesNum[0], nodesGlobFirst[rank])
nodesGlobLast = [97, 97, 95]
test.assertEqual(globalNodesNum[-1], nodesGlobLast[rank])

# Owner of Nodes
outerNodes = mesh.getOwnerNodes()
test.assertEqual(outerNodes[1], rank)

# Node 92 (index is 91) is shared by all meshes (owner is 1)
node92 = [85, 84 ,106]
test.assertEqual(globalNodesNum[node92[rank]-1], 92-1)
test.assertEqual(outerNodes[node92[rank]-1], 1)


# to complete

test.printSummary()

code_aster.close()
