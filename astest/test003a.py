#!/usr/bin/python
# -*- coding: utf-8 -*-

# Test inspiré de zzzz255a

import code_aster
import numpy as np

# Creation of the mesh
mesh = code_aster.Mesh()
mesh.readMedFile("zzzz255a.mmed")

# Creation of the model
model = code_aster.Model()
model.setSupportMesh(mesh)
model.addModelingOnGroupOfElements(code_aster.Mechanics, code_aster.Tridimensional,"ALL")
model.build()

# Creation of the crack
crack = code_aster.XfemCrack(mesh)

shape = code_aster.CrackShape()
rayon = 250.
shape.setEllipseCrackShape(rayon, rayon, np.asarray((0., 0., 0.)), np.asarray((1., 0., 0. )), np.asarray((0., 1. , 0. )))

crack.setCrackShape(shape)

crack.build()

# New xfem model
xmodel = model.enrichWithXfem(crack)



