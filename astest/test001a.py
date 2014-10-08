#!/usr/bin/python

import code_aster

# Creation du maillage
monMaillage = code_aster.Mesh()

# Relecture du fichier MED
monMaillage.readMEDFile("test001a")

#help(monMaillage)

coord = monMaillage.getCoordinates()

#help(coord)

# Acces uniquement en lecture verifie !
print "coord[3] ",coord[3]

try:
    coord[3] = 5.0
except:
    print "coord is read-only"

# Manipulation sur les entites du maillage
monMaillage.getGroupOfNodes("A")

# Exception si le groupe n'existe pas
try:
    monMaillage.getGroupOfNodes("RIEN")
except Exception as e:
    print e

# Definition du modele Aster
monModel = code_aster.Model()
monModel.setSupportMesh(monMaillage)
monModel.addElementaryModelisation(code_aster.Mechanics, code_aster.Tridimensional)

monModel.build()

# Definition du modele Aster
monModel2 = code_aster.Model()
monModel2.setSupportMesh(monMaillage)
try:
    monModel2.addElementaryModelisation(code_aster.Thermal, code_aster.DKT)
except Exception as e:
    print e
