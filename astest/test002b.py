#!/usr/bin/python

import code_aster

monMaillage = code_aster.Mesh()
monMaillage.readMedFile( "test001f.mmed" )

monModel = code_aster.Model()
monModel.setSupportMesh( monMaillage )
monModel.addModelingOnAllMesh( code_aster.Mechanics, code_aster.Tridimensional )
monModel.build()

YOUNG = 200000.0;
POISSON = 0.3;

materElas = code_aster.MaterialBehaviour.ElasMaterialBehaviour()
materElas.setDoubleValue( "E", YOUNG )
materElas.setDoubleValue( "Nu", POISSON )

acier = code_aster.Material()
acier.addMaterialBehaviour( materElas )
acier.build()
acier.debugPrint(6)

affectMat = code_aster.MaterialOnMesh()
affectMat.setSupportMesh( monMaillage )
affectMat.addMaterialOnAllMesh( acier )
affectMat.build()

imposedDof1 = code_aster.DisplacementDouble()
imposedDof1.setValue( code_aster.Loads.Dx, 0.0 )
imposedDof1.setValue( code_aster.Loads.Dy, 0.0 )
imposedDof1.setValue( code_aster.Loads.Dz, 0.0 )
CharMeca1 = code_aster.ImposedDisplacementDouble()
CharMeca1.setSupportModel( monModel )
CharMeca1.setValue( imposedDof1, "Bas" )
CharMeca1.build()

imposedPres1 = code_aster.PressureDouble()
imposedPres1.setValue( code_aster.Loads.Pres, 1000. )
CharMeca2 = code_aster.DistributedPressureDouble()
CharMeca2.setSupportModel( monModel )
CharMeca2.setValue( imposedPres1, "Haut" )
CharMeca2.build()

solverLin = code_aster.LinearSolver( code_aster.Mumps, code_aster.Metis )
methodeNL = code_aster.NonLinearMethod( "NEWTON" )
methodeNL.setLinearSolver(solverLin)


statNonLine = code_aster.StaticNonLinearSolver()
statNonLine.addMechanicalLoad( CharMeca1 )
statNonLine.addMechanicalLoad( CharMeca2 )
statNonLine.setSupportModel( monModel )
statNonLine.setMaterialOnMesh( affectMat )
statNonLine.setNonLinearMethod( methodeNL )
# Ne marche pas encore 
#resu = statNonLine.execute_op70()
# print " Fin de test002d   ", resu
