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

from code_aster.DataStructure.DataStructure cimport DataStructure
from code_aster.Studies.FailureConvergenceManager cimport GenericConvergenceError


cdef class TimeStepManager( DataStructure ):

    """Python wrapper on the C++ TimeStepManager object"""

    def __cinit__( self, bint init = True ):
        """Initialization: stores the pointer to the C++ object"""
        if init:
            self._cptr = new TimeStepManagerPtr( new TimeStepManagerInstance() )

    def __dealloc__( self ):
        """Destructor"""
        if self._cptr is not NULL:
            del self._cptr

    cdef set( self, TimeStepManagerPtr other ):
        """Point to an existing object"""
        # set must be subclassed if it is necessary
        self._cptr = new TimeStepManagerPtr( other )

    cdef TimeStepManagerPtr* getPtr( self ):
        """Return the pointer on the c++ shared-pointer object"""
        return self._cptr

    cdef TimeStepManagerInstance* getInstance( self ):
        """Return the pointer on the c++ instance object"""
        return self._cptr.get()

    def addErrorManager( self, GenericConvergenceError cvError ):
        """Add an Manager of convergence error"""
        self.getInstance().addErrorManager( deref( cvError.getPtr() ) )

    def build( self ):
        """Build the TimeStepManager"""
        self.getInstance().build()

    def setAutomaticManagement( self, isAuto ):
        """Set the management of the time list (manual ou automatic)"""
        self.getInstance().setAutomaticManagement( isAuto )

    def setMaximumNumberOfTimeStep( self, maximum ):
        """Set the maximum number of time stemp"""
        self.getInstance().setMaximumNumberOfTimeStep( maximum )

    def setMaximumTimeStep( self, maximum ):
        """Set the maximum time step"""
        self.getInstance().setMaximumTimeStep( maximum )

    def setMinimumTimeStep( self, minimum ):
        """Set the minimum time step"""
        self.getInstance().setMinimumTimeStep( minimum )

    def setTimeList( self, doubleVector ):
        """Set the time list"""
        self.getInstance().setTimeList( doubleVector )

    def debugPrint( self, logicalUnit=6 ):
        """Print debug information of the content"""
        self.getInstance().debugPrint( logicalUnit )
