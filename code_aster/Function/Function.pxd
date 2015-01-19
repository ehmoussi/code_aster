# coding: utf-8

cimport cFunction


cdef class Function:

    cdef cFunction.Function* _cptr
