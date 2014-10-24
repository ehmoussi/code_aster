#!/usr/bin/python

import code_aster

# Creation du maillage, objet "0       "
monMaillage = code_aster.Mesh()

# Relecture du fichier MED
monMaillage.readMEDFile("test001e")

# Definition du modele Aster, objet "1       "
monModel = code_aster.Model()
monModel.setSupportMesh(monMaillage)
monModel.addModelisationOnAllMesh(code_aster.Mechanics, code_aster.Tridimensional)

monModel.build()

# Chargement cinematique, objet "2       "
charCine = code_aster.KinematicsLoad()
charCine.setSupportModel(monModel)
charCine.addImposedMechanicalDOFOnElements(code_aster.Dx, 0., "Bas")

charCine.build()

# Materiau, objet "3       "
acier = code_aster.Material()
tmp = code_aster.ElasticMaterialBehaviour()
tmp.setDoubleValue( "E", 2.e11 )
tmp.setDoubleValue( "Nu", 0.3 )

acier.addMaterialBehaviour( tmp )
acier.build()

# Champ de materiau, objet "4       "
affectMat = code_aster.AllocatedMaterial()
affectMat.setSupportMesh( monMaillage )
affectMat.addMaterialOnAllMesh( acier )
affectMat.build()

# Matrice elementaire, objet "5       "
matr_elem = code_aster.ElementaryMatrix()
matr_elem.setSupportModel( monModel )
matr_elem.setAllocatedMaterial( affectMat )
matr_elem.computeMechanicalRigidity()
matr_elem.debugPrint( 8 )
