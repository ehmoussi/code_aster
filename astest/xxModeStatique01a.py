#!/usr/bin/python
# coding: utf-8

import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

monMaillage = code_aster.Mesh()
monMaillage.readMedFile("test001f.mmed")


monModel = code_aster.Model()
monModel.setSupportMesh(monMaillage)
monModel.addModelingOnAllMesh(code_aster.Physics.Mechanics, code_aster.Modelings.Tridimensional)
monModel.build()


YOUNG = 200000.0
POISSON = 0.3

materElas = code_aster.ElasMaterialBehaviour()
materElas.setDoubleValue("E", YOUNG)
materElas.setDoubleValue("Nu", POISSON)


acier = code_aster.Material()
acier.addMaterialBehaviour(materElas)
acier.build()

affeMat = code_aster.MaterialOnMesh(monMaillage)
affeMat.addMaterialOnAllMesh(acier)
affeMat.buildWithoutInputVariables()

imposedDof1 = code_aster.DisplacementDouble()
imposedDof1.setValue(code_aster.PhysicalQuantityComponent.Dx, 0.0)
imposedDof1.setValue(code_aster.PhysicalQuantityComponent.Dy, 0.0)
imposedDof1.setValue(code_aster.PhysicalQuantityComponent.Dz, 0.0)

CharMeca1 = code_aster.ImposedDisplacementDouble(monModel)
CharMeca1.setValue(imposedDof1, "Bas")
CharMeca1.build()

imposedPres1 = code_aster.PressureDouble()
imposedPres1.setValue(code_aster.PhysicalQuantityComponent.Pres, 1000.)

CharMeca2 = code_aster.DistributedPressureDouble(monModel)
CharMeca2.setValue(imposedPres1, "Haut")
CharMeca2.build()

study = code_aster.StudyDescription(monModel, affeMat)
study.addMechanicalLoad(CharMeca1)
study.addMechanicalLoad(CharMeca2)
dProblem = code_aster.DiscreteProblem(study)

matr_elemK = dProblem.computeMechanicalRigidityMatrix()
matr_elemM = dProblem.computeMechanicalMassMatrix()


monSolver = code_aster.MumpsSolver( code_aster.Renumbering.Metis )


numeDDLK = code_aster.DOFNumbering()
numeDDLK.setElementaryMatrix(matr_elemK)
numeDDLK.computeNumerotation()

numeDDLM = code_aster.DOFNumbering()
numeDDLM.setElementaryMatrix(matr_elemM)
numeDDLM.computeNumerotation()


matrAsseK = code_aster.AssemblyMatrixDisplacementDouble()
matrAsseK.appendElementaryMatrix(matr_elemK)
matrAsseK.setDOFNumbering(numeDDLK)
matrAsseK.build()

matrAsseM = code_aster.AssemblyMatrixDisplacementDouble()
matrAsseM.appendElementaryMatrix(matr_elemM)
matrAsseM.setDOFNumbering(numeDDLK)
matrAsseM.build()

print "mode_statique python debut"

mode_stat1 = code_aster.StaticModeDepl()
mode_stat1.setStiffMatrix(matrAsseK)
mode_stat1.setLinearSolver(monSolver)
mode_stat1.enableOnAllMesh()
mode_stat1.WantedComponent(['DX', 'DY'])
resu = mode_stat1.execute()


mode_stat2 = code_aster.StaticModeForc()
mode_stat2.setStiffMatrix(matrAsseK)
mode_stat2.enableOnAllMesh()
mode_stat2.setLinearSolver(monSolver)
mode_stat2.WantedComponent(['DX',])
mode_stat2.execute()

mode_stat3 = code_aster.StaticModePseudo()
mode_stat3.setStiffMatrix(matrAsseK)
mode_stat3.setMassMatrix(matrAsseM)
mode_stat3.enableOnAllMesh()
mode_stat3.setLinearSolver(monSolver)
mode_stat3.WantedAxe(['X', 'Y', 'Z'])
mode_stat3.execute()

mode_stat4 = code_aster.StaticModeInterf()
mode_stat4.setStiffMatrix(matrAsseK)
mode_stat4.setMassMatrix(matrAsseM)
mode_stat4.enableOnAllMesh()
mode_stat4.setLinearSolver(monSolver)
mode_stat4.setAllComponents()
mode_stat4.setNumberOfModes(1)
mode_stat4.setShift(1.0)
# mode_stat4.execute()

print "mode_statique python ok"

mod_sta1 = MODE_STATIQUE(MATR_RIGI=matrAsseK,
                         MODE_STAT=_F(TOUT='OUI',
                                      AVEC_CMP=('DX', 'DY'),
                                      ),)


mod_sta2 = MODE_STATIQUE(MATR_RIGI=matrAsseK,
                         FORCE_NODALE=_F(TOUT='OUI',
                                         SANS_CMP=('DX', 'DY'),
                                         ),)

mod_sta3 = MODE_STATIQUE(MATR_RIGI=matrAsseK,
                         MATR_MASS=matrAsseM,
                         PSEUDO_MODE=_F(DIRECTION=(0.0, 1.0, 0.0),
                                        NOM_DIR='toto',
                                        ),)

print "MODE_STATIQUE couche de compat ok"



vecx = CALC_CHAR_SEISME(MATR_MASS=matrAsseM,
                        DIRECTION=(1.0,0.0,0.0,),
                        MODE_STAT=mod_sta1, GROUP_NO="Bas", );

# Debut du TEST_RESU
mod_sta1.update()
MyFieldOnNodes1 = mod_sta1.getRealFieldOnNodes("DEPL", 1)
sfon1 = MyFieldOnNodes1.exportToSimpleFieldOnNodes()
# sfon1.debugPrint()

# Test
sfon1.updateValuePointers()

test.assertAlmostEqual(sfon1.getValue(0, 0), 0.180974483763)

mod_sta2.update()
MyFieldOnNodes2 = mod_sta2.getRealFieldOnNodes("DEPL", 1)
sfon2 = MyFieldOnNodes2.exportToSimpleFieldOnNodes()
# sfon2.debugPrint()

# Test
sfon2.updateValuePointers()

test.assertAlmostEqual(sfon2.getValue(0, 0), 2.56667232228e-05)

mod_sta3.update()
MyFieldOnNodes3 = mod_sta3.getRealFieldOnNodes("DEPL", 1)
sfon3 = MyFieldOnNodes3.exportToSimpleFieldOnNodes()
# sfon3.debugPrint()

# Test
sfon3.updateValuePointers()

test.assertAlmostEqual(sfon3.getValue(0, 0), 0.0)

# Test
test.assertEqual(vecx.getType(), "CHAM_NO_SDASTER")
test.printSummary()
# Fin du TEST_RESU
