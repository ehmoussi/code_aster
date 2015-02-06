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


cdef class GeneralMaterialBehaviour:

    """Python wrapper on the C++ GeneralMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        if init:
            self._cptr = new GeneralMaterialBehaviourPtr( \
                                new GeneralMaterialBehaviourInstance() )

    def __dealloc__( self ):
        """Destructor"""
        # subclassing, see https://github.com/cython/cython/wiki/WrappingSetOfCppClasses
        cdef GeneralMaterialBehaviourPtr* tmp
        if self._cptr is not NULL:
            tmp = <GeneralMaterialBehaviourPtr *>self._cptr
            del tmp
            self._cptr = NULL

    cdef set( self, GeneralMaterialBehaviourPtr other ):
        """Point to an existing object"""
        # set must be subclassed if it is necessary
        self._cptr = new GeneralMaterialBehaviourPtr( other )

    cdef GeneralMaterialBehaviourPtr* getPtr( self ):
        """Return the pointer on the c++ shared-pointer object"""
        return self._cptr

    cdef GeneralMaterialBehaviourInstance* getInstance( self ):
        """Return the pointer on the c++ instance object"""
        return self._cptr.get()

    def setDoubleValue( self, property, value ):
        """Define the value of a material property"""
        return self.getInstance().setDoubleValue( property, value )


cdef class ElasticMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ ElasticMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new ElasticMaterialBehaviourPtr( new ElasticMaterialBehaviourInstance() )
