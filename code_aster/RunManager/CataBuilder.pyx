# coding: utf-8

cimport cCataBuilder


cdef class CataBuilder:

    def __cinit__( self ):
        self._cptr = new cCataBuilder.CataBuilder()

    def __dealloc__( self ):
        """Destructor"""
        if self._cptr:
            del self._cptr

    def run( self ):
        """Build the elements catalog"""
        self._cptr.run()
