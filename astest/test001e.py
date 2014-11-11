#!/usr/bin/python

import code_aster

# Creation du maillage
monMaillage = code_aster.Mesh()

# Relecture du fichier MED
monMaillage.readMEDFile("test001a.mmed")

#help(monMaillage)

coord = monMaillage.getCoordinates()

#help(coord)

# Acces uniquement en lecture verifie !
print "coord[3] ",coord[3]

try:
    coord[3] = 5.0
except:
    print "coord is read-only"

# Definition du modele Aster
monModel = code_aster.Model()
monModel.setSupportMesh(monMaillage)
monModel.addModelisationOnAllMesh(code_aster.Mechanics, code_aster.Tridimensional)

monModel.build()

charCine = code_aster.KinematicsLoad()
charCine.setSupportModel(monModel)
charCine.addImposedMechanicalDOFOnElements(code_aster.Dx, 0., "Bas")
try:
    charCine.addImposedMechanicalDOFOnElements(code_aster.Temperature, 0., "Haut")
except:
    print "Impossible d'affecter un blocage en temperature sur un DEPL"

charCine.build()
