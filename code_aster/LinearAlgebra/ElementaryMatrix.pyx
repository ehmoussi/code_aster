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

from code_aster.Modeling.Model cimport Model
from code_aster.Materials.MaterialOnMesh cimport MaterialOnMesh
from code_aster.Loads.MechanicalLoad cimport GenericMechanicalLoad


cdef class ElementaryMatrix:

    """Python wrapper on the C++ ElementaryMatrix object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        if init:
            self._cptr = new ElementaryMatrixPtr( new ElementaryMatrixInstance() )

    def __dealloc__( self ):
        """Destructor"""
        if self._cptr is not NULL:
            del self._cptr

    cdef set( self, ElementaryMatrixPtr other ):
        """Point to an existing object"""
        self._cptr = new ElementaryMatrixPtr( other )

    cdef ElementaryMatrixPtr* getPtr( self ):
        """Return the pointer on the c++ shared-pointer object"""
        return self._cptr

    cdef ElementaryMatrixInstance* getInstance( self ):
        """Return the pointer on the c++ instance object"""
        return self._cptr.get()

    def addMechanicalLoad( self, GenericMechanicalLoad load ):
        """Add the same material on all the mesh"""
        self.getInstance().addMechanicalLoad( deref( load.getPtr() ) )

    def computeMechanicalRigidity( self ):
        """Compute the mechanical rigidity"""
        self.getInstance().computeMechanicalRigidity()

    def setMaterialOnMesh( self, MaterialOnMesh curMatOnMesh ):
        """Set the support mesh"""
        self.getInstance().setMaterialOnMesh( deref( curMatOnMesh.getPtr() ) )

    def setSupportModel( self, Model curModel ):
        """Set the support mesh"""
        self.getInstance().setSupportModel( deref( curModel.getPtr() ) )

    def debugPrint( self, logicalUnit=6 ):
        """Print debug information of the content"""
        self.getInstance().debugPrint( logicalUnit )
