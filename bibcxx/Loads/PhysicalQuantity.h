#ifndef PHYSICALQUANTITY_H_
#define PHYSICALQUANTITY_H_

#include <list>
#include <set>
#include <string>

using namespace std;

/* person_in_charge: nicolas.sellenet at edf.fr */

/**
* enum AsterCoordinates
*   Toutes les coordonnees des grandeurs de Code_Aster
* @author Nicolas Sellenet
*/
enum AsterCoordinates { Dx, Dy, Dz, Drx, Dry, Drz, Temperature, MiddleTemperature };
extern const char* AsterCoordinatesNames[8];

/**
* Declaration des coordonnees du deplacement
*   Coordonnees du deplacement
* @author Nicolas Sellenet
*/
const int nbDisplacementCoordinates = 6;
extern const AsterCoordinates DeplCoordinates[nbDisplacementCoordinates];

/**
* Declaration des coordonnees de la temperature
*   Coordonnees du deplacement
* @author Nicolas Sellenet
*/
const int nbThermalCoordinates = 2;
extern const AsterCoordinates TempCoordinates[nbThermalCoordinates];

// Ces wrappers sont la pour autoriser que les set soitent const
// Sinon, on aurait pas pu passer directement des const set<> en parametre template
struct WrapDepl
{
    static const set< AsterCoordinates > setOfCoordinates;
};

struct WrapTemp
{
    static const set< AsterCoordinates > setOfCoordinates;
};

/**
* class PhysicalQuantity
*   Classe definissant un grandeur physique (DEPL_R, TEMP_R, etc.)
*   Classe template prenant en arguments :
*    - le type (double, complex, ...)
*    - la classe correspondant a la grandeur (DEPL, TEMP, ...)
* @author Nicolas Sellenet
*/
template< class ValueType, class Wrapping >
class PhysicalQuantity
{
    public:
        typedef ValueType QuantityType;

        static bool hasCoordinate( AsterCoordinates test )
        {
            if ( Wrapping::setOfCoordinates.find( test ) == Wrapping::setOfCoordinates.end() ) return false;
            return true;
        }
};

typedef PhysicalQuantity< double, WrapDepl > DoubleDisplacementType;

typedef PhysicalQuantity< double, WrapTemp > DoubleTemperatureType;

#endif /* PHYSICALQUANTITY_H_ */
