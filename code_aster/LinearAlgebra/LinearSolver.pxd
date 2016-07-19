# coding: utf-8

# Copyright (C) 1991 - 2015  EDF R&D                www.code-aster.org
#
# This file is part of Code_Aster.
#
# Code_Aster is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 2 of the License, or
# (at your option) any later version.
#
# Code_Aster is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Code_Aster.  If not, see <http://www.gnu.org/licenses/>.

from code_aster.DataStructure.DataStructure cimport DataStructure
from code_aster.LinearAlgebra.AssemblyMatrix cimport AssemblyMatrixDoublePtr
from code_aster.DataFields.FieldOnNodes cimport FieldOnNodesDoublePtr


cdef extern from "LinearAlgebra/AllowedLinearSolver.h":

    cpdef enum LinearSolverEnum:
        MultFront, Ldlt, Mumps, Petsc, Gcpc

    cpdef enum Renumbering:
        MD, MDA, Metis, RCMK, AMD, AMF, PORD, QAMD, Scotch, Auto, Sans

    cpdef enum Preconditioning:
        IncompleteLdlt, SimplePrecisionLdlt, Jacobi, Sor, Ml, Boomer, Gamg, LagrBloc, Without

    cpdef enum IterativeSolverAlgorithm:
        ConjugateGradiant, ConjugateResidual, GMRes, GCR, FGMRes

    cpdef enum LagrangeTreatment:
        Eliminate, NotEliminate, DoubleLagrangeEliminate

    cpdef enum MemoryManagement:
         InCore, OutOfCore, Automatic, Evaluation

    cpdef enum MatrixType:
        NonSymetric, Symetric, SymetricPositiveDefinite, Undefined

cdef extern from "LinearAlgebra/LinearSolver.h":

    cdef cppclass LinearSolverInstance:

        LinearSolverInstance(LinearSolverEnum curLinSolv, Renumbering curRenum)
        FieldOnNodesDoublePtr solveDoubleLinearSystem(const AssemblyMatrixDoublePtr& currentMatrix,
                                                       const FieldOnNodesDoublePtr& currentRHS)
        void disablePreprocessing()
        void setAlgorithm(IterativeSolverAlgorithm algo)
        void setDistributedMatrix(bint matDist)
        void setErrorOnMatrixSingularity(bint error)
        void setFillingLevel(int filLevel)
        void setLagrangeElimination(LagrangeTreatment lagrTreat)
        void setLowRankSize(double size)
        void setLowRankThreshold(double threshold)
        void setMatrixFilter(double filter)
        void setMatrixType(MatrixType matType)
        void setMaximumNumberOfIteration(int number)
        void setMemoryManagement(MemoryManagement memManagt)
        void setPrecisionMix(bint precMix)
        void setPreconditioning(Preconditioning precond)
        void setPreconditioningResidual(double residual)
        void setSolverResidual(double residual)
        void setUpdatePreconditioningParameter(int value)

    cdef cppclass LinearSolverPtr:

        LinearSolverPtr(LinearSolverPtr&)
        LinearSolverPtr(LinearSolverInstance*)
        LinearSolverInstance* get()

#### LinearSolver

cdef class LinearSolver(DataStructure):

    cdef LinearSolverPtr* _cptr

    cdef set(self, LinearSolverPtr other)
    cdef LinearSolverPtr* getPtr(self)
    cdef LinearSolverInstance* getInstance(self)
