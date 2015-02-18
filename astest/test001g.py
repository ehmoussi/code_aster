#!/usr/bin/python
# -*- coding: ISO-8859-1 -*-

import code_aster

# Définition d'une force

traction=code_aster.ForceDouble()
# Affecter composantes/valeurs
traction.setValue(code_aster.Fx, 1.0 )
traction.setValue(code_aster.Fy, 2.0 )
traction.setValue(code_aster.Fz, 3.0 )

# Mauvaise composante 
try:
    traction.setValue(code_aster.Dx, 0.0 )
except:
    print "Dx n'est pas une composante de FORC_R ! "
    
# Affichage
traction.debugPrint()

# On change la valeur d'une composante
traction.setValue(code_aster.Fy, 4.0 )
# Affichage
traction.debugPrint()

