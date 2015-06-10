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

from cpython.ref cimport PyObject

from code_aster.Supervis.libBaseUtils import debug, to_cstr
from code_aster.Supervis cimport libBaseUtils
from code_aster.Supervis.libBaseUtils cimport copyToFStr, to_fstring_array


cdef class ResultNaming:

    """This class manages the names of the jeveux objects"""

    def __init__( self ):
        """Initialize the counter"""
        self._numberOfAsterObjects = 0
        # Maximum 16^8 Aster sd because of the base name of a sd aster (8 characters)
        # and because the hexadecimal system is used to give a name to a given sd
        self._maxNumberOfAsterObjects = 4294967295

    cdef string getNewResultObjectName( self ):
        """Return a new result name
        The first one is "0       ", then "1       ", etc.
        @return String of 8 characters containing the new name
        """
        self._numberOfAsterObjects += 1
        return self.getResultObjectName()

    cdef string getResultObjectName( self ):
        """Return the name of the result created by the current command
        @return String of 8 characters containing the name
        """
        cdef string name = "{:<8x}".format( self._numberOfAsterObjects )
        debug( "getResultObjectName returns", name )
        return name

# global instance
resultNaming = ResultNaming()


cdef class CommandSyntax:

    """This class describes the syntax of command for compatibility
    with the fortran code that use the legacy supervisor."""

    def __init__( self, name="unNamed" ):
        """Create a new command"""
        global currentCommand
        self._name = name
        # FIXME: remove unused attributes
        self._resultName = " "
        self._resultType = " "
        self._definition = None
        debug( "new command is ", self._name )
        # only FIN is allowed to free the current "in failure" command
        if self._name == "FIN" and currentCommand is not None:
            currentCommand.free()
        assert currentCommand is None, \
            "CommandSyntax {} must be freed".format( currentCommand._name )
        currentCommand = self
        self._commandCata = getCommandCata( name )

    cpdef free( self ):
        """Reset the current command pointer as soon as possible"""
        # `currentCommand` must be reset before the garbage collector will do it
        global currentCommand
        debug( "del command ", self._name )
        currentCommand = None

    def __repr__( self ):
        """Representation of the command"""
        return "Command {!r}, returns {!r} <{!r}>\n` syntax: {}".format( \
            self._name, self._resultName, self._resultType,
            self._definition)

    def debugPrint( self ):
        """Representation of the command"""
        print "Command {!r}, returns {!r} <{!r}>\n` syntax: {}".format( \
            self._name, self._resultName, self._resultType,
            self._definition)

    cpdef setResult( self, sdName, sdType ):
        """Register the result of the command: name and type"""
        self._resultName = sdName
        self._resultType = sdType

    cpdef define( self, dictSyntax ):
        """Register the keywords values"""
        if self._commandCata != None:
            debug( "define0", self._name, dictSyntax )
            defaultKwds = self._commandCata.getDefaultKeywords( dictSyntax )
            for key, value in defaultKwds.iteritems():
                assert type( value ) != dict, \
                    'unexpected type for value: {!r}'.format( value )
                userValue = dictSyntax.get( key )
                if userValue == None:
                    dictSyntax[ key ] = value
                    continue
                if type( value ) == list:
                    if type( userValue ) == dict:
                        assert len( value ) == 1
                        dictSyntax[ key ].update(value[0])
                    else:
                        assert len(userValue) == len(value)
                        for i in range(len(value)):
                            ret2 = value[i]
                            ret3 = userValue[i]
                            for key2, value2 in ret2.iteritems():
                                ret4 = ret3.get( key2 )
                                if ret4 == None:
                                    ret3[ key2 ] = value2
        self._definition = dictSyntax
        debug( "define1", self._name, self._definition )

    cdef getName( self ):
        """Return the command name"""
        return self._name

    cdef getResultName( self ):
        """Return the name of the result of the command"""
        return self._resultName

    cdef getResultType( self ):
        """Return the type of the result of the command"""
        return self._resultType

    def _getFactorKeyword( self, factName ):
        """Return the occurrences of a factor keyword"""
        # a factor keyword may be empty: {} (None means 'does not exist')
        dictDef = self._definition.get( factName, None )
        debug( "factor keyword", factName, dictDef )
        if dictDef is None:
            return None
        if type( dictDef ) is dict:
            dictDef = [dictDef, ]
        return dictDef

    def _getFactorKeywordOccurrence( self, factName, occurrence ):
        """Return the definition of an occurrence of a factor keyword"""
        dictDef = self._getFactorKeyword( factName )
        if dictDef is None:
            return None
        try: return dictDef[occurrence]
        except: return None

    def _getDefinition( self, factName, occurrence ):
        """Return the definition of a factor keyword or of the top-level
        if `factName` is blank"""
        if not factName.strip():
            dictDef = self._definition
        else:
            dictDef = self._getFactorKeywordOccurrence( factName, occurrence )
            if not dictDef:
                dictDef = {}
        assert type(dictDef) is dict, "syntax not defined"
        return dictDef

    cpdef int getFactorKeywordNbOcc( self, factName ):
        """Return the number of occurrences of a factor keyword"""
        dictDef = self._getFactorKeyword( factName )
        debug( "_getFactorKeyword", factName, dictDef )
        if dictDef is None:
            return 0
        debug( "getFactorKeywordNbOcc: len(dictDef) = ", len( dictDef ) )
        return len(dictDef)

    cpdef int existsFactorAndSimpleKeyword( self, factName, int occurrence,
                                            simpName ):
        """Tell if the couple ( factor keyword, simple keyword ) exists"""
        dictDef = self._getDefinition( factName, occurrence )
        value = dictDef.get( simpName, None )
        if value is None or type( value ) is dict:
            return 0
        return 1

    cpdef object getValue( self, factName, int occurrence, simpName ):
        """Return the values of a (simple) keyword"""
        if not self.existsFactorAndSimpleKeyword( factName, occurrence, simpName ):
            return []
        value = self._getDefinition( factName, occurrence )[simpName]
        if type( value ) not in (list, tuple):
            value = [value, ]
        debug( "getValue", value )
        return value


