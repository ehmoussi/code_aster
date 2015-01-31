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

from code_aster.Supervis.libBaseUtils import to_cstr


class ExecutionParameter:

    """This class stores and provides the execution parameters.
    The execution parameters are read from the command line or using
    the method `set()`.
    """

    def __init__( self ):
        """Initialization of attributes"""
        self._args = {}
        self._args['suivi_batch'] = 0
        self._args['dbgjeveux'] = 0

        self._args['memory'] = 1000.
        self._args['maxbase'] = 1000.
        self._args['tpmax'] = 86400

        self._args['repdex'] = '.'

    def set( self, argName, argValue ):
        """Set the value of an execution parameter"""
        self._args[argName] = argValue

    def get( self, argName ):
        """Return the value of an execution parameter
        @param argName Argument de la ligne de commande demande
        @return Entier relu
        """
        return self._args.get( argName, None )

    def parse_args( self, argv ):
        """Parse the command line arguments to set the execution parameters"""
        #TODO
        print "TODO: parsing arguments:", argv


# global instance
executionParameter = ExecutionParameter()

def setExecutionParameter( argName, argValue ):
    """Static function to set parameters from the user command file"""
    global executionParameter
    executionParameter.set( argName, argValue)

cdef public long getParameterLong( char* argName ):
    """Request the value of an execution parameter of type 'int'"""
    global executionParameter
    value = executionParameter.get( argName ) or 0
    print 'gtopti( {} ): {}'.format( argName, value )
    return value

cdef public double getParameterDouble( char* argName ):
    """Request the value of an execution parameter of type 'double'"""
    global executionParameter
    value = executionParameter.get( argName ) or 0.
    print 'gtoptr( {} ): {}'.format( argName, value )
    return value

cdef public void gtoptk_( char* argName, char* valk, long* iret,
                          unsigned int larg, unsigned int lvalk ):
    """Request the value of an execution parameter of type 'string'"""
    global executionParameter
    arg = to_cstr( argName, larg )
    value = executionParameter.get( arg )
    if value is None:
        iret[0] = 4
    else:
        copyToFStr( valk, value, lvalk )
        iret[0] = 0
    print 'gtoptk( {} ): {}, iret {}'.format( arg, value, iret[0] )
