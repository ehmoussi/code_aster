#!/usr/bin/python

import code_aster
test = code_aster.TestCase()

# Creation du maillage
monMaillage = code_aster.Mesh()

# Relecture du fichier MED
monMaillage.readMedFile("test001f.mmed")

# Definition du modele Aster
monModel = code_aster.Model()
monModel.setSupportMesh(monMaillage)
monModel.addModelingOnAllMesh(code_aster.Mechanics, code_aster.Tridimensional)

monModel.build()

charCine = code_aster.KinematicsLoad()
charCine.setSupportModel(monModel)
charCine.addImposedMechanicalDOFOnElements(code_aster.Dx, 0., "Bas")
test.assertEqual( charCine.getType(), "CHAR_CINE" )

# Impossible d'affecter un blocage en temperature sur un DEPL
with test.assertRaises( RuntimeError ):
    charCine.addImposedMechanicalDOFOnElements(code_aster.Temp, 0., "Haut")

charCine.build()
