# coding: utf-8


cdef extern from "Modeling/PhysicsAndModelings.h":

    cdef enum Physics:
        cMechanics "Mechanics"
        cThermal "Thermal"
        cAcoustics "Acoustics"

    cdef enum Modelings:
        cAxisymmetrical "Axisymmetrical"
        cTridimensional "Tridimensional"
        cPlanar "Planar"
        cDKT "DKT"
