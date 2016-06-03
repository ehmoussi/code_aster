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

from cython.operator cimport dereference as deref

from code_aster.DataStructure.DataStructure cimport DataStructure
from code_aster.Function.Function cimport Function


MasterNorm, SlaveNorm, AverageNorm = cMasterNorm, cSlaveNorm, cAverageNorm


cdef class ContactZone( DataStructure ):
    """Python wrapper on the C++ ContactZone object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        if init:
            self._cptr = new ContactZonePtr( new ContactZoneInstance() )

    def __dealloc__( self ):
        """Destructor"""
        if self._cptr is not NULL:
            del self._cptr

    cdef set( self, ContactZonePtr other ):
        """Point to an existing object"""
        self._cptr = new ContactZonePtr( other )

    cdef ContactZonePtr* getPtr( self ):
        """Return the pointer on the c++ shared-pointer object"""
        return self._cptr

    cdef ContactZoneInstance* getInstance( self ):
        """Return the pointer on the c++ instance object"""
        return self._cptr.get()

    def addBeamDescription( self ):
        """"""
        self.getInstance().addBeamDescription(  )

    def addPlateDescription( self ):
        """"""
        self.getInstance().addPlateDescription(  )

    def addMasterGroupOfElements( self, nameOfGroup ):
        """"""
        self.getInstance().addMasterGroupOfElements( nameOfGroup )

    def addSlaveGroupOfElements( self, nameOfGroup ):
        """"""
        self.getInstance().addSlaveGroupOfElements( nameOfGroup )

    def disableResolution( self, tolInterp = 0. ):
        """"""
        self.getInstance().disableResolution( tolInterp )

    def excludeGroupOfElementsFromSlave( self, name ):
        """"""
        self.getInstance().excludeGroupOfElementsFromSlave( name )

    def excludeGroupOfNodesFromSlave( self, name ):
        """"""
        self.getInstance().excludeGroupOfNodesFromSlave( name )

    def setFixMasterVector( self, absc ):
        """"""
        self.getInstance().setFixMasterVector( absc )

    def setMasterDistanceFunction( self, Function func ):
        """"""
        self.getInstance().setMasterDistanceFunction( deref( func.getPtr() ) )

    def setSlaveDistanceFunction( self, Function func ):
        """"""
        self.getInstance().setSlaveDistanceFunction( deref( func.getPtr() ) )

    def setPairingVector( self, absc ):
        """"""
        self.getInstance().setPairingVector( absc )

    def setTangentMasterVector( self, absc ):
        """"""
        self.getInstance().setTangentMasterVector( absc )

    def setNormType( self, normType ):
        """"""
        self.getInstance().setNormType( normType )

    #def debugPrint( self, logicalUnit=6 ):
        #"""Print debug information of the content"""
        #self.getInstance().debugPrint( logicalUnit )
