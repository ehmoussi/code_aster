# coding: utf-8

from libcpp.string cimport string

cdef extern from "Function/Function.h":

    cdef cppclass FunctionInstance:
        FunctionInstance()
        void setParameterName( string name )
        bint build()

    cdef cppclass Function:

        Function(bint init)
        FunctionInstance* getInstance()
        bint isEmpty()
