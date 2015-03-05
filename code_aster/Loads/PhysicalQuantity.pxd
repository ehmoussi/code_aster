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


cdef extern from "Loads/PhysicalQuantity.h":

    cpdef enum PhysicalQuantityComponent:
        Dx, Dy, Dz, Drx, Dry, Drz, Temp, MiddleTemp, Pres, Fx, Fy, Fz, Mx, My, Mz, N, Vy, Vz, Mt, Mfy, Mfz, F1, F2, F3, Mf1, Mf2

#### ForceDouble

    cdef cppclass ForceDoubleInstance:
        ForceDoubleInstance()
        void setValue( PhysicalQuantityComponent comp, double val ) except +
        void debugPrint()

    cdef cppclass ForceDoublePtr:

        ForceDoublePtr( ForceDoublePtr& )
        ForceDoublePtr( ForceDoubleInstance * )
        ForceDoubleInstance* get()

#### StructuralForceDouble

    cdef cppclass StructuralForceDoubleInstance:
        StructuralForceDoubleInstance()
        void setValue( PhysicalQuantityComponent comp, double val ) except +
        void debugPrint()

    cdef cppclass StructuralForceDoublePtr:

        StructuralForceDoublePtr( StructuralForceDoublePtr& )
        StructuralForceDoublePtr( StructuralForceDoubleInstance * )
        StructuralForceDoubleInstance* get()

#### LocalBeamForceDouble

    cdef cppclass LocalBeamForceDoubleInstance:
        LocalBeamForceDoubleInstance()
        void setValue( PhysicalQuantityComponent comp, double val ) except +
        void debugPrint()

    cdef cppclass LocalBeamForceDoublePtr:

        LocalBeamForceDoublePtr( LocalBeamForceDoublePtr& )
        LocalBeamForceDoublePtr( LocalBeamForceDoubleInstance * )
        LocalBeamForceDoubleInstance* get()


#### LocalShellForceDouble

    cdef cppclass LocalShellForceDoubleInstance:
        LocalShellForceDoubleInstance()
        void setValue( PhysicalQuantityComponent comp, double val ) except +
        void debugPrint()

    cdef cppclass LocalShellForceDoublePtr:

        LocalShellForceDoublePtr( LocalShellForceDoublePtr& )
        LocalShellForceDoublePtr( LocalShellForceDoubleInstance * )
        LocalShellForceDoubleInstance* get()

#### DoubleDisplacement

    cdef cppclass DoubleDisplacementInstance:
        DoubleDisplacementInstance()
        void setValue( PhysicalQuantityComponent comp, double val ) except +
        void debugPrint()

    cdef cppclass DoubleDisplacementPtr:

        DoubleDisplacementPtr( DoubleDisplacementPtr& )
        DoubleDisplacementPtr( DoubleDisplacementInstance * )
        DoubleDisplacementInstance* get()

#### DoublePressure

    cdef cppclass DoublePressureInstance:
        DoublePressureInstance()
        void setValue( PhysicalQuantityComponent comp, double val ) except +
        void debugPrint()

    cdef cppclass DoublePressurePtr:

        DoublePressurePtr( DoublePressurePtr& )
        DoublePressurePtr( DoublePressureInstance * )
        DoublePressureInstance* get()


#### ForceDouble

cdef class ForceDouble:

    cdef ForceDoublePtr* _cptr

    cdef set( self, ForceDoublePtr other )
    cdef ForceDoublePtr* getPtr( self )
    cdef ForceDoubleInstance* getInstance( self )


#### StructuralForceDouble

cdef class StructuralForceDouble:

    cdef StructuralForceDoublePtr* _cptr

    cdef set( self, StructuralForceDoublePtr other )
    cdef StructuralForceDoublePtr* getPtr( self )
    cdef StructuralForceDoubleInstance* getInstance( self )


#### LocalBeamForceDouble

cdef class LocalBeamForceDouble:

    cdef LocalBeamForceDoublePtr* _cptr

    cdef set( self, LocalBeamForceDoublePtr other )
    cdef LocalBeamForceDoublePtr* getPtr( self )
    cdef LocalBeamForceDoubleInstance* getInstance( self )

#### LocalShellForceDouble

cdef class LocalShellForceDouble:

    cdef LocalShellForceDoublePtr* _cptr

    cdef set( self, LocalShellForceDoublePtr other )
    cdef LocalShellForceDoublePtr* getPtr( self )
    cdef LocalShellForceDoubleInstance* getInstance( self )


#### DoubleDisplacement

cdef class DoubleDisplacement:

    cdef DoubleDisplacementPtr* _cptr

    cdef set( self, DoubleDisplacementPtr other )
    cdef DoubleDisplacementPtr* getPtr( self )
    cdef DoubleDisplacementInstance* getInstance( self )


#### DoublePressure

cdef class DoublePressure:

    cdef DoublePressurePtr* _cptr

    cdef set( self, DoublePressurePtr other )
    cdef DoublePressurePtr* getPtr( self )
    cdef DoublePressureInstance* getInstance( self )
