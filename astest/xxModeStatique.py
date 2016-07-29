#!/usr/bin/python

# coding: utf-8


import code_aster
from code_aster.Commands import *


test = code_aster.TestCase()

monMaillage = code_aster.Mesh()
monMaillage.readMedFile("test001f.mmed")


monModel = code_aster.Model()
monModel.setSupportMesh(monMaillage)
monModel.addModelingOnAllMesh(code_aster.Mechanics, code_aster.Tridimensional)
monModel.build()


YOUNG = 200000.0
POISSON = 0.3

materElas = code_aster.MaterialBehaviour.ElasMaterialBehaviour()
materElas.setDoubleValue("E", YOUNG)
materElas.setDoubleValue("Nu", POISSON)


acier = code_aster.Material()
acier.addMaterialBehaviour(materElas)
acier.build()

affeMat = code_aster.MaterialOnMesh()
affeMat.setSupportMesh(monMaillage)
affeMat.addMaterialOnAllMesh(acier)
affeMat.build()

imposedDof1 = code_aster.DisplacementDouble()
imposedDof1.setValue(code_aster.Loads.Dx, 0.0)
imposedDof1.setValue(code_aster.Loads.Dy, 0.0)
imposedDof1.setValue(code_aster.Loads.Dz, 0.0)

CharMeca1 = code_aster.ImposedDisplacementDouble()
CharMeca1.setSupportModel(monModel)
CharMeca1.setValue(imposedDof1, "Bas")
CharMeca1.build()

imposedPres1 = code_aster.PressureDouble()
imposedPres1.setValue(code_aster.Loads.Pres, 1000.)

CharMeca2 = code_aster.DistributedPressureDouble()
CharMeca2.setSupportModel(monModel)
CharMeca2.setValue(imposedPres1, "Haut")
CharMeca2.build()

matr_elemK = code_aster.ElementaryMatrix()
matr_elemK.setSupportModel(monModel)
matr_elemK.setMaterialOnMesh(affeMat)
matr_elemK.addMechanicalLoad(CharMeca1)
matr_elemK.addMechanicalLoad(CharMeca2)
matr_elemK.computeMechanicalRigidity()

matr_elemM = code_aster.ElementaryMatrix()
matr_elemM.setSupportModel(monModel)
matr_elemM.setMaterialOnMesh(affeMat)
matr_elemM.addMechanicalLoad(CharMeca1)
matr_elemM.addMechanicalLoad(CharMeca2)
matr_elemM.computeMechanicalMass()


monSolver = code_aster.LinearSolver(
    code_aster.LinearAlgebra.Mumps, code_aster.LinearAlgebra.Metis)


numeDDLK = code_aster.DOFNumbering()
numeDDLK.setElementaryMatrix(matr_elemK)
numeDDLK.setLinearSolver(monSolver)
numeDDLK.computeNumerotation()

numeDDLM = code_aster.DOFNumbering()
numeDDLM.setElementaryMatrix(matr_elemM)
numeDDLM.setLinearSolver(monSolver)
numeDDLM.computeNumerotation()


matrAsseK = code_aster.AssemblyMatrixDouble()
matrAsseK.setElementaryMatrix(matr_elemK)
matrAsseK.setDOFNumbering(numeDDLK)
matrAsseK.build()

matrAsseM = code_aster.AssemblyMatrixDouble()
matrAsseM.setElementaryMatrix(matr_elemM)
matrAsseM.setDOFNumbering(numeDDLK)
matrAsseM.build()

print "mode_statique python debut"

mode_stat1 = code_aster.StaticModeDepl()
mode_stat1.setStiffMatrix(matrAsseK)
mode_stat1.setLinearSolver(monSolver)
mode_stat1.setAllLoc()
mode_stat1.Wantedcmp(('DX', 'DY'))
resu = mode_stat1.execute()


mode_stat2 = code_aster.StaticModeForc()
mode_stat2.setStiffMatrix(matrAsseK)
mode_stat2.setAllLoc()
mode_stat2.setLinearSolver(monSolver)
mode_stat2.Wantedcmp(('DX',))
mode_stat2.execute()

mode_stat3 = code_aster.StaticModePseudo()
mode_stat3.setStiffMatrix(matrAsseK)
mode_stat3.setMassMatrix(matrAsseM)
mode_stat3.setAllLoc()
mode_stat3.setLinearSolver(monSolver)
mode_stat3.WantedAxe(('X', 'Y', 'Z'))
mode_stat3.execute()

mode_stat4 = code_aster.StaticModeInterf()
mode_stat4.setStiffMatrix(matrAsseK)
mode_stat4.setMassMatrix(matrAsseM)
mode_stat4.setAllLoc()
mode_stat4.setLinearSolver(monSolver)
mode_stat4.setAllCmp()
mode_stat4.setNbmod(1)
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

# Debut du TEST_RESU
MyFieldOnNodes1 = mod_sta1.getRealFieldOnNodes("DEPL", 0)
sfon1 = MyFieldOnNodes1.exportToSimpleFieldOnNodes()
# sfon1.debugPrint()

# Test
sfon1.updateValuePointers()

test.assertAlmostEqual(sfon1.getValue(0, 0), 0.180974483763)

MyFieldOnNodes2 = mod_sta2.getRealFieldOnNodes("DEPL", 0)
sfon2 = MyFieldOnNodes2.exportToSimpleFieldOnNodes()
# sfon2.debugPrint()

# Test
sfon2.updateValuePointers()

test.assertAlmostEqual(sfon2.getValue(0, 0), 2.56667232228e-05)

MyFieldOnNodes3 = mod_sta3.getRealFieldOnNodes("DEPL", 0)
sfon3 = MyFieldOnNodes3.exportToSimpleFieldOnNodes()
# sfon3.debugPrint()

# Test
sfon3.updateValuePointers()

test.assertAlmostEqual(sfon3.getValue(0, 0), 0.0)


test.printSummary()
# Fin du TEST_RESU
