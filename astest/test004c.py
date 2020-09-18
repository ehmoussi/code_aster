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

# validation du pilotage inspiré de ssnv176c

import code_aster
from code_aster.Commands import *
import numpy as np

code_aster.init("--test")

test = code_aster.TestCase()

monMaillage = code_aster.Mesh()
monMaillage.readAsterFile( "test004c.mail" )

monModel = code_aster.Model(monMaillage)
monModel.addModelingOnMesh( code_aster.Physics.Mechanics, code_aster.Modelings.Tridimensional )
monModel.build()
# materiau
Young = 32000.0
Poisson = 0.2

beton = DEFI_MATERIAU(ELAS = _F(E = Young,
                                NU = Poisson,),
                      ENDO_ORTH_BETON = _F(ALPHA = 0.87,
                                           K0 = 3.e-4,
                                           K1 = 10.5,
                                           K2 = 6.e-4,
                                           ECROB = 1.e-3,
                                           ECROD = 0.06,),)

affectMat = code_aster.MaterialField(monMaillage)
affectMat.addMaterialsOnMesh( beton )
affectMat.buildWithoutExternalVariable()


# Chargement
imposedDof1 = code_aster.DisplacementReal()
imposedDof1.setValue( code_aster.PhysicalQuantityComponent.Dx, 0.0 )
imposedDof1.setValue( code_aster.PhysicalQuantityComponent.Dy, 0.0 )
imposedDof1.setValue( code_aster.PhysicalQuantityComponent.Dz, 0.0 )
charMeca1 = code_aster.ImposedDisplacementReal(monModel)
charMeca1.setValue( imposedDof1, "N0" )
charMeca1.build()

#TODO un chargement avec liaison_ddl

imposedDof2 = code_aster.DisplacementReal()
imposedDof2.setValue( code_aster.PhysicalQuantityComponent.Dx, 1.0 )
charMeca2 = code_aster.ImposedDisplacementReal(monModel)
charMeca2.setValue( imposedDof1, "N1" )
charMeca2.build()
test.assertEqual(charMeca2.getType(), "CHAR_MECA")

# Instants de calcul pour la première phase de calcul

temps = [0.0, 1.0]
timeList = code_aster.TimeStepManager()
timeList.setTimeList( temps )
timeList.build()

# Analyse non-linéaire pour cette première phase
statNonLine1 = code_aster.NonLinearStaticAnalysis()
statNonLine1.addStandardExcitation( charMeca1 )
statNonLine1.addStandardExcitation( charMeca2 )
statNonLine1.setModel( monModel )
statNonLine1.setMaterialField( affectMat )

statNonLine1.setLoadStepManager( timeList )

endoOrthBeton = code_aster.Behaviour(
    code_aster.ConstitutiveLaw.ConcreteOrthotropicDamage,
    code_aster.StrainType.SmallStrain)
statNonLine1.addBehaviourOnCells( endoOrthBeton )


#resu1 = statNonLine1.execute()

# Instants de calcul pour la seconde phase de calcul
temps = np.linspace(1.0, 2.0, num=50)
timeList = code_aster.TimeStepManager()
timeList.setTimeList( temps )
timeList.build()



# Analyse non-linéaire pour la seconde phase (avec pilotage)
statNonLine2 = code_aster.NonLinearStaticAnalysis()
statNonLine2.addStandardExcitation( charMeca1 )
statNonLine2.addStandardExcitation( charMeca2 )
statNonLine2.setModel( monModel )
statNonLine2.setMaterialField( affectMat )
statNonLine2.addBehaviourOnCells( endoOrthBeton )

statNonLine2.setLoadStepManager( timeList )

# Define the initial state of the current analysis
start = code_aster.State(0)
# from the last computed step of the previous analysis
#start.setFromNonLinearResult( resu1, 1.0 )
#statNonLine2.setInitialState( start )

pilotage=code_aster.Driving( code_aster.DrivingType.ElasticityLimit )
pilotage.setLowerBoundOfDrivingParameter(0.0)
pilotage.setUpperBoundOfDrivingParameter(1.0)
pilotage.setMinimumValueOfDrivingParameter( 0.000001 )
pilotage.setMultiplicativeCoefficient( 1.0 )
statNonLine2.setDriving( pilotage )

#resu2 = statNonLine2.execute()
# at least it pass here!

test.printSummary()

FIN()
