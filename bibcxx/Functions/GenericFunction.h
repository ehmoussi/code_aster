#ifndef GENERICFUNCTION_H_
#define GENERICFUNCTION_H_

/**
 * @file GenericFunction.h
 * @brief Fichier entete de la classe GenericFunction
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2018  EDF R&D                www.code-aster.org
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

/* person_in_charge: nicolas.sellenet at edf.fr */

#include "astercxx.h"
#include "DataStructures/DataStructure.h"

/**
 * @class GenericFunctionInstance
 * @brief Base class of Function, Formula and Table
 * @author Nicolas Sellenet
 */
class GenericFunctionInstance : public DataStructure {
  private:
  public:
    /**
     * @typedef GenericFunctionPtr
     * @brief Pointeur intelligent vers un GenericFunction
     */
    typedef boost::shared_ptr< GenericFunctionInstance > GenericFunctionPtr;

    /**
     * @brief Constructeur
     */
    GenericFunctionInstance( const std::string &name, const std::string &type )
        : DataStructure( name, 19, type ){};

    /**
     * @brief Get the result name
     * @return  name of the result
     */
    virtual std::string getResultName() { return ""; };

    /**
     * @brief Return the number of points of the function
     */
    virtual ASTERINTEGER maximumSize() const throw( std::runtime_error ) { return 0; };

    /**
     * @brief Return the number of points of the function
     */
    virtual ASTERINTEGER size() const throw( std::runtime_error ) { return 0; };
};

/**
 * @typedef GenericFunctionPtr
 * @brief Pointeur intelligent vers un GenericFunctionInstance
 */
typedef boost::shared_ptr< GenericFunctionInstance > GenericFunctionPtr;

#endif /* GENERICFUNCTION_H_ */
