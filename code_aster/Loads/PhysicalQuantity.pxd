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
        Dx, Dy, Dz, Drx, Dry, Drz, Pressure, Fx, Fy, Fz, Mx, My, Mz

#### ForceDouble

    cdef cppclass ForceDoubleInstance:
        ForceDoubleInstance()
        void setValue( PhysicalQuantityComponent comp, double val ) except +
        void debugPrint()

    cdef cppclass ForceDoublePtr:

        ForceDoublePtr( ForceDoublePtr& )
        ForceDoublePtr( ForceDoubleInstance * )
        ForceDoubleInstance* get()

#### ForceAndMomentumDouble

    cdef cppclass ForceAndMomentumDoubleInstance:
        ForceAndMomentumDoubleInstance()
        void setValue( PhysicalQuantityComponent comp, double val ) except +
        void debugPrint()

    cdef cppclass ForceAndMomentumDoublePtr:

        ForceAndMomentumDoublePtr( ForceAndMomentumDoublePtr& )
        ForceAndMomentumDoublePtr( ForceAndMomentumDoubleInstance * )
        ForceAndMomentumDoubleInstance* get()

#### ForceDouble

cdef class ForceDouble:

    cdef ForceDoublePtr* _cptr

    cdef set( self, ForceDoublePtr other )
    cdef ForceDoublePtr* getPtr( self )
    cdef ForceDoubleInstance* getInstance( self )

#### ForceAndMomentumDouble

cdef class ForceAndMomentumDouble:

    cdef ForceAndMomentumDoublePtr* _cptr

    cdef set( self, ForceAndMomentumDoublePtr other )
    cdef ForceAndMomentumDoublePtr* getPtr( self )
    cdef ForceAndMomentumDoubleInstance* getInstance( self )
