# coding: utf-8

import code_aster
from code_aster import AsterError
code_aster.init()

test = code_aster.TestCase()

# Creation du maillage
monMaillage = code_aster.Mesh()

# Relecture du fichier MED
monMaillage.readMedFile("test001d.mmed")

# Definition du modele Aster
monModel = code_aster.Model()
monModel.setMesh(monMaillage)
monModel.addModelingOnAllMesh(code_aster.Physics.Mechanics, code_aster.Modelings.Tridimensional)
monModel.build()

# Definition d'un chargement de type FORCE_NODALE à partir d'une ForceReal
force = code_aster.ForceReal()
force.setValue( code_aster.PhysicalQuantityComponent.Fz, 100.0 )

print(" >>>> Construction d'un chargement NodalForceReal")
CharMeca1 = code_aster.NodalForceReal(monModel)
# On ne peut pas imposer une force nodale sur un groupe de mailles
with test.assertRaises( RuntimeError ):
    CharMeca1.setValue( force, "UP" )


nameOfGroup = "A"
CharMeca1.setValue( force, nameOfGroup )
print("      sur le groupe : ", nameOfGroup)
ret = CharMeca1.build()
#CharMeca1.debugPrint()
test.assertTrue( ret )

# Definition d'un chargement de type FORCE_NODALE à partir d'un StructuralForceReal

force_pour_structure = code_aster.StructuralForceReal()
force_pour_structure.setValue( code_aster.PhysicalQuantityComponent.Mx, 10.0 )
force_pour_structure.setValue( code_aster.PhysicalQuantityComponent.My, 20.0 )
force_pour_structure.setValue( code_aster.PhysicalQuantityComponent.Mz, 30.0 )

print(" >>>> Construction d'un chargement NodalStructuralForceReal")
print("      Ce chargement est correct pour le catalogue mais conduit à une erreur Fortran ")
CharMeca2 = code_aster.NodalStructuralForceReal(monModel)
nameOfGroup = "B"
CharMeca2.setValue( force_pour_structure, nameOfGroup )
print("      sur le groupe : ", nameOfGroup)

# Le Dl MX n'est pas autorisé
# fortran error
with test.assertRaises( AsterError ):
    CharMeca2.build()

#CharMeca2.debugPrint()

# Definition d'un chargement de type FORCE_FACE à partir d'un ForceReal
print(" >>>> Construction d'un chargement ForceOnFaceReal")

CharMeca3 = code_aster.ForceOnFaceReal(monModel)
nameOfGroup = "UP"
CharMeca3.setValue( force, nameOfGroup )
print("      sur le groupe : ", nameOfGroup)
ret = CharMeca3.build()
test.assertTrue( ret )


# Definition d'un chargement de type FORCE_ARETE à partir d'un ForceReal
print(" >>>> Construction d'un chargement ForceOnEdgeReal")
CharMeca4 = code_aster.ForceOnEdgeReal(monModel)
nameOfGroup = "UP"
CharMeca4.setValue( force, nameOfGroup )
print("      sur le groupe : ", nameOfGroup)
ret = CharMeca4.build()
test.assertTrue( ret )

# Definition d'un chargement de type FORCE_ARETE à partir d'un StructuralForceReal
print(" >>>> Construction d'un chargement StructuralForceOnEdgeReal")
# C'est bizarre, on entre un groupe qui est une face et le fortran ne détecte rien !
CharMeca5 = code_aster.StructuralForceOnEdgeReal(monModel)
nameOfGroup = "UP"
CharMeca5.setValue( force_pour_structure, nameOfGroup )
print("      sur le groupe : ", nameOfGroup)
ret = CharMeca5.build()
test.assertTrue( ret )

# Definition d'un chargement de type FORCE_CONTOUR à partir d'un ForceReal
print(" >>>> Construction d'un chargement LineicForceReal")

