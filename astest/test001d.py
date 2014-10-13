#!/usr/bin/python
# -*- coding: utf-8 -*-

import code_aster

# Creation du maillage
monMaillage = code_aster.Mesh()

# Relecture du fichier MED
monMaillage.readMEDFile("test001d")

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

# Definition des chargements
print "Initialisation de CharMeca"
monCharMeca = code_aster.MechanicalLoad()
print "Définition du modèle support"
monCharMeca.setSupportModel(monModel)
print "Définition du déplacement imposé sur BOTTOM"
monCharMeca.addDisplacementLoad("DX",0.0, "BOTTOM")
print "Définition de la pression imposée sur UP"
monCharMeca.addPressure(1000.,"UP")
print "Appel de la construction (build) du chargement mécanique (affe_char_meca)"
monCharMeca.build()

print "Fin"
