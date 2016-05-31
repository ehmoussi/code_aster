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
from cython.operator cimport dereference as deref

#from code_aster.Mesh.Mesh cimport Mesh


cdef class ImposedTemperature:
    """Python wrapper on the C++ ImposedTemperature object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        if init:
            self._cptr = new ImposedTemperaturePtr( new ImposedTemperatureInstance() )

    def __dealloc__( self ):
        """Destructor"""
        if self._cptr is not NULL:
            del self._cptr

    cdef set( self, ImposedTemperaturePtr other ):
        """Point to an existing object"""
        self._cptr = new ImposedTemperaturePtr( other )

    cdef ImposedTemperaturePtr* getPtr( self ):
        """Return the pointer on the c++ shared-pointer object"""
        return self._cptr

    cdef ImposedTemperatureInstance* getInstance( self ):
        """Return the pointer on the c++ instance object"""
        return self._cptr.get()

    def addGroupOfNodes( self, nameOfGroup ):
        """Add a modeling on all the mesh"""
        print "coucou2"
        self.getInstance().addGroupOfNodes( nameOfGroup )

    #def debugPrint( self, logicalUnit=6 ):
        #"""Print debug information of the content"""
        #self.getInstance().debugPrint( logicalUnit )
