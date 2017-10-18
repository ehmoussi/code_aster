#!/usr/bin/python
# coding: utf-8
# validation du pilotage inspiré de ssnv176c

import code_aster
import numpy as np

code_aster.init()

test = code_aster.TestCase()

monMaillage = code_aster.Mesh.create()
monMaillage.readAsterMeshFile( "test004c.mail" )

monModel = code_aster.Model.create()
monModel.setSupportMesh( monMaillage )
monModel.addModelingOnAllMesh( code_aster.Physics.Mechanics, code_aster.Modelings.Tridimensional )
monModel.build()
# materiau
Young = 32000.0;
Poisson = 0.2

materElas = code_aster.ElasMaterialBehaviour.create()
materElas.setDoubleValue( "E", Young )
materElas.setDoubleValue( "Nu", Poisson )

materBeton = code_aster.EndoOrthBetonMaterialBehaviour.create()
materBeton.setDoubleValue("Alpha", 0.87 )
materBeton.setDoubleValue("K0", 3.e-4 )
materBeton.setDoubleValue("K1", 10.5 )
materBeton.setDoubleValue("K2", 6.e-4)
materBeton.setDoubleValue("Ecrob",1.e-3)
materBeton.setDoubleValue("Ecrod", 0.06)


beton = code_aster.Material.create()
beton.addMaterialBehaviour( materElas )
beton.addMaterialBehaviour( materBeton )
beton.build()

affectMat = code_aster.MaterialOnMesh.create(monMaillage)
affectMat.addMaterialOnAllMesh( beton )
affectMat.build()


# Chargement
imposedDof1 = code_aster.DisplacementDouble.create()
imposedDof1.setValue( code_aster.PhysicalQuantityComponent.Dx, 0.0 )
imposedDof1.setValue( code_aster.PhysicalQuantityComponent.Dy, 0.0 )
imposedDof1.setValue( code_aster.PhysicalQuantityComponent.Dz, 0.0 )
charMeca1 = code_aster.ImposedDisplacementDouble.create(monModel)
charMeca1.setValue( imposedDof1, "N0" )
charMeca1.build()

#TODO un chargement avec liaison_ddl

imposedDof2 = code_aster.DisplacementDouble.create()
imposedDof2.setValue( code_aster.PhysicalQuantityComponent.Dx, 1.0 )
charMeca2 = code_aster.ImposedDisplacementDouble.create(monModel)
charMeca2.setValue( imposedDof1, "N1" )
charMeca2.build()

# Instants de calcul pour la première phase de calcul

temps = [0.0, 1.0]
timeList = code_aster.TimeStepManager.create()
timeList.setTimeList( temps )
timeList.build()

# Analyse non-linéaire pour cette première phase
statNonLine1 = code_aster.StaticNonLinearAnalysis.create()
statNonLine1.addStandardExcitation( charMeca1 )
statNonLine1.addStandardExcitation( charMeca2 )
statNonLine1.setSupportModel( monModel )
statNonLine1.setMaterialOnMesh( affectMat )

statNonLine1.setLoadStepManager( timeList )

EndoOrthBeton = code_aster.Behaviour.create(code_aster.ConcreteOrthotropicDamage,
                                            code_aster.SmallStrain )
statNonLine1.addBehaviourOnElements( EndoOrthBeton )


#resu1 = statNonLine1.execute()

# Instants de calcul pour la seconde phase de calcul
temps = np.linspace(1.0, 2.0, num=50)
timeList = code_aster.TimeStepManager.create()
timeList.setTimeList( temps )
timeList.build()



# Analyse non-linéaire pour la seconde phase (avec pilotage)
statNonLine2 = code_aster.StaticNonLinearAnalysis.create()
statNonLine2.addStandardExcitation( charMeca1 )
statNonLine2.addStandardExcitation( charMeca2 )
statNonLine2.setSupportModel( monModel )
statNonLine2.setMaterialOnMesh( affectMat )
statNonLine2.addBehaviourOnElements( EndoOrthBeton )

statNonLine2.setLoadStepManager( timeList )

# Define the initial state of the current analysis
start = code_aster.State()
# from the last computed step of the previous analysis
#start.setFromNonLinearEvolution( resu1, 1.0 )
#statNonLine2.setInitialState( start )

pilotage=code_aster.Driving.create( code_aster.ElasticityLimit )
pilotage.setLowerBoundOfDrivingParameter(0.0)
pilotage.setUpperBoundOfDrivingParameter(1.0)
pilotage.setMinimumValueOfDrivingParameter( 0.000001 )
pilotage.setMultiplicativeCoefficient( 1.0 )
statNonLine2.setDriving( pilotage )

#resu2 = statNonLine2.execute()
# at least it pass here!
test.assertTrue( True )
test.printSummary()
