# coding: utf-8

from cFieldOnNodes cimport cFieldOnNodesDouble


cdef class FieldOnNodesDouble:

    cdef cFieldOnNodesDouble* _cptr

    cdef copy( self, cFieldOnNodesDouble& other )
