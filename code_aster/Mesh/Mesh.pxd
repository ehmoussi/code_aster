# coding: utf-8

from libcpp.string cimport string

cimport cMesh


cdef class Mesh:

    cdef cMesh.Mesh* _cptr
    cdef cMesh.MeshInstance* _inst

    # cdef bint isEmpty
    # cdef bint readMEDFile
