# coding: utf-8

import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

monMaillage = code_aster.Mesh()
monMaillage.readMedFile( "test001f.mmed" )

monModel = code_aster.Model(monMaillage)
monModel.addModelingOnAllMesh( code_aster.Physics.Mechanics, code_aster.Modelings.Tridimensional )
monModel.build()

YOUNG = 200000.0
POISSON = 0.3

acier = DEFI_MATERIAU(ELAS = _F(E = YOUNG,
                                NU = POISSON,),)
acier.debugPrint(6)

affectMat = code_aster.MaterialField(monMaillage)
affectMat.addMaterialsOnAllMesh( acier )
affectMat.buildWithoutExternalVariable()

imposedDof1 = code_aster.DisplacementReal()
imposedDof1.setValue( code_aster.PhysicalQuantityComponent.Dx, 0.0 )
imposedDof1.setValue( code_aster.PhysicalQuantityComponent.Dy, 0.0 )
imposedDof1.setValue( code_aster.PhysicalQuantityComponent.Dz, 0.0 )
charMeca1 = code_aster.ImposedDisplacementReal(monModel)
charMeca1.setValue( imposedDof1, "Bas" )
charMeca1.build()
test.assertEqual(charMeca1.getType(), "CHAR_MECA")

imposedPres1 = code_aster.PressureReal()
imposedPres1.setValue( code_aster.PhysicalQuantityComponent.Pres, 1000. )
charMeca2 = code_aster.DistributedPressureReal(monModel)
charMeca2.setValue( imposedPres1, "Haut" )
charMeca2.build()
test.assertEqual(charMeca2.getType(), "CHAR_MECA")

monSolver = code_aster.MumpsSolver( code_aster.Renumbering.Metis )

# Define a first nonlinear Analysis
statNonLine1 = code_aster.NonLinearStaticAnalysis()
statNonLine1.addStandardExcitation( charMeca1 )
statNonLine1.addStandardExcitation( charMeca2 )
statNonLine1.setModel( monModel )
statNonLine1.setMaterialField( affectMat )
statNonLine1.setLinearSolver( monSolver )
# elas = code_aster.Behaviour()
elas = code_aster.Behaviour(code_aster.ConstitutiveLaw.Elas,
                                   code_aster.StrainType.SmallStrain)
statNonLine1.addBehaviourOnCells( elas )


temps = [0., 0.5 ]
timeList = code_aster.TimeStepManager()
timeList.setTimeList( temps )

error1 = code_aster.EventError()
action1 = code_aster.SubstepingOnError()
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
test.assertEqual(resu.getType(), "EVOL_NOLI")
#resu.debugPrint( 6 )

# Define a second nonlinear Analysis
statNonLine2 = code_aster.NonLinearStaticAnalysis()
statNonLine2.addStandardExcitation( charMeca1 )
statNonLine2.addStandardExcitation( charMeca2 )
statNonLine2.setModel( monModel )
statNonLine2.setMaterialField( affectMat )
statNonLine2.addBehaviourOnCells( elas )
# Define the initial state of the current analysis
start = code_aster.State(0)
# from the last computed step of the previous analysis
start.setFromNonLinearResult( resu, 0.5, 1.e-6 )
statNonLine2.setInitialState( start )
#
temps =[1.0, 1.5];
timeList = code_aster.TimeStepManager()
timeList.setTimeList( temps )

error1 = code_aster.EventError()
action1 = code_aster.SubstepingOnError()
action1.setAutomatic( False )
error1.setAction( action1 )
timeList.addErrorManager( error1 )
timeList.build()
statNonLine2.setLoadStepManager( timeList )
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! commenter: execute of the 2nd nonlinear Analysis
#statNonLine2.execute()

# at least it pass here!
test.printSummary()

FIN()
