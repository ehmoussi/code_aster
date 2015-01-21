# coding: utf-8

from libcpp.string cimport string
from cython.operator cimport dereference as deref

from code_aster.Mesh.Mesh cimport Mesh
from code_aster.Mesh.cMesh cimport cMesh

from cPhysicsAndModeling cimport Physics, Modelings

Mechanics, Thermal, Acoustics = cMechanics, cThermal, cAcoustics
Axisymmetrical, Tridimensional, Planar, DKT = cAxisymmetrical, cTridimensional, cPlanar, cDKT


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

    def build( self ):
        """Build the model"""
        self._cptr.getInstance().build()

    def addModelingOnAllMesh( self, phys, mod ):
        """Add a modeling on all the mesh"""
        self._cptr.getInstance().addModelisationOnAllMesh( phys, mod )

    def addModelingOnGroupOfElements( self, phys, mod, nameOfGroup ):
        """Add a modeling on a group of elements"""
        self._cptr.getInstance().addModelisationOnGroupOfElements( phys, mod, nameOfGroup )

    def addModelingOnGroupOfNodes( self, phys, mod, nameOfGroup ):
        """Add a modeling on a group of nodes"""
        self._cptr.getInstance().addModelisationOnGroupOfNodes( phys, mod, nameOfGroup )

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
