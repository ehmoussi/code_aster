# coding: utf-8

cimport cFieldOnNodes

ctypedef cFieldOnNodes.FieldOnNodes[double] cFieldOnNodesDouble


cdef class FieldOnNodesDouble:

    cdef cFieldOnNodes.FieldOnNodes[double]* _cptr
    cdef cFieldOnNodes.FieldOnNodesInstance[double]* _inst

    cdef assign
