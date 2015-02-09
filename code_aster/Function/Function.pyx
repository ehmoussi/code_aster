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

# numpy implementation in cython currently generates a warning at compilation
import numpy as np
cimport numpy as np


cdef class Function:
    """Python wrapper on the C++ Function object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        if init:
            self._cptr = new FunctionPtr( new FunctionInstance() )

    def __dealloc__( self ):
        """Destructor"""
        if self._cptr is not NULL:
            del self._cptr

    cdef set( self, FunctionPtr other ):
        """Point to an existing object"""
        self._cptr = new FunctionPtr( other )

    cdef FunctionPtr* getPtr( self ):
        """Return the pointer on the c++ shared-pointer object"""
        return self._cptr

    cdef FunctionInstance* getInstance( self ):
        """Return the pointer on the c++ instance object"""
        return self._cptr.get()

    def setParameterName( self, string name ):
        """Set the name of the parameter"""
        self.getInstance().setParameterName( name )

    def setResultName( self, string name ):
        """Set the name of the parameter"""
        self.getInstance().setResultName( name )

    def setInterpolation( self, typ ):
        """Set the type of interpolation"""
        typ = typ.strip()
        try:
            assert len(typ) == 7
            spl = typ.split()
            assert len(spl) == 2
            assert spl[0] in ('LIN', 'LOG', 'NON')
            assert spl[1] in ('LIN', 'LOG', 'NON')
            typ = " ".join(spl)
        except AssertionError:
            raise ValueError( "Invalid interpolation type: '{}'".format( typ ) )
        self.getInstance().setInterpolation( typ )

    def setExtrapolation( self, typ ):
        """Set the type of extrapolation"""
        typ = typ.strip()
        try:
            assert len(typ) == 2
            assert typ[0] in ('E', 'C', 'L', 'I')
            assert typ[1] in ('E', 'C', 'L', 'I')
        except AssertionError:
            raise ValueError( "Invalid extrapolation type: '{}'".format( typ ) )
        self.getInstance().setExtrapolation( typ )

    def setValues( self, abscissas, ordinates ):
        """Define the values of the function"""
        self.getInstance().setValues( abscissas, ordinates )

    def size( self ):
        """Return the number of point of the function"""
        return self.getInstance().size()

    def getValuesAsArray( self ):
        """Return an array object of the values"""
        cdef const double* data = self.getInstance().getDataPtr()
        cdef long size = self.getInstance().size()
        cdef long i
        cdef np.ndarray[np.float64_t, ndim=2] res
        res = np.zeros([size, 2], dtype=float)
        for i in range( size ):
            res[i, 0] = data[2 * i]
            res[i, 1] = data[2 * i + 1]
        return res

    def debugPrint( self, logicalUnit=6 ):
        """Print debug information of the content"""
        self.getInstance().debugPrint( logicalUnit )
