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

from code_aster.DataStructure.DataStructure cimport DataStructure

cdef class DoubleImposedTemperature( DataStructure ):
    """Python wrapper on the C++ DoubleImposedTemperature object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        if init:
            self._cptr = new DoubleImposedTemperaturePtr( new DoubleImposedTemperatureInstance() )

    def __dealloc__( self ):
        """Destructor"""
        if self._cptr is not NULL:
            del self._cptr

    cdef set( self, DoubleImposedTemperaturePtr other ):
        """Point to an existing object"""
        self._cptr = new DoubleImposedTemperaturePtr( other )

    cdef DoubleImposedTemperaturePtr* getPtr( self ):
        """Return the pointer on the c++ shared-pointer object"""
        return self._cptr

    cdef DoubleImposedTemperatureInstance* getInstance( self ):
        """Return the pointer on the c++ instance object"""
        return self._cptr.get()

    def addGroupOfNodes( self, nameOfGroup ):
        """Add a modeling on all the mesh"""
        self.getInstance().addGroupOfNodes( nameOfGroup )

cdef class DoubleDistributedFlow( DataStructure ):
    """Python wrapper on the C++ DoubleDistributedFlow object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        if init:
            self._cptr = new DoubleDistributedFlowPtr( new DoubleDistributedFlowInstance() )

    def __dealloc__( self ):
        """Destructor"""
        if self._cptr is not NULL:
            del self._cptr

    cdef set( self, DoubleDistributedFlowPtr other ):
        """Point to an existing object"""
        self._cptr = new DoubleDistributedFlowPtr( other )

    cdef DoubleDistributedFlowPtr* getPtr( self ):
        """Return the pointer on the c++ shared-pointer object"""
        return self._cptr

    cdef DoubleDistributedFlowInstance* getInstance( self ):
        """Return the pointer on the c++ instance object"""
        return self._cptr.get()

    def addGroupOfElements( self, nameOfGroup ):
        """Add a modeling on all the mesh"""
        self.getInstance().addGroupOfElements( nameOfGroup )

    def setLowerNormalFlow( self, flun_inf ):
        """set value of lower normal flow """
        self.getInstance().setLowerNormalFlow( flun_inf )
 
    def setUpperNormalFlow( self, flun_sup ):
        """set value of upper normal flow """
        self.getInstance().setUpperNormalFlow( flun_sup )

    def setFlowXYZ( self, fluxx, fluxy, fluxz ):
        """set values of  x, y and z componant of flow """
        self.getInstance().setFlowXYZ( fluxx, fluxy, fluxz )
  
cdef class DoubleNonLinearFlow( DataStructure ):
    """Python wrapper on the C++ DoubleDistributedFlow object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        if init:
            self._cptr = new DoubleNonLinearFlowPtr( new DoubleNonLinearFlowInstance() )

    def __dealloc__( self ):
        """Destructor"""
        if self._cptr is not NULL:
            del self._cptr

    cdef set( self, DoubleNonLinearFlowPtr other ):
        """Point to an existing object"""
        self._cptr = new DoubleNonLinearFlowPtr( other )

    cdef DoubleNonLinearFlowPtr* getPtr( self ):
        """Return the pointer on the c++ shared-pointer object"""
        return self._cptr

    cdef DoubleNonLinearFlowInstance* getInstance( self ):
        """Return the pointer on the c++ instance object"""
        return self._cptr.get()

    def addGroupOfElements( self, nameOfGroup ):
        """Add a modeling on all the mesh"""
        self.getInstance().addGroupOfElements( nameOfGroup )

    def setFlow( self, flun ):
        """set value of normal flow """
        self.getInstance().setFlow( flun )
 
cdef class DoubleExchange( DataStructure ):
    """Python wrapper on the C++ DoubleExchange object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        if init:
            self._cptr = new DoubleExchangePtr( new DoubleExchangeInstance() )

    def __dealloc__( self ):
        """Destructor"""
        if self._cptr is not NULL:
            del self._cptr

    cdef set( self, DoubleExchangePtr other ):
        """Point to an existing object"""
        self._cptr = new DoubleExchangePtr( other )

    cdef DoubleExchangePtr* getPtr( self ):
        """Return the pointer on the c++ shared-pointer object"""
        return self._cptr

    cdef DoubleExchangeInstance* getInstance( self ):
        """Return the pointer on the c++ instance object"""
        return self._cptr.get()

    def addGroupOfElements( self, nameOfGroup ):
        """Add a modeling on all the mesh"""
        self.getInstance().addGroupOfElements( nameOfGroup )
     
    def setExchangeCoefficient( self, coefH ) :
        """set value of external temperature """
        self.getInstance().setExchangeCoefficient( coefH )
		 
    def setExternalTemperature( self, tempExt ) :
        """set value of external temperature """
        self.getInstance().setExternalTemperature( tempExt )
        
    def setExchangeCoefficientInfSup( self, coefHInf, coefHSup ) :
        """set value of external temperature """
        self.getInstance().setExchangeCoefficientInfSup( coefHInf, coefHSup )
		
    def setExternalTemperatureInfSup( self, tempExtInf, tempExtSup ):
        """set value of external temperature """
        self.getInstance().setExternalTemperatureInfSup( tempExtInf, tempExtSup )
        
