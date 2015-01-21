# coding: utf-8

ctypedef enum Physics: Mechanics, Thermal, Acoustics

ctypedef enum Modeling: Axisymmetrical, Tridimensional, Planar, DKT


cdef extern from "Modelisations/PhysicsAndModelisations.h":

    pass
