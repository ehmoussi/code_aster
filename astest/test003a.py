#!/usr/bin/python
# -*- coding: utf-8 -*-

# Test inspiré de zzzz255a

import code_aster
import numpy as np

code_aster.init()

test=code_aster.TestCase()

# Creation of the mesh
mesh = code_aster.Mesh.create()
mesh.readMedFile("zzzz255a.mmed")

# Creation of the model
model = code_aster.Model.create()
model.setSupportMesh(mesh)
model.addModelingOnGroupOfElements(code_aster.Physics.Mechanics,
                                   code_aster.Modelings.Tridimensional,"ALL")
model.build()

# Creation of the crack
crack = code_aster.XfemCrack.create(mesh)

shape = code_aster.CrackShape.create()
rayon = 250.
shape.setEllipseCrackShape(rayon, rayon, [0., 0., 0.], [1., 0., 0.], [0., 1. , 0.], "IN")

crack.setCrackShape(shape)
crack.build()
test.assertEqual( crack.getType(), "FISS_XFEM" )

"""
FIXME: enrichWithXfem does not exist!!
# New xfem model
xmodel = model.enrichWithXfem(crack)
"""

# Tests
normalLevelSet=crack.getNormalLevelSetField()
test.assertAlmostEqual(normalLevelSet[0],-50.)
test.assertAlmostEqual(normalLevelSet[10000],-16.6666666666667)
test.assertAlmostEqual(normalLevelSet[20000],33.3333333333333)

tangentialLevelSet=crack.getTangentialLevelSetField()
test.assertAlmostEqual(tangentialLevelSet[0],457.10678118654755)
test.assertAlmostEqual(tangentialLevelSet[1000],36.744175568087485)
test.assertAlmostEqual(tangentialLevelSet[10000],64.4660377352206)
