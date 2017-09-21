#!/usr/bin/python
# coding: utf-8

import code_aster
test = code_aster.TestCase()

monMaillage = code_aster.Mesh.create()
monMaillage.readMedFile( "test001f.mmed" )

monModel = code_aster.Model.create()
monModel.setSupportMesh( monMaillage )
monModel.addModelingOnAllMesh( code_aster.Physics.Mechanics, code_aster.Modelings.Tridimensional )
monModel.build()

YOUNG = 200000.0;
POISSON = 0.3;

materElas = code_aster.ElasMaterialBehaviour.create()
materElas.setDoubleValue( "E", YOUNG )
materElas.setDoubleValue( "Nu", POISSON )

acier = code_aster.Material.create()
acier.addMaterialBehaviour(materElas)
acier.build()
acier.debugPrint(6)

affectMat = code_aster.MaterialOnMesh.create(monMaillage)
affectMat.addMaterialOnAllMesh( acier )
affectMat.build()

charMeca1 = code_aster.KinematicsLoad.create()
charMeca1.setSupportModel(monModel)
charMeca1.addImposedMechanicalDOFOnNodes(code_aster.PhysicalQuantityComponent.Dx, 0., "Bas")
charMeca1.addImposedMechanicalDOFOnNodes(code_aster.PhysicalQuantityComponent.Dy, 0., "Bas")
charMeca1.addImposedMechanicalDOFOnNodes(code_aster.PhysicalQuantityComponent.Dz, 0., "Bas")
charMeca1.build()

imposedPres1 = code_aster.PressureDouble.create()
imposedPres1.setValue( code_aster.PhysicalQuantityComponent.Pres, 1000. )
charMeca2 = code_aster.DistributedPressureDouble.create(monModel)
charMeca2.setValue( imposedPres1, "Haut" )
charMeca2.build()

# Define the nonlinear method that will be used
#monSolver = code_aster.MumpsSolver.create(code_aster.Renumbering.Metis)
monSolver = code_aster.PetscSolver.create( code_aster.Renumbering.Sans )
monSolver.setPreconditioning(code_aster.Preconditioning.Ml)
lineSearch = code_aster.LineSearchMethod.create(code_aster.LineSearchEnum.Corde )

# Define a nonlinear Analysis
statNonLine = code_aster.StaticNonLinearAnalysis.create()
statNonLine.addStandardExcitation( charMeca1 )
statNonLine.addStandardExcitation( charMeca2 )
statNonLine.setSupportModel( monModel )
statNonLine.setMaterialOnMesh( affectMat )
statNonLine.setLinearSolver( monSolver )
#statNonLine.setLineSearchMethod( lineSearch )
#Elas = code_aster.Behaviour( code_aster.Elas, code_aster.SmallStrain )
#Elas = code_aster.Behaviour();
#statNonLine.addBehaviourOnElements( Elas );

temps = [0., 0.5, 1.]
timeList = code_aster.TimeStepManager.create()
timeList.setTimeList( temps )

error1 = code_aster.ConvergenceError.create()
action1 = code_aster.SubstepingOnError.create()
action1.setAutomatic( False )
error1.setAction( action1 )
timeList.addErrorManager( error1 )
#error2 = code_aster.Studies.ContactDetectionError()
#action2 = code_aster.Studies.SubstepingOnContact()
#error2.setAction( action2 )
#timeList.addErrorManager( error2 )
timeList.build()
#timeList.debugPrint( 6 )
statNonLine.setLoadStepManager( timeList )
# Run the nonlinear analysis
resu = statNonLine.execute()
#resu.debugPrint( 6 )
a=resu.getRealFieldOnElements('SIEF_ELGA',1)
#z=a.EXTR_COMP()
# at least it pass here!
test.assertTrue( True )
test.printSummary()
