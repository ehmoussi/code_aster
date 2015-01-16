# coding: utf-8

cdef extern from "RunManager/CataBuilder.h":

    cdef cppclass CataBuilder:

        CataBuilder()
        void run()
