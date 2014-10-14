
#include "Modelisations/AuthorizedModelisations.h"

/**
* Initialisation des modelisations autorisees pour chaque physique
*/

Enum<AuthorizedMechnicsModelisation>::instances_list Enum<AuthorizedMechnicsModelisation>::s_instances;

const AuthorizedMechnicsModelisation AuthorizedMechnicsModelisation::ModelAxis(Axisymmetrical);
const AuthorizedMechnicsModelisation AuthorizedMechnicsModelisation::Model3D(Tridimensional);
const AuthorizedMechnicsModelisation AuthorizedMechnicsModelisation::ModelPlanar(Planar);
const AuthorizedMechnicsModelisation AuthorizedMechnicsModelisation::ModelDKT(DKT);


Enum<AuthorizedThermalModelisation>::instances_list Enum<AuthorizedThermalModelisation>::s_instances;

const AuthorizedThermalModelisation AuthorizedThermalModelisation::ModelAxis(Axisymmetrical);
const AuthorizedThermalModelisation AuthorizedThermalModelisation::Model3D(Tridimensional);
const AuthorizedThermalModelisation AuthorizedThermalModelisation::ModelPlanar(Planar);
