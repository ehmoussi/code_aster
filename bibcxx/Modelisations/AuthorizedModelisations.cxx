
#include "Modelisations/AuthorizedModelisations.h"

/**
* Initialisation des modelisations autorisees pour chaque physique
*/

const set< Modelisations > WrapMechanics::setOfModelisations( MechanicsModelisations,
                                                              MechanicsModelisations + nbModelisationsMechanics );

const set< Modelisations > WrapThermal::setOfModelisations( ThermalModelisations,
                                                            ThermalModelisations + nbModelisationsThermal );
