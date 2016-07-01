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
from cython.operator cimport dereference as deref

cdef class UnitaryThermalLoad:
    """Python wrapper on the C++ UnitaryThermalLoad object"""

    def __cinit__(self):
        """Initialization: stores the pointer to the C++ object"""
        pass

    def __dealloc__(self):
        """Destructor"""
        # subclassing, see https://github.com/cython/cython/wiki/WrappingSetOfCppClasses
        cdef UnitaryThermalLoadPtr* tmp
        if self._cptr is not NULL:
            tmp = <UnitaryThermalLoadPtr *>self._cptr
            del tmp
            self._cptr = NULL

    cdef set(self, UnitaryThermalLoadPtr other):
        """Point to an existing object"""
        # set must be subclassed if it is necessary
        self._cptr = new UnitaryThermalLoadPtr(other)

    cdef UnitaryThermalLoadPtr* getPtr(self):
        """Return the pointer on the c++ shared-pointer object"""
        return self._cptr

    cdef UnitaryThermalLoadInstance* getInstance(self):
        """Return the pointer on the c++ instance object"""
        return self._cptr.get()

cdef class DoubleImposedTemperature( UnitaryThermalLoad ):
    """Python wrapper on the C++ DoubleImposedTemperature object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        if init:
            self._cptr = <UnitaryThermalLoadPtr *>\
				new DoubleImposedTemperaturePtr( new DoubleImposedTemperatureInstance() )

    def addGroupOfNodes( self, nameOfGroup ):
        """Add a modeling on all the mesh"""
        (<DoubleImposedTemperatureInstance* >self.getInstance()).addGroupOfNodes( nameOfGroup )

cdef class DoubleDistributedFlow( UnitaryThermalLoad ):
    """Python wrapper on the C++ DoubleDistributedFlow object"""

    def __cinit__( self, double fluxn=0.0, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        if init:
            self._cptr = <UnitaryThermalLoadPtr *>\
				new DoubleDistributedFlowPtr( new DoubleDistributedFlowInstance(fluxn) )

    def addGroupOfElements( self, nameOfGroup ):
        """Add a modeling on all the mesh"""
        (<DoubleDistributedFlowInstance* >self.getInstance()).addGroupOfElements( nameOfGroup )

    def setNormalFlow( self, flun_inf ):
        """set value of normal flow """
        (<DoubleDistributedFlowInstance* >self.getInstance()).setNormalFlow( flun_inf )

    def setLowerNormalFlow( self, flun_inf ):
        """set value of lower normal flow """
        (<DoubleDistributedFlowInstance* >self.getInstance()).setLowerNormalFlow( flun_inf )
 
    def setUpperNormalFlow( self, flun_sup ):
        """set value of upper normal flow """
        (<DoubleDistributedFlowInstance* >self.getInstance()).setUpperNormalFlow( flun_sup )

    def setFlowXYZ( self, fluxx, fluxy, fluxz ):
        """set values of  x, y and z componant of flow """
        (<DoubleDistributedFlowInstance* >self.getInstance()).setFlowXYZ( fluxx, fluxy, fluxz )
  
cdef class DoubleNonLinearFlow( UnitaryThermalLoad ):
    """Python wrapper on the C++ DoubleDistributedFlow object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        if init:
            self._cptr = <UnitaryThermalLoadPtr *>\
				new DoubleNonLinearFlowPtr( new DoubleNonLinearFlowInstance() )

    def addGroupOfElements( self, nameOfGroup ):
        """Add a modeling on all the mesh"""
        (<DoubleNonLinearFlowInstance* >self.getInstance()).addGroupOfElements( nameOfGroup )

    def setFlow( self, flun ):
        """set value of normal flow """
        (<DoubleNonLinearFlowInstance* >self.getInstance()).setFlow( flun )
 
