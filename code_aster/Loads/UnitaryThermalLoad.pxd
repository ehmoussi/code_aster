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
from libcpp.vector cimport vector
from libcpp.string cimport string

from code_aster.DataStructure.DataStructure cimport DataStructure
 

cdef extern from "Loads/UnitaryThermalLoad.h":

    ctypedef vector[double] VectorDouble

    cdef cppclass UnitaryThermalLoadInstance:

        UnitaryThermalLoadInstance()

    cdef cppclass UnitaryThermalLoadPtr:

        UnitaryThermalLoadPtr(UnitaryThermalLoadPtr&)
        UnitaryThermalLoadPtr(UnitaryThermalLoadInstance *)
        UnitaryThermalLoadInstance* get()

    cdef cppclass DoubleImposedTemperatureInstance(UnitaryThermalLoadInstance):

        DoubleImposedTemperatureInstance()
        void addGroupOfNodes( string nameOfGroup ) except +
        #void debugPrint( int logicalUnit )

    cdef cppclass DoubleImposedTemperaturePtr:

        DoubleImposedTemperaturePtr( DoubleImposedTemperaturePtr& )
        DoubleImposedTemperaturePtr( DoubleImposedTemperatureInstance* )
        DoubleImposedTemperatureInstance* get()

    cdef cppclass DoubleDistributedFlowInstance(UnitaryThermalLoadInstance):

        DoubleDistributedFlowInstance( double )
        void addGroupOfElements( string nameOfElement ) except +
        void setNormalFlow( double )
        void setLowerNormalFlow( double )
        void setUpperNormalFlow( double )
        void setFlowXYZ( double, double, double )
        #void debugPrint( int logicalUnit )

    cdef cppclass DoubleDistributedFlowPtr:

        DoubleDistributedFlowPtr( DoubleDistributedFlowPtr& , double fluxn=0.0)
        DoubleDistributedFlowPtr( DoubleDistributedFlowInstance* )
        DoubleDistributedFlowInstance* get()

    cdef cppclass DoubleNonLinearFlowInstance(UnitaryThermalLoadInstance):

        DoubleNonLinearFlowInstance()
        void addGroupOfElements( string nameOfElement ) except +
        void setFlow( double )

    cdef cppclass DoubleNonLinearFlowPtr:

        DoubleNonLinearFlowPtr( DoubleNonLinearFlowPtr& )
        DoubleNonLinearFlowPtr( DoubleNonLinearFlowInstance* )
        DoubleNonLinearFlowInstance* get()

    cdef cppclass DoubleExchangeInstance(UnitaryThermalLoadInstance):

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

    cdef cppclass DoubleExchangeWallInstance(UnitaryThermalLoadInstance):

        DoubleExchangeWallInstance()
        void addGroupOfElements( string nameOfElement ) except +
        void setExchangeCoefficient( double )
        void setTranslation( const VectorDouble& )

    cdef cppclass DoubleExchangeWallPtr:

        DoubleExchangeWallPtr( DoubleExchangeWallPtr& )
        DoubleExchangeWallPtr( DoubleExchangeWallInstance* )
        DoubleExchangeWallInstance* get()
        
    cdef cppclass DoubleThermalRadiationInstance(UnitaryThermalLoadInstance):

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
 
    cdef cppclass DoubleThermalGradientInstance(UnitaryThermalLoadInstance):

        DoubleThermalGradientInstance()   
        void addGroupOfElements( string nameOfElement ) except +
        void setFlowXYZ( double, double, double )     

    cdef cppclass DoubleThermalGradientPtr:

        DoubleThermalGradientPtr( DoubleThermalGradientPtr& )
        DoubleThermalGradientPtr( DoubleThermalGradientInstance* )
        DoubleThermalGradientInstance* get()

cdef class UnitaryThermalLoad(DataStructure):
    cdef UnitaryThermalLoadPtr* _cptr
    cdef set(self, UnitaryThermalLoadPtr other)
    cdef UnitaryThermalLoadPtr* getPtr(self)
    cdef UnitaryThermalLoadInstance* getInstance(self)

cdef class DoubleImposedTemperature( UnitaryThermalLoad ):
    pass

cdef class DoubleDistributedFlow( UnitaryThermalLoad ):
    pass

cdef class DoubleNonLinearFlow( UnitaryThermalLoad ):
    pass

cdef class DoubleExchange( UnitaryThermalLoad ):
    pass
    
cdef class DoubleExchangeWall( UnitaryThermalLoad ):
    pass

cdef class DoubleThermalRadiation( UnitaryThermalLoad ):
    pass

cdef class DoubleThermalGradient( UnitaryThermalLoad ):
    pass
