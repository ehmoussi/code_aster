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
from code_aster.Loads.PhysicalQuantity cimport ForceDoublePtr, ForceAndMomentumDoublePtr


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

#### NodalForceAndMomentumDouble 

    cdef cppclass NodalForceAndMomentumDoubleInstance( GenericMechanicalLoadInstance ):

        NodalForceAndMomentumDoubleInstance()
        bint setValue( ForceAndMomentumDoublePtr physQuantPtr, string nameOfGroup ) except+
        bint setSupportModel( ModelPtr currentModel )
        bint build() except +
        const string getType()
        void debugPrint( int logicalUnit )

    cdef cppclass NodalForceAndMomentumDoublePtr:

        NodalForceAndMomentumDoublePtr( NodalForceAndMomentumDoublePtr& )
        NodalForceAndMomentumDoublePtr( NodalForceAndMomentumDoubleInstance * )
        NodalForceAndMomentumDoubleInstance* get()

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

#### ForceAndMomentumOnEdgeDouble 

    cdef cppclass ForceAndMomentumOnEdgeDoubleInstance( GenericMechanicalLoadInstance ):

        ForceAndMomentumOnEdgeDoubleInstance()
        bint setValue( ForceAndMomentumDoublePtr physQuantPtr, string nameOfGroup ) except+
        bint setSupportModel( ModelPtr currentModel )
        bint build() except +
        const string getType()
        void debugPrint( int logicalUnit )

    cdef cppclass ForceAndMomentumOnEdgeDoublePtr:

        ForceAndMomentumOnEdgeDoublePtr( ForceAndMomentumOnEdgeDoublePtr& )
        ForceAndMomentumOnEdgeDoublePtr( ForceAndMomentumOnEdgeDoubleInstance * )
        ForceAndMomentumOnEdgeDoubleInstance* get()

#### LineicForceAndMomentumDouble 

    cdef cppclass LineicForceAndMomentumDoubleInstance( GenericMechanicalLoadInstance ):

        LineicForceAndMomentumDoubleInstance()
        bint setValue( ForceAndMomentumDoublePtr physQuantPtr, string nameOfGroup ) except+
        bint setSupportModel( ModelPtr currentModel )
        bint build() except +
        const string getType()
        void debugPrint( int logicalUnit )

    cdef cppclass LineicForceAndMomentumDoublePtr:

        LineicForceAndMomentumDoublePtr( LineicForceAndMomentumDoublePtr& )
        LineicForceAndMomentumDoublePtr( LineicForceAndMomentumDoubleInstance * )
        LineicForceAndMomentumDoubleInstance* get()

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

#### ForceAndMomentumOnBeamDouble 

    cdef cppclass ForceAndMomentumOnBeamDoubleInstance( GenericMechanicalLoadInstance ):

        ForceAndMomentumOnBeamDoubleInstance()
        bint setValue( ForceAndMomentumDoublePtr physQuantPtr, string nameOfGroup ) except+
        bint setSupportModel( ModelPtr currentModel )
        bint build() except +
        const string getType()
        void debugPrint( int logicalUnit )

    cdef cppclass ForceAndMomentumOnBeamDoublePtr:

        ForceAndMomentumOnBeamDoublePtr( ForceAndMomentumOnBeamDoublePtr& )
        ForceAndMomentumOnBeamDoublePtr( ForceAndMomentumOnBeamDoubleInstance * )
        ForceAndMomentumOnBeamDoubleInstance* get()

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


#### NodalForceAndMomentumDouble 

cdef class NodalForceAndMomentumDouble( GenericMechanicalLoad ):
    pass


#### ForceOnFaceDouble 

cdef class ForceOnFaceDouble( GenericMechanicalLoad ):
    pass


#### ForceAndMomentumOnEdgeDouble 

cdef class ForceAndMomentumOnEdgeDouble( GenericMechanicalLoad ):
    pass


#### LineicForceAndMomentumDouble 

cdef class LineicForceAndMomentumDouble( GenericMechanicalLoad ):
    pass


#### InternalForceDouble 

cdef class InternalForceDouble( GenericMechanicalLoad ):
    pass


#### ForceAndMomentumOnBeamDouble 

cdef class ForceAndMomentumOnBeamDouble( GenericMechanicalLoad ):
    pass

