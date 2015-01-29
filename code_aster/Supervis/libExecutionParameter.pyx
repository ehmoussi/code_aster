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

# from libaster cimport MakeCStrFromFStr, CopyCStrToFStr, FreeStr


cdef class ExecutionParameter:

    """This class stores and provides the execution parameters.
    The execution parameters are read from the command line or using
    the method `setParameter()`.
    """

    def __cinit__( self ):
        """Declaration of attributes"""
        self._args = {}

    def __init__( self ):
        """Initialization of attributes"""
        self._args['suivi_batch'] = 0
        self._args['dbgjeveux'] = 0

        self._args['memory'] = 1000.
        self._args['maxbase'] = 1000.

        self._args['repdex'] = '.'

    cpdef getParameter( self, argName ):
        """Return the value of an execution parameter
        @param argName Argument de la ligne de commande demande
        @return Entier relu
        """
        return self._args.get( argName, None )


# global instance
execParameter = ExecutionParameter()


cdef public int Xgtopti_( string argName ):
    """Request the value of an execution parameter of type 'int'"""
    global execParameter
    value = execParameter.getParameter( argName ) or 0
    print 'gtopti( {} ): {}'.format( argName, value )
    return value


cdef public double Xgtoptr_( string argName ):
    """Request the value of an execution parameter of type 'double'"""
    global execParameter
    value = execParameter.getParameter( argName ) or 0.
    print 'gtoptr( {} ): {}'.format( argName, value )
    return value


cdef public void Xgtoptk_( char* argName, char* valk, long* iret,
                          unsigned int larg, unsigned int lvalk ):
    """Request the value of an execution parameter of type 'string'"""
    global execParameter
    cdef char* arg
    # arg = MakeCStrFromFStr( argName, larg )
    arg = argName
    value = execParameter.getParameter( arg )
    if value is None:
        iret[0] = 4
        print 'gtoptk( {} ): {}, iret {}'.format( argName, value, iret[0] )
    else:
        # CopyCStrToFStr( valk, value, lvalk )
        valk = value
        iret[0] = 0
        print 'gtoptk( {} ): {}, iret {}'.format( argName, value, iret[0] )
        # FreeStr( arg )
