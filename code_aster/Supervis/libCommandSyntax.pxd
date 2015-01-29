# CommandSyntax

cimport baseutils
# from libaster cimport MakeCStrFromFStr, CopyCStrToFStr, FreeStr


cdef class CommandSyntax:

    cdef        _name
    cdef bint   _numOperator
    cdef        _resultName
    cdef        _resultType
    cdef object _definition

    cdef void setResult( self, sdName, sdType )

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
