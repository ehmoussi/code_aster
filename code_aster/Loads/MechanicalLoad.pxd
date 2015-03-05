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

from code_aster.Modeling.Model cimport ModelPtr
from code_aster.Loads.PhysicalQuantity cimport ForceDoublePtr, StructuralForceDoublePtr, LocalBeamForceDoublePtr, LocalShellForceDoublePtr
from code_aster.Loads.PhysicalQuantity cimport DoubleDisplacementPtr, DoublePressurePtr


cdef extern from "Loads/MechanicalLoad.h":

#### GenericMechanicalLoad

    cdef cppclass GenericMechanicalLoadInstance:

        GenericMechanicalLoadInstance()
        bint setSupportModel( ModelPtr currentModel )
        const string getType()
        void debugPrint( int logicalUnit )

    cdef cppclass GenericMechanicalLoadPtr:

        GenericMechanicalLoadPtr( GenericMechanicalLoadPtr& )
        GenericMechanicalLoadPtr( GenericMechanicalLoadInstance * )
        GenericMechanicalLoadInstance* get()

#### NodalForceDouble

    cdef cppclass NodalForceDoubleInstance( GenericMechanicalLoadInstance ):

        NodalForceDoubleInstance()
        bint setValue( ForceDoublePtr physQuantPtr, string nameOfGroup ) except+
        bint setSupportModel( ModelPtr currentModel )
        bint build() except +
        const string getType()
        void debugPrint( int logicalUnit )

    cdef cppclass NodalForceDoublePtr:

        NodalForceDoublePtr( NodalForceDoublePtr& )
        NodalForceDoublePtr( NodalForceDoubleInstance * )
        NodalForceDoubleInstance* get()

#### NodalStructuralForceDouble

    cdef cppclass NodalStructuralForceDoubleInstance( GenericMechanicalLoadInstance ):

        NodalStructuralForceDoubleInstance()
        bint setValue( StructuralForceDoublePtr physQuantPtr, string nameOfGroup ) except+
        bint setSupportModel( ModelPtr currentModel )
        bint build() except +
        const string getType()
        void debugPrint( int logicalUnit )

    cdef cppclass NodalStructuralForceDoublePtr:

        NodalStructuralForceDoublePtr( NodalStructuralForceDoublePtr& )
        NodalStructuralForceDoublePtr( NodalStructuralForceDoubleInstance * )
        NodalStructuralForceDoubleInstance* get()

#### ForceOnFaceDouble

    cdef cppclass ForceOnFaceDoubleInstance( GenericMechanicalLoadInstance ):

        ForceOnFaceDoubleInstance()
        bint setValue( ForceDoublePtr physQuantPtr, string nameOfGroup ) except+
        bint setSupportModel( ModelPtr currentModel )
        bint build() except +
        const string getType()
        void debugPrint( int logicalUnit )

    cdef cppclass ForceOnFaceDoublePtr:

        ForceOnFaceDoublePtr( ForceOnFaceDoublePtr& )
        ForceOnFaceDoublePtr( ForceOnFaceDoubleInstance * )
        ForceOnFaceDoubleInstance* get()

#### ForceOnEdgeDouble

    cdef cppclass ForceOnEdgeDoubleInstance( GenericMechanicalLoadInstance ):

        ForceOnEdgeDoubleInstance()
        bint setValue( ForceDoublePtr physQuantPtr, string nameOfGroup ) except+
        bint setSupportModel( ModelPtr currentModel )
        bint build() except +
        const string getType()
        void debugPrint( int logicalUnit )

    cdef cppclass ForceOnEdgeDoublePtr:

        ForceOnEdgeDoublePtr( ForceOnEdgeDoublePtr& )
        ForceOnEdgeDoublePtr( ForceOnEdgeDoubleInstance * )
        ForceOnEdgeDoubleInstance* get()

#### StructuralForceOnEdgeDouble

    cdef cppclass StructuralForceOnEdgeDoubleInstance( GenericMechanicalLoadInstance ):

        StructuralForceOnEdgeDoubleInstance()
        bint setValue( StructuralForceDoublePtr physQuantPtr, string nameOfGroup ) except+
        bint setSupportModel( ModelPtr currentModel )
        bint build() except +
        const string getType()
        void debugPrint( int logicalUnit )

    cdef cppclass StructuralForceOnEdgeDoublePtr:

        StructuralForceOnEdgeDoublePtr( StructuralForceOnEdgeDoublePtr& )
        StructuralForceOnEdgeDoublePtr( StructuralForceOnEdgeDoubleInstance * )
        StructuralForceOnEdgeDoubleInstance* get()

#### LineicForceDouble

    cdef cppclass LineicForceDoubleInstance( GenericMechanicalLoadInstance ):

        LineicForceDoubleInstance()
        bint setValue( ForceDoublePtr physQuantPtr, string nameOfGroup ) except+
        bint setSupportModel( ModelPtr currentModel )
        bint build() except +
        const string getType()
        void debugPrint( int logicalUnit )

    cdef cppclass LineicForceDoublePtr:

        LineicForceDoublePtr( LineicForceDoublePtr& )
        LineicForceDoublePtr( LineicForceDoubleInstance * )
        LineicForceDoubleInstance* get()

#### InternalForceDouble

    cdef cppclass InternalForceDoubleInstance( GenericMechanicalLoadInstance ):

        InternalForceDoubleInstance()
        bint setValue( ForceDoublePtr physQuantPtr, string nameOfGroup ) except+
        bint setSupportModel( ModelPtr currentModel )
        bint build() except +
        const string getType()
        void debugPrint( int logicalUnit )

    cdef cppclass InternalForceDoublePtr:

        InternalForceDoublePtr( InternalForceDoublePtr& )
        InternalForceDoublePtr( InternalForceDoubleInstance * )
        InternalForceDoubleInstance* get()

