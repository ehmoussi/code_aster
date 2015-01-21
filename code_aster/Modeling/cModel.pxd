# coding: utf-8

from libcpp.string cimport string

from code_aster.Mesh.cMesh cimport cMesh
from cPhysicsAndModeling cimport Physics, Modelings

cdef extern from "Modelisations/Model.h":

    cdef cppclass cModelInstance "ModelInstance":

        cModelInstance()
        void addModelisationOnAllMesh( Physics phys, Modelings mod )
        void addModelisationOnGroupOfElements( Physics phys, Modelings mod, string nameOfGroup )
        void addModelisationOnGroupOfNodes( Physics phys, Modelings mod, string nameOfGroup )
        void setSplittingMethod()
        bint setSupportMesh( cMesh& currentMesh )
        cMesh& getSupportMesh()
        bint build()

    cdef cppclass cModel "Model":

        cModel( bint init )
        cModelInstance* getInstance()
        void copy( cModel& other )
        bint isEmpty()
