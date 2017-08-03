#!/usr/bin/python
# coding: utf-8

import code_aster
from code_aster.Commands import *

test = code_aster.TestCase()

#parallel=False
parallel=True

if (parallel):
    monMaillage = code_aster.ParallelMesh.create()
    monMaillage.readMedFile( "xxParallelMesh001a" )
else:
    monMaillage = code_aster.Mesh.create()
    monMaillage.readMedFile("xxParallelNonlinearMechanics001a.med")

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

affectMat = code_aster.MaterialOnMesh.create()
affectMat.setSupportMesh( monMaillage )
affectMat.addMaterialOnAllMesh( acier )
affectMat.build()

charMeca1 = code_aster.KinematicsLoad.create()
charMeca1.setSupportModel(monModel)
charMeca1.addImposedMechanicalDOFOnNodes(code_aster.PhysicalQuantityComponent.Dx, 0., "COTE_B")
charMeca1.addImposedMechanicalDOFOnNodes(code_aster.PhysicalQuantityComponent.Dy, 0., "COTE_B")
charMeca1.addImposedMechanicalDOFOnNodes(code_aster.PhysicalQuantityComponent.Dz, 0., "COTE_B")
charMeca1.build()

charMeca2 = code_aster.KinematicsLoad.create()
charMeca2.setSupportModel(monModel)
charMeca2.addImposedMechanicalDOFOnNodes(code_aster.PhysicalQuantityComponent.Dy, 10., "COTE_H")
charMeca2.addImposedMechanicalDOFOnNodes(code_aster.PhysicalQuantityComponent.Dz, 10., "COTE_H")
charMeca2.build()

# Define the nonlinear method that will be used
monSolver = code_aster.PetscSolver.create( code_aster.Renumbering.Sans )
monSolver.setPreconditioning(code_aster.Preconditioning.Ml)

# Define a nonlinear Analysis
statNonLine = code_aster.StaticNonLinearAnalysis.create()
statNonLine.addStandardExcitation( charMeca1 )
statNonLine.addStandardExcitation( charMeca2 )
statNonLine.setSupportModel( monModel )
statNonLine.setMaterialOnMesh( affectMat )
statNonLine.setLinearSolver( monSolver )

temps = [0., 0.5, 1.]
timeList = code_aster.TimeStepManager.create()
timeList.setTimeList( temps )

error1 = code_aster.ConvergenceError.create()
action1 = code_aster.SubstepingOnError.create()
action1.setAutomatic( False )
error1.setAction( action1 )
timeList.addErrorManager( error1 )
timeList.build()
#timeList.debugPrint( 6 )
statNonLine.setLoadStepManager( timeList )
# Run the nonlinear analysis
resu = statNonLine.execute()
#resu.debugPrint( 6 )

# at least it pass here!
test.assertTrue( True )
test.printSummary()
