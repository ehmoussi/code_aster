# coding: utf-8

# Copyright (C) 1991 - 2016  EDF R&D                www.code-aster.org
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
from libcpp.vector cimport vector

from code_aster.DataStructure.DataStructure cimport DataStructure
from code_aster.Results.MechanicalModeContainer cimport MechanicalModeContainerPtr, MechanicalModeContainer
from .LinearSolver cimport LinearSolverPtr
from .StructureInterface cimport StructureInterfacePtr
from .AssemblyMatrix cimport AssemblyMatrixDoublePtr, AssemblyMatrixComplexPtr
from code_aster.Discretization.DOFNumbering cimport DOFNumberingPtr

cdef extern from "LinearAlgebra/ModalBasisDefinition.h":

    ctypedef vector[int] VectorInt
    ctypedef vector[double] VectorDouble
    ctypedef vector[MechanicalModeContainerPtr] VectorOfMechaModePtr
    #ctypedef vector[MechanicalModeContainer] VectorOfMechaMode

    cdef cppclass GenericModalBasisInstance:

        GenericModalBasisInstance()
        bint build()
        void setLinearSolver(const LinearSolverPtr& solver)

    cdef cppclass GenericModalBasisPtr:

        GenericModalBasisPtr(GenericModalBasisPtr&)
        GenericModalBasisPtr(GenericModalBasisInstance*)
        GenericModalBasisInstance* get()

    cdef cppclass StandardModalBasisInstance(GenericModalBasisInstance):

        StandardModalBasisInstance()
        void setModalBasis(const StructureInterfacePtr& structInterf,
                           const VectorOfMechaModePtr& vecOfMechaMode,
                           const VectorInt& vecOfInt)
        #void setModalBasis(const StructureInterfacePtr& structInterf,
                           #const MechanicalModeContainerPtr& mechaMode,
                           #const VectorInt& vecOfInt)

    cdef cppclass StandardModalBasisPtr:

        StandardModalBasisPtr(StandardModalBasisPtr&)
        StandardModalBasisPtr(StandardModalBasisInstance*)
        StandardModalBasisInstance* get()

    cdef cppclass RitzBasisInstance(GenericModalBasisInstance):

        RitzBasisInstance()
        void addModalBasis(const GenericModalBasisPtr& basis,
                           const VectorInt& vecOfInt)
        void addModalBasis(const VectorOfMechaModePtr& vecOfMechaMode,
                           const VectorInt& vecOfInt)
        void addModalBasis(const MechanicalModeContainerPtr& interf,
                           const VectorInt& vecOfInt)
        void reorthonormalising(const AssemblyMatrixComplexPtr& matr)
        void reorthonormalising(const AssemblyMatrixDoublePtr& matr)
        void setListOfModalDamping(const VectorDouble& vec)
        void setStructureInterface(const StructureInterfacePtr& interf)
        void setReferenceDOFNumbering(const DOFNumberingPtr& dofNum)

    cdef cppclass RitzBasisPtr:

        RitzBasisPtr(RitzBasisPtr&)
        RitzBasisPtr(RitzBasisInstance*)
        RitzBasisInstance* get()

    cdef cppclass OrthonormalizedBasisInstance(GenericModalBasisInstance):

        OrthonormalizedBasisInstance(const MechanicalModeContainerPtr& basis,
                                     const AssemblyMatrixDoublePtr& matr)
        OrthonormalizedBasisInstance(const MechanicalModeContainerPtr& basis,
                                     const AssemblyMatrixComplexPtr& matr)

    cdef cppclass OrthonormalizedBasisPtr:

        OrthonormalizedBasisPtr(OrthonormalizedBasisPtr&)
        OrthonormalizedBasisPtr(OrthonormalizedBasisInstance*)
        OrthonormalizedBasisInstance* get()

    cdef cppclass OrthogonalBasisWithoutMassInstance(GenericModalBasisInstance):

        OrthogonalBasisWithoutMassInstance(const MechanicalModeContainerPtr& basis,
                                           const VectorOfMechaModePtr& vec )

    cdef cppclass OrthogonalBasisWithoutMassPtr:

        OrthogonalBasisWithoutMassPtr(OrthogonalBasisWithoutMassPtr&)
        OrthogonalBasisWithoutMassPtr(OrthogonalBasisWithoutMassInstance*)
        OrthogonalBasisWithoutMassInstance* get()

#### GenericModalBasis

cdef class GenericModalBasis(DataStructure):

    cdef GenericModalBasisPtr* _cptr

    cdef set(self, GenericModalBasisPtr other)
    cdef GenericModalBasisPtr* getPtr(self)
    cdef GenericModalBasisInstance* getInstance(self)

#### StandardModalBasis

cdef class StandardModalBasis(GenericModalBasis):
    pass

#### RitzBasis

cdef class RitzBasis(GenericModalBasis):
    pass

#### OrthonormalizedBasis

cdef class OrthonormalizedBasis(GenericModalBasis):
    pass

#### OrthogonalBasisWithoutMass

cdef class OrthogonalBasisWithoutMass(GenericModalBasis):
    pass
