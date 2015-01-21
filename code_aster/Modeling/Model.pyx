# coding: utf-8

from libcpp.string cimport string
from cython.operator cimport dereference as deref

from code_aster.Mesh.Mesh cimport Mesh
from code_aster.Mesh.cMesh cimport cMesh
from cModel cimport cModel


cdef class Model:
    """Python wrapper on the C++ Model object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        self._cptr = new cModel( init )

    cdef copy( self, cModel& other ):
        """Refer to an existing C++ object"""
        self._cptr.copy( other )

    def __dealloc__( self ):
        """Destructor"""
        if self._cptr:
            del self._cptr

    def isEmpty( self ):
        """Tell if the object is empty"""
        return self._cptr.isEmpty()

    def setSupportMesh( self, Mesh mesh ):
        """Set the support mesh of the model"""
        ok = self._cptr.getInstance().setSupportMesh( deref(mesh._cptr) )
        return ok

    def getSupportMesh( self ):
        """Return the support mesh"""
        cdef cMesh* cmesh
        cmesh = &(self._cptr.getInstance().getSupportMesh())
        mesh = Mesh()
        mesh.copy( deref(cmesh) )
        return mesh
