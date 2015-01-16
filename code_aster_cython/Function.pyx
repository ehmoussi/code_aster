# distutils: language = c++

from libcpp.string cimport string

cimport cFunction

cdef class pyFunction:

    """Python wrapper on the C++ Function object"""

    cdef cFunction.Function* _cptr
    cdef cFunction.FunctionInstance* _inst

    def __cinit__( self, bint init=True ):
        """Initialization: stores pointers to the C++ objects"""
        self._cptr = new cFunction.Function( init )
        self._inst = self._cptr.getInstance()

    def __dealloc__( self ):
        """Destructor"""
        if self._cptr:
            del self._cptr

    def setParameterName( self, string name ):
        """Set the name of the parameter"""
        assert self._inst, 'Pointer to C++ object not initialized'
        self._inst.setParameterName( name )

    def isEmpty(self):
        """Tell if the object is empty"""
        return self._cptr.isEmpty()
