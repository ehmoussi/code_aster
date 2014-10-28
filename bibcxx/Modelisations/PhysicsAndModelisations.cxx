
#include "PhysicsAndModelisations.h"

const char* const PhysicNames[nbPhysics] = { "MECANIQUE", "THERMIQUE", "ACOUSTIQUE" };
const char* const ModelisationNames[nbModelisations] = { "AXIS", "3D", "PLAN", "DKT" };


const Modelisations MechanicsModelisations[nbModelisationsMechanics] = { Axisymmetrical, Tridimensional,
                                                                         Planar, DKT };

const Modelisations ThermalModelisations[nbModelisationsThermal] = { Axisymmetrical, Tridimensional,
                                                                     Planar };
