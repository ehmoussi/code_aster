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
#acier.debugPrint(6)

affectMat = code_aster.MaterialField(monMaillage)
affectMat.addMaterialsOnMesh( acier )
affectMat.buildWithoutExternalVariable()


kine1 = code_aster.KinematicsMechanicalLoad()
kine1.setModel(monModel)
kine1.addImposedMechanicalDOFOnCells(code_aster.PhysicalQuantityComponent.Dx, 0., "Bas")
kine1.addImposedMechanicalDOFOnCells(code_aster.PhysicalQuantityComponent.Dy, 0., "Bas")
kine1.addImposedMechanicalDOFOnCells(code_aster.PhysicalQuantityComponent.Dz, 0., "Bas")
kine1.build()
test.assertEqual(kine1.getType(), "CHAR_CINE_MECA")

kine2=code_aster.KinematicsMechanicalLoad()
kine2.setModel(monModel)
kine2.addImposedMechanicalDOFOnCells(code_aster.PhysicalQuantityComponent.Dz, 0.1, "Haut")
kine2.build()
test.assertEqual(kine2.getType(), "CHAR_CINE_MECA")

monSolver = code_aster.MumpsSolver( code_aster.Renumbering.Metis )

# Define a first nonlinear Analysis
statNonLine1 = code_aster.NonLinearStaticAnalysis()

statNonLine1.addStandardExcitation( kine1 )
statNonLine1.addStandardExcitation( kine2 )

statNonLine1.setModel( monModel )
statNonLine1.setMaterialField( affectMat )
statNonLine1.setLinearSolver( monSolver )
elas = code_aster.Behaviour(code_aster.ConstitutiveLaw.Elas,
                                   code_aster.StrainType.SmallStrain )
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
#resu = statNonLine1.execute()
#resu.debugPrint( 6 )

test.printSummary()

FIN()
