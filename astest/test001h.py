# coding: utf-8

"""
Identical to test001a except that it calls legacy commands DEBUT/POURSUITE/FIN
to check the restarting of a computation.
"""

import code_aster
from code_aster.Commands import *

DEBUT()

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
model = code_aster.Model()
test.assertEqual(model.getType(), "MODELE_SDASTER")
model.setMesh(mesh)
model.addModelingOnAllMesh(
    code_aster.Physics.Mechanics, code_aster.Modelings.Tridimensional)

model.setSplittingMethod(code_aster.ModelSplitingMethod.GroupOfElements)
test.assertEqual(model.getSplittingMethod(),
                 code_aster.ModelSplitingMethod.GroupOfElements)

model.setSplittingMethod(code_aster.ModelSplitingMethod.Centralized)
test.assertEqual(model.getSplittingMethod(),
                 code_aster.ModelSplitingMethod.Centralized)

model.build()

# Definition du modele Aster
model2 = code_aster.Model()
model2.setMesh(mesh)

with test.assertRaisesRegex(RuntimeError, 'not allowed'):
    model2.addModelingOnAllMesh(
        code_aster.Physics.Thermal, code_aster.Modelings.DKT)

# Verification du comptage de référence sur le maillage
del mesh

with test.assertRaises(NameError):
    mesh

mesh2 = model.getMesh()
test.assertTrue(mesh2.hasGroupOfElements('Tout'))

# Vérification du debug
mesh2.debugPrint(66)

del coord
code_aster.saveObjects()

test.printSummary()

FIN()
