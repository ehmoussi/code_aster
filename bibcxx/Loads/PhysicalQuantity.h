#ifndef PHYSICALQUANTITY_H_
#define PHYSICALQUANTITY_H_

#include <list>
#include <set>
#include <string>

using namespace std;

/* person_in_charge: nicolas.sellenet at edf.fr */

/**
* enum AsterCoordinates
*   Toutes les coordonnes des grandeurs de Code_Aster
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

// /**
// * class ElementaryCoordinate
// *   Classes qui sert a definir une composante elementaire d'une grandeur
// * @author Nicolas Sellenet
// */
// template< class ValueType, const AsterCoordinates *AsterCoords, int NbCoord >
// class ElementaryCoordinate
// {
//     private:
//         typedef ValueType CoordinateType;
//         typedef AsterCoordinates CoordinateEnum;
// 
//         string         _name;
//         CoordinateEnum _coordEnum;
// 
//     public:
//         /**
//         * Constructeur
//         * @param name Nom Aster de la composante 
//         * @param curEnum Numero de la composante dans AsterCoordinates
//         */
//         ElementaryCoordinate(string name, AsterCoordinates curEnum): _name( name ),
//                                                                      _coordEnum( curEnum )
//         {};
// };
// 
// template< class ValueType, const AsterCoordinates *AsterCoords, int NbCoord >
// class PhysicalQuantity
// {
//     private:
//         set< AsterCoordinates >   _mapOfEnum;
// 
//     public:
//         typedef ValueType QuantityType;
// 
//         /**
//         * Constructeur
//         */
//         PhysicalQuantity()
//         {
//             for( int i = 0; i < NbCoord; ++i )
//             {
//                 const int num = (int) AsterCoords[i];
//                 _mapOfEnum.insert( AsterCoords[i] );
//             }
//         };
// 
//         /**
//         * Construction du MaterialInstance
//         *   A partir des GeneralMaterialBehaviour ajoutes par l'utilisateur :
//         *   creation de objets Jeveux
//         * @param testValue AsterCoordinates a tester
//         * @return Booleen indiquant si la composante appartient a la grandeur physique
//         */
//         bool hasCoordinate( AsterCoordinates testValue ) const
//         {
//             if ( _mapOfEnum.find( testValue ) == _mapOfEnum.end() ) return false;
//             return true;
//         };
// };

/**
* class PhysicalQuantity
*   Classe definissant un grandeur physique (DEPL_R, TEMP_R, etc.)
*   Classe template prenant en arguments :
*    - le type (double, complex, ...)
*    - la liste des AsterCoordinates correspondant a la grandeur
*    - le nombre de composantes
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
