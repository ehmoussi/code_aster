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

"""
This module defines common utilities
"""

def resizeStr( cstr, size ):
    """Resized a string to be assigned to a char* for a fortran string
    buffer = resizeStr(pystring, 32)
    fstr = buff
    """
    return '{:{size}}'.format( cstr[:size], size=size )


def to_cstr( pystring, size ):
    """Convert a fortran string by removing the trailing spaces"""
    return pystring[:size].rstrip()


def fstring_array_tolist( char* fstr_array, long nbstr, unsigned int lenstr ):
    """Create a list of strings from an array of fortran strings
    (a char* of length `nbstr * lenstr`).
    Reverse of `to_fstring_array`."""
    lstr = []
    for i in range(nbstr):
        substr = fstr_array[i * lenstr, (i + 1) * lenstr]
        lstr.append(to_cstr(substr, lenstr))
    return lstr


cdef void copyToFStr( char* dest, pystring, unsigned int str_size ):
    """Copy a string into an existing Fortran string (already
    allocated of at least `str_size` chars)
    """
    buffer = resizeStr( pystring, str_size )
    cdef char* resized = buffer
    memcpy( dest, resized, str_size )


# utilities for arrays
# http://stackoverflow.com/questions/17511309/fast-string-array-cython
# The caller must free the returned array
cdef char** to_cstring_array( list_str ):
    """Convert a list of strings into a char**"""
    cdef char **ret = <char **>malloc( len( list_str ) * sizeof( char * ))
    cdef int i
    for i in range( len( list_str ) ):
        ret[i] = PyString_AsString( list_str[i] )
    return ret


cdef double* to_cdouble_array( list_dble ):
    """Convert a list of doubles into a double*"""
    cdef double *ret = <double*>malloc( len( list_dble ) * sizeof( double ))
    cdef int i
    for i in range( len( list_dble ) ):
        ret[i] = list_dble[i]
    return ret


cdef long* to_clong_array( list_long ):
    """Convert a list of integers into a long*"""
    cdef long *ret = <long*>malloc( len( list_long ) * sizeof( long ))
    cdef int i
    for i in range( len( list_long ) ):
        ret[i] = list_long[i]
    return ret


cdef void to_fstring_array( list_str, int str_size, char* ret ):
    """Convert a list of strings (of the same size) into a char**"""
    # http://stackoverflow.com/questions/17511309/fast-string-array-cython
    cdef int i
    for i in range( len( list_str ) ):
        copyToFStr( ret + i * str_size, resizeStr(list_str[i], str_size), str_size )
