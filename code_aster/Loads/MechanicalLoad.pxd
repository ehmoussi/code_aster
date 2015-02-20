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

#### NodalForceDouble 

    cdef cppclass NodalForceDoubleInstance:

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

    cdef cppclass NodalForceAndMomentumDoubleInstance:

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

    cdef cppclass ForceOnFaceDoubleInstance:

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

    cdef cppclass ForceAndMomentumOnEdgeDoubleInstance:

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

    cdef cppclass LineicForceAndMomentumDoubleInstance:

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

    cdef cppclass InternalForceDoubleInstance:

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

############################################################################################


#### NodalForceDouble 

cdef class NodalForceDouble:
    cdef NodalForceDoublePtr* _cptr
    cdef set( self, NodalForceDoublePtr other )
    cdef NodalForceDoublePtr* getPtr( self )
    cdef NodalForceDoubleInstance* getInstance( self )

#### NodalForceAndMomentumDouble 

cdef class NodalForceAndMomentumDouble:
    cdef NodalForceAndMomentumDoublePtr* _cptr
    cdef set( self, NodalForceAndMomentumDoublePtr other )
    cdef NodalForceAndMomentumDoublePtr* getPtr( self )
    cdef NodalForceAndMomentumDoubleInstance* getInstance( self )


#### ForceOnFaceDouble 

cdef class ForceOnFaceDouble:
    cdef ForceOnFaceDoublePtr* _cptr
    cdef set( self, ForceOnFaceDoublePtr other )
    cdef ForceOnFaceDoublePtr* getPtr( self )
    cdef ForceOnFaceDoubleInstance* getInstance( self )

#### ForceAndMomentumOnEdgeDouble 

cdef class ForceAndMomentumOnEdgeDouble:
    cdef ForceAndMomentumOnEdgeDoublePtr* _cptr
    cdef set( self, ForceAndMomentumOnEdgeDoublePtr other )
    cdef ForceAndMomentumOnEdgeDoublePtr* getPtr( self )
    cdef ForceAndMomentumOnEdgeDoubleInstance* getInstance( self )

#### LineicForceAndMomentumDouble 

cdef class LineicForceAndMomentumDouble:
    cdef LineicForceAndMomentumDoublePtr* _cptr
    cdef set( self, LineicForceAndMomentumDoublePtr other )
    cdef LineicForceAndMomentumDoublePtr* getPtr( self )
    cdef LineicForceAndMomentumDoubleInstance* getInstance( self )

#### InternalForceDouble 

cdef class InternalForceDouble:
    cdef InternalForceDoublePtr* _cptr
    cdef set( self, InternalForceDoublePtr other )
    cdef InternalForceDoublePtr* getPtr( self )
    cdef InternalForceDoubleInstance* getInstance( self )


