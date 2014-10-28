#ifndef PHYSICSANDMODELISATIONS_H_
#define PHYSICSANDMODELISATIONS_H_

/* person_in_charge: nicolas.sellenet at edf.fr */

/**
* enum Physics
*   Physiques existantes dans Code_Aster
* @author Nicolas Sellenet
*/
enum Physics { Mechanics, Thermal, Acoustics };
const int nbPhysics = 3;
extern const char* const PhysicNames[nbPhysics];

/**
* enum Modelisations
*   Modelisations existantes dans Code_Aster
* @author Nicolas Sellenet
*/
enum Modelisations { Axisymmetrical, Tridimensional, Planar, DKT };
const int nbModelisations = 4;
extern const char* const ModelisationNames[nbModelisations];


const int nbModelisationsMechanics = 4;
extern const Modelisations MechanicsModelisations[nbModelisationsMechanics];

const int nbModelisationsThermal = 3;
extern const Modelisations ThermalModelisations[nbModelisationsThermal];

#endif /* PHYSICSANDMODELISATIONS_H_ */
