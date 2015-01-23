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

from cMesh cimport cMesh
from code_aster.DataFields.cFieldOnNodes cimport cFieldOnNodesDouble

from code_aster.DataFields.FieldOnNodes cimport FieldOnNodesDouble


cdef class Mesh:
    """Python wrapper on the C++ Mesh object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        self._cptr = new cMesh( init )

    cdef cMesh* get_pointer( self ):
        """Return the pointer on the c++ object"""
        return self._cptr

    cdef copy( self, cMesh& other ):
        """Refer to an existing C++ object"""
        self._cptr.copy( other )

    def __dealloc__( self ):
        """Destructor"""
        if self._cptr:
            del self._cptr

    def isEmpty( self ):
        """Tell if the object is empty"""
        return self._cptr.isEmpty()

    def getCoordinates(self):
        """Return the coordinates as a FieldOnNodesDouble object"""
        cdef cFieldOnNodesDouble coord
        coord = self._cptr.getInstance().getCoordinates()
        coordinates = FieldOnNodesDouble()
        coordinates.copy( coord )
        return coordinates

    #def hasGroupOfElements( self, string name )
    #def hasGroupOfNodes( self, string name )

    def readMEDFile( self, string pathFichier ):
        """Read a MED file"""
        return self._cptr.getInstance().readMEDFile( pathFichier )
