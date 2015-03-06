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

#### ForceDouble

cdef class ForceDouble:
    """Python wrapper on the C++ ForceDouble Object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        if init :
            self._cptr = new ForceDoublePtr( new ForceDoubleInstance() )

    def __dealloc__( self ):
        """Destructor"""
        if self._cptr is not NULL:
            del self._cptr

    cdef set( self, ForceDoublePtr other ):
        """Point to an existing object"""
        self._cptr = new ForceDoublePtr( other )

    cdef ForceDoublePtr* getPtr( self ):
        """Return the pointer on the c++ shared-pointer object"""
        return self._cptr

    cdef ForceDoubleInstance* getInstance( self ):
        """Return the pointer on the c++ instance object"""
        return self._cptr.get()

    def debugPrint( self ):
        """Print debug information of the content"""
        self.getInstance().debugPrint( )

    def setValue( self, component, value ):
        """Define the value of a component of the physical quantity """
        self.getInstance().setValue( component, value )


#####  StructuralForceDouble

cdef class StructuralForceDouble:
    """Python wrapper on the C++ StructuralForceDouble Object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        if init :
            self._cptr = new StructuralForceDoublePtr( new StructuralForceDoubleInstance() )

    def __dealloc__( self ):
        """Destructor"""
        if self._cptr is not NULL:
            del self._cptr

    cdef set( self, StructuralForceDoublePtr other ):
        """Point to an existing object"""
        self._cptr = new StructuralForceDoublePtr( other )

    cdef StructuralForceDoublePtr* getPtr( self ):
        """Return the pointer on the c++ shared-pointer object"""
        return self._cptr

    cdef StructuralForceDoubleInstance* getInstance( self ):
        """Return the pointer on the c++ instance object"""
        return self._cptr.get()

    def debugPrint( self ):
        """Print debug information of the content"""
        self.getInstance().debugPrint( )

    def setValue( self, component, value ):
        """Define the value of a component of the physical quantity """
        self.getInstance().setValue( component, value )

#####  LocalBeamForceDouble

cdef class LocalBeamForceDouble:
    """Python wrapper on the C++ LocalBeamForceDouble Object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        if init :
            self._cptr = new LocalBeamForceDoublePtr( new LocalBeamForceDoubleInstance() )

    def __dealloc__( self ):
        """Destructor"""
        if self._cptr is not NULL:
            del self._cptr

    cdef set( self, LocalBeamForceDoublePtr other ):
        """Point to an existing object"""
        self._cptr = new LocalBeamForceDoublePtr( other )

    cdef LocalBeamForceDoublePtr* getPtr( self ):
        """Return the pointer on the c++ shared-pointer object"""
        return self._cptr

    cdef LocalBeamForceDoubleInstance* getInstance( self ):
        """Return the pointer on the c++ instance object"""
        return self._cptr.get()

    def debugPrint( self ):
        """Print debug information of the content"""
        self.getInstance().debugPrint( )

    def setValue( self, component, value ):
        """Define the value of a component of the physical quantity """
        self.getInstance().setValue( component, value )

#####  LocalShellForceDouble

cdef class LocalShellForceDouble:
    """Python wrapper on the C++ LocalShellForceDouble Object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        if init :
            self._cptr = new LocalShellForceDoublePtr( new LocalShellForceDoubleInstance() )

    def __dealloc__( self ):
        """Destructor"""
        if self._cptr is not NULL:
            del self._cptr

    cdef set( self, LocalShellForceDoublePtr other ):
        """Point to an existing object"""
        self._cptr = new LocalShellForceDoublePtr( other )

    cdef LocalShellForceDoublePtr* getPtr( self ):
        """Return the pointer on the c++ shared-pointer object"""
        return self._cptr

    cdef LocalShellForceDoubleInstance* getInstance( self ):
        """Return the pointer on the c++ instance object"""
        return self._cptr.get()

    def debugPrint( self ):
        """Print debug information of the content"""
        self.getInstance().debugPrint( )

    def setValue( self, component, value ):
        """Define the value of a component of the physical quantity """
        self.getInstance().setValue( component, value )

#####  DisplacementDouble

cdef class DisplacementDouble:
    """Python wrapper on the C++ DisplacementDouble Object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        if init :
            self._cptr = new DisplacementDoublePtr( new DisplacementDoubleInstance() )

    def __dealloc__( self ):
        """Destructor"""
        if self._cptr is not NULL:
            del self._cptr

    cdef set( self, DisplacementDoublePtr other ):
        """Point to an existing object"""
        self._cptr = new DisplacementDoublePtr( other )

    cdef DisplacementDoublePtr* getPtr( self ):
        """Return the pointer on the c++ shared-pointer object"""
        return self._cptr

    cdef DisplacementDoubleInstance* getInstance( self ):
        """Return the pointer on the c++ instance object"""
        return self._cptr.get()

    def debugPrint( self ):
        """Print debug information of the content"""
        self.getInstance().debugPrint( )

    def setValue( self, component, value ):
        """Define the value of a component of the physical quantity """
        self.getInstance().setValue( component, value )


#####  PressureDouble

cdef class PressureDouble:
    """Python wrapper on the C++ PressureDouble Object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        if init :
            self._cptr = new PressureDoublePtr( new PressureDoubleInstance() )

    def __dealloc__( self ):
        """Destructor"""
        if self._cptr is not NULL:
            del self._cptr

    cdef set( self, PressureDoublePtr other ):
        """Point to an existing object"""
        self._cptr = new PressureDoublePtr( other )

    cdef PressureDoublePtr* getPtr( self ):
        """Return the pointer on the c++ shared-pointer object"""
        return self._cptr

    cdef PressureDoubleInstance* getInstance( self ):
        """Return the pointer on the c++ instance object"""
        return self._cptr.get()

    def debugPrint( self ):
        """Print debug information of the content"""
        self.getInstance().debugPrint( )

    def setValue( self, component, value ):
        """Define the value of a component of the physical quantity """
        self.getInstance().setValue( component, value )