cdef CommandSyntax currentCommand
currentCommand = None
commandCataDictionary = {}

def commandsRegister( commandsDict ):
    global commandCataDictionary
    commandCataDictionary = commandsDict

def getCommandCata( name ):
    global commandCataDictionary
    return commandCataDictionary.get( name )


def setCurrentCommand( syntax ):
    global currentCommand
    currentCommand = syntax

def getCurrentCommand():
    global currentCommand
    return currentCommand


cdef public void newCommandSyntax( const char* name ):
    global currentCommand
    currentCommand = CommandSyntax( name )

cdef public void deleteCommandSyntax():
    global currentCommand
    currentCommand.free()

cdef public void setResultCommandSyntax( const char* resultObjectName, const char* resultType ):
    global currentCommand
    currentCommand.setResult( resultObjectName, resultType )

cdef public void defineCommandSyntax( PyObject* dict ):
    global currentCommand
    cdef object curDict = <object>dict
    currentCommand.define( curDict )

cdef public void debugPrintCommandSyntax():
    global currentCommand
    currentCommand.debugPrint()


def _F( **kwargs ):
    """For convenience of writing"""
    return kwargs


cdef public string getNewResultObjectName():
    """Return a new result name
    The first one is "0       ", then "1       ", etc.
    @return String of 8 characters containing the new name
    """
    global resultNaming
    return resultNaming.getNewResultObjectName()

cdef public string getResultObjectName():
    """Return the name of the result created by the current command
    @return String of 8 characters containing the name
    """
    global resultNaming
    return resultNaming.getResultObjectName()


cdef public void getres_( char* resultName, char* resultType, char* commandName,
                          unsigned int lres, unsigned int ltype,
                          unsigned int lcmd) except *:
    """Wrapper for fortran calls to getName, getResultName and getResultType"""
    if currentCommand is None:
        raise ValueError( "there is no active command" )
    debug( "Current Command is", currentCommand )
    copyToFStr( commandName, currentCommand.getName(), lcmd )
    copyToFStr( resultName, currentCommand.getResultName(), lres )
    copyToFStr( resultType, currentCommand.getResultType(), ltype )
    debug( "getres", ( commandName[:lcmd], resultName[:lres], resultType[:ltype] ) )


