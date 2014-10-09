#ifndef PHYSICSANDMODELISATIONS_H
#define PHYSICSANDMODELISATIONS_H

/* person_in_charge: nicolas.sellenet at edf.fr */

/**
* enum Physics
*   Physiques existantes dans Code_Aster
* @author Nicolas Sellenet
*/
enum Physics { Mechanics, Thermal, Acoustics };
static const char* const PhysicNames[] = { "MECANIQUE", "THERMIQUE", "ACOUSTIQUE" };

/**
* enum Modelisations
*   Modelisations existantes dans Code_Aster
* @author Nicolas Sellenet
*/
enum Modelisations { Axisymmetrical, Tridimensional, Planar, DKT };
static const char* const ModelisationNames[] = { "AXIS", "3D", "PLAN", "DKT" };

#endif /* PHYSICSANDMODELISATIONS_H */
