# coding: utf-8

cimport cMesh


cdef class Mesh:

    cdef cMesh.Mesh* _cptr
    cdef cMesh.MeshInstance* _inst
