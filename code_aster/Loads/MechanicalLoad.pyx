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
from code_aster.Loads.PhysicalQuantity cimport ForceDouble, StructuralForceDouble, LocalBeamForceDouble, LocalShellForceDouble
from code_aster.Loads.PhysicalQuantity cimport DisplacementDouble, PressureDouble
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


###### NodalStructuralForceDouble

cdef class NodalStructuralForceDouble( GenericMechanicalLoad ):
    """Python wrapper on the C++ NodalStructuralForceDouble Object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        if init:
            self._cptr = <GenericMechanicalLoadPtr *>\
                new NodalStructuralForceDoublePtr ( new NodalStructuralForceDoubleInstance() )

    def build( self ):
        """Build the model"""
        instance = <NodalStructuralForceDoubleInstance*> self.getInstance()
        iret = instance.build()
        return iret

    def setSupportModel( self, Model model ):
        """Set the support model of the mechanical load"""
        return self.getInstance().setSupportModel( deref( model.getPtr() ) )

    def setValue( self, StructuralForceDouble StructuralForce, string nameOfGroup = ""):
        """Set a physical quantity of a Mesh entity"""
        instance = <NodalStructuralForceDoubleInstance*> self.getInstance()
        return instance.setValue( deref( StructuralForce.getPtr() ), nameOfGroup )


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


###### ForceOnEdgeDouble

cdef class ForceOnEdgeDouble( GenericMechanicalLoad ):
    """Python wrapper on the C++ ForceOnEdgeDouble Object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        if init:
            self._cptr = <GenericMechanicalLoadPtr *>\
                new ForceOnEdgeDoublePtr ( new ForceOnEdgeDoubleInstance() )

    def build( self ):
        """Build the model"""
        instance = <ForceOnEdgeDoubleInstance*> self.getInstance()
        iret = instance.build()
        return iret

    def setSupportModel( self, Model model ):
        """Set the support model of the mechanical load"""
        return self.getInstance().setSupportModel( deref( model.getPtr() ) )

    def setValue( self, ForceDouble Force, string nameOfGroup = ""):
        """Set a physical quantity of a Mesh entity"""
        instance = <ForceOnEdgeDoubleInstance*> self.getInstance()
        return instance.setValue( deref( Force.getPtr() ), nameOfGroup )


    def debugPrint( self, logicalUnit=6 ):
        """Print debug information of the content"""
        self.getInstance().debugPrint( logicalUnit )


###### StructuralForceOnEdgeDouble

cdef class StructuralForceOnEdgeDouble( GenericMechanicalLoad ):
    """Python wrapper on the C++ StructuralForceOnEdgeDouble Object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        if init:
            self._cptr = <GenericMechanicalLoadPtr *>\
                new StructuralForceOnEdgeDoublePtr ( new StructuralForceOnEdgeDoubleInstance() )

    def build( self ):
        """Build the model"""
        instance = <StructuralForceOnEdgeDoubleInstance*> self.getInstance()
        iret = instance.build()
        return iret

    def setSupportModel( self, Model model ):
        """Set the support model of the mechanical load"""
        return self.getInstance().setSupportModel( deref( model.getPtr() ) )

    def setValue( self, StructuralForceDouble Force, string nameOfGroup = ""):
        """Set a physical quantity of a Mesh entity"""
        instance = <StructuralForceOnEdgeDoubleInstance*> self.getInstance()
        return instance.setValue( deref( Force.getPtr() ), nameOfGroup )


    def debugPrint( self, logicalUnit=6 ):
        """Print debug information of the content"""
        self.getInstance().debugPrint( logicalUnit )


###### LineicForceDouble

cdef class LineicForceDouble( GenericMechanicalLoad ):
    """Python wrapper on the C++ LineicForceDouble Object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        if init:
            self._cptr = <GenericMechanicalLoadPtr *>\
                new LineicForceDoublePtr ( new LineicForceDoubleInstance() )

    def build( self ):
        """Build the model"""
        instance = <LineicForceDoubleInstance*>self.getInstance()
        iret = instance.build()
        return iret

    def setSupportModel( self, Model model ):
        """Set the support model of the mechanical load"""
        return self.getInstance().setSupportModel( deref( model.getPtr() ) )

    def setValue( self, ForceDouble Force, string nameOfGroup = ""):
        """Set a physical quantity of a Mesh entity"""
        instance = <LineicForceDoubleInstance*>self.getInstance()
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


