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


cdef class ResultNaming:

    cdef int _numberOfAsterObjects
    cdef long _maxNumberOfAsterObjects

    cdef string getNewResultObjectName( self )
    cdef string getResultObjectName( self )


cdef ResultNaming resultNaming


cdef class CommandSyntax:

    cdef        _name
    cdef bint   _numOperator
    cdef        _resultName
    cdef        _resultType
    cdef object _definition
    cdef object _commandCata

    cpdef setResult( self, sdName, sdType )

    cpdef define( self, dictSyntax )

    cpdef free( self )

    cdef getName( self )

    cdef getResultName( self )

    cdef getResultType( self )

    # def _getFactorKeyword( self, factName )
    #
    # def _getFactorKeywordOccurrence( self, factName, occurrence )
    #
    # def _getDefinition( self, factName, occurrence )

    cpdef int getFactorKeywordNbOcc( self, factName )

    cpdef int existsFactorAndSimpleKeyword( self, factName, int occurrence,
                                            simpName )

    cpdef object getValue( self, factName, int occurrence, simpName )


cdef CommandSyntax currentCommand
