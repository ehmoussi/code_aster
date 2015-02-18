#!/usr/bin/python
# -*- coding: utf-8 -*-

import code_aster

# Creation du maillage
monMaillage = code_aster.Mesh()

# Relecture du fichier MED
monMaillage.readMedFile("test001d.mmed")

# Definition du modele Aster
monModel = code_aster.Model()
monModel.setSupportMesh(monMaillage)
monModel.addModelingOnAllMesh(code_aster.Mechanics, code_aster.Tridimensional)
monModel.build()

# Definition des chargements
traction=code_aster.ForceDouble()
traction.setValue( code_aster.Loads.Fz,100.0 )


monCharMeca = code_aster.NodalForceDouble()
monCharMeca.setSupportModel(monModel)
try:
    monCharMeca.setQuantityOnMeshEntity( traction, "UP" )
except:
    print " On ne peut pas imposer une force nodale sur un groupe de mailles "

monCharMeca.setQuantityOnMeshEntity( traction, "A" )

print "Appel de la construction (build) du chargement mécanique (affe_char_meca)"
#monCharMeca.build()
#monCharMeca.debugPrint()
print "Fin"
