#ifndef PHYSICALQUANTITY_H_
#define PHYSICALQUANTITY_H_

#include <boost/type_traits/is_enum.hpp>
#include <boost/type_traits/is_floating_point.hpp>
#include <boost/type_traits/is_same.hpp>
#include <boost/utility/enable_if.hpp>
#include <list>
#include <set>
#include <string>

using namespace std;

/* person_in_charge: nicolas.sellenet at edf.fr */

/**
* enum DisplacementCoordinates
*   Coordonnees du deplacement
* @author Nicolas Sellenet
*/
enum DisplacementCoordinates { Dx, Dy, Dz, Drx, Dry, Drz };
static const int nbDisplacementCoordinates = 6;
static const char* const DisplacementCoordinatesNames[] = { "DX", "DY", "DZ", "DRX", "DRY", "DRZ" };

enum ThermalCoordinates { Temperature, MiddleTemperature };
static const int nbThermalCoordinates = 2;
static const char* const ThermalCoordinatesNames[] = { "TEMP", "TEMP_MIL" };

template< class ValueType, class Enum, typename Allowed = void >
class ElementaryCoordinate;

template< class ValueType, class Enum >
class ElementaryCoordinate< ValueType, Enum,
                            typename boost::enable_if< boost::is_enum< Enum >, void >::type >
{
    private:
        typedef ValueType CoordinateType;
        typedef Enum CoordinateEnum;

        string         _name;
        CoordinateEnum _coordEnum;

    public:
        ElementaryCoordinate(string name, Enum curEnum): _name( name ), _coordEnum( curEnum )
        {};
};

template< class ValueType, class Enum >
class PhysicalQuantity
{
    private:
        typedef ElementaryCoordinate< ValueType, Enum > CurrentCoordinate;

        string                    _name;
        list< CurrentCoordinate > _listOfCoordinates;
        set< Enum >               _mapOfEnum;

    public:
        PhysicalQuantity( string name, const int nbCoord, const char* const names[] ): _name( name )
        {
            for( int i = 0; i < nbCoord; ++i )
            {
                _listOfCoordinates.push_back( CurrentCoordinate( names[i], (Enum) i ) );
                _mapOfEnum.insert( ( Enum ) i );
            }
        };

        bool hasCoordinate( Enum testValue )
        {
            if ( _mapOfEnum.find( testValue ) == _mapOfEnum.end() ) return false;
            return true;
        };
};

extern PhysicalQuantity< double, DisplacementCoordinates > Displacement;

#endif /* PHYSICALQUANTITY_H_ */
