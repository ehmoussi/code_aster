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
Utilities to be called for the Fortran subroutines
"""
# NB: global objects must be created by an import of this modules (in __init__).
# No .pxd because not "included" by other cython modules.

import random

from Comportement import catalc

from .libBaseUtils import to_cstr, fstring_array_tolist
from .libBaseUtils cimport copyToFStr, to_fstring_array


# Random number generator
randomGenerator = None


cdef public void iniran_( long* number ):
    """Reinitialize the random number generator"""
    global randomGenerator
    randomGenerator = random.Random(100)
    randomGenerator.jumpahead( number[0] )


cdef public void getran_( double* value ):
    """Return a random number"""
    if randomGenerator is None:
        iniran_( [0] )
    value[0] = randomGenerator.random()


# interface to the CataLoiComportement container
cdef public void lccree_( long* nbkit, char* list_kit, char* compor,
                          unsigned int lkit, unsigned int lcompor ):
    """Create a set of behaviours from those given in `list_kit`"""
    lstr = fstring_array_tolist( list_kit, nbkit[0], lkit )
    new = catalc.create(*lstr)
    copyToFStr( compor, new, lcompor )


cdef public void lcalgo_( char* compor, char* algo,
                          unsigned int lcompor, unsigned int lalgo ):
    """Return the first integration algorithm"""
    sret = catalc.get_algo( to_cstr(compor, lcompor) )
    copyToFStr( algo, sret, lalgo )


cdef public void lcinfo_( char* compor, long* numlc, long* nbvari,
                          unsigned int lcompor ):
    """Return the index of the lc00xx subroutine and the number of internal variables."""
    ret = catalc.get_info( to_cstr(compor, lcompor) )
    numlc[0] = ret[0]
    nbvari[0] = ret[1]


cdef public void lcvari_( char* compor, long* nbvari, char* nomvar,
                          unsigned int lcompor, unsigned int lnomvar ):
    """Return the list of internal variables names"""
    names = catalc.get_vari( to_cstr(compor, lcompor) )
    assert len(names) == nbvari[0], "expect {0} variables, got {1}".format(nbvari[0], len(names))
    to_fstring_array( names, lnomvar, nomvar )


cdef public void lctest_( char* compor, char* prop, char* value, long* iret,
                          unsigned int lcompor, unsigned int lprop, unsigned int lval):
    """Tell if the value is authorized for the property"""
    iret[0] = catalc.query( to_cstr(compor, lcompor), to_cstr(prop, lprop), to_cstr(value, lval) )


cdef public void lctype_( char* compor, char* typ,
                          unsigned int lcompor, unsigned int ltyp ):
    """Return the type of behaviour: std, mfront or kit"""
    sret = catalc.get_type( to_cstr(compor, lcompor) )
    copyToFStr( typ, sret, ltyp )


cdef public void lcdiscard_( char* compor, unsigned int lcompor ):
    """Remove a 'working' behaviour object.
    With compor=' ', remove all working objects."""
    name = to_cstr( compor, lcompor )
    names = []
    if name:
        names.append(name)
    catalc.discard( *names )


cdef public void lcsymb_( char* compor, char* name,
                          unsigned int lcompor, unsigned int lname ):
    """Return the name of the function to call in the MFront library"""
    sret = catalc.get_symbol( to_cstr( compor, lcompor ) )
    copyToFStr( name, sret, lname )
