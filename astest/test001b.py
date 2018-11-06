#!/usr/bin/python

import code_aster
from code_aster.Commands import *
code_aster.init()

test = code_aster.TestCase()

acier = code_aster.Material()

acier = DEFI_MATERIAU(ELAS = _F(E = 2.e11,
                               NU = 0.3,),)
acier.debugPrint( 8 )

# Creation du maillage
monMaillage = code_aster.Mesh()

# Relecture du fichier MED
monMaillage.readMedFile( "test001a.mmed" )
monMaillage.debugPrint( 8 )

affectMat = code_aster.MaterialOnMesh(monMaillage)

affectMat.addMaterialOnAllMesh( acier )
affectMat.addMaterialOnGroupOfElements( acier, ["Tout"] )
affectMat.buildWithoutInputVariables()
affectMat.debugPrint( 8 )

# just check it pass here!
test.assertTrue( True )
test.printSummary()
