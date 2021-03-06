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

code_aster.init("--test")

# check Mesh object API
test = code_aster.TestCase()

# from MED format
mesh = code_aster.Mesh()
mesh.readMedFile("test001f.mmed")

test.assertFalse(mesh.isParallel())
test.assertEqual(mesh.getDimension(), 3)
test.assertEqual(mesh.getNumberOfNodes(), 27)
test.assertEqual(mesh.getNumberOfCells(), 56)

# test groups
# do the same thing (compatibily with ParallelMesh)
test.assertSequenceEqual(sorted(mesh.getGroupsOfNodes()),
                         ['A', 'B', 'Bas', 'C', 'D', 'E', 'F', 'G', 'H', 'Haut'])
test.assertSequenceEqual(sorted(mesh.getGroupsOfNodes()), sorted(mesh.getGroupsOfNodes(True)))
test.assertSequenceEqual(sorted(mesh.getGroupsOfNodes()), sorted(mesh.getGroupsOfNodes(False)))
# do the same thing (compatibily with ParallelMesh)
test.assertTrue(mesh.hasGroupOfNodes('A'))
test.assertTrue(mesh.hasGroupOfNodes('A', True))
test.assertTrue(mesh.hasGroupOfNodes('A', False))
test.assertFalse(mesh.hasGroupOfNodes('AA'))
test.assertFalse(mesh.hasGroupOfNodes('AA', True))
test.assertFalse(mesh.hasGroupOfNodes('AA', False))


# do the same thing (compatibily with ParallelMesh)
test.assertSequenceEqual(sorted(mesh.getGroupsOfCells()), ['Bas', 'Haut'])
test.assertSequenceEqual(sorted(mesh.getGroupsOfCells()), sorted(mesh.getGroupsOfCells(False)))
test.assertSequenceEqual(sorted(mesh.getGroupsOfCells()), sorted(mesh.getGroupsOfCells(True)))

# do the same thing (compatibily with ParallelMesh)
test.assertTrue(mesh.hasGroupOfCells('Bas'))
test.assertTrue(mesh.hasGroupOfCells('Bas', True))
test.assertTrue(mesh.hasGroupOfCells('Bas', False))
test.assertFalse(mesh.hasGroupOfCells('Droit'))
test.assertFalse(mesh.hasGroupOfCells('Droit', True))
test.assertFalse(mesh.hasGroupOfCells('Droit', False))

# test coordiantes
coord = mesh.getCoordinates()
test.assertEqual(coord[3], 0.0)
values = coord.getValues()
test.assertEqual(len(values), 27 * 3)

connect = mesh.getConnectivity()
cellsHaut = mesh.getCells('Haut')
test.assertSequenceEqual(cellsHaut, [45, 46, 47, 48])
nodesHaut = mesh.getNodes('Haut')
test.assertSequenceEqual(nodesHaut, [1, 3, 5, 7, 10, 14, 18, 20, 26])
# do the same thing (compatibily with ParallelMesh)
test.assertSequenceEqual(mesh.getNodes('Haut', True), [1, 3, 5, 7, 10, 14, 18, 20, 26])
test.assertSequenceEqual(mesh.getNodes('Haut', True, True), [1, 3, 5, 7, 10, 14, 18, 20, 26])
test.assertSequenceEqual(mesh.getNodes('Haut', False), [1, 3, 5, 7, 10, 14, 18, 20, 26])
test.assertSequenceEqual(mesh.getNodes('Haut', False, False), [1, 3, 5, 7, 10, 14, 18, 20, 26])
test.assertSequenceEqual(mesh.getNodes('Haut', True, False), [1, 3, 5, 7, 10, 14, 18, 20, 26])
test.assertSequenceEqual(mesh.getNodes('Haut', False, True), [1, 3, 5, 7, 10, 14, 18, 20, 26])

# test different variant
test.assertEqual(mesh.getNumberOfNodes(), len(mesh.getNodes()))
test.assertEqual(mesh.getNumberOfCells(), len(mesh.getCells()))

test.assertSequenceEqual(mesh.getNodes(), range(1, mesh.getNumberOfNodes()+1))
test.assertSequenceEqual(mesh.getCells(), range(1, mesh.getNumberOfCells()+1))

# do the same thing (compatibily with ParallelMesh)
test.assertSequenceEqual(sorted(mesh.getNodes()), sorted(mesh.getNodes(True)))
test.assertSequenceEqual(sorted(mesh.getNodes()), sorted(mesh.getNodes(True, True)))
test.assertSequenceEqual(sorted(mesh.getNodes()), sorted(mesh.getNodes(False)))
test.assertSequenceEqual(sorted(mesh.getNodes()), sorted(mesh.getNodes(False, True)))
test.assertSequenceEqual(sorted(mesh.getNodes()), sorted(mesh.getNodes(False, False)))
test.assertSequenceEqual(sorted(mesh.getNodes()), sorted(mesh.getNodes(True, False)))

