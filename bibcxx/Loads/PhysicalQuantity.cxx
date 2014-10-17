
/* person_in_charge: nicolas.sellenet at edf.fr */

#include "Loads/PhysicalQuantity.h"

const char* DisplacementCoordinatesNames[] = { "DX", "DY", "DZ", "DRX", "DRY", "DRZ" };
const char* ThermalCoordinatesNames[] = { "TEMP", "TEMP_MIL" };

PhysicalQuantity< double, DisplacementCoordinates, nbDisplacementCoordinates,
                  DisplacementCoordinatesNames > DoubleDisplacement( "DEPL" );
