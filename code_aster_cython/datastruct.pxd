# coding: utf-8

cimport cMesh
cimport cFunction


cdef class Mesh:

    cdef cMesh.Mesh* _cptr
    cdef cMesh.MeshInstance* _inst


cdef class Function:

    cdef cFunction.Function* _cptr
    cdef cFunction.FunctionInstance* _inst
