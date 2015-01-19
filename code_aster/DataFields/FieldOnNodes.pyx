# coding: utf-8

from libcpp.string cimport string
from cython.operator cimport dereference as deref

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

    def __getitem__( self, i ):
        """Return the value at the given index"""
        cdef double val = deref(self._inst)[i]
        return val

    def isEmpty( self ):
        """Tell if the object is empty"""
        return self._cptr.isEmpty()