CharMeca6 = code_aster.LineicForceReal(monModel)
nameOfGroup = "BOTTOM"
CharMeca6.setValue( force, nameOfGroup )
print("      sur le groupe : ", nameOfGroup)
ret = CharMeca6.build()
test.assertTrue( ret )

# Definition d'un chargement de type FORCE_INTERNE à partir d'un ForceReal
print(" >>>> Construction d'un chargement InternalForceReal")

CharMeca7 = code_aster.InternalForceReal(monModel)
nameOfGroup = "BOTTOM"
CharMeca7.setValue( force, nameOfGroup )
print("      sur le groupe : ", nameOfGroup)
ret = CharMeca7.build()
test.assertTrue( ret )

# Definition d'un chargement de type FORCE_POUTRE à partir d'un StructuralForceReal
print(" >>>> Construction d'un chargement StructuralForceOnBeamReal")

CharMeca8 = code_aster.StructuralForceOnBeamReal(monModel)
nameOfGroup = "OA"
CharMeca8.setValue( force_pour_structure, nameOfGroup )
print("      sur le groupe : ", nameOfGroup)
ret = CharMeca8.build()
test.assertTrue( ret )

# Definition d'un chargement de type FORCE_POUTRE à partir d'un LocalBeamForceReal
print(" >>>> Construction d'un chargement LocalForceOnBeamReal")

fpoutre = code_aster.LocalBeamForceReal()
fpoutre.setValue(code_aster.PhysicalQuantityComponent.N, 5.0)

CharMeca9 = code_aster.LocalForceOnBeamReal(monModel)
nameOfGroup = "BOTTOM"
CharMeca9.setValue( fpoutre, nameOfGroup )
print("      sur le groupe : ", nameOfGroup)
ret = CharMeca9.build()
test.assertTrue( ret )

# Definition d'un chargement de type FORCE_COQUE à partir d'un StructuralForceReal
print(" >>>> Construction d'un chargement StructuralForceOnShellReal")

CharMeca10 = code_aster.StructuralForceOnShellReal(monModel)
nameOfGroup = "UP"
CharMeca10.setValue( force_pour_structure, nameOfGroup )
print("      sur le groupe : ", nameOfGroup)
ret = CharMeca10.build()
test.assertTrue( ret )

# Definition d'un chargement de type FORCE_COQUE à partir d'un LocalShellForceReal
print(" >>>> Construction d'un chargement LocalForceOnShellReal")

fshell = code_aster.LocalShellForceReal()
fshell.setValue(code_aster.PhysicalQuantityComponent.F1, 11.0)
fshell.setValue(code_aster.PhysicalQuantityComponent.F2, 12.0)
fshell.setValue(code_aster.PhysicalQuantityComponent.F3, 13.0)

CharMeca11 = code_aster.LocalForceOnShellReal(monModel)
nameOfGroup = "UP"
CharMeca11.setValue( fshell, nameOfGroup )
print("      sur le groupe : ", nameOfGroup)
ret = CharMeca11.build()
test.assertTrue( ret )

# Definition d'un chargement de type FORCE_COQUE à partir d'une PressureReal
print(" >>>> Construction d'un chargement PressureOnShellReal")

pression = code_aster.PressureReal()
pression.setValue(code_aster.PhysicalQuantityComponent.Pres, 14.0)

CharMeca12 = code_aster.PressureOnShellReal(monModel)
nameOfGroup = "UP"
CharMeca12.setValue( pression, nameOfGroup )
print("      sur le groupe : ", nameOfGroup)
ret = CharMeca12.build()
test.assertTrue( ret )

# Imposer une PressureReal sur un groupe de noeuds
print(" >>>> Construction d'un chargement ImposedPressureReal")
CharMeca13 = code_aster.ImposedPressureReal(monModel)
nameOfGroup = "O"
CharMeca13.setValue( pression, nameOfGroup )
print("      sur le groupe : ", nameOfGroup)
# fortran error
with test.assertRaises( AsterError ):
    CharMeca13.build()

test.printSummary()

code_aster.close()