###### StructuralForceOnBeamDouble

cdef class StructuralForceOnBeamDouble( GenericMechanicalLoad ):
    """Python wrapper on the C++ StructuralForceOnBeamDouble Object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        if init:
            self._cptr = <GenericMechanicalLoadPtr *>\
                new StructuralForceOnBeamDoublePtr ( new StructuralForceOnBeamDoubleInstance() )

    def build( self ):
        """Build the model"""
        instance = <StructuralForceOnBeamDoubleInstance*>self.getInstance()
        iret = instance.build()
        return iret

    def setSupportModel( self, Model model ):
        """Set the support model of the mechanical load"""
        return self.getInstance().setSupportModel( deref( model.getPtr() ) )

    def setValue( self, StructuralForceDouble Force, string nameOfGroup = ""):
        """Set a physical quantity of a Mesh entity"""
        instance = <StructuralForceOnBeamDoubleInstance*>self.getInstance()
        return instance.setValue( deref( Force.getPtr() ), nameOfGroup )


    def debugPrint( self, logicalUnit=6 ):
        """Print debug information of the content"""
        self.getInstance().debugPrint( logicalUnit )


###### LocalForceOnBeamDouble

cdef class LocalForceOnBeamDouble( GenericMechanicalLoad ):
    """Python wrapper on the C++ LocalForceOnBeamDouble Object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        if init:
            self._cptr = <GenericMechanicalLoadPtr *>\
                new LocalForceOnBeamDoublePtr ( new LocalForceOnBeamDoubleInstance() )

    def build( self ):
        """Build the model"""
        instance = <LocalForceOnBeamDoubleInstance*>self.getInstance()
        iret = instance.build()
        return iret

    def setSupportModel( self, Model model ):
        """Set the support model of the mechanical load"""
        return self.getInstance().setSupportModel( deref( model.getPtr() ) )

    def setValue( self, LocalBeamForceDouble Force, string nameOfGroup = ""):
        """Set a physical quantity of a Mesh entity"""
        instance = <LocalForceOnBeamDoubleInstance*>self.getInstance()
        return instance.setValue( deref( Force.getPtr() ), nameOfGroup )

    def debugPrint( self, logicalUnit=6 ):
        """Print debug information of the content"""
        self.getInstance().debugPrint( logicalUnit )

###### StructuralForceOnShellDouble

cdef class StructuralForceOnShellDouble( GenericMechanicalLoad ):
    """Python wrapper on the C++ StructuralForceOnShellDouble Object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        if init:
            self._cptr = <GenericMechanicalLoadPtr *>\
                new StructuralForceOnShellDoublePtr ( new StructuralForceOnShellDoubleInstance() )

    def build( self ):
        """Build the model"""
        instance = <StructuralForceOnShellDoubleInstance*>self.getInstance()
        iret = instance.build()
        return iret

    def setSupportModel( self, Model model ):
        """Set the support model of the mechanical load"""
        return self.getInstance().setSupportModel( deref( model.getPtr() ) )

    def setValue( self, StructuralForceDouble Force, string nameOfGroup = ""):
        """Set a physical quantity of a Mesh entity"""
        instance = <StructuralForceOnShellDoubleInstance*>self.getInstance()
        return instance.setValue( deref( Force.getPtr() ), nameOfGroup )


    def debugPrint( self, logicalUnit=6 ):
        """Print debug information of the content"""
        self.getInstance().debugPrint( logicalUnit )



###### LocalForceOnShellDouble

cdef class LocalForceOnShellDouble( GenericMechanicalLoad ):
    """Python wrapper on the C++ LocalForceOnShellDouble Object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        if init:
            self._cptr = <GenericMechanicalLoadPtr *>\
                new LocalForceOnShellDoublePtr ( new LocalForceOnShellDoubleInstance() )

    def build( self ):
        """Build the model"""
        instance = <LocalForceOnShellDoubleInstance*>self.getInstance()
        iret = instance.build()
        return iret

    def setSupportModel( self, Model model ):
        """Set the support model of the mechanical load"""
        return self.getInstance().setSupportModel( deref( model.getPtr() ) )

    def setValue( self, LocalShellForceDouble Force, string nameOfGroup = ""):
        """Set a physical quantity of a Mesh entity"""
        instance = <LocalForceOnShellDoubleInstance*>self.getInstance()
        return instance.setValue( deref( Force.getPtr() ), nameOfGroup )

    def debugPrint( self, logicalUnit=6 ):
        """Print debug information of the content"""
        self.getInstance().debugPrint( logicalUnit )

