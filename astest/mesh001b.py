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

from code_aster.Commands import DEFI_GROUP

code_aster.init("--test")

# check ParallelMesh object API
test = code_aster.TestCase()

# MPI test
rank = code_aster.getMPIRank()
nbproc = code_aster.getMPINumberOfProcs()

test.assertEqual(nbproc, 3)

# from MED format (only this one a ParallelMesh)
mesh = code_aster.ParallelMesh()
mesh.readMedFile("mesh001b")


mesh=DEFI_GROUP( reuse=mesh, MAILLAGE=mesh,
                  CREA_GROUP_NO=(_F(  NOM = 'GN'+str(rank),  GROUP_NO = 'EXT_0'),),
                  CREA_GROUP_MA=(_F(  NOM = 'GC'+str(rank),  GROUP_MA = 'Cable0'),))

test.assertTrue(mesh.isParallel())
test.assertEqual(mesh.getDimension(), 3)

nbNodes = [89, 90, 109]
nbCells = [59, 54, 75]

test.assertEqual(mesh.getNumberOfNodes(), nbNodes[rank])
test.assertEqual(mesh.getNumberOfCells(), nbCells[rank])

# test groups
globalGroupsOfCells = ["Cable0", "Cable1","Cable2", "Cable3", "Cable4", "Cable5", "Cable6", \
                          "Cable7","Cable8","Press" , "Encast","Beton", "GC0", "GC1", "GC2" ]
groupsOfCells = [ ["Cable0", "Cable1","Cable2", "Cable3", "Cable4", "Cable5", "Cable6", \
                          "Cable7","Cable8","Press" , "Encast","Beton", "GC0"   ] , \
                ["Cable0", "Cable1","Cable2", "Cable3", "Cable4", "Cable5", "Cable6", \
                          "Cable7","Cable8","Press" , "Beton", "GC1"   ], \
                ["Cable0", "Cable1","Cable2", "Cable3", "Cable4", "Cable5", "Cable6", \
                          "Cable7","Cable8","Press" , "Encast","Beton", "GC2"   ] ]

test.assertSequenceEqual(sorted(mesh.getGroupsOfCells()), sorted(globalGroupsOfCells))
test.assertSequenceEqual(sorted(mesh.getGroupsOfCells(False)), sorted(globalGroupsOfCells))
test.assertSequenceEqual(sorted(mesh.getGroupsOfCells(True)), sorted(groupsOfCells[rank]))

test.assertTrue( mesh.hasGroupOfCells("Beton"))
test.assertTrue( mesh.hasGroupOfCells("Beton", False))
test.assertTrue( mesh.hasGroupOfCells("Beton", True))
test.assertTrue( mesh.hasGroupOfCells("GC1", False))
test.assertTrue( mesh.hasGroupOfCells("GC"+str(rank), True))
test.assertFalse( mesh.hasGroupOfCells("GC4", True))
test.assertFalse( mesh.hasGroupOfCells("GC4", False))

globalGroupsOfNodes = [ "EXT_0", "EXT_1", "EXT_2", "GN0", "GN1", "GN2"]
groupsOfNodes = [ [ "EXT_0", "EXT_1", "EXT_2", "GN0"], [ "EXT_0", "EXT_1", "EXT_2", "GN1"], \
                    [ "EXT_0", "EXT_1", "EXT_2", "GN2"]]

test.assertSequenceEqual(sorted(mesh.getGroupsOfNodes()), sorted(globalGroupsOfNodes))
test.assertSequenceEqual(sorted(mesh.getGroupsOfNodes(False)), sorted(globalGroupsOfNodes))
test.assertSequenceEqual(sorted(mesh.getGroupsOfNodes(True)), sorted(groupsOfNodes[rank]))

test.assertTrue( mesh.hasGroupOfNodes("EXT_0"))
test.assertTrue( mesh.hasGroupOfNodes("EXT_0", False))
test.assertTrue( mesh.hasGroupOfNodes("EXT_0", True))
test.assertTrue( mesh.hasGroupOfNodes("GN1", False))
test.assertTrue( mesh.hasGroupOfNodes("GN"+str(rank), True))
test.assertFalse( mesh.hasGroupOfNodes("GN4", True))
test.assertFalse( mesh.hasGroupOfNodes("GN4", False))

