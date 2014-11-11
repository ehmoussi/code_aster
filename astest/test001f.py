#!/usr/bin/python

import code_aster

monMaillage = code_aster.Mesh()
monMaillage.readMEDFile( "test001f.mmed" )

monModel = code_aster.Model()
monModel.setSupportMesh( monMaillage )
monModel.addModelisationOnAllMesh( code_aster.Mechanics, code_aster.Tridimensional )
monModel.build()

materElas = code_aster.ElasticMaterialBehaviour()
materElas.setDoubleValue( "E", 2.e11 )
materElas.setDoubleValue( "Nu", 0.3 )

acier = code_aster.Material()
acier.addMaterialBehaviour( materElas )
acier.build()

affectMat = code_aster.AllocatedMaterial()
affectMat.setSupportMesh( monMaillage )
affectMat.addMaterialOnAllMesh( acier )
affectMat.build()

monCharMeca1 = code_aster.MechanicalLoad()
monCharMeca1.setSupportModel( monModel )
monCharMeca1.setDisplacementOnNodes( "DX", 0.0, "Bas" )
monCharMeca1.setDisplacementOnNodes( "DY", 0.0, "Bas" )
monCharMeca1.setDisplacementOnNodes( "DZ", 0.0, "Bas" )
monCharMeca1.build()

monCharMeca2 = code_aster.MechanicalLoad()
monCharMeca2.setSupportModel( monModel )
monCharMeca2.setPressureOnElements( 1000., "Haut" )
monCharMeca2.build()

matr_elem = code_aster.ElementaryMatrix()
matr_elem.setSupportModel( monModel )
matr_elem.setAllocatedMaterial( affectMat )
matr_elem.addMechanicalLoad( monCharMeca1 )
matr_elem.addMechanicalLoad( monCharMeca2 )
matr_elem.computeMechanicalRigidity()

monSolver = code_aster.LinearSolver( code_aster.Mumps, code_aster.Metis )

numeDDL = code_aster.DOFNumerotation()
numeDDL.setElementaryMatrix( matr_elem )
numeDDL.setLinearSolver( monSolver )
numeDDL.computeNumerotation()

vectElem = code_aster.ElementaryVector()
vectElem.addMechanicalLoad( monCharMeca1 )
vectElem.addMechanicalLoad( monCharMeca2 )
vectElem.computeMechanicalLoads()

retour = vectElem.assembleVector( numeDDL )

matrAsse = code_aster.AssemblyMatrixDouble()
matrAsse.setElementaryMatrix( matr_elem )
matrAsse.setDOFNumerotation( numeDDL )
matrAsse.build()
matrAsse.factorization()

resu = monSolver.solveDoubleLinearSystem( matrAsse, retour )

resu.printMEDFormat( "test.med" )
