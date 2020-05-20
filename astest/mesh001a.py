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

# check Mesh object API
test = code_aster.TestCase()

# from MED format
mesh = code_aster.Mesh()
mesh.readMedFile("test001f.mmed")

test.assertFalse(mesh.isParallel())
test.assertEqual(mesh.getDimension(), 3)
test.assertEqual(mesh.getNumberOfNodes(), 27)
test.assertEqual(mesh.getNumberOfCells(), 56)
test.assertSequenceEqual(sorted(mesh.getGroupsOfNodes()),
                         ['A', 'B', 'Bas', 'C', 'D', 'E', 'F', 'G', 'H', 'Haut'])
test.assertSequenceEqual(sorted(mesh.getGroupsOfCells()), ['Bas', 'Haut'])
coord = mesh.getCoordinates()
test.assertEqual(coord[3], 0.0)
values = coord.getValues()
test.assertEqual(len(values), 27 * 3)

connect = mesh.getConnectivity()
cellsHaut = mesh.getCells('Haut')
test.assertSequenceEqual(cellsHaut, [45, 46, 47, 48])
nodesHaut = mesh.getNodes('Haut')
test.assertSequenceEqual(nodesHaut, [1, 3, 5, 7, 10, 14, 18, 20, 26])

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
