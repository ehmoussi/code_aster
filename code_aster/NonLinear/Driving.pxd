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
from code_aster.Geometry.Geometry cimport UnitVectorEnum

cdef extern from "NonLinear/Driving.h":

    cpdef enum DrivingTypeEnum :
      DisplacementValue, DisplacementNorm, JumpOnCrackValue, 
      JumpOnCrackNorm, LimitLoad, MonotonicStrain,  ElasticityLimit

    cpdef enum SelectionCriterionEnum :
        SmallestDisplacementIncrement, SmallestAngleIncrement, SmallestResidual, MixedCriterion

    cdef cppclass DrivingInstance:

        DrivingInstance( DrivingTypeEnum curDriving )
        
        void addObservationGroupOfNodes( string name )
        void addObservationGroupOfElements( string name )
        void setDrivingDirectionOnCrack( UnitVectorEnum dir )
        void setMaximumValueOfDrivingParameter( double eta_max )
        void setMinimumValueOfDrivingParameter( double eta_min )
        void setLowerBoundOfDrivingParameter( double eta_r_min )
        void setUpperBoundOfDrivingParameter( double eta_r_max )
        void activateThreshold()
        void deactivateThreshold()
        void setMultiplicativeCoefficient( double coef ) 

    cdef cppclass DrivingPtr:

        DrivingPtr( DrivingPtr& )
        DrivingPtr( DrivingInstance* )
        DrivingInstance* get()

#### Driving

cdef class Driving :

    cdef DrivingPtr* _cptr

    cdef set( self, DrivingPtr other )
    cdef DrivingPtr* getPtr( self )
    cdef DrivingInstance* getInstance( self )
