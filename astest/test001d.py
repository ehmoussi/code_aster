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

# Definition d'un chargement de type FORCE_NODALE à partir d'une ForceDouble

traction=code_aster.ForceDouble()
traction.setValue( code_aster.Loads.Fz, 100.0 )

print " >>>> Construction d'un chargement NodalForceDouble"
CharMeca1 = code_aster.NodalForceDouble()
CharMeca1.setSupportModel(monModel)
try:
    CharMeca1.setValue( traction, "UP" )
except:
    print " On ne peut pas imposer une force nodale sur un groupe de mailles "

try:
    CharMeca1.setValue( traction )
except:
    print " On ne peut pas imposer une force nodale sur tout le maillage "

CharMeca1.setValue( traction, "A" )
ret=CharMeca1.build()
#CharMeca1.debugPrint()
print " Fin de la construction : ", ret 

# Definition d'un chargement de type FORCE_NODALE à partir d'un ForceAndMomentumDouble

moment=code_aster.ForceAndMomentumDouble()
moment.setValue( code_aster.Loads.Mx, 10.0 )
moment.setValue( code_aster.Loads.My, 20.0 )
moment.setValue( code_aster.Loads.Mz, 30.0 )

print " >>>> Construction d'un chargement NodalForceAndMomentumDouble"
print "      Ce chargement est correct pour le catalogue mais conduit à une erreur Fortran "
CharMeca2 = code_aster.NodalForceAndMomentumDouble()
CharMeca2.setSupportModel(monModel)
CharMeca2.setValue( moment, "B" )
try:
    ret = CharMeca2.build()
except:
    " Le Dl MX n'est pas autorisé (erreur Fortran) "

#CharMeca2.debugPrint()
print "Fin"
