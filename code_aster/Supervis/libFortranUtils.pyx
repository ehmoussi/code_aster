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

import random

# Random number generator
# NB: global objects must be created by an import of this modules (in __init__)
randomGenerator = None


cdef public void iniran_( long* number ):
    """Reinitialize the random number generator"""
    global randomGenerator
    randomGenerator = random.Random(100)
    randomGenerator.jumpahead( number[0] )


cdef public void getran_( double* value ):
    """Return a random number"""
    global randomGenerator
    if randomGenerator is None:
        iniran_( [0] )
    value[0] = randomGenerator.random()
