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
monModel.addModelingOnAllMesh(code_aster.Mechanics, code_aster.Tridimensional)

monModel.build()

# Definition du modele Aster
monModel2 = code_aster.Model()
monModel2.setSupportMesh(monMaillage)
try:
    monModel2.addElementaryModeling(code_aster.Thermal, code_aster.DKT)
except Exception as e:
    print e
