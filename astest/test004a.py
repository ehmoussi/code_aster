# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
# This file is part of code_aster.
#
# code_aster is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# code_aster is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with code_aster.  If not, see <http://www.gnu.org/licenses/>.
# --------------------------------------------------------------------

import code_aster
from code_aster.Commands import *

code_aster.init("--test")

test = code_aster.TestCase()

monMaillage = code_aster.Mesh()
monMaillage.readMedFile( "test001f.mmed" )

monModel = code_aster.Model(monMaillage)
monModel.addModelingOnMesh( code_aster.Physics.Mechanics, code_aster.Modelings.Tridimensional )
monModel.build()

YOUNG = 200000.0
POISSON = 0.3

acier = DEFI_MATERIAU(ELAS = _F(E = YOUNG,
                                NU = POISSON,),)
acier.debugPrint(6)

affectMat = code_aster.MaterialField(monMaillage)
affectMat.addMaterialsOnMesh( acier )
affectMat.buildWithoutExternalVariable()

charMeca1 = code_aster.KinematicsMechanicalLoad()
charMeca1.setModel(monModel)
charMeca1.addImposedMechanicalDOFOnNodes(code_aster.PhysicalQuantityComponent.Dx, 0., "Bas")
charMeca1.addImposedMechanicalDOFOnNodes(code_aster.PhysicalQuantityComponent.Dy, 0., "Bas")
charMeca1.addImposedMechanicalDOFOnNodes(code_aster.PhysicalQuantityComponent.Dz, 0., "Bas")
charMeca1.build()

imposedPres1 = code_aster.PressureReal()
imposedPres1.setValue( code_aster.PhysicalQuantityComponent.Pres, 1000. )
charMeca2 = code_aster.DistributedPressureReal(monModel)
charMeca2.setValue( imposedPres1, "Haut" )
charMeca2.build()

# Define the nonlinear method that will be used
#monSolver = code_aster.MumpsSolver(code_aster.Renumbering.Metis)
monSolver = code_aster.PetscSolver( code_aster.Renumbering.Sans )
monSolver.setPreconditioning(code_aster.Preconditioning.Ml)
lineSearch = code_aster.LineSearchMethod(code_aster.LineSearchEnum.Corde )

# Define a nonlinear Analysis
statNonLine = code_aster.NonLinearStaticAnalysis()
statNonLine.addStandardExcitation( charMeca1 )
statNonLine.addStandardExcitation( charMeca2 )
statNonLine.setModel( monModel )
statNonLine.setMaterialField( affectMat )
statNonLine.setLinearSolver( monSolver )
#statNonLine.setLineSearchMethod( lineSearch )
#Elas = code_aster.Behaviour( code_aster.Elas, code_aster.SmallStrain )
#Elas = code_aster.Behaviour();
#statNonLine.addBehaviourOnCells( Elas );

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
timeList.build()
#timeList.debugPrint( 6 )
statNonLine.setLoadStepManager( timeList )

# Run the nonlinear analysis
resu = statNonLine.execute()
#resu.debugPrint( 6 )

u=resu.getRealFieldOnNodes('DEPL',2)
z=u.EXTR_COMP()
test.assertEqual(len(z.valeurs),81)

sixx=resu.getRealFieldOnCells('SIEF_ELGA',1)
z=sixx.EXTR_COMP('SIXX')
test.assertEqual(len(z.valeurs),64)

test.printSummary()

FIN()
