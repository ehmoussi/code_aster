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

code_aster.init("--test")
test = code_aster.TestCase()

# Creation du maillage
mesh = code_aster.Mesh()
test.assertEqual(mesh.getType(), 'MAILLAGE_SDASTER')

# Relecture du fichier MED
mesh.readMedFile("test001a.mmed")

# help(mesh)

coord = mesh.getCoordinates()
test.assertEqual(coord.getType(), "CHAM_NO_SDASTER")
# help(coord)

# check readonly access
print("coord[3] ", coord[3])
test.assertEqual(coord[3], 1.0)

with test.assertRaises(TypeError):
    coord[3] = 5.0

# Definition du modele Aster
model = code_aster.Model(mesh)
test.assertEqual(model.getType(), "MODELE_SDASTER")
model.addModelingOnMesh(
    code_aster.Physics.Mechanics, code_aster.Modelings.Tridimensional)

model.setSplittingMethod(code_aster.ModelSplitingMethod.GroupOfCells)
test.assertEqual(model.getSplittingMethod(),
                 code_aster.ModelSplitingMethod.GroupOfCells)

model.setSplittingMethod(code_aster.ModelSplitingMethod.Centralized)
test.assertEqual(model.getSplittingMethod(),
                 code_aster.ModelSplitingMethod.Centralized)

model.build()

# Definition du modele Aster
model2 = code_aster.Model(mesh)

with test.assertRaisesRegex(RuntimeError, 'not allowed'):
    model2.addModelingOnMesh(
        code_aster.Physics.Thermal, code_aster.Modelings.DKT)

# Verification du comptage de référence sur le maillage
del mesh

with test.assertRaises(NameError):
    mesh

mesh2 = model.getMesh()
test.assertTrue('Tout' in mesh2.getGroupsOfCells())

# Vérification du debug
mesh2.debugPrint(66)

del coord
code_aster.saveObjects()

test.printSummary()

code_aster.close()
