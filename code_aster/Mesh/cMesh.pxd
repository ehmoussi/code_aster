# coding: utf-8

from libcpp.string cimport string

from code_aster.DataFields.cFieldOnNodes cimport FieldOnNodes

cdef extern from "Mesh/Mesh.h":

    cdef cppclass cMeshInstance "MeshInstance":

        cMeshInstance()
        FieldOnNodes[double] getCoordinates()
        bint hasGroupOfElements( string name )
        bint hasGroupOfNodes( string name )
        bint readMEDFile( string pathFichier )

    cdef cppclass cMesh "Mesh":

        cMesh(bint init)
        cMeshInstance* getInstance()
        void copy( cMesh& other )
        bint isEmpty()