###### PressureOnShellDouble

cdef class PressureOnShellDouble( GenericMechanicalLoad ):
    """Python wrapper on the C++ PressureOnShellDouble Object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        if init:
            self._cptr = <GenericMechanicalLoadPtr *>\
                new PressureOnShellDoublePtr ( new PressureOnShellDoubleInstance() )

    def build( self ):
        """Build the model"""
        instance = <PressureOnShellDoubleInstance*>self.getInstance()
        iret = instance.build()
        return iret

    def setSupportModel( self, Model model ):
        """Set the support model of the mechanical load"""
        return self.getInstance().setSupportModel( deref( model.getPtr() ) )

    def setValue( self, PressureDouble pressure, string nameOfGroup = ""):
        """Set a physical quantity of a Mesh entity"""
        instance = <PressureOnShellDoubleInstance*>self.getInstance()
        return instance.setValue( deref( pressure.getPtr() ), nameOfGroup )

    def debugPrint( self, logicalUnit=6 ):
        """Print debug information of the content"""
        self.getInstance().debugPrint( logicalUnit )

###### ImposedDisplacementDouble

cdef class ImposedDisplacementDouble( GenericMechanicalLoad ):
    """Python wrapper on the C++ ImposedDisplacementDouble Object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        if init:
            self._cptr = <GenericMechanicalLoadPtr *>\
                new ImposedDisplacementDoublePtr ( new ImposedDisplacementDoubleInstance() )

    def build( self ):
        """Build the model"""
        instance = <ImposedDisplacementDoubleInstance*>self.getInstance()
        iret = instance.build()
        return iret

    def setSupportModel( self, Model model ):
        """Set the support model of the mechanical load"""
        return self.getInstance().setSupportModel( deref( model.getPtr() ) )

    def setValue( self, DisplacementDouble disp, string nameOfGroup = ""):
        """Set a physical quantity of a Mesh entity"""
        instance = <ImposedDisplacementDoubleInstance*>self.getInstance()
        return instance.setValue( deref( disp.getPtr() ), nameOfGroup )


    def debugPrint( self, logicalUnit=6 ):
        """Print debug information of the content"""
        self.getInstance().debugPrint( logicalUnit )

###### ImposedPressureDouble

cdef class ImposedPressureDouble( GenericMechanicalLoad ):
    """Python wrapper on the C++ ImposedPressureDouble Object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        if init:
            self._cptr = <GenericMechanicalLoadPtr *>\
                new ImposedPressureDoublePtr ( new ImposedPressureDoubleInstance() )

    def build( self ):
        """Build the model"""
        instance = <ImposedPressureDoubleInstance*>self.getInstance()
        iret = instance.build()
        return iret

    def setSupportModel( self, Model model ):
        """Set the support model of the mechanical load"""
        return self.getInstance().setSupportModel( deref( model.getPtr() ) )

    def setValue( self, PressureDouble disp, string nameOfGroup = ""):
        """Set a physical quantity of a Mesh entity"""
        instance = <ImposedPressureDoubleInstance*>self.getInstance()
        return instance.setValue( deref( disp.getPtr() ), nameOfGroup )


    def debugPrint( self, logicalUnit=6 ):
        """Print debug information of the content"""
        self.getInstance().debugPrint( logicalUnit )

###### DistributedPressureDouble

cdef class DistributedPressureDouble( GenericMechanicalLoad ):
    """Python wrapper on the C++ DistributedPressureDouble Object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        if init:
            self._cptr = <GenericMechanicalLoadPtr *>\
                new DistributedPressureDoublePtr ( new DistributedPressureDoubleInstance() )

    def build( self ):
        """Build the model"""
        instance = <DistributedPressureDoubleInstance*>self.getInstance()
        iret = instance.build()
        return iret

    def setSupportModel( self, Model model ):
        """Set the support model of the mechanical load"""
        return self.getInstance().setSupportModel( deref( model.getPtr() ) )

    def setValue( self, PressureDouble pressure, string nameOfGroup = ""):
        """Set a physical quantity of a Mesh entity"""
        instance = <DistributedPressureDoubleInstance*>self.getInstance()
        return instance.setValue( deref( pressure.getPtr() ), nameOfGroup )


    def debugPrint( self, logicalUnit=6 ):
        """Print debug information of the content"""
        self.getInstance().debugPrint( logicalUnit )
