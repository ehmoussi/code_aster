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


cdef extern from "Loads/UnitaryThermalLoad.h":

    cdef cppclass DoubleImposedTemperatureInstance:

        DoubleImposedTemperatureInstance()
        void addGroupOfNodes( string nameOfGroup ) except +
        #void debugPrint( int logicalUnit )

    cdef cppclass DoubleImposedTemperaturePtr:

        DoubleImposedTemperaturePtr( DoubleImposedTemperaturePtr& )
        DoubleImposedTemperaturePtr( DoubleImposedTemperatureInstance* )
        DoubleImposedTemperatureInstance* get()

    cdef cppclass DoubleDistributedFlowInstance:

        DoubleDistributedFlowInstance()
        void addGroupOfElements( string nameOfElement ) except +
        void setLowerNormalFlow( double )
        void setUpperNormalFlow( double )
        void setFlowXYZ( double, double, double )
        #void debugPrint( int logicalUnit )

    cdef cppclass DoubleDistributedFlowPtr:

        DoubleDistributedFlowPtr( DoubleDistributedFlowPtr& )
        DoubleDistributedFlowPtr( DoubleDistributedFlowInstance* )
        DoubleDistributedFlowInstance* get()

    cdef cppclass DoubleNonLinearFlowInstance:

        DoubleNonLinearFlowInstance()
        void addGroupOfElements( string nameOfElement ) except +
        void setFlow( double )

    cdef cppclass DoubleNonLinearFlowPtr:

        DoubleNonLinearFlowPtr( DoubleNonLinearFlowPtr& )
        DoubleNonLinearFlowPtr( DoubleNonLinearFlowInstance* )
        DoubleNonLinearFlowInstance* get()

    cdef cppclass DoubleExchangeInstance:

        DoubleExchangeInstance()
        void addGroupOfElements( string nameOfElement ) except +
        void setExternalTemperature( double )
        void setExchangeCoefficient( double )
        void setExternalTemperatureInfSup( double , double )
        void setExchangeCoefficientInfSup( double , double )
        #void debugPrint( int logicalUnit )

    cdef cppclass DoubleExchangePtr:

        DoubleExchangePtr( DoubleExchangePtr& )
        DoubleExchangePtr( DoubleExchangeInstance* )
        DoubleExchangeInstance* get()

    cdef cppclass DoubleExchangeWallInstance:

        DoubleExchangeWallInstance()
        void addGroupOfElements( string nameOfElement ) except +
        void setExchangeCoefficient( double )
        void setTranslation( double , double , double)

    cdef cppclass DoubleExchangeWallPtr:

        DoubleExchangeWallPtr( DoubleExchangeWallPtr& )
        DoubleExchangeWallPtr( DoubleExchangeWallInstance* )
        DoubleExchangeWallInstance* get()
        
    cdef cppclass DoubleThermalRadiationInstance:

        DoubleThermalRadiationInstance()
        void addGroupOfElements( string nameOfElement ) except +
        void setExternalTemperature( double )
        void setEpsilon( double )
        void setSigma( double )
       #void debugPrint( int logicalUnit )

    cdef cppclass DoubleThermalRadiationPtr:

        DoubleThermalRadiationPtr( DoubleThermalRadiationPtr& )
        DoubleThermalRadiationPtr( DoubleThermalRadiationInstance* )
        DoubleThermalRadiationInstance* get()
 
    cdef cppclass DoubleThermalGradientInstance:

        DoubleThermalGradientInstance()   
        void addGroupOfElements( string nameOfElement ) except +
        void setFlowXYZ( double, double, double )     

    cdef cppclass DoubleThermalGradientPtr:

        DoubleThermalGradientPtr( DoubleThermalGradientPtr& )
        DoubleThermalGradientPtr( DoubleThermalGradientInstance* )
        DoubleThermalGradientInstance* get()

cdef class DoubleImposedTemperature( DataStructure ):

    cdef DoubleImposedTemperaturePtr* _cptr

    cdef set( self, DoubleImposedTemperaturePtr other )
    cdef DoubleImposedTemperaturePtr* getPtr( self )
    cdef DoubleImposedTemperatureInstance* getInstance( self )

cdef class DoubleDistributedFlow( DataStructure ):

    cdef DoubleDistributedFlowPtr* _cptr

    cdef set( self, DoubleDistributedFlowPtr other )
    cdef DoubleDistributedFlowPtr* getPtr( self )
    cdef DoubleDistributedFlowInstance* getInstance( self )

cdef class DoubleNonLinearFlow( DataStructure ):

    cdef DoubleNonLinearFlowPtr* _cptr

    cdef set( self, DoubleNonLinearFlowPtr other )
    cdef DoubleNonLinearFlowPtr* getPtr( self )
    cdef DoubleNonLinearFlowInstance* getInstance( self )

cdef class DoubleExchange( DataStructure ):

    cdef DoubleExchangePtr* _cptr

    cdef set( self, DoubleExchangePtr other )
    cdef DoubleExchangePtr* getPtr( self )
    cdef DoubleExchangeInstance* getInstance( self )
    
cdef class DoubleExchangeWall( DataStructure ):

    cdef DoubleExchangeWallPtr* _cptr

    cdef set( self, DoubleExchangeWallPtr other )
    cdef DoubleExchangeWallPtr* getPtr( self )
    cdef DoubleExchangeWallInstance* getInstance( self )

cdef class DoubleThermalRadiation( DataStructure ):

    cdef DoubleThermalRadiationPtr* _cptr

    cdef set( self, DoubleThermalRadiationPtr other )
    cdef DoubleThermalRadiationPtr* getPtr( self )
    cdef DoubleThermalRadiationInstance* getInstance( self )

cdef class DoubleThermalGradient( DataStructure ):

    cdef DoubleThermalGradientPtr* _cptr

    cdef set( self, DoubleThermalGradientPtr other )
    cdef DoubleThermalGradientPtr* getPtr( self )
    cdef DoubleThermalGradientInstance* getInstance( self )