#### StructuralForceOnBeamDouble

    cdef cppclass StructuralForceOnBeamDoubleInstance( GenericMechanicalLoadInstance ):

        StructuralForceOnBeamDoubleInstance()
        bint setValue( StructuralForceDoublePtr physQuantPtr, string nameOfGroup ) except+
        bint setSupportModel( ModelPtr currentModel )
        bint build() except +
        const string getType()
        void debugPrint( int logicalUnit )

    cdef cppclass StructuralForceOnBeamDoublePtr:

        StructuralForceOnBeamDoublePtr( StructuralForceOnBeamDoublePtr& )
        StructuralForceOnBeamDoublePtr( StructuralForceOnBeamDoubleInstance * )
        StructuralForceOnBeamDoubleInstance* get()

#### LocalForceOnBeamDouble

    cdef cppclass LocalForceOnBeamDoubleInstance( GenericMechanicalLoadInstance ):

        LocalForceOnBeamDoubleInstance()
        bint setValue( LocalBeamForceDoublePtr physQuantPtr, string nameOfGroup ) except+
        bint setSupportModel( ModelPtr currentModel )
        bint build() except +
        const string getType()
        void debugPrint( int logicalUnit )

    cdef cppclass LocalForceOnBeamDoublePtr:

        LocalForceOnBeamDoublePtr( LocalForceOnBeamDoublePtr& )
        LocalForceOnBeamDoublePtr( LocalForceOnBeamDoubleInstance * )
        LocalForceOnBeamDoubleInstance* get()

#### LocalForceOnShellDouble

    cdef cppclass LocalForceOnShellDoubleInstance( GenericMechanicalLoadInstance ):

        LocalForceOnShellDoubleInstance()
        bint setValue( LocalShellForceDoublePtr physQuantPtr, string nameOfGroup ) except+
        bint setSupportModel( ModelPtr currentModel )
        bint build() except +
        const string getType()
        void debugPrint( int logicalUnit )

    cdef cppclass LocalForceOnShellDoublePtr:

        LocalForceOnShellDoublePtr( LocalForceOnShellDoublePtr& )
        LocalForceOnShellDoublePtr( LocalForceOnShellDoubleInstance * )
        LocalForceOnShellDoubleInstance* get()

#### ImposedDoubleDisplacement

    cdef cppclass ImposedDoubleDisplacementInstance( GenericMechanicalLoadInstance ):

        ImposedDoubleDisplacementInstance()
        bint setValue( DoubleDisplacementPtr physQuantPtr, string nameOfGroup ) except+
        bint setSupportModel( ModelPtr currentModel )
        bint build() except +
        const string getType()
        void debugPrint( int logicalUnit )

    cdef cppclass ImposedDoubleDisplacementPtr:

        ImposedDoubleDisplacementPtr( ImposedDoubleDisplacementPtr& )
        ImposedDoubleDisplacementPtr( ImposedDoubleDisplacementInstance * )
        ImposedDoubleDisplacementInstance* get()

#### DistributedDoublePressure

    cdef cppclass DistributedDoublePressureInstance( GenericMechanicalLoadInstance ):

        DistributedDoublePressureInstance()
        bint setValue( DoublePressurePtr physQuantPtr, string nameOfGroup ) except+
        bint setSupportModel( ModelPtr currentModel )
        bint build() except +
        const string getType()
        void debugPrint( int logicalUnit )

    cdef cppclass DistributedDoublePressurePtr:

        DistributedDoublePressurePtr( DistributedDoublePressurePtr& )
        DistributedDoublePressurePtr( DistributedDoublePressureInstance * )
        DistributedDoublePressureInstance* get()

############################################################################################

#### GenericMechanicalLoad

cdef class GenericMechanicalLoad:
    cdef GenericMechanicalLoadPtr* _cptr
    cdef set( self, GenericMechanicalLoadPtr other )
    cdef GenericMechanicalLoadPtr* getPtr( self )
    cdef GenericMechanicalLoadInstance* getInstance( self )


#### NodalForceDouble

cdef class NodalForceDouble( GenericMechanicalLoad ):
    pass


#### NodalStructuralForceDouble

cdef class NodalStructuralForceDouble( GenericMechanicalLoad ):
    pass


#### ForceOnFaceDouble

cdef class ForceOnFaceDouble( GenericMechanicalLoad ):
    pass


#### ForceOnEdgeDouble

cdef class ForceOnEdgeDouble( GenericMechanicalLoad ):
    pass

#### StructuralForceOnEdgeDouble

cdef class StructuralForceOnEdgeDouble( GenericMechanicalLoad ):
    pass

#### LineicForceDouble

cdef class LineicForceDouble( GenericMechanicalLoad ):
    pass


#### InternalForceDouble

cdef class InternalForceDouble( GenericMechanicalLoad ):
    pass


#### StructuralForceOnBeamDouble

cdef class StructuralForceOnBeamDouble( GenericMechanicalLoad ):
    pass

#### LocalForceOnBeamDouble

cdef class LocalForceOnBeamDouble( GenericMechanicalLoad ):
    pass

#### LocalForceOnShellDouble

cdef class LocalForceOnShellDouble( GenericMechanicalLoad ):
    pass

#### ImposedDoubleDisplacement

cdef class ImposedDoubleDisplacement( GenericMechanicalLoad ):
    pass


#### DistributedDoublePressure

cdef class DistributedDoublePressure( GenericMechanicalLoad ):
    pass

