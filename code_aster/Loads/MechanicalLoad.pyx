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
from code_aster.Loads.PhysicalQuantity cimport ForceDouble, ForceAndMomentumDouble
from code_aster.Modeling.Model cimport Model
from code_aster.Supervis.libCommandSyntax cimport CommandSyntax, resultNaming

###### NodalForceDouble

cdef class NodalForceDouble:
    """Python wrapper on the C++ NodalForceDouble Object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        if init:
            self._cptr = new NodalForceDoublePtr ( new NodalForceDoubleInstance() )

    def __dealloc__( self ):
        """Destructor"""
        if self._cptr is not NULL:
            del self._cptr

    cdef set( self, NodalForceDoublePtr other ):
        """Point to an existing object"""
        self._cptr = new NodalForceDoublePtr( other )

    cdef NodalForceDoublePtr* getPtr( self ):
        """Return the pointer on the c++ shared-pointer object"""
        return self._cptr

    cdef NodalForceDoubleInstance* getInstance( self ):
        """Return the pointer on the c++ instance object"""
        return self._cptr.get()

    def build( self ):
        """Build the model"""
        instance = self.getInstance()
        iret = instance.build()
        return iret

    def setSupportModel( self, Model model ):
        """Set the support model of the mechanical load"""
        return self.getInstance().setSupportModel( deref( model.getPtr() ) )

    def setValue( self, ForceDouble force, string nameOfGroup = ""):
        """Set a physical quantity of a Mesh entity"""
        return self.getInstance().setValue( deref( force.getPtr() ), nameOfGroup )


    def debugPrint( self, logicalUnit=6 ):
        """Print debug information of the content"""
        self.getInstance().debugPrint( logicalUnit )


###### NodalForceAndMomentumDouble

cdef class NodalForceAndMomentumDouble:
    """Python wrapper on the C++ NodalForceAndMomentumDouble Object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        if init:
            self._cptr = new NodalForceAndMomentumDoublePtr ( new NodalForceAndMomentumDoubleInstance() )

    def __dealloc__( self ):
        """Destructor"""
        if self._cptr is not NULL:
            del self._cptr

    cdef set( self, NodalForceAndMomentumDoublePtr other ):
        """Point to an existing object"""
        self._cptr = new NodalForceAndMomentumDoublePtr( other )

    cdef NodalForceAndMomentumDoublePtr* getPtr( self ):
        """Return the pointer on the c++ shared-pointer object"""
        return self._cptr

    cdef NodalForceAndMomentumDoubleInstance* getInstance( self ):
        """Return the pointer on the c++ instance object"""
        return self._cptr.get()

    def build( self ):
        """Build the model"""
        instance = self.getInstance()
        iret = instance.build()
        return iret

    def setSupportModel( self, Model model ):
        """Set the support model of the mechanical load"""
        return self.getInstance().setSupportModel( deref( model.getPtr() ) )

    def setValue( self, ForceAndMomentumDouble ForceAndMomentum, string nameOfGroup = ""):
        """Set a physical quantity of a Mesh entity"""
        return self.getInstance().setValue( deref( ForceAndMomentum.getPtr() ), nameOfGroup )


    def debugPrint( self, logicalUnit=6 ):
        """Print debug information of the content"""
        self.getInstance().debugPrint( logicalUnit )

###### ForceOnFaceDouble

cdef class ForceOnFaceDouble:
    """Python wrapper on the C++ ForceOnFaceDouble Object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        if init:
            self._cptr = new ForceOnFaceDoublePtr ( new ForceOnFaceDoubleInstance() )

    def __dealloc__( self ):
        """Destructor"""
        if self._cptr is not NULL:
            del self._cptr

    cdef set( self, ForceOnFaceDoublePtr other ):
        """Point to an existing object"""
        self._cptr = new ForceOnFaceDoublePtr( other )

    cdef ForceOnFaceDoublePtr* getPtr( self ):
        """Return the pointer on the c++ shared-pointer object"""
        return self._cptr

    cdef ForceOnFaceDoubleInstance* getInstance( self ):
        """Return the pointer on the c++ instance object"""
        return self._cptr.get()

    def build( self ):
        """Build the model"""
        instance = self.getInstance()
        iret = instance.build()
        return iret

    def setSupportModel( self, Model model ):
        """Set the support model of the mechanical load"""
        return self.getInstance().setSupportModel( deref( model.getPtr() ) )

    def setValue( self, ForceDouble Force, string nameOfGroup = ""):
        """Set a physical quantity of a Mesh entity"""
        return self.getInstance().setValue( deref( Force.getPtr() ), nameOfGroup )


    def debugPrint( self, logicalUnit=6 ):
        """Print debug information of the content"""
        self.getInstance().debugPrint( logicalUnit )

###### ForceAndMomentumOnEdgeDouble

cdef class ForceAndMomentumOnEdgeDouble:
    """Python wrapper on the C++ ForceAndMomentumOnEdgeDouble Object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        if init:
            self._cptr = new ForceAndMomentumOnEdgeDoublePtr ( new ForceAndMomentumOnEdgeDoubleInstance() )

    def __dealloc__( self ):
        """Destructor"""
        if self._cptr is not NULL:
            del self._cptr

    cdef set( self, ForceAndMomentumOnEdgeDoublePtr other ):
        """Point to an existing object"""
        self._cptr = new ForceAndMomentumOnEdgeDoublePtr( other )

    cdef ForceAndMomentumOnEdgeDoublePtr* getPtr( self ):
        """Return the pointer on the c++ shared-pointer object"""
        return self._cptr

    cdef ForceAndMomentumOnEdgeDoubleInstance* getInstance( self ):
        """Return the pointer on the c++ instance object"""
        return self._cptr.get()

    def build( self ):
        """Build the model"""
        instance = self.getInstance()
        iret = instance.build()
        return iret

    def setSupportModel( self, Model model ):
        """Set the support model of the mechanical load"""
        return self.getInstance().setSupportModel( deref( model.getPtr() ) )

    def setValue( self, ForceAndMomentumDouble Force, string nameOfGroup = ""):
        """Set a physical quantity of a Mesh entity"""
        return self.getInstance().setValue( deref( Force.getPtr() ), nameOfGroup )


    def debugPrint( self, logicalUnit=6 ):
        """Print debug information of the content"""
        self.getInstance().debugPrint( logicalUnit )

