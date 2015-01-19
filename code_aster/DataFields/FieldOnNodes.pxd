# coding: utf-8

from cFieldOnNodes cimport cFieldOnNodesInstanceDouble, cFieldOnNodesDouble


cdef class FieldOnNodesDouble:

    cdef cFieldOnNodesDouble* _cptr
    cdef cFieldOnNodesInstanceDouble* _inst

    cdef assign( self, cFieldOnNodesDouble other )
