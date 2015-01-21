# coding: utf-8

from libcpp.string cimport string

from cMesh cimport cMesh


cdef class Mesh:

    cdef cMesh* _cptr

    cdef copy( self, cMesh& other )
