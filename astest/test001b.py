#!/usr/bin/python

import code_aster
code_aster.init()

test = code_aster.TestCase()

acier = code_aster.Material()
elas = code_aster.ElasMaterialBehaviour()
elas.setDoubleValue( "E", 2.e11 )
elas.setDoubleValue( "Nu", 0.3 )

acier.addMaterialBehaviour( elas )
acier.build()
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
