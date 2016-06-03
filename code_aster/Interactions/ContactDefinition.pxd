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

from code_aster.DataStructure.DataStructure cimport DataStructure
from code_aster.Interactions.ContactZone cimport ContactZonePtr
from code_aster.Modeling.Model cimport ModelPtr


cdef extern from "Interactions/ContactDefinition.h":

    cdef enum FrictionEnum:
        cCoulomb "Coulomb"
        cWithoutFriction "WithoutFriction"

    cdef enum GeometricResolutionAlgorithmEnum:
        cFixPoint "FixPoint"
        cNewton "Newton"

    cdef enum GeometricUpdateEnum:
        cAuto "Auto"
        cControlled "Controlled"
        cWithoutGeometricUpdate "WithoutGeometricUpdate"

    cdef enum ContactPrecondEnum:
        cDirichlet "Dirichlet"
        cWithoutPrecond "WithoutPrecond"

    cdef cppclass DiscretizedContactInstance:

        DiscretizedContactInstance()
        void addContactZone(const ContactZonePtr& zone)
        bint build()
        void setModel(ModelPtr& model)
        void setGeometricResolutionAlgorithm(const GeometricResolutionAlgorithmEnum& curAlgo) except +
        void setGeometricUpdate(const GeometricUpdateEnum& curUp) except +
        void setMaximumNumberOfGeometricIteration(const int& value) except +
        void setGeometricResidual(const double& value) except +
        void setNumberOfGeometricIteration(const int& value) except +
        void setNormsSmooth(const bint& curBool)
        void setNormsVerification(const bint curBool)
        void setStopOnInterpenetrationDetection(const bint& curBool)
        void setContactAlgorithm(const int& coef) except +
        void enableContactMatrixSingularityDetection(const bint& value)
        void numberOfSolversForSchurComplement(const int& value)
        void setResidualForGcp(const double& value)
        void allowOutOfBoundLinearSearch(const bint& value)
        void setPreconditioning(const ContactPrecondEnum& value)
        void setThresholdOfPreconditioningActivation(const double& value) except +
        void setMaximumNumberOfPreconditioningIteration(const int& value) except +
        void debugPrint( int logicalUnit )

    cdef cppclass DiscretizedContactPtr:

        DiscretizedContactPtr( DiscretizedContactPtr& )
        DiscretizedContactPtr( DiscretizedContactInstance* )
        DiscretizedContactInstance* get()


cdef class DiscretizedContact( DataStructure ):

    cdef DiscretizedContactPtr* _cptr

    cdef set( self, DiscretizedContactPtr other )
    cdef DiscretizedContactPtr* getPtr( self )
    cdef DiscretizedContactInstance* getInstance( self )


cdef extern from "Interactions/ContactDefinition.h":

    cdef cppclass ContinuousContactInstance:

        ContinuousContactInstance()
        #void debugPrint( int logicalUnit )

    cdef cppclass ContinuousContactPtr:

        ContinuousContactPtr( ContinuousContactPtr& )
        ContinuousContactPtr( ContinuousContactInstance* )
        ContinuousContactInstance* get()


cdef class ContinuousContact( DataStructure ):

    cdef ContinuousContactPtr* _cptr

    cdef set( self, ContinuousContactPtr other )
    cdef ContinuousContactPtr* getPtr( self )
    cdef ContinuousContactInstance* getInstance( self )


cdef extern from "Interactions/ContactDefinition.h":

    cdef cppclass XfemContactInstance:

        XfemContactInstance()
        #void debugPrint( int logicalUnit )

    cdef cppclass XfemContactPtr:

        XfemContactPtr( XfemContactPtr& )
        XfemContactPtr( XfemContactInstance* )
        XfemContactInstance* get()


cdef class XfemContact( DataStructure ):

    cdef XfemContactPtr* _cptr

    cdef set( self, XfemContactPtr other )
    cdef XfemContactPtr* getPtr( self )
    cdef XfemContactInstance* getInstance( self )


cdef extern from "Interactions/ContactDefinition.h":

    cdef cppclass UnilateralConnexionInstance:

        UnilateralConnexionInstance()
        #void debugPrint( int logicalUnit )

    cdef cppclass UnilateralConnexionPtr:

        UnilateralConnexionPtr( UnilateralConnexionPtr& )
        UnilateralConnexionPtr( UnilateralConnexionInstance* )
        UnilateralConnexionInstance* get()


cdef class UnilateralConnexion( DataStructure ):

    cdef UnilateralConnexionPtr* _cptr

    cdef set( self, UnilateralConnexionPtr other )
    cdef UnilateralConnexionPtr* getPtr( self )
    cdef UnilateralConnexionInstance* getInstance( self )
