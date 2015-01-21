# coding: utf-8

from cPhysicsAndModeling cimport cMechanics, cThermal, cAcoustics
from cPhysicsAndModeling cimport cAxisymmetrical, cTridimensional, cPlanar, cDKT
from cModel cimport cModel


cdef class Model:

    cdef cModel* _cptr

    cdef copy( self, cModel& other )