# Link betwenn local and global numbering
globalNodesNum = mesh.getNodes(False)
nodesGlobFirst = [4, 44, 0]
test.assertEqual(globalNodesNum[0], nodesGlobFirst[rank])
nodesGlobLast = [97, 97, 95]
test.assertEqual(globalNodesNum[-1], nodesGlobLast[rank])

# Owner of Nodes
NodesRank = mesh.getNodesRank()
test.assertEqual(NodesRank[1], rank)

# Node 92 (index is 91) is shared by all meshes (owner is 1)
node92 = [85, 84 ,106]
test.assertEqual(globalNodesNum[node92[rank]-1], 92-1)
test.assertEqual(NodesRank[node92[rank]-1], 1)

def inter(list1, list2):
    return list(set(list1).intersection(list2))

test.assertEqual(mesh.getNumberOfNodes(), len(mesh.getNodes()))
test.assertEqual(mesh.getNumberOfNodes(), len(mesh.getNodes(True)))
test.assertEqual(mesh.getNumberOfNodes(), len(mesh.getNodes(False)))

test.assertEqual(mesh.getNumberOfCells(), len(mesh.getCells()))

test.assertSequenceEqual(mesh.getNodes(), range(1, mesh.getNumberOfNodes()+1))
test.assertSequenceEqual(mesh.getNodes(True), range(1, mesh.getNumberOfNodes()+1))
test.assertSequenceEqual(mesh.getCells(), range(1, mesh.getNumberOfCells()+1))

allNodes = []
innerNodes = []
outerNodes = []

for i in range(mesh.getNumberOfNodes()):
    allNodes.append(i+1)
    if NodesRank[i] == rank:
        innerNodes.append(i+1)
    else:
        outerNodes.append(i+1)

test.assertTrue( len(inter(innerNodes, outerNodes)) == 0)


test.assertSequenceEqual(sorted(mesh.getNodes()),sorted(allNodes))
test.assertSequenceEqual(sorted(mesh.getNodes(True)),sorted(allNodes))
test.assertSequenceEqual(sorted(mesh.getNodes(False)),
                        sorted([globalNodesNum[i-1] for i in allNodes]))
test.assertSequenceEqual(sorted(mesh.getNodes(True, False)),sorted(outerNodes))
test.assertSequenceEqual(sorted(mesh.getNodes(False, False)),
                        sorted([globalNodesNum[i-1] for i in outerNodes]))
test.assertSequenceEqual(sorted(mesh.getNodes(True, True)),sorted(innerNodes))
test.assertSequenceEqual(sorted(mesh.getNodes(False, True)),
                        sorted([globalNodesNum[i-1] for i in innerNodes]))

test.assertSequenceEqual(sorted(mesh.getNodes("Beton")),sorted(mesh.getNodes("Beton", True)))
test.assertSequenceEqual(sorted(mesh.getNodes("Beton")),
    sorted(inter(mesh.getNodes("Beton"), mesh.getNodes() )))
test.assertSequenceEqual(sorted(mesh.getNodes("Beton")),
    sorted(inter(mesh.getNodes("Beton", True), mesh.getNodes(True) )))
test.assertSequenceEqual(sorted(mesh.getNodes("Beton")),
    sorted(inter(mesh.getNodes("Beton"), mesh.getNodes(True) )))
test.assertSequenceEqual(sorted(mesh.getNodes("Beton")),
    sorted(inter(mesh.getNodes("Beton", True), mesh.getNodes() )))
test.assertSequenceEqual(sorted(mesh.getNodes("Beton", False)),
    sorted(inter(mesh.getNodes("Beton", False), mesh.getNodes(False) )))
test.assertSequenceEqual(sorted(mesh.getNodes("Beton", False)),
    sorted(inter(mesh.getNodes("Beton", False), mesh.getNodes(False) )))
test.assertSequenceEqual(sorted(mesh.getNodes("Beton", False)),
    sorted(inter(mesh.getNodes("Beton", False), allNodes )))

test.printSummary()

code_aster.close()
