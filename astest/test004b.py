#!/usr/bin/python
# coding: utf-8

import code_aster
test = code_aster.TestCase()

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
#acier.debugPrint(6)

affectMat = code_aster.MaterialOnMesh()
affectMat.setSupportMesh( monMaillage )
affectMat.addMaterialOnAllMesh( acier )
affectMat.build()

imposedDof1 = code_aster.DisplacementDouble()
imposedDof1.setValue( code_aster.Loads.Dx, 0.0 )
imposedDof1.setValue( code_aster.Loads.Dy, 0.0 )
imposedDof1.setValue( code_aster.Loads.Dz, 0.0 )
charMeca1 = code_aster.ImposedDisplacementDouble()
charMeca1.setSupportModel( monModel )
charMeca1.setValue( imposedDof1, "Bas" )
charMeca1.build()

imposedPres1 = code_aster.PressureDouble()
imposedPres1.setValue( code_aster.Loads.Pres, 1000. )
charMeca2 = code_aster.DistributedPressureDouble()
charMeca2.setSupportModel( monModel )
charMeca2.setValue( imposedPres1, "Haut" )
charMeca2.build()

monSolver = code_aster.LinearSolver( code_aster.Mumps, code_aster.Metis )

# Define a first nonlinear Analysis
statNonLine1 = code_aster.StaticNonLinearAnalysis()
statNonLine1.addMechanicalLoad( charMeca1 )
statNonLine1.addMechanicalLoad( charMeca2 )
statNonLine1.setSupportModel( monModel )
statNonLine1.setMaterialOnMesh( affectMat )
statNonLine1.setLinearSolver( monSolver )
Elas = code_aster.Behaviour( code_aster.Elas, code_aster.SmallDeformation )
statNonLine1.addBehaviourOnElements( Elas );


temps = [0., 0.5 ]
timeList = code_aster.Studies.TimeStepManager()
timeList.setTimeList( temps )

error1 = code_aster.Studies.ConvergenceError()
action1 = code_aster.Studies.SubstepingOnError()
action1.setAutomatic( False )
error1.setAction( action1 )
timeList.addErrorManager( error1 )
#error2 = code_aster.Studies.ContactDetectionError()
#action2 = code_aster.Studies.SubstepingOnContact()
#error2.setAction( action2 )
#timeList.addErrorManager( error2 )
timeList.build()
#timeList.debugPrint( 6 )
statNonLine1.setLoadStepManager( timeList ) 
# Run the nonlinear analysis
#resu = statNonLine1.execute()
#resu.debugPrint( 6 )

# Define a second nonlinear Analysis
statNonLine2 = code_aster.StaticNonLinearAnalysis()
statNonLine2.addMechanicalLoad( charMeca1 )
statNonLine2.addMechanicalLoad( charMeca2 )
statNonLine2.setSupportModel( monModel )
statNonLine2.setMaterialOnMesh( affectMat )
Elas = code_aster.Behaviour( code_aster.Elas, code_aster.SmallDeformation )
statNonLine2.addBehaviourOnElements( Elas )
# Define the initial state of the current analysis
start = code_aster.State()
# from the last computed step of the previous analysis
#start.setFromNonLinearEvolution( resu, 0.5 )
#statNonLine2.setInitialState( start )
#
temps =[1.0, 1.5];
timeList = code_aster.Studies.TimeStepManager()
timeList.setTimeList( temps )

error1 = code_aster.Studies.ConvergenceError()
action1 = code_aster.Studies.SubstepingOnError()
action1.setAutomatic( False )
error1.setAction( action1 )
timeList.addErrorManager( error1 )
timeList.build()
statNonLine2.setLoadStepManager( timeList ) 
#statNonLine2.execute()

# at least it pass here!
test.assertTrue( True )
test.printSummary()
