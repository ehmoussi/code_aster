# coding: utf-8

cdef extern from "RunManager/Initializer.h":

    void asterInitialization( int mode )
    void asterFinalization()
