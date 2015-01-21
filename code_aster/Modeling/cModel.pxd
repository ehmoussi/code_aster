# coding: utf-8

from libcpp.string cimport string

from code_aster.Mesh.cMesh cimport cMesh
from cPhysicsAndModeling cimport Physics, Modeling

cdef extern from "Modelisations/Model.h":

    cdef cppclass cModelInstance "ModelInstance":

        cModelInstance()
        void addModelisationOnAllMesh( Physics phys, Modeling mod )
        void setSplittingMethod()
        bint setSupportMesh( cMesh& currentMesh )
        cMesh& getSupportMesh()

    cdef cppclass cModel "Model":

        cModel( bint init )
        cModelInstance* getInstance()
        void copy( cModel& other )
        bint isEmpty()