cdef public int listeMotCleSimpleFromMotCleFacteur(
        char* factKeyword, int occurrence, int nbval,
        char* arraySimpleKeyword, int keywordSize,
        char* arrayType, int typeSize, int* nbKeyword):
    """Return the list of the SimpleKeyword under a FactorKeyword
    Fills the passed and already allocated fortran array of strings.
    """
    if currentCommand is None:
        raise ValueError( "there is no active command" )
    dictFkw = currentCommand._getFactorKeywordOccurrence( factKeyword, occurrence )
    if dictFkw is None:
        nbKeyword[0] = 0
        return 1

    keywords = dictFkw.keys()
    size = len( keywords )
    if nbval <= 0:
        nbKeyword[0] = -size
        return 0
    nbKeyword[0] = size

    types = []
    for value in dictFkw.values():
        if type( value ) == str:
            typ = "TX"
        elif type( value ) == float:
            typ = "R8"
        elif type( value ) == int:
            typ ="IS"
        else:
            raise TypeError( "Unexpected type: {!r}".format(type(value)) )
        types.append( typ )
    # fill the fortran array
    debug("getmjm: keywords =", keywords)
    debug("getmjm: types =", types)
    assert len(keywords) == len(types) == size
    to_fstring_array( keywords, keywordSize, arraySimpleKeyword )
    to_fstring_array( types, typeSize, arrayType )
    return 0


cdef public void getfac_( char* factName, long* number, unsigned int lname ):
    """Wrapper function to command.getFactorKeywordNbOcc()"""
    if currentCommand is None:
        number[0] =  0
        return
    keyword = to_cstr( factName, lname )
    number[0] = currentCommand.getFactorKeywordNbOcc( keyword )


cdef public int existsCommandFactorAndSimpleKeyword(
        char* factName, int occurrence, char* simpName ):
    """Wrapper function to command.existsFactorAndSimpleKeyword()"""
    if currentCommand is None:
        return 0
    return currentCommand.existsFactorAndSimpleKeyword( factName, occurrence,
                                                        simpName )

cdef public char** getCommandKeywordValueString(
        char* factName, int occurrence,
        char* simpName, int* size ) except *:
    """Wrapper function to command.getValue() for string"""
    if currentCommand is None:
        raise ValueError( "there is no active command" )
    value = currentCommand.getValue( factName, occurrence, simpName )
    if len( value ) > 0 and type( value[0] ) not in ( str, unicode ):
        raise TypeError( "string expected for %r/%r, got %s" % ( factName, simpName, type(value[0]) ) )
    cdef char** strArray = libBaseUtils.to_cstring_array( value )
    size[0] = len( value )
    return strArray


cdef public double* getCommandKeywordValueDouble(
        char* factName, int occurrence,
        char* simpName, int* size ) except *:
    """Wrapper function to command.getValue() for double"""
    if currentCommand is None:
        raise ValueError( "there is no active command" )
    value = currentCommand.getValue( factName, occurrence, simpName )
    if len( value ) > 0:
        try:
            float( value[0] )
        except TypeError:
            raise TypeError( "float expected, got %s" % type( value[0] ) )
    cdef double* dbleArray = libBaseUtils.to_cdouble_array( value )
    size[0] = len( value )
    return dbleArray


cdef public long* getCommandKeywordValueInt(
        char* factName, int occurrence,
        char* simpName, int* size ) except *:
    """Wrapper function to command.getValue() for integer"""
    if currentCommand is None:
        raise ValueError( "there is no active command" )
    value = currentCommand.getValue( factName, occurrence, simpName )
    if len( value ) > 0 and type( value[0] ) not in ( int, long ):
        raise TypeError( "integer expected, got %s" % type( value[0] ) )
    cdef long* longArray = libBaseUtils.to_clong_array( value )
    size[0] = len( value )
    return longArray
