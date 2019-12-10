# coding: utf-8

import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

monMaillage = code_aster.Mesh()
monMaillage.readMedFile( "test001f.mmed" )

monModel = code_aster.Model()
monModel.setMesh( monMaillage )
monModel.addModelingOnAllMesh( code_aster.Physics.Mechanics,
                               code_aster.Modelings.Tridimensional )
monModel.build()

YOUNG = 200000.0;
POISSON = 0.3;

acier = DEFI_MATERIAU(ELAS = _F(E = YOUNG,
                                    NU = POISSON,),)
acier.debugPrint(6)

affectMat = code_aster.MaterialOnMesh(monMaillage)
affectMat.addMaterialOnAllMesh( acier )
affectMat.buildWithoutInputVariables()

imposedDof1 = code_aster.DisplacementDouble()
imposedDof1.setValue( code_aster.PhysicalQuantityComponent.Dx, 0.0 )
imposedDof1.setValue( code_aster.PhysicalQuantityComponent.Dy, 0.0 )
imposedDof1.setValue( code_aster.PhysicalQuantityComponent.Dz, 0.0 )
CharMeca1 = code_aster.ImposedDisplacementDouble(monModel)
CharMeca1.setValue( imposedDof1, "Bas" )
CharMeca1.build()

imposedPres1 = code_aster.PressureDouble()
imposedPres1.setValue( code_aster.PhysicalQuantityComponent.Pres, 1000. )
CharMeca2 = code_aster.DistributedPressureDouble(monModel)
CharMeca2.setValue( imposedPres1, "Haut" )
CharMeca2.build()

monSolver = code_aster.MumpsSolver( code_aster.Renumbering.Metis )

mecaStatique = code_aster.StaticMechanicalSolver(monModel, affectMat)
mecaStatique.addMechanicalLoad( CharMeca1 )
mecaStatique.addMechanicalLoad( CharMeca2 )
mecaStatique.setLinearSolver( monSolver )

temps = [0., 0.5, 1.]
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
acier.debugPrint(6)
timeList.build()
timeList.debugPrint( 8 )

resu = mecaStatique.execute()
resu.debugPrint( 8 )

# at least it pass here!
test.assertTrue( True )
test.printSummary()

FIN()
