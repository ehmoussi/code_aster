#ifndef JEVEUXALLOWEDTYPES_H_
#define JEVEUXALLOWEDTYPES_H_

/* person_in_charge: nicolas.sellenet at edf.fr */

#include "command/Initializer.h"
#include <complex.h>

/**
* enumeration JeveuxTypes
*   fournit tous les types existant dans le gestionnaire memoire Jeveux
* @author Nicolas Sellenet
*/
enum JeveuxTypes { Integer, Integer4, Double, Complex, Char8, Char16, Char24, Char32, Char80 };
/**
* liste JeveuxTypesNames
*   fournit sous forme de chaine les types Jeveux existant
* @author Nicolas Sellenet
*/
static const char* JeveuxTypesNames[9] = { "I", "I4", "R", "C", "K8", "K16", "K24", "K32", "K80" };

/**
* struct template AllowedJeveuxType
*   structure permettant de limiter le type instanciable de JeveuxVectorInstance
*   on se limite aux type de JeveuxTypes
* @author Nicolas Sellenet
*/
template<typename T>
struct AllowedJeveuxType; // undefined for bad types!

template<> struct AllowedJeveuxType< long >
{
     static const unsigned short numTypeJeveux = Integer;
};

template<> struct AllowedJeveuxType< short int >
{
     static const unsigned short numTypeJeveux = Integer4;
};

template<> struct AllowedJeveuxType< double >
{
     static const unsigned short numTypeJeveux = Double;
};

template<> struct AllowedJeveuxType< double complex >
{
     static const unsigned short numTypeJeveux = Complex;
};

template<> struct AllowedJeveuxType< char[8] >
{
     static const unsigned short numTypeJeveux = Char8;
};

template<> struct AllowedJeveuxType< char[16] >
{
     static const unsigned short numTypeJeveux = Char16;
};

template<> struct AllowedJeveuxType< char[24] >
{
     static const unsigned short numTypeJeveux = Char24;
};

template<> struct AllowedJeveuxType< char[32] >
{
     static const unsigned short numTypeJeveux = Char32;
};

template<> struct AllowedJeveuxType< char[80] >
{
     static const unsigned short numTypeJeveux = Char80;
};

#endif /* JEVEUXALLOWEDTYPES_H_ */