medconn = mesh.getMedConnectivity()
medtypes = np.array(mesh.getMedCellsTypes())
test.assertEqual(len(medtypes), mesh.getNumberOfCells())
# cells 1-24: SEG2
test.assertTrue((medtypes[:24] == 102).all())
# cells 25-48: QUAD4
test.assertTrue((medtypes[25:48] == 204).all())
# cells 49-56: HEXA8
test.assertTrue((medtypes[49:] == 308).all())

# check cell #47 (index 46)
quad47 = connect[47 - 1]
test.assertSequenceEqual(quad47, [10, 1, 18, 26])
test.assertSequenceEqual(medconn[47 - 1], [10, 1, 18, 26])

# always 3 coordinates, even if 'getDimension() == 2'
npcoord = np.array(values).reshape((-1, 3))
# z(cell #47) == 1.
for i in quad47:
    test.assertEqual(npcoord[i - 1][2], 1.0)

# same connectivities for SEG2, QUAD4
test.assertSequenceEqual(connect[12], medconn[12])
test.assertSequenceEqual(connect[36], medconn[36])
# different connectivities for HEXA8
conn_ast = [1, 9, 21, 10, 18, 23, 27, 26]
conn_med = [1, 10, 21, 9, 18, 26, 27, 23]
test.assertSequenceEqual(connect[49 - 1], conn_ast)
test.assertSequenceEqual(medconn[49 - 1], conn_med)

# boundingbox of mesh: (0, 0, 0) -> (1, 1, 1)
test.assertEqual(npcoord.min(), 0.)
test.assertEqual(npcoord.max(), 1.)

# read a HEXA27 from ASTER format
mail = code_aster.Mesh()
mail.readAsterFile("zzzz366a.mail")
m1, m2, m3 = mail.getConnectivity()
# reference connectivities from '.mail' file
ast27 = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20,
         21, 22, 23, 24, 25, 26, 27]
ast20 = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20]
ast08 = [1, 2, 3, 4, 5, 6, 7, 8]
test.assertSequenceEqual(m1, ast27)
test.assertSequenceEqual(m2, ast20)
test.assertSequenceEqual(m3, ast08)

m1, m2, m3 = mail.getMedConnectivity()
# reference connectivities from IMPR_RESU/MED + mdump
med27 = [1, 4, 3, 2, 5, 8, 7, 6, 12, 11, 10, 9, 20, 19, 18, 17, 13, 16, 15, 14,
         21, 25, 24, 23, 22, 26, 27]
med20 = [1, 4, 3, 2, 5, 8, 7, 6, 12, 11, 10, 9, 20, 19, 18, 17, 13, 16, 15, 14]
med08 = [1, 4, 3, 2, 5, 8, 7, 6]
test.assertSequenceEqual(m1, med27)
test.assertSequenceEqual(m2, med20)
test.assertSequenceEqual(m3, med08)

# from ASTER format
mail = code_aster.Mesh()
mail.readAsterFile("ssnp14c.mail")

test.assertFalse(mail.isParallel())
test.assertEqual(mail.getDimension(), 3)
test.assertEqual(mail.getNumberOfNodes(), 22)
test.assertEqual(mail.getNumberOfCells(), 6)
test.assertSequenceEqual(mail.getGroupsOfNodes(), [])
test.assertSequenceEqual(sorted(mail.getGroupsOfCells()),
                         ['BAS', 'DROITE', 'GAUCHE', 'HAUT'])
coord = mail.getCoordinates()
test.assertEqual(coord[3], 1.0)
values = coord.getValues()
test.assertEqual(len(values), 22 * 3)

# # from GMSH format
gmsh = code_aster.Mesh()
gmsh.readGmshFile("ssnv187a.msh")

test.assertFalse(gmsh.isParallel())
test.assertEqual(gmsh.getDimension(), 2)
test.assertEqual(gmsh.getNumberOfNodes(), 132)
test.assertEqual(gmsh.getNumberOfCells(), 207)
test.assertSequenceEqual(gmsh.getGroupsOfNodes(),
                         ['GM5'])
test.assertSequenceEqual(sorted(gmsh.getGroupsOfCells()),
                         ['GM1', 'GM3', 'GM4', 'GM5', 'GM6'])
coord = gmsh.getCoordinates()
test.assertEqual(coord[3], 1.0)
values = coord.getValues()
test.assertEqual(len(values), 132 * 3)

# from GIBI format
gibi = code_aster.Mesh()
gibi.readGibiFile("erreu03a.mgib")

test.assertFalse(gibi.isParallel())
test.assertEqual(gibi.getDimension(), 3)
test.assertEqual(gibi.getNumberOfNodes(), 125)
test.assertEqual(gibi.getNumberOfCells(), 84)
test.assertSequenceEqual(sorted(gibi.getGroupsOfNodes()),
                         ['A', 'B', 'C'])
test.assertSequenceEqual(sorted(gibi.getGroupsOfCells()),
                         ['AB', 'BASE1', 'CUBE1'])
coord = gibi.getCoordinates()
test.assertEqual(coord[3], 10.0)
values = coord.getValues()
test.assertEqual(len(values), 125 * 3)

test.printSummary()

code_aster.close()
