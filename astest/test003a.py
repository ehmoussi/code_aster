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

# Test inspiré de zzzz255a

import code_aster
import numpy as np

code_aster.init("--test")

test=code_aster.TestCase()

# Creation of the mesh
mesh = code_aster.Mesh()
mesh.readMedFile("zzzz255a.mmed")

# Creation of the model
model = code_aster.Model(mesh)
model.addModelingOnGroupOfCells(code_aster.Physics.Mechanics,
                                   code_aster.Modelings.Tridimensional,"ALL")
model.build()

# Creation of the crack
crack = code_aster.XfemCrack(mesh)

shape = code_aster.CrackShape()
rayon = 250.
shape.setEllipseCrackShape(rayon, rayon, [0., 0., 0.], [1., 0., 0.], [0., 1. , 0.], "IN")

crack.setCrackShape(shape)
crack.build()
test.assertEqual( crack.getType(), "FISS_XFEM" )

# New xfem model
xmodel=crack.enrichModelWithXfem(model)

# Tests
normalLevelSet=crack.getNormalLevelSetField()
test.assertAlmostEqual(normalLevelSet[0],-50.)
test.assertAlmostEqual(normalLevelSet[10000],-16.6666666666667)
test.assertAlmostEqual(normalLevelSet[20000],33.3333333333333)

tangentialLevelSet=crack.getTangentialLevelSetField()
test.assertAlmostEqual(tangentialLevelSet[0],457.10678118654755)
test.assertAlmostEqual(tangentialLevelSet[1000],36.744175568087485)
test.assertAlmostEqual(tangentialLevelSet[10000],64.4660377352206)

test.printSummary()

code_aster.close()
