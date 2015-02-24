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


cdef class GenericMechanicalLoad:

    """Python wrapper on the C++ GenericMechanicalLoad object"""

    def __cinit__( self ):
        """Initialization: stores the pointer to the C++ object"""
        pass

    def __dealloc__( self ):
        """Destructor"""
        # subclassing, see https://github.com/cython/cython/wiki/WrappingSetOfCppClasses
        cdef GenericMechanicalLoadPtr* tmp
        if self._cptr is not NULL:
            tmp = <GenericMechanicalLoadPtr *>self._cptr
            del tmp
            self._cptr = NULL

    cdef set( self, GenericMechanicalLoadPtr other ):
        """Point to an existing object"""
        # set must be subclassed if it is necessary
        self._cptr = new GenericMechanicalLoadPtr( other )

    cdef GenericMechanicalLoadPtr* getPtr( self ):
        """Return the pointer on the c++ shared-pointer object"""
        return self._cptr

    cdef GenericMechanicalLoadInstance* getInstance( self ):
        """Return the pointer on the c++ instance object"""
        return self._cptr.get()


###### NodalForceDouble

cdef class NodalForceDouble( GenericMechanicalLoad ):
    """Python wrapper on the C++ NodalForceDouble Object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        if init:
            self._cptr = <GenericMechanicalLoadPtr *>\
                new NodalForceDoublePtr ( new NodalForceDoubleInstance() )

    def build( self ):
        """Build the model"""
        instance = <NodalForceDoubleInstance*> self.getInstance()
        iret = instance.build()
        return iret

    def setSupportModel( self, Model model ):
        """Set the support model of the mechanical load"""
        return self.getInstance().setSupportModel( deref( model.getPtr() ) )

    def setValue( self, ForceDouble force, string nameOfGroup = ""):
        """Set a physical quantity of a Mesh entity"""
        instance = <NodalForceDoubleInstance*> self.getInstance()
        return instance.setValue( deref( force.getPtr() ), nameOfGroup )


    def debugPrint( self, logicalUnit=6 ):
        """Print debug information of the content"""
        self.getInstance().debugPrint( logicalUnit )


###### NodalForceAndMomentumDouble

cdef class NodalForceAndMomentumDouble( GenericMechanicalLoad ):
    """Python wrapper on the C++ NodalForceAndMomentumDouble Object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        if init:
            self._cptr = <GenericMechanicalLoadPtr *>\
                new NodalForceAndMomentumDoublePtr ( new NodalForceAndMomentumDoubleInstance() )

    def build( self ):
        """Build the model"""
        instance = <NodalForceAndMomentumDoubleInstance*> self.getInstance()
        iret = instance.build()
        return iret

    def setSupportModel( self, Model model ):
        """Set the support model of the mechanical load"""
        return self.getInstance().setSupportModel( deref( model.getPtr() ) )

    def setValue( self, ForceAndMomentumDouble ForceAndMomentum, string nameOfGroup = ""):
        """Set a physical quantity of a Mesh entity"""
        instance = <NodalForceAndMomentumDoubleInstance*> self.getInstance()
        return instance.setValue( deref( ForceAndMomentum.getPtr() ), nameOfGroup )


    def debugPrint( self, logicalUnit=6 ):
        """Print debug information of the content"""
        self.getInstance().debugPrint( logicalUnit )

###### ForceOnFaceDouble

cdef class ForceOnFaceDouble( GenericMechanicalLoad ):
    """Python wrapper on the C++ ForceOnFaceDouble Object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        if init:
            self._cptr = <GenericMechanicalLoadPtr *>\
                new ForceOnFaceDoublePtr ( new ForceOnFaceDoubleInstance() )

    def build( self ):
        """Build the model"""
        instance = <ForceOnFaceDoubleInstance*> self.getInstance()
        iret = instance.build()
        return iret

    def setSupportModel( self, Model model ):
        """Set the support model of the mechanical load"""
        return self.getInstance().setSupportModel( deref( model.getPtr() ) )

    def setValue( self, ForceDouble Force, string nameOfGroup = ""):
        """Set a physical quantity of a Mesh entity"""
        instance = <ForceOnFaceDoubleInstance*> self.getInstance()
        return instance.setValue( deref( Force.getPtr() ), nameOfGroup )


    def debugPrint( self, logicalUnit=6 ):
        """Print debug information of the content"""
        self.getInstance().debugPrint( logicalUnit )

###### ForceAndMomentumOnEdgeDouble

cdef class ForceAndMomentumOnEdgeDouble( GenericMechanicalLoad ):
    """Python wrapper on the C++ ForceAndMomentumOnEdgeDouble Object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        if init:
            self._cptr = <GenericMechanicalLoadPtr *>\
                new ForceAndMomentumOnEdgeDoublePtr ( new ForceAndMomentumOnEdgeDoubleInstance() )

    def build( self ):
        """Build the model"""
        instance = <ForceAndMomentumOnEdgeDoubleInstance*> self.getInstance()
        iret = instance.build()
        return iret

    def setSupportModel( self, Model model ):
        """Set the support model of the mechanical load"""
        return self.getInstance().setSupportModel( deref( model.getPtr() ) )

    def setValue( self, ForceAndMomentumDouble Force, string nameOfGroup = ""):
        """Set a physical quantity of a Mesh entity"""
        instance = <ForceAndMomentumOnEdgeDoubleInstance*> self.getInstance()
        return instance.setValue( deref( Force.getPtr() ), nameOfGroup )


    def debugPrint( self, logicalUnit=6 ):
        """Print debug information of the content"""
        self.getInstance().debugPrint( logicalUnit )

