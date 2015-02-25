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


#####  ForceAndMomentumDouble

cdef class ForceAndMomentumDouble:
    """Python wrapper on the C++ ForceAndMomentumDouble Object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        if init :
            self._cptr = new ForceAndMomentumDoublePtr( new ForceAndMomentumDoubleInstance() )

    def __dealloc__( self ):
        """Destructor"""
        if self._cptr is not NULL:
            del self._cptr

    cdef set( self, ForceAndMomentumDoublePtr other ):
        """Point to an existing object"""
        self._cptr = new ForceAndMomentumDoublePtr( other )

    cdef ForceAndMomentumDoublePtr* getPtr( self ):
        """Return the pointer on the c++ shared-pointer object"""
        return self._cptr

    cdef ForceAndMomentumDoubleInstance* getInstance( self ):
        """Return the pointer on the c++ instance object"""
        return self._cptr.get()

    def debugPrint( self ):
        """Print debug information of the content"""
        self.getInstance().debugPrint( )

    def setValue( self, component, value ):
        """Define the value of a component of the physical quantity """
        self.getInstance().setValue( component, value )


#####  DoubleDisplacement

cdef class DoubleDisplacement:
    """Python wrapper on the C++ DoubleDisplacement Object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        if init :
            self._cptr = new DoubleDisplacementPtr( new DoubleDisplacementInstance() )

    def __dealloc__( self ):
        """Destructor"""
        if self._cptr is not NULL:
            del self._cptr

    cdef set( self, DoubleDisplacementPtr other ):
        """Point to an existing object"""
        self._cptr = new DoubleDisplacementPtr( other )

    cdef DoubleDisplacementPtr* getPtr( self ):
        """Return the pointer on the c++ shared-pointer object"""
        return self._cptr

    cdef DoubleDisplacementInstance* getInstance( self ):
        """Return the pointer on the c++ instance object"""
        return self._cptr.get()

    def debugPrint( self ):
        """Print debug information of the content"""
        self.getInstance().debugPrint( )

    def setValue( self, component, value ):
        """Define the value of a component of the physical quantity """
        self.getInstance().setValue( component, value )


#####  DoublePressure

cdef class DoublePressure:
    """Python wrapper on the C++ DoublePressure Object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        if init :
            self._cptr = new DoublePressurePtr( new DoublePressureInstance() )

    def __dealloc__( self ):
        """Destructor"""
        if self._cptr is not NULL:
            del self._cptr

    cdef set( self, DoublePressurePtr other ):
        """Point to an existing object"""
        self._cptr = new DoublePressurePtr( other )

    cdef DoublePressurePtr* getPtr( self ):
        """Return the pointer on the c++ shared-pointer object"""
        return self._cptr

    cdef DoublePressureInstance* getInstance( self ):
        """Return the pointer on the c++ instance object"""
        return self._cptr.get()

    def debugPrint( self ):
        """Print debug information of the content"""
        self.getInstance().debugPrint( )

    def setValue( self, component, value ):
        """Define the value of a component of the physical quantity """
        self.getInstance().setValue( component, value )
