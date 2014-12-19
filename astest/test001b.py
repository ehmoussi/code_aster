#!/usr/bin/python

import code_aster

acier = code_aster.Material()
tmp = code_aster.ElasticMaterialBehaviour()
tmp.setDoubleValue( "E", 2.e11 )
tmp.setDoubleValue( "Nu", 0.3 )

acier.addMaterialBehaviour( tmp )
acier.build()
acier.debugPrint( 8 )

# Creation du maillage
monMaillage = code_aster.Mesh()

# Relecture du fichier MED
monMaillage.readMEDFile( "test001a.mmed" )
monMaillage.debugPrint( 8 )

affectMat = code_aster.MaterialOnMesh()
affectMat.setSupportMesh( monMaillage )

affectMat.addMaterialOnAllMesh( acier )
affectMat.addMaterialOnGroupOfElements( acier, "Tout" )
affectMat.build()
affectMat.debugPrint( 8 )
