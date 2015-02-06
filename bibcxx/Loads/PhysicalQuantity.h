#ifndef PHYSICALQUANTITY_H_
#define PHYSICALQUANTITY_H_

/**
 * @file PhysicalQuantity.h
 * @brief Fichier definissant les grandeurs physiques de Code_Aster
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2014  EDF R&D                www.code-aster.org
 *
 *   This file is part of Code_Aster.
 *
 *   Code_Aster is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 2 of the License, or
 *   (at your option) any later version.
 *
 *   Code_Aster is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with Code_Aster.  If not, see <http://www.gnu.org/licenses/>.
 */

#include <list>
#include <set>

/* person_in_charge: nicolas.sellenet at edf.fr */

/**
 * @enum AsterCoordinates
 * @brief Toutes les coordonnees des grandeurs de Code_Aster
 */
enum AsterCoordinates { Dx, Dy, Dz, Drx, Dry, Drz, Temperature, MiddleTemperature, Pressure };
extern const char* AsterCoordinatesNames[9];

/**
 * @def nbDisplacementCoordinates
 * @brief Nombre de coordonnees du deplacement
 */
const int nbDisplacementCoordinates = 6;
/**
 * @def DeplCoordinates
 * @brief Declaration des coordonnees du deplacement
 */
extern const AsterCoordinates DeplCoordinates[nbDisplacementCoordinates];

/**
 * @def nbThermalCoordinates
 * @brief Nombre de coordonnees de la temperature
 */
const int nbThermalCoordinates = 2;
/**
 * @def TempCoordinates
 * @brief Declaration des coordonnees de la temperature
 */
extern const AsterCoordinates TempCoordinates[nbThermalCoordinates];

/**
 * @def nbPressureCoordinates
 * @brief Number of of coordinates specifying a pressure 
 */
const int nbPressureCoordinates = 1;
/**
 * @def PresCoordinates
 * @brief Declare pressure coodinates 
 */
extern const AsterCoordinates PresCoordinates[nbPressureCoordinates];

// Ces wrappers sont la pour autoriser que les set soient const
// Sinon, on aurait pas pu passer directement des const set<> en parametre template
/**
 * @struct WrapDepl
 * @brief Structure destinee a definir les coordonnees autorisees pour DEPL
 */
struct WrapDepl
{
    /** @brief Coordonnees autorisees pour DEPL */
    static const std::set< AsterCoordinates > setOfCoordinates;
};

/**
 * @struct WrapTemp
 * @brief Structure destinee a definir les coordonnees autorisees pour TEMP
 */
struct WrapTemp
{
    /** @brief Coordonnees autorisees pour TEMP */
    static const std::set< AsterCoordinates > setOfCoordinates;
};

/**
 * @struct WrapTemp
 * @brief Structure destinee a definir les coordonnees autorisees pour TEMP
 */
struct WrapPres
{
    /** @brief Coordonnees autorisees pour PRESSION */
    static const std::set< AsterCoordinates > setOfCoordinates;
};

/**
 * @struct PhysicalQuantity
 * @brief Classe definissant un grandeur physique (DEPL_R, TEMP_R, etc.)
 * @author Nicolas Sellenet
 */
template< class ValueType, class Wrapping >
struct PhysicalQuantity
{
    /** @typedef Definition du type informatique de la grandeur physique */
    typedef ValueType QuantityType;

    /**
     * @brief Fonction statique hasCoordinate
     * @param test coordonnee a tester
     * @return vrai sur la coordonnee fait partie de la grandeur
     */
    static bool hasCoordinate( AsterCoordinates test )
    {
        if ( Wrapping::setOfCoordinates.find( test ) == Wrapping::setOfCoordinates.end() ) return false;
        return true;
    };
};

/** @typedef Definition de DEPL_R */
typedef PhysicalQuantity< double, WrapDepl > DoubleDisplacementType;

/** @typedef Definition de TEMP_R */
typedef PhysicalQuantity< double, WrapTemp > DoubleTemperatureType;

/** @typedef Pression */
typedef PhysicalQuantity< double, WrapPres > DoublePressureType;

#endif /* PHYSICALQUANTITY_H_ */
