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
import numpy as np

code_aster.init("--test")

test = code_aster.TestCase()

monMaillage = code_aster.Mesh()
monMaillage.readMedFile("test001f.mmed")

monModel = code_aster.Model(monMaillage)
monModel.addModelingOnMesh(code_aster.Physics.Mechanics, code_aster.Modelings.Tridimensional)
monModel.build()
test.assertEqual(monModel.getType(), "MODELE_SDASTER")

YOUNG = 200000.0
POISSON = 0.3

Kinv = 3.2841e-4
Kv = 1./Kinv
SY = 437.0
Rinf = 758.0
Qzer = 758.0-437.
Qinf = Qzer + 100.
b = 2.3
C1inf = 63767.0/2.0
C2inf = 63767.0/2.0
Gam1 = 341.0
Gam2 = 341.0
C_Pa = 1.e+6

acier = DEFI_MATERIAU(ELAS=_F(E=YOUNG,
                              NU=POISSON,),
                      VISCOCHAB=_F(K=SY*C_Pa,
                                   B=b,
                                   MU=10,
                                   Q_M=Qinf * C_Pa,
                                   Q_0=Qzer * C_Pa,
                                   C1=C1inf * C_Pa,
                                   C2=C2inf * C_Pa,
                                   G1_0=Gam1,
                                   G2_0=Gam2,
                                   K_0=Kv * C_Pa,
                                   N=11,
                                   A_K=1.,),)
# acier.debugPrint(6)
test.assertEqual(acier.getType(), "MATER_SDASTER")

affectMat = code_aster.MaterialField(monMaillage)
affectMat.addMaterialsOnMesh(acier)
affectMat.addMaterialsOnGroupOfCells(acier, ['Haut', 'Bas'])
affectMat.buildWithoutExternalVariable()
test.assertEqual(affectMat.getType(), "CHAM_MATER")

imposedDof1 = code_aster.DisplacementReal()
imposedDof1.setValue(code_aster.PhysicalQuantityComponent.Dx, 0.0)
imposedDof1.setValue(code_aster.PhysicalQuantityComponent.Dy, 0.0)
imposedDof1.setValue(code_aster.PhysicalQuantityComponent.Dz, 0.0)
CharMeca1 = code_aster.ImposedDisplacementReal(monModel)
CharMeca1.setValue(imposedDof1, "Bas")
CharMeca1.build()
test.assertEqual(CharMeca1.getType(), "CHAR_MECA")

imposedPres1 = code_aster.PressureReal()
imposedPres1.setValue(code_aster.PhysicalQuantityComponent.Pres, 1000.)
CharMeca2 = code_aster.DistributedPressureReal(monModel)
CharMeca2.setValue(imposedPres1, "Haut")
CharMeca2.build()
test.assertEqual(CharMeca2.getType(), "CHAR_MECA")

study = code_aster.StudyDescription(monModel, affectMat)
study.addMechanicalLoad(CharMeca1)
study.addMechanicalLoad(CharMeca2)
dProblem = code_aster.DiscreteProblem(study)
vectElem = dProblem.buildElementaryMechanicalLoadsVector()
matr_elem = dProblem.computeMechanicalStiffnessMatrix()

test.assertEqual(matr_elem.getType(), "MATR_ELEM_DEPL_R")

monSolver = code_aster.MumpsSolver(code_aster.Renumbering.Metis)

numeDDL = code_aster.DOFNumbering()
numeDDL.setElementaryMatrix(matr_elem)
numeDDL.computeNumbering()
# numeDDL.debugPrint(6)
test.assertEqual(numeDDL.getType(), "NUME_DDL_SDASTER")

# vectElem.debugPrint(6)
test.assertEqual(vectElem.getType(), "VECT_ELEM_DEPL_R")

retour = vectElem.assembleVector(numeDDL)

matrAsse = code_aster.AssemblyMatrixDisplacementReal()
matrAsse.appendElementaryMatrix(matr_elem)
matrAsse.setDOFNumbering(numeDDL)
matrAsse.build()

x = matrAsse.EXTR_MATR(sparse=True)
test.assertTrue('numpy' in str(type(x[0])))

# test setValues
# -----------------
values, idx, jdx, neq = matrAsse.EXTR_MATR(sparse=True)
K1 = matrAsse.EXTR_MATR()

neq = K1.shape[0]
matrAsse.setValues([0,1], [0,1], [1.,1.])
K2 = matrAsse.EXTR_MATR()
test.assertAlmostEqual(np.linalg.norm(K2), np.sqrt(2))


matrAsse.setValues(idx.tolist(), jdx.tolist(), values.tolist())
K3 = matrAsse.EXTR_MATR()
test.assertEqual(np.linalg.norm(K1 - K3), 0)


try:
    import petsc4py
    import code_aster.LinearAlgebra
except ImportError:
    pass
else:
    A = code_aster.LinearAlgebra.AssemblyMatrixToPetsc4Py(matrAsse)
    v = petsc4py.PETSc.Viewer.DRAW(A.comm)
    A.view(v)

monSolver.matrixFactorization(matrAsse)
test.assertEqual(matrAsse.getType(), "MATR_ASSE_DEPL_R")

vcine = dProblem.buildKinematicsLoad(numeDDL, 0.)
resu = monSolver.solveRealLinearSystemWithKinematicsLoad(matrAsse, vcine, retour)

y = resu.EXTR_COMP()
test.assertEqual(len(y.valeurs), 81)

resu2 = resu.exportToSimpleFieldOnNodes()
resu2.updateValuePointers()
test.assertAlmostEqual(resu2.getValue(5, 3), 0.000757555469653289)

resu.printMedFile("fort.med")

# test setValues + solve
# ----------------------
matrAsse.setValues(idx.tolist(), jdx.tolist(), [10*v for v in values])
monSolver.matrixFactorization(matrAsse)
resu = monSolver.solveRealLinearSystem(matrAsse, retour)
resu2 = resu.exportToSimpleFieldOnNodes()
resu2.updateValuePointers()
test.assertAlmostEqual(resu2.getValue(5, 3), 0.000757555469653289/10.)

test.printSummary()

FIN()
