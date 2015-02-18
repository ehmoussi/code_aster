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

    cdef enum Component_Enum:
        cDx         "Dx"
        cDy         "Dy"
        cDz         "Dz"
        cDrx        "Drx"
        cDry        "Dry"
        cDrz        "Drz"
        cPressure   "Pressure"
        cFx         "Fx"
        cFy         "Fy"
        cFz         "Fz"
        cMx         "Mx"
        cMy         "My"
        cMz         "Mz"
        

    cdef cppclass ForceDoubleInstance:
        ForceDoubleInstance()
        void setValue( Component_Enum comp, double val ) except +
        void debugPrint()


    cdef cppclass ForceDoublePtr:

        ForceDoublePtr( ForceDoublePtr& )
        ForceDoublePtr( ForceDoubleInstance * )
        ForceDoubleInstance* get()

cdef class ForceDouble:

    cdef ForceDoublePtr* _cptr

    cdef set( self, ForceDoublePtr other )
    cdef ForceDoublePtr* getPtr( self )
    cdef ForceDoubleInstance* getInstance( self )
