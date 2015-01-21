# coding: utf-8


cdef extern from "Modelisations/PhysicsAndModelisations.h":

    cdef enum Physics:
        cMechanics "Mechanics"
        cThermal "Thermal"
        cAcoustics "Acoustics"

    cdef enum Modelings "Modelisations":
        cAxisymmetrical "Axisymmetrical"
        cTridimensional "Tridimensional"
        cPlanar "Planar"
        cDKT "DKT"
