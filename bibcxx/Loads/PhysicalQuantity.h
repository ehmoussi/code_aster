#ifndef PHYSICALQUANTITY_H_
#define PHYSICALQUANTITY_H_

#include <boost/type_traits/is_enum.hpp>
#include <boost/utility/enable_if.hpp>
#include <list>
#include <set>
#include <string>
#include <iostream>

using namespace std;

/* person_in_charge: nicolas.sellenet at edf.fr */

/**
* enum DisplacementCoordinates
*   Coordonnees du deplacement
* @author Nicolas Sellenet
*/
enum DisplacementCoordinates { Dx, Dy, Dz, Drx, Dry, Drz };
const int nbDisplacementCoordinates = 6;
extern const char* DisplacementCoordinatesNames[];

enum ThermalCoordinates { Temperature, MiddleTemperature };
const int nbThermalCoordinates = 2;
extern const char* ThermalCoordinatesNames[];

template< class ValueType, class Enum, int NbCoord, const char **CoordNames, typename Allowed = void >
class ElementaryCoordinate;

template< class ValueType, class Enum, int NbCoord, const char **CoordNames >
class ElementaryCoordinate< ValueType, Enum, NbCoord, CoordNames,
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

template< class ValueType, class Enum, int NbCoord, const char **CoordNames >
class PhysicalQuantity
{
    private:
        typedef ElementaryCoordinate< ValueType, Enum, NbCoord, CoordNames > CurrentCoordinate;
        typedef ValueType valueType;

        string                    _name;
        list< CurrentCoordinate > _listOfCoordinates;
        set< Enum >               _mapOfEnum;

    public:
        PhysicalQuantity( string name ): _name( name )
        {
            for( int i = 0; i < NbCoord; ++i )
            {
                _listOfCoordinates.push_back( CurrentCoordinate( CoordNames[i], (Enum) i ) );
                _mapOfEnum.insert( ( Enum ) i );
            }
        };

        bool hasCoordinate( Enum testValue )
        {
            if ( _mapOfEnum.find( testValue ) == _mapOfEnum.end() ) return false;
            return true;
        };
};

extern PhysicalQuantity< double, DisplacementCoordinates, nbDisplacementCoordinates,
                         DisplacementCoordinatesNames > DoubleDisplacement;

#endif /* PHYSICALQUANTITY_H_ */