###### LineicForceAndMomentumDouble

cdef class LineicForceAndMomentumDouble( GenericMechanicalLoad ):
    """Python wrapper on the C++ LineicForceAndMomentumDouble Object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        if init:
            self._cptr = <GenericMechanicalLoadPtr *>\
                new LineicForceAndMomentumDoublePtr ( new LineicForceAndMomentumDoubleInstance() )

    def build( self ):
        """Build the model"""
        instance = <LineicForceAndMomentumDoubleInstance*>self.getInstance()
        iret = instance.build()
        return iret

    def setSupportModel( self, Model model ):
        """Set the support model of the mechanical load"""
        return self.getInstance().setSupportModel( deref( model.getPtr() ) )

    def setValue( self, ForceAndMomentumDouble Force, string nameOfGroup = ""):
        """Set a physical quantity of a Mesh entity"""
        instance = <LineicForceAndMomentumDoubleInstance*>self.getInstance()
        return instance.setValue( deref( Force.getPtr() ), nameOfGroup )


    def debugPrint( self, logicalUnit=6 ):
        """Print debug information of the content"""
        self.getInstance().debugPrint( logicalUnit )

###### InternalForceDouble

cdef class InternalForceDouble( GenericMechanicalLoad ):
    """Python wrapper on the C++ InternalForceDouble Object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        if init:
            self._cptr = <GenericMechanicalLoadPtr *>\
                new InternalForceDoublePtr ( new InternalForceDoubleInstance() )

    def build( self ):
        """Build the model"""
        instance = <InternalForceDoubleInstance*>self.getInstance()
        iret = instance.build()
        return iret

    def setSupportModel( self, Model model ):
        """Set the support model of the mechanical load"""
        return self.getInstance().setSupportModel( deref( model.getPtr() ) )

    def setValue( self, ForceDouble force, string nameOfGroup = ""):
        """Set a physical quantity of a Mesh entity"""
        instance = <InternalForceDoubleInstance*>self.getInstance()
        return instance.setValue( deref( force.getPtr() ), nameOfGroup )


    def debugPrint( self, logicalUnit=6 ):
        """Print debug information of the content"""
        self.getInstance().debugPrint( logicalUnit )

###### ForceAndMomentumOnBeamDouble

cdef class ForceAndMomentumOnBeamDouble( GenericMechanicalLoad ):
    """Python wrapper on the C++ ForceAndMomentumOnBeamDouble Object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        if init:
            self._cptr = <GenericMechanicalLoadPtr *>\
                new ForceAndMomentumOnBeamDoublePtr ( new ForceAndMomentumOnBeamDoubleInstance() )

    def build( self ):
        """Build the model"""
        instance = <ForceAndMomentumOnBeamDoubleInstance*>self.getInstance()
        iret = instance.build()
        return iret

    def setSupportModel( self, Model model ):
        """Set the support model of the mechanical load"""
        return self.getInstance().setSupportModel( deref( model.getPtr() ) )

    def setValue( self, ForceAndMomentumDouble Force, string nameOfGroup = ""):
        """Set a physical quantity of a Mesh entity"""
        instance = <ForceAndMomentumOnBeamDoubleInstance*>self.getInstance()
        return instance.setValue( deref( Force.getPtr() ), nameOfGroup )


    def debugPrint( self, logicalUnit=6 ):
        """Print debug information of the content"""
        self.getInstance().debugPrint( logicalUnit )
