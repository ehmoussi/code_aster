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


cdef class Driving :
    """Python wrapper on the C++ Driving Object"""

    def __cinit__( self, DrivingTypeEnum curDriving ):
        """Initialization: stores the pointer to the C++ object"""
        self._cptr = new DrivingPtr( new DrivingInstance( curDriving ) )

    def __dealloc__( self ):
        """Destructor"""
        if self._cptr is not NULL:
            del self._cptr

    cdef set( self, DrivingPtr other ):
        """Point to an existing object"""
        self._cptr = new DrivingPtr( other )
       
    cdef DrivingPtr* getPtr( self ):
        """Return the pointer on the c++ shared-pointer object"""
        return self._cptr

    cdef DrivingInstance* getInstance( self ):
        """Return the pointer on the c++ instance object"""
        return self._cptr.get()
    
    def addObservationGroupOfNodes( self, string name ):
        """Define observation nodes for the driving"""
        self.getInstance().addObservationGroupOfNodes( name )

    def addObservationGroupOfElements( self, string name ):
        """Define observation elements for the driving"""
        self.getInstance().addObservationGroupOfElements( name )

    def setDrivingDirectionOnCrack( self, UnitVectorEnum dir ):
        """Define driving direction on crack """
        self.getInstance().setDrivingDirectionOnCrack( dir )
    
    def setMaximumValueOfDrivingParameter( self, double eta_max ) :
        """Define Maximum Value of Driving Parameter"""
        self.getInstance().setMaximumValueOfDrivingParameter( eta_max )

    def setMinimumValueOfDrivingParameter( self, double eta_min ) :
        """Define Minimum Value of Driving Parameter"""
        self.getInstance().setMinimumValueOfDrivingParameter( eta_min )

    def setLowerBoundOfDrivingParameter( self, double eta_r_min ) :
        """Define Lower Bound of Driving Parameter"""
        self.getInstance().setLowerBoundOfDrivingParameter( eta_r_min )

    def setUpperBoundOfDrivingParameter( self, double eta_r_max ) :
        """Define Upper Bound of Driving Parameter"""
        self.getInstance().setUpperBoundOfDrivingParameter( eta_r_max )
    
    def activateThreshold( self ) :
        """ Force thresholding of Driving Parameter during process """
        self.getInstance().activateThreshold()

    def deactivateThreshold( self ) : 
        """ Relax thresholding of Driving Parameter during process """
        self.getInstance().deactivateThreshold()

    def setMultiplicativeCoefficient( self, double coef ): 
        """ Set Multiplicative Coefficient """
        self.getInstance().setMultiplicativeCoefficient( coef )
 
