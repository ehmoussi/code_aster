# coding: utf-8

from libcpp.string cimport string

from code_aster.Mesh.cMesh cimport cMesh

cdef extern from "Modelisations/Model.h":

    cdef cppclass cModelInstance "ModelInstance":

        cModelInstance()
        bint setSupportMesh( cMesh& currentMesh )
        cMesh& getSupportMesh()

    cdef cppclass cModel "Model":

        cModel( bint init )
        cModelInstance* getInstance()
        void copy( cModel& other )
        bint isEmpty()
