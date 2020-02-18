#ifndef SURFACE_H_
#define SURFACE_H_

/**
 * @file Surface.h
 * @brief Fichier entete de la classe Surface
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2020  EDF R&D                www.code-aster.org
 *
 *   This file is part of Code_Aster.
 *
 *   Code_Aster is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 3 of the License, or
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

/* person_in_charge: nicolas.sellenet at edf.fr */

#include "astercxx.h"

#include "MemoryManager/JeveuxVector.h"
#include "MemoryManager/JeveuxCollection.h"
#include "Supervis/ResultNaming.h"
#include "Functions/GenericFunction.h"

/**
 * @class SurfaceClass
 * @brief Cette classe correspond a une nappe
 * @author Nicolas Sellenet
 */
class SurfaceClass : public GenericFunctionClass {
  private:
    // Vecteur Jeveux '.PARA'
    JeveuxVectorReal _parameters;
    // Vecteur Jeveux '.VALE'
    JeveuxCollectionReal _value;

  public:
    /**
     * @typedef SurfacePtr
     * @brief Pointeur intelligent vers un Surface
     */
    typedef boost::shared_ptr< SurfaceClass > SurfacePtr;

    /**
     * @brief Constructeur
     */
    SurfaceClass() : SurfaceClass( ResultNaming::getNewResultName() ){};

    /**
     * @brief Constructeur
     */
    SurfaceClass( const std::string name )
        : GenericFunctionClass( name, "NAPPE", "NAPPE" ),
          _parameters( JeveuxVectorReal( getName() + ".PARA" ) ),
          _value( JeveuxCollectionReal( getName() + ".VALE" ) ){};

    /**
     * @brief Copy extension parameters to python list
     * @return  return list of parameters
     */
    PyObject *exportExtensionToPython() const ;

    /**
     * @brief Copy parameters to python list
     * @return  return list of parameters
     */
    PyObject *exportParametersToPython() const ;

    /**
     * @brief Copy values to python list [[[func1_abs],[func1_ord]],[[func2_abs],[func2_ord]],...]
     * @return  return list of list of list of values
     */
    PyObject *exportValuesToPython() const ;

    /**
     * @brief Get the result name
     * @return  name of the result
     */
    std::string getResultName() {
        if ( !_property->exists() )
            return "";
        _property->updateValuePointer();
        return ( *_property )[3].toString();
    };

    /**
     * @brief Return the number of points of the function
     */
    ASTERINTEGER maximumSize() const {
        _value->buildFromJeveux();
        ASTERINTEGER toReturn = 0;
        for ( const auto &curIter : *_value ) {
            if ( curIter.size() > toReturn )
                toReturn = curIter.size();
        }
        return toReturn;
    };

    /**
     * @brief Return the number of points of the function
     */
    ASTERINTEGER size() const {
        _value->buildFromJeveux();
        ASTERINTEGER toReturn = 0;
        for ( const auto &curIter : *_value ) {
            toReturn += curIter.size();
        }
        return toReturn;
    };
};

/**
 * @typedef SurfacePtr
 * @brief Pointeur intelligent vers un SurfaceClass
 */
typedef boost::shared_ptr< SurfaceClass > SurfacePtr;

#endif /* SURFACE_H_ */
