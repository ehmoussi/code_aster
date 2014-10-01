#!/usr/bin/python

import code_aster

# Creation du maillage
monMaillage = code_aster.Mesh()

# Relecture du fichier MED
monMaillage.readMEDFile("test001a.repe")

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
monModel.addModelisation("MECANIQUE", "3D")

monModel.build()
