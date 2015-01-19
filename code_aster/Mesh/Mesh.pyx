# coding: utf-8

from libcpp.string cimport string

cimport cMesh
from code_aster.DataFields.cFieldOnNodes cimport cFieldOnNodesDouble

from code_aster.DataFields.FieldOnNodes cimport FieldOnNodesDouble


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
        cdef cFieldOnNodesDouble coord = self._inst.getCoordinates()
        coordinates = FieldOnNodesDouble( init=False )
        coordinates.assign( coord )
        return coordinates

    #def hasGroupOfElements( self, string name )
    #def hasGroupOfNodes( self, string name )

    def readMEDFile( self, string pathFichier ):
        """Read a MED file"""
        assert self._inst, 'Pointer to C++ object not initialized'
        return self._inst.readMEDFile( pathFichier )