cdef class DoubleExchangeWall( DataStructure ):
    """Python wrapper on the C++ DoubleExchange object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        if init:
            self._cptr = new DoubleExchangeWallPtr( new DoubleExchangeWallInstance() )

    def __dealloc__( self ):
        """Destructor"""
        if self._cptr is not NULL:
            del self._cptr

    cdef set( self, DoubleExchangeWallPtr other ):
        """Point to an existing object"""
        self._cptr = new DoubleExchangeWallPtr( other )

    cdef DoubleExchangeWallPtr* getPtr( self ):
        """Return the pointer on the c++ shared-pointer object"""
        return self._cptr

    cdef DoubleExchangeWallInstance* getInstance( self ):
        """Return the pointer on the c++ instance object"""
        return self._cptr.get()

    def addGroupOfElements( self, nameOfGroup ):
        """Add a modeling on all the mesh"""
        self.getInstance().addGroupOfElements( nameOfGroup )
     
    def setExchangeCoefficient( self, coefH ) :
        """set value of external temperature """
        self.getInstance().setExchangeCoefficient( coefH )
		 
    def setTranslation( self, valx, valy, valz ) :
        """set value of external temperature """
        self.getInstance().setTranslation( valx, valy, valz )
        
cdef class DoubleThermalRadiation( DataStructure ):
    """Python wrapper on the C++ DoubleThermalRadiation object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        if init:
            self._cptr = new DoubleThermalRadiationPtr( new DoubleThermalRadiationInstance() )

    def __dealloc__( self ):
        """Destructor"""
        if self._cptr is not NULL:
            del self._cptr

    cdef set( self, DoubleThermalRadiationPtr other ):
        """Point to an existing object"""
        self._cptr = new DoubleThermalRadiationPtr( other )

    cdef DoubleThermalRadiationPtr* getPtr( self ):
        """Return the pointer on the c++ shared-pointer object"""
        return self._cptr

    cdef DoubleThermalRadiationInstance* getInstance( self ):
        """Return the pointer on the c++ instance object"""
        return self._cptr.get()

    def addGroupOfElements( self, nameOfGroup ):
        """Add a modeling on all the mesh"""
        self.getInstance().addGroupOfElements( nameOfGroup )
        
    def setExternalTemperature( self, tempExt ):
        """set value of external temperature """
        self.getInstance().setExternalTemperature( tempExt )

    def setEpsilon ( self, epsilon ):
         """set value of epsilon """
         self.getInstance().setEpsilon( epsilon )
    
    def setSigma ( self, sigma ):
         """set value of sigma """
         self.getInstance().setSigma( sigma )
        
cdef class DoubleThermalGradient( DataStructure ):
    """Python wrapper on the C++ DoubleThermalGradient object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        if init:
            self._cptr = new DoubleThermalGradientPtr( new DoubleThermalGradientInstance() )

    def __dealloc__( self ):
        """Destructor"""
        if self._cptr is not NULL:
            del self._cptr

    cdef set( self, DoubleThermalGradientPtr other ):
        """Point to an existing object"""
        self._cptr = new DoubleThermalGradientPtr( other )

    cdef DoubleThermalGradientPtr* getPtr( self ):
        """Return the pointer on the c++ shared-pointer object"""
        return self._cptr

    cdef DoubleThermalGradientInstance* getInstance( self ):
        """Return the pointer on the c++ instance object"""
        return self._cptr.get()

    def addGroupOfElements( self, nameOfGroup ):
        """Add a modeling on all the mesh"""
        self.getInstance().addGroupOfElements( nameOfGroup )

    def setFlowXYZ( self, fluxx, fluxy, fluxz ):
        """set values of  x, y and z componant of flow """
        self.getInstance().setFlowXYZ( fluxx, fluxy, fluxz )

