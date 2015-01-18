# coding: utf-8

from libcpp.string cimport string

from code_aster.DataFields.FieldOnNodes cimport FieldOnNodesDouble, cFieldOnNodesDouble
cimport cMesh

cdef class Mesh:
    """Python wrapper on the C++ Mesh object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores pointers to the C++ objects"""
        self._cptr = new cMesh.Mesh( init )
        self._inst = self._cptr.getInstance()

    def __dealloc__( self ):
        """Destructor"""
        if self._cptr:
            del self._cptr

    def isEmpty( self ):
        """Tell if the object is empty"""
        return self._cptr.isEmpty()

    def getCoordinates(self):
        """Return the coordinates as a FieldOnNodesDouble object"""
        cdef cFieldOnNodesDouble cptr = self._inst.getCoordinates()

    #def hasGroupOfElements( self, string name )
    #def hasGroupOfNodes( self, string name )

    def readMEDFile( self, string pathFichier ):
        """Read a MED file"""
        assert self._inst, 'Pointer to C++ object not initialized'
        return self._inst.readMEDFile( pathFichier )
