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

nameOfGroup = "A"
CharMeca1.setValue( traction, nameOfGroup )
print "     sur le groupe : ", nameOfGroup
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
nameOfGroup = "B"
CharMeca2.setValue( moment, nameOfGroup )
print "     sur le groupe : ", nameOfGroup
try:
    ret = CharMeca2.build()
except:
    " Le Dl MX n'est pas autorisé (erreur Fortran) "

#CharMeca2.debugPrint()

# Definition d'un chargement de type FORCE_FACE à partir d'un ForceDouble
print " >>>> Construction d'un chargement ForceOnFaceDouble"

CharMeca3 = code_aster.ForceOnFaceDouble()
CharMeca3.setSupportModel(monModel)
nameOfGroup = "UP"
CharMeca3.setValue( traction, nameOfGroup )
print "     sur le groupe : ", nameOfGroup
ret = CharMeca3.build()
print " Fin de la construction : ", ret 

# Definition d'un chargement de type FORCE_ARETE à partir d'un ForceAndMomentumDouble
print " >>>> Construction d'un chargement ForceAndMomentumOnEdgeDouble"
# C'est bizarre, on entre un groupe qui est une face et le fortran ne détecte rien !
CharMeca4 = code_aster.ForceAndMomentumOnEdgeDouble()
CharMeca4.setSupportModel(monModel)
nameOfGroup = "UP"
CharMeca4.setValue( moment, nameOfGroup )
print "     sur le groupe : ", nameOfGroup
ret = CharMeca4.build()
print " Fin de la construction : ", ret 

# Definition d'un chargement de type FORCE_CONTOUR à partir d'un ForceAndMomentumDouble
print " >>>> Construction d'un chargement LineicForceAndMomentumDouble"

CharMeca5 = code_aster.LineicForceAndMomentumDouble()
CharMeca5.setSupportModel(monModel)
nameOfGroup = "BOTTOM" 
CharMeca5.setValue( moment, nameOfGroup )
print "     sur le groupe : ", nameOfGroup
ret = CharMeca5.build()
print " Fin de la construction : ", ret 

# Definition d'un chargement de type FORCE_INTERNE à partir d'un ForceDouble
print " >>>> Construction d'un chargement InternalForceDouble"

CharMeca6 = code_aster.InternalForceDouble()
CharMeca6.setSupportModel(monModel)
nameOfGroup = "BOTTOM" 
CharMeca6.setValue( traction, nameOfGroup )
print "     sur le groupe : ", nameOfGroup
ret = CharMeca6.build()
print " Fin de la construction : ", ret 
print "Fin"
