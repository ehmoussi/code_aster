# coding: utf-8

cimport cCataBuilder


cdef class CataBuilder:

    cdef cCataBuilder.CataBuilder* _cptr
