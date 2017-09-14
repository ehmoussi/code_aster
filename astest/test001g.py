#!/usr/bin/python
# coding: utf-8

import code_aster
test = code_aster.TestCase()

# Définition d'une force

traction=code_aster.ForceDouble.create()
# Affecter composantes/valeurs
traction.setValue(code_aster.Loads.Fx, 1.0 )
traction.setValue(code_aster.Loads.Fy, 2.0 )
traction.setValue(code_aster.Loads.Fz, 3.0 )

# Mauvaise composante
# Dx n'est pas une composante de FORC_R !
with test.assertRaisesRegexp( RuntimeError, "component is not allowed"):
    traction.setValue(code_aster.Loads.Dx, 0.0 )

# Affichage
traction.debugPrint()

# On change la valeur d'une composante
traction.setValue(code_aster.Loads.Fy, 4.0 )
# Affichage
traction.debugPrint()

test.printSummary()
