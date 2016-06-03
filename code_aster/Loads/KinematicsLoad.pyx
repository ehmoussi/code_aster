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

from code_aster.DataStructure.DataStructure cimport DataStructure
from code_aster.Modeling.Model cimport Model
from code_aster.Supervis.libCommandSyntax cimport CommandSyntax, resultNaming


cdef class KinematicsLoad( DataStructure ):
    """Python wrapper on the C++ KinematicsLoad object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        if init:
            self._cptr = new KinematicsLoadPtr( new KinematicsLoadInstance() )

    def __dealloc__( self ):
        """Destructor"""
        if self._cptr is not NULL:
            del self._cptr

    def addImposedMechanicalDOFOnElements( self, coordinate, value, nameOfGroup ):
        """Add an imposed mechanical degree of freedom on a group of elements"""
        self.getInstance().addImposedMechanicalDOFOnElements( coordinate, value, nameOfGroup )

    def addImposedMechanicalDOFOnNodes( self, coordinate, value, nameOfGroup ):
        """Add an imposed mechanical degree of freedom on a group of nodes"""
        self.getInstance().addImposedMechanicalDOFOnNodes( coordinate, value, nameOfGroup )

    def addImposedThermalDOFOnElements( self, coordinate, value, nameOfGroup ):
        """Add an imposed thermal degree of freedom on a group of elements"""
        self.getInstance().addImposedThermalDOFOnElements( coordinate, value, nameOfGroup )

    def addImposedThermalDOFOnNodes( self, coordinate, value, nameOfGroup ):
        """Add an imposed thermal degree of freedom on a group of nodes"""
        self.getInstance().addImposedThermalDOFOnNodes( coordinate, value, nameOfGroup )

    def build( self ):
        """Build the load"""
        instance = self.getInstance()
        iret = instance.build()
        return iret

    def debugPrint( self, logicalUnit=6 ):
        """Print debug information of the content"""
        self.getInstance().debugPrint( logicalUnit )

    cdef KinematicsLoadInstance* getInstance( self ):
        """Return the pointer on the c++ instance object"""
        return self._cptr.get()

    cdef KinematicsLoadPtr* getPtr( self ):
        """Return the pointer on the c++ shared-pointer object"""
        return self._cptr

    cdef set( self, KinematicsLoadPtr other ):
        """Point to an existing object"""
        self._cptr = new KinematicsLoadPtr( other )

    def setSupportModel( self, Model model ):
        """Set the support model of the load"""
        return self.getInstance().setSupportModel( deref( model.getPtr() ) )
