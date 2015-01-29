# CommandSyntax

from baseutils import debug


cdef class CommandSyntax:

    """This class describes the syntax of command for compatibility
    with the fortran code that use the legacy supervisor."""

    def __init__( self, name="", numOp=0 ):
        """Create a new command"""
        global currentCommand
        self._name = name
        # FIXME: remove unused attributes
        self._numOperator = numOp
        self._resultName = " "
        self._resultType = " "
        self._definition = None
        debug( "new command is ", self._name )
        assert currentCommand is None, \
            "CommandSyntax {} must be freed".format( currentCommand._name )
        currentCommand = self

    def __dealloc__( self ):
        """Destructor: ensure that the command has been freed"""
        assert currentCommand is None, \
            "CommandSyntax {} must be freed".format( self._name )

    cpdef free( self ):
        """Reset the current command pointer as soon as possible"""
        # `currentCommand` must be reset before the garbage collector will do it
        global currentCommand
        debug( "del command ", self._name )
        currentCommand = None

    cdef void setResult( self, sdName, sdType ):
        """Register the result of the command: name and type"""
        self._resultName = sdName
        self._resultType = sdType

    cpdef define( self, dictSyntax ):
        """Register the keywords values"""
        self._definition = dictSyntax
        debug( "syntax", self._name, self._definition )

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
        if occurrence > len( dictDef ) - 1:
            return None
        else:
            dictDef = dictDef[occurrence]
        return dictDef

    def _getDefinition( self, factName, occurrence ):
        """Return the definition of a factor keyword or of the top-level
        if `factName` is blank"""
        if not factName.strip():
            dictDef = self._definition
        else:
            dictDef = self._getFactorKeywordOccurrence( factName, occurrence )
            if not dictDef:
                dictDef = {}
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


def _F( **kwargs ):
    """For convenience of writing"""
    return kwargs


#TODO: use JeveuxString
cdef public void Xgetres_( char* resultName, char* resultType, char* commandName,
                          unsigned int lres, unsigned int ltype,
                          unsigned int lcmd):
    """Wrapper for fortran calls to getName, getResultName and getResultType"""
    if currentCommand is None:
        raise ValueError( "there is no active command" )
    name = currentCommand.getName()
    # CopyCStrToFStr( commandName, name, lcmd )
    commandName = name

    name = currentCommand.getResultName()
    # CopyCStrToFStr( resultName, name, lres )
    resultName = name

    name = currentCommand.getResultType()
    # CopyCStrToFStr( resultType, name, ltype )
    resultType = name
    debug( "getres", ( commandName[:lcmd], resultName[:lres], resultType[:ltype] ) )


cdef public int XlisteMotCleSimpleFromMotCleFacteur(
        char* factKeyword, int occurrence, int keywordSize, int typeSize,
        char*** arraySimpleKeyword, char*** arrayType, int* nbKeyword):
    # TODO: getmjm
    pass

cdef public void Xgetfac_( char* factName, long* number, unsigned int lname ):
    """Wrapper function to command.getFactorKeywordNbOcc()"""
    if currentCommand is None:
        number[0] =  0
        return
    # keyword = MakeCStrFromFStr( factName, lname )
    keyword = factName
    number[0] = currentCommand.getFactorKeywordNbOcc( keyword )
    # FreeStr( keyword )

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
    cdef char** strArray = baseutils.to_cstring_array( value )
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
    cdef double* dbleArray = baseutils.to_cdouble_array( value )
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
    cdef long* longArray = baseutils.to_clong_array( value )
    size[0] = len( value )
    return longArray
