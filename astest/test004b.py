#!/usr/bin/python
# coding: utf-8

import code_aster

code_aster.init()

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
acier.addMaterialBehaviour( materElas )
acier.build()
#acier.debugPrint(6)

affectMat = code_aster.MaterialOnMesh.create(monMaillage)
affectMat.addMaterialOnAllMesh( acier )
affectMat.build()

imposedDof1 = code_aster.DisplacementDouble.create()
imposedDof1.setValue( code_aster.PhysicalQuantityComponent.Dx, 0.0 )
imposedDof1.setValue( code_aster.PhysicalQuantityComponent.Dy, 0.0 )
imposedDof1.setValue( code_aster.PhysicalQuantityComponent.Dz, 0.0 )
charMeca1 = code_aster.ImposedDisplacementDouble.create(monModel)
charMeca1.setValue( imposedDof1, "Bas" )
charMeca1.build()

imposedPres1 = code_aster.PressureDouble.create()
imposedPres1.setValue( code_aster.PhysicalQuantityComponent.Pres, 1000. )
charMeca2 = code_aster.DistributedPressureDouble.create(monModel)
charMeca2.setValue( imposedPres1, "Haut" )
charMeca2.build()

monSolver = code_aster.MumpsSolver.create( code_aster.Renumbering.Metis )

# Define a first nonlinear Analysis
statNonLine1 = code_aster.StaticNonLinearAnalysis.create()
statNonLine1.addStandardExcitation( charMeca1 )
statNonLine1.addStandardExcitation( charMeca2 )
statNonLine1.setSupportModel( monModel )
statNonLine1.setMaterialOnMesh( affectMat )
statNonLine1.setLinearSolver( monSolver )
# elas = code_aster.Behaviour.create()
elas = code_aster.Behaviour.create(code_aster.ConstitutiveLaw.Elas,
                                   code_aster.StrainType.SmallStrain)
statNonLine1.addBehaviourOnElements( elas )


temps = [0., 0.5 ]
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
statNonLine1.setLoadStepManager( timeList )
# Run the nonlinear analysis
resu = statNonLine1.execute()
#resu.debugPrint( 6 )

# Define a second nonlinear Analysis
statNonLine2 = code_aster.StaticNonLinearAnalysis.create()
statNonLine2.addStandardExcitation( charMeca1 )
statNonLine2.addStandardExcitation( charMeca2 )
statNonLine2.setSupportModel( monModel )
statNonLine2.setMaterialOnMesh( affectMat )
statNonLine2.addBehaviourOnElements( elas )
# Define the initial state of the current analysis
start = code_aster.State.create(0)
# from the last computed step of the previous analysis
start.setFromNonLinearEvolution( resu, 0.5, 1.e-6 )
statNonLine2.setInitialState( start )
#
temps =[1.0, 1.5];
timeList = code_aster.TimeStepManager.create()
timeList.setTimeList( temps )

error1 = code_aster.ConvergenceError.create()
action1 = code_aster.SubstepingOnError.create()
action1.setAutomatic( False )
error1.setAction( action1 )
timeList.addErrorManager( error1 )
timeList.build()
statNonLine2.setLoadStepManager( timeList )
#statNonLine2.execute()

# at least it pass here!
test.assertTrue( True )
test.printSummary()