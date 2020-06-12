# coding: utf-8

import code_aster

code_aster.init()

test = code_aster.TestCase()

# Définition d'une force

traction=code_aster.ForceReal()
# Affecter composantes/valeurs
traction.setValue(code_aster.PhysicalQuantityComponent.Fx, 1.0 )
traction.setValue(code_aster.PhysicalQuantityComponent.Fy, 2.0 )
traction.setValue(code_aster.PhysicalQuantityComponent.Fz, 3.0 )

# Mauvaise composante
# Dx n'est pas une composante de FORC_R !
with test.assertRaisesRegex( RuntimeError, "component is not allowed"):
    traction.setValue(code_aster.PhysicalQuantityComponent.Dx, 0.0 )

# Affichage
traction.debugPrint()

# On change la valeur d'une composante
traction.setValue(code_aster.PhysicalQuantityComponent.Fy, 4.0 )
# Affichage
traction.debugPrint()

test.printSummary()

code_aster.close()
