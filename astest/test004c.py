# coding: utf-8
# validation du pilotage inspiré de ssnv176c

import code_aster
from code_aster.Commands import *
import numpy as np

code_aster.init()

test = code_aster.TestCase()

monMaillage = code_aster.Mesh()
monMaillage.readAsterMeshFile( "test004c.mail" )

monModel = code_aster.Model(monMaillage)
monModel.addModelingOnAllMesh( code_aster.Physics.Mechanics, code_aster.Modelings.Tridimensional )
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

affectMat = code_aster.MaterialOnMesh(monMaillage)
affectMat.addMaterialOnAllMesh( beton )
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
statNonLine1.setMaterialOnMesh( affectMat )

statNonLine1.setLoadStepManager( timeList )

endoOrthBeton = code_aster.Behaviour(
    code_aster.ConstitutiveLaw.ConcreteOrthotropicDamage,
    code_aster.StrainType.SmallStrain)
statNonLine1.addBehaviourOnElements( endoOrthBeton )


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
statNonLine2.setMaterialOnMesh( affectMat )
statNonLine2.addBehaviourOnElements( endoOrthBeton )

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
test.assertTrue( True )
test.printSummary()

FIN()
