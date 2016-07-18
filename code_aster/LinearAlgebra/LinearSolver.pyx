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

from libcpp.string cimport string
from cython.operator cimport dereference as deref

from code_aster.DataStructure.DataStructure cimport DataStructure
from code_aster.LinearAlgebra.AssemblyMatrix cimport AssemblyMatrixDouble
from code_aster.DataFields.FieldOnNodes cimport FieldOnNodesDouble


cdef class LinearSolver(DataStructure):
    """Python wrapper on the C++ LinearSolver Object"""

    def __cinit__(self, LinearSolverEnum curLinSolv = MultFront, Renumbering curRenum = Metis,
                   bint init = True):
        """Initialization: stores the pointer to the C++ object"""
        if init :
            self._cptr = new LinearSolverPtr(new LinearSolverInstance(curLinSolv, curRenum))

    def __dealloc__(self):
        """Destructor"""
        if self._cptr is not NULL:
            del self._cptr

    cdef set(self, LinearSolverPtr other):
        """Point to an existing object"""
        self._cptr = new LinearSolverPtr(other)

    cdef LinearSolverPtr* getPtr(self):
        """Return the pointer on the c++ shared-pointer object"""
        return self._cptr

    cdef LinearSolverInstance* getInstance(self):
        """Return the pointer on the c++ instance object"""
        return self._cptr.get()

    def solveDoubleLinearSystem(self, AssemblyMatrixDouble currentMatrix, FieldOnNodesDouble currentRHS):
        """Assembly elementary vector"""
        result = FieldOnNodesDouble()
        result.set(self.getInstance().solveDoubleLinearSystem(
                        deref(currentMatrix.getPtr()),
                        deref(currentRHS.getPtr())))
        return result

    def disablePreprocessing(self):
        """"""
        self.getInstance().disablePreprocessing()

    def setAlgorithm(self, algo):
        self.getInstance().setAlgorithm(algo)

    def setDistributedMatrix(self, matDist):
        self.getInstance().setDistributedMatrix(matDist)

    def setErrorOnMatrixSingularity(self, error):
        self.getInstance().setErrorOnMatrixSingularity(error)

    def setFillingLevel(self, filLevel):
        self.getInstance().setFillingLevel(filLevel)

    def setLagrangeElimination(self, lagrTreat):
        self.getInstance().setLagrangeElimination(lagrTreat)

    def setLowRankSize(self, size):
        self.getInstance().setLowRankSize(size)

    def setLowRankThreshold(self, threshold):
        self.getInstance().setLowRankThreshold(threshold)

    def setMatrixFilter(self, filter):
        self.getInstance().setMatrixFilter(filter)

    def setMatrixType(self, matType):
        self.getInstance().setMatrixType(matType)

    def setMaximumNumberOfIteration(self, number):
        self.getInstance().setMaximumNumberOfIteration(number)

    def setMemoryManagement(self, memManagt):
        self.getInstance().setMemoryManagement(memManagt)

    def setPrecisionMix(self, precMix):
        self.getInstance().setPrecisionMix(precMix)

    def setPreconditioning(self, precond):
        self.getInstance().setPreconditioning(precond)

    def setPreconditioningResidual(self, residual):
        self.getInstance().setPreconditioningResidual(residual)

    def setSolverResidual(self, residual):
        self.getInstance().setSolverResidual(residual)

    def setUpdatePreconditioningParameter(self, value):
        self.getInstance().setUpdatePreconditioningParameter(value)
