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

import numpy as N
import code_aster
from code_aster.Commands import *

code_aster.init("--test")

test = code_aster.TestCase()

MAIL = code_aster.ParallelMesh()
MAIL.readMedFile("xxParallelMesh002a")
#MAIL.debugPrint()

MATER=DEFI_MATERIAU(ELAS=_F(E=10000.0,
                            NU=0.,
                            RHO=1.0,),
                            );

affectMat = code_aster.MaterialField(MAIL)
affectMat.addMaterialsOnMesh(MATER)
affectMat.buildWithoutExternalVariable()

MODT=AFFE_MODELE(MAILLAGE=MAIL,
                 AFFE=_F(TOUT='OUI',
                         PHENOMENE='MECANIQUE',
                         MODELISATION='D_PLAN',),
                 DISTRIBUTION=_F(METHODE='CENTRALISE',),);

#MODT = code_aster.Model(MAIL))

charCine = code_aster.KinematicsMechanicalLoad()
charCine.setModel(MODT)
charCine.addImposedMechanicalDOFOnNodes(code_aster.PhysicalQuantityComponent.Dx, 0., "EncastN")
charCine.addImposedMechanicalDOFOnNodes(code_aster.PhysicalQuantityComponent.Dy, 0., "EncastN")
charCine.build()

CHT1 = AFFE_CHAR_MECA(MODELE=MODT,
                      PESANTEUR=_F(GRAVITE=1.0,
                                   DIRECTION=(0.0, -1.0, 0.0),),
                      INFO=1,
                      VERI_NORM='NON',)

study = code_aster.StudyDescription(MODT, affectMat)
study.addKinematicsLoad(charCine)
study.addMechanicalLoad(CHT1)
dProblem = code_aster.DiscreteProblem(study)
vect_elem = dProblem.buildElementaryMechanicalLoadsVector()
matr_elem = dProblem.computeMechanicalStiffnessMatrix()

monSolver = code_aster.PetscSolver( code_aster.Renumbering.Sans )
monSolver.setPreconditioning(code_aster.Preconditioning.Without)

numeDDL = code_aster.ParallelDOFNumbering()
numeDDL.setElementaryMatrix(matr_elem)
numeDDL.computeNumbering()
test.assertEqual(numeDDL.getType(), "NUME_DDL_P")
#numeDDL.debugPrint()

matrAsse = code_aster.AssemblyMatrixDisplacementReal()
matrAsse.appendElementaryMatrix(matr_elem)
matrAsse.setDOFNumbering(numeDDL)
matrAsse.addKinematicsLoad(charCine)
matrAsse.build()
test.assertEqual(matrAsse.getType(), "MATR_ASSE_DEPL_R")
#matrAsse.debugPrint()

retour = vect_elem.assembleVector( numeDDL )

monSolver.matrixFactorization( matrAsse )
resu = monSolver.solveRealLinearSystem( matrAsse, retour )
    #resu.debugPrint(6)

try:
    import petsc4py
    import code_aster.LinearAlgebra
except ImportError:
    pass
else:
    A = code_aster.LinearAlgebra.AssemblyMatrixToPetsc4Py(matrAsse)
    v = petsc4py.PETSc.Viewer().createASCII("xxParallelMesh002a.out")
    v.pushFormat(petsc4py.PETSc.Viewer.Format.ASCII_DENSE)
    A.view(v)

    rank=A.getComm().getRank()
    print('rank=',rank)
    rs, re = A.getOwnershipRange()
    ce,_ = A.getSize()
    rows = N.array(list(range(rs, re)), dtype=petsc4py.PETSc.IntType)
    cols = N.array(list(range(0, ce)), dtype=petsc4py.PETSc.IntType)
    rows = petsc4py.PETSc.IS().createGeneral(rows, comm=A.getComm())
    cols = petsc4py.PETSc.IS().createGeneral(cols, comm=A.getComm())
    (S,) = A.getSubMatrices(rows, cols)
    v = petsc4py.PETSc.Viewer().createASCII("xxParallelMesh002a_rank"+str(rank)+".out",comm=S.getComm())
    S.view(v)

test.printSummary()

FIN()
