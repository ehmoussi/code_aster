# coding: utf-8

from libcpp.string cimport string

cimport cFunction

cdef class Function:
    """Python wrapper on the C++ Function object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores pointers to the C++ objects"""
        self._cptr = new cFunction.Function( init )

    def __dealloc__( self ):
        """Destructor"""
        if self._cptr:
            del self._cptr

    def isEmpty(self):
        """Tell if the object is empty"""
        return self._cptr.isEmpty()

    def setParameterName( self, string name ):
        """Set the name of the parameter"""
        self._cptr.getInstance().setParameterName( name )
