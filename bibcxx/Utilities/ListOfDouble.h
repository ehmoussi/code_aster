#ifndef LISTOFDOUBLE_H_
#define LISTOFDOUBLE_H_

/**
 * @file ListOfDouble.h
 * @brief Fichier entete de la classe ListOfDouble
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2017  EDF R&D                www.code-aster.org
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
#include "MemoryManager/JeveuxVector.h"

/**
 * @class ListOfDoubleInstance
 * @brief Cette classe correspond a une listr8
 * @author Nicolas Sellenet
 */
class ListOfDoubleInstance: public DataStructure
{
private:
    /** @brief Objet Jeveux '.BINT' */
    JeveuxVectorDouble   _bint;
    /** @brief Objet Jeveux '.LPAS' */
    JeveuxVectorDouble   _lpas;
    /** @brief Objet Jeveux '.NBPA' */
    JeveuxVectorLong     _nbPa;
    /** @brief Objet Jeveux '.VALE' */
    JeveuxVectorDouble   _vale;

public:
    /**
     * @typedef ListOfDoublePtr
     * @brief Pointeur intelligent vers un ListOfDouble
     */
    typedef boost::shared_ptr< ListOfDoubleInstance > ListOfDoublePtr;

    /**
     * @brief Constructeur
     */
    ListOfDoubleInstance():
        ListOfDoubleInstance( ResultNaming::getNewResultName() )
    {};

    /**
     * @brief Constructeur
     */
    ListOfDoubleInstance( const std::string name ):
        DataStructure( name, 19, "LISTR8", Permanent ),
        _bint( JeveuxVectorDouble( getName() + ".BINT" ) ),
        _lpas( JeveuxVectorDouble( getName() + ".LPAS" ) ),
        _nbPa( JeveuxVectorLong( getName() + ".NBPA" ) ),
        _vale( JeveuxVectorDouble( getName() + ".VALE" ) )
    {};

    VectorDouble getValues() const throw( std::runtime_error );
};

/**
 * @typedef ListOfDoublePtr
 * @brief Pointeur intelligent vers un ListOfDoubleInstance
 */
typedef boost::shared_ptr< ListOfDoubleInstance > ListOfDoublePtr;

#endif /* LISTOFDOUBLE_H_ */
