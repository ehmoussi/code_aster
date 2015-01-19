# coding: utf-8

from libcpp.string cimport string

from cFieldOnNodes cimport cFieldOnNodesDouble


cdef class FieldOnNodesDouble:
    """Python wrapper on the C++ FieldOnNodes object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores pointers to the C++ objects"""
        self._cptr = new cFieldOnNodesDouble( )
        self._inst = self._cptr.getInstance()

    cdef assign( self, cFieldOnNodesDouble other ):
        """Use an existing C++ object"""
        # copy
        self._cptr.setInstance( other.getInstance() )
        self._inst = self._cptr.getInstance()

    def __dealloc__( self ):
        """Destructor"""
        if self._cptr:
            del self._cptr

    def isEmpty( self ):
        """Tell if the object is empty"""
        return self._cptr.isEmpty()
