
/* person_in_charge: nicolas.sellenet at edf.fr */

#include "Loads/PhysicalQuantity.h"

const char* AsterCoordinatesNames[8] = { "DX", "DY", "DZ", "DRX", "DRY", "DRZ", "TEMP", "TEMP_MIL" };

const AsterCoordinates DeplCoordinates[nbDisplacementCoordinates] = { Dx, Dy, Dz, Drx, Dry, Drz };

const AsterCoordinates TempCoordinates[nbThermalCoordinates] = { Temperature, MiddleTemperature };


const set< AsterCoordinates >WrapDepl::setOfCoordinates( DeplCoordinates, DeplCoordinates + nbDisplacementCoordinates );

const set< AsterCoordinates >WrapTemp::setOfCoordinates( TempCoordinates, TempCoordinates + nbThermalCoordinates );
