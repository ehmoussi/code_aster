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

force=code_aster.ForceDouble()
force.setValue( code_aster.Loads.Fz, 100.0 )

print " >>>> Construction d'un chargement NodalForceDouble"
CharMeca1 = code_aster.NodalForceDouble()
CharMeca1.setSupportModel(monModel)
try:
    CharMeca1.setValue( force, "UP" )
except:
    print " On ne peut pas imposer une force nodale sur un groupe de mailles "

try:
    CharMeca1.setValue( force )
except:
    print " On ne peut pas imposer une force nodale sur tout le maillage "

nameOfGroup = "A"
CharMeca1.setValue( force, nameOfGroup )
print "     sur le groupe : ", nameOfGroup
ret=CharMeca1.build()
#CharMeca1.debugPrint()
print " Fin de la construction : ", ret 

# Definition d'un chargement de type FORCE_NODALE à partir d'un StructuralForceDouble

force_pour_structure=code_aster.StructuralForceDouble()
force_pour_structure.setValue( code_aster.Loads.Mx, 10.0 )
force_pour_structure.setValue( code_aster.Loads.My, 20.0 )
force_pour_structure.setValue( code_aster.Loads.Mz, 30.0 )

print " >>>> Construction d'un chargement NodalStructuralForceDouble"
print "      Ce chargement est correct pour le catalogue mais conduit à une erreur Fortran "
CharMeca2 = code_aster.NodalStructuralForceDouble()
CharMeca2.setSupportModel(monModel)
nameOfGroup = "B"
CharMeca2.setValue( force_pour_structure, nameOfGroup )
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
CharMeca3.setValue( force, nameOfGroup )
print "     sur le groupe : ", nameOfGroup
ret = CharMeca3.build()
print " Fin de la construction : ", ret 


# Definition d'un chargement de type FORCE_ARETE à partir d'un ForceDouble
print " >>>> Construction d'un chargement ForceOnEdgeDouble"
CharMeca4 = code_aster.ForceOnEdgeDouble()
CharMeca4.setSupportModel(monModel)
nameOfGroup = "UP"
CharMeca4.setValue( force, nameOfGroup )
print "     sur le groupe : ", nameOfGroup
ret = CharMeca4.build()
print " Fin de la construction : ", ret
 
# Definition d'un chargement de type FORCE_ARETE à partir d'un StructuralForceDouble
print " >>>> Construction d'un chargement StructuralForceOnEdgeDouble"
# C'est bizarre, on entre un groupe qui est une face et le fortran ne détecte rien !
CharMeca5 = code_aster.StructuralForceOnEdgeDouble()
CharMeca5.setSupportModel(monModel)
nameOfGroup = "UP"
CharMeca5.setValue( force_pour_structure, nameOfGroup )
print "     sur le groupe : ", nameOfGroup
ret = CharMeca5.build()
print " Fin de la construction : ", ret 

# Definition d'un chargement de type FORCE_CONTOUR à partir d'un ForceDouble
print " >>>> Construction d'un chargement LineicForceDouble"

CharMeca6 = code_aster.LineicForceDouble()
CharMeca6.setSupportModel(monModel)
nameOfGroup = "BOTTOM" 
CharMeca6.setValue( force, nameOfGroup )
print "     sur le groupe : ", nameOfGroup
ret = CharMeca6.build()
print " Fin de la construction : ", ret 

# Definition d'un chargement de type FORCE_INTERNE à partir d'un ForceDouble
print " >>>> Construction d'un chargement InternalForceDouble"

CharMeca7 = code_aster.InternalForceDouble()
CharMeca7.setSupportModel(monModel)
nameOfGroup = "BOTTOM" 
CharMeca7.setValue( force, nameOfGroup )
print "     sur le groupe : ", nameOfGroup
ret = CharMeca7.build()
print " Fin de la construction : ", ret 
print "Fin"

# Definition d'un chargement de type FORCE_POUTRE à partir d'un StructuralForceDouble
print " >>>> Construction d'un chargement StructuralForceOnBeamDouble"

CharMeca8 = code_aster.StructuralForceOnBeamDouble()
CharMeca8.setSupportModel(monModel)
nameOfGroup = "OA" 
CharMeca8.setValue( force_pour_structure, nameOfGroup )
print "     sur le groupe : ", nameOfGroup
ret = CharMeca8.build()
print " Fin de la construction : ", ret 

# Definition d'un chargement de type FORCE_POUTRE à partir d'un LocalBeamForceDouble
print " >>>> Construction d'un chargement LocalForceOnBeamDouble"

fpoutre = code_aster.LocalBeamForceDouble()
fpoutre.setValue(code_aster.Loads.N, 5.0)
 
CharMeca9 = code_aster.LocalForceOnBeamDouble()
CharMeca9.setSupportModel(monModel)
nameOfGroup = "BOTTOM" 
CharMeca9.setValue( fpoutre, nameOfGroup )
print "     sur le groupe : ", nameOfGroup
ret = CharMeca9.build()
print " Fin de la construction : ", ret 

# Definition d'un chargement de type FORCE_COQUE à partir d'un StructuralForceDouble
print " >>>> Construction d'un chargement StructuralForceOnShellDouble"

CharMeca10 = code_aster.StructuralForceOnShellDouble()
CharMeca10.setSupportModel(monModel)
nameOfGroup = "UP" 
CharMeca10.setValue( force_pour_structure, nameOfGroup )
print "     sur le groupe : ", nameOfGroup
ret = CharMeca10.build()
print " Fin de la construction : ", ret 

# Definition d'un chargement de type FORCE_COQUE à partir d'un LocalShellForceDouble
print " >>>> Construction d'un chargement LocalForceOnShellDouble"

fshell = code_aster.LocalShellForceDouble()
fshell.setValue(code_aster.Loads.F1, 11.0)
fshell.setValue(code_aster.Loads.F2, 12.0)
fshell.setValue(code_aster.Loads.F3, 13.0)
 
CharMeca11 = code_aster.LocalForceOnShellDouble()
CharMeca11.setSupportModel(monModel)
nameOfGroup = "UP" 
CharMeca11.setValue( fshell, nameOfGroup )
print "     sur le groupe : ", nameOfGroup
ret = CharMeca11.build()
print " Fin de la construction : ", ret 

# Definition d'un chargement de type FORCE_COQUE à partir d'une PressureDouble
print " >>>> Construction d'un chargement PressureOnShellDouble"

pression = code_aster.PressureDouble()
pression.setValue(code_aster.Loads.Pres, 14.0)
 
CharMeca12 = code_aster.PressureOnShellDouble()
CharMeca12.setSupportModel(monModel)
nameOfGroup = "UP" 
CharMeca12.setValue( pression, nameOfGroup )
print "     sur le groupe : ", nameOfGroup
ret = CharMeca12.build()
print " Fin de la construction : ", ret 

# Imposer une PressureDouble sur un groupe de noeuds
print " >>>> Construction d'un chargement ImposedPressureDouble"
CharMeca13 = code_aster.ImposedPressureDouble()
CharMeca13.setSupportModel(monModel)
nameOfGroup = "O" 
CharMeca13.setValue( pression, nameOfGroup )
print "     sur le groupe : ", nameOfGroup
#ret = CharMeca13.build()
#print " Fin de la construction : ", ret 
