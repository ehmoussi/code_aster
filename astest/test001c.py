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
monMaillage = code_aster.Mesh()

# test de relecture d'un fichier Gmsh
monMaillage.readGmshFile("ssnv187a.msh")

# test du format Gibi
mtest = code_aster.Mesh()
mtest.readGibiFile("zzzz364a.mgib")

coord = monMaillage.getCoordinates()

# check readonly access
print("coord[3] ", coord[3])
test.assertEqual( coord[3], 1.0 )

with test.assertRaises(TypeError):
    coord[3] = 5.0

# Definition du modele Aster
monModel = code_aster.Model(monMaillage)
monModel.addModelingOnMesh(code_aster.Physics.Mechanics, code_aster.Modelings.Tridimensional)

# delete monMaillage and check that the C++ object still exists because
# referenced by the model object
del monMaillage
with test.assertRaises(NameError):
    monMaillage.getCoordinates()

# delete/overwrite monModel, coord object still exists
monModel = 1
test.assertEqual( coord[3], 1.0 )

test.printSummary()

code_aster.close()
