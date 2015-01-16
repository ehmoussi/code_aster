# coding: utf-8

from libcpp.string cimport string

cimport cMesh

cdef class Mesh:
    """Python wrapper on the C++ Mesh object"""

    cdef cMesh.Mesh* _cptr
    cdef cMesh.MeshInstance* _inst

    def __cinit__( self, bint init=True ):
        """Initialization: stores pointers to the C++ objects"""
        self._cptr = new cMesh.Mesh( init )
        self._inst = self._cptr.getInstance()

    def __dealloc__( self ):
        """Destructor"""
        if self._cptr:
            del self._cptr

    def isEmpty(self):
        """Tell if the object is empty"""
        return self._cptr.isEmpty()

    #def getCoordinates(self)
    #def hasGroupOfElements( self, string name )
    #def hasGroupOfNodes( self, string name )

    def readMEDFile( self, string pathFichier ):
        """Read a MED file"""
        assert self._inst, 'Pointer to C++ object not initialized'
        return self._inst.readMEDFile( pathFichier )