cdef class DoubleExchange( UnitaryThermalLoad ):
    """Python wrapper on the C++ DoubleExchange object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        if init:
            self._cptr = <UnitaryThermalLoadPtr *>\
				new DoubleExchangePtr( new DoubleExchangeInstance() )

    def addGroupOfElements( self, nameOfGroup ):
        """Add a modeling on all the mesh"""
        (<DoubleExchangeInstance* >self.getInstance()).addGroupOfElements( nameOfGroup )
     
    def setExchangeCoefficient( self, coefH ) :
        """set value of external temperature """
        (<DoubleExchangeInstance* >self.getInstance()).setExchangeCoefficient( coefH )
		 
    def setExternalTemperature( self, tempExt ) :
        """set value of external temperature """
        (<DoubleExchangeInstance* >self.getInstance()).setExternalTemperature( tempExt )
        
    def setExchangeCoefficientInfSup( self, coefHInf, coefHSup ) :
        """set value of external temperature """
        (<DoubleExchangeInstance* >self.getInstance()).setExchangeCoefficientInfSup( coefHInf, coefHSup )
		
    def setExternalTemperatureInfSup( self, tempExtInf, tempExtSup ):
        """set value of external temperature """
        (<DoubleExchangeInstance* >self.getInstance()).setExternalTemperatureInfSup( tempExtInf, tempExtSup )
        
cdef class DoubleExchangeWall( UnitaryThermalLoad ):
    """Python wrapper on the C++ DoubleExchange object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        if init:
            self._cptr = <UnitaryThermalLoadPtr *>\
				new DoubleExchangeWallPtr( new DoubleExchangeWallInstance() )

    def addGroupOfElements( self, nameOfGroup ):
        """Add a modeling on all the mesh"""
        (<DoubleExchangeWallInstance* >self.getInstance()).addGroupOfElements( nameOfGroup )
     
    def setExchangeCoefficient( self, coefH ) :
        """set value of external temperature """
        (<DoubleExchangeWallInstance* >self.getInstance()).setExchangeCoefficient( coefH )
		 
    def setTranslation( self, valxyz ) :
        """set value of external temperature """
        (<DoubleExchangeWallInstance* >self.getInstance()).setTranslation( valxyz )
        
cdef class DoubleThermalRadiation( UnitaryThermalLoad ):
    """Python wrapper on the C++ DoubleThermalRadiation object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        if init:
            self._cptr = <UnitaryThermalLoadPtr *>\
				new DoubleThermalRadiationPtr( new DoubleThermalRadiationInstance() )

    def addGroupOfElements( self, nameOfGroup ):
        """Add a modeling on all the mesh"""
        (<DoubleThermalRadiationInstance* >self.getInstance()).addGroupOfElements( nameOfGroup )
        
    def setExternalTemperature( self, tempExt ):
        """set value of external temperature """
        (<DoubleThermalRadiationInstance* >self.getInstance()).setExternalTemperature( tempExt )

    def setEpsilon ( self, epsilon ):
         """set value of epsilon """
         (<DoubleThermalRadiationInstance* >self.getInstance()).setEpsilon( epsilon )
    
    def setSigma ( self, sigma ):
         """set value of sigma """
         (<DoubleThermalRadiationInstance* >self.getInstance()).setSigma( sigma )
        
cdef class DoubleThermalGradient( UnitaryThermalLoad ):
    """Python wrapper on the C++ DoubleThermalGradient object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        if init:
            self._cptr = <UnitaryThermalLoadPtr *>\
				new DoubleThermalGradientPtr( new DoubleThermalGradientInstance() )

    def addGroupOfElements( self, nameOfGroup ):
        """Add a modeling on all the mesh"""
        (<DoubleThermalGradientInstance* >self.getInstance()).addGroupOfElements( nameOfGroup )

    def setFlowXYZ( self, fluxx, fluxy, fluxz ):
        """set values of  x, y and z componant of flow """
        (<DoubleThermalGradientInstance* >self.getInstance()).setFlowXYZ( fluxx, fluxy, fluxz )

