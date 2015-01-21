# coding: utf-8

from cModel cimport cModel


cdef class Model:

    cdef cModel* _cptr

    cdef copy( self, cModel& other )
