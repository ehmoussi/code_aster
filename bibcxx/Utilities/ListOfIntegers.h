#ifndef LISTOFINTEGERS_H_
#define LISTOFINTEGERS_H_

/**
 * @file ListOfIntegers.h
 * @brief Fichier entete de la classe ListOfIntegers
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

#include "DataStructures/DataStructure.h"
#include "MemoryManager/JeveuxVector.h"

/**
 * @class ListOfIntegersClass
 * @brief Cette classe correspond a une listr8
 * @author Nicolas Sellenet
 */
class ListOfIntegersClass : public DataStructure {
  private:
    /** @brief Objet Jeveux '.BINT' */
    JeveuxVectorReal _bint;
    /** @brief Objet Jeveux '.LPAS' */
    JeveuxVectorReal _lpas;
    /** @brief Objet Jeveux '.NBPA' */
    JeveuxVectorLong _nbPa;
    /** @brief Objet Jeveux '.VALE' */
    JeveuxVectorLong _vale;

  public:
    /**
     * @typedef ListOfIntegersPtr
     * @brief Pointeur intelligent vers un ListOfIntegers
     */
    typedef boost::shared_ptr< ListOfIntegersClass > ListOfIntegersPtr;

    /**
     * @brief Constructeur
     */
    ListOfIntegersClass() : ListOfIntegersClass( ResultNaming::getNewResultName() ){};

    /**
     * @brief Constructeur
     */
    ListOfIntegersClass( const std::string name )
        : DataStructure( name, 19, "LISTIS", Permanent ),
          _bint( JeveuxVectorReal( getName() + ".BINT" ) ),
          _lpas( JeveuxVectorReal( getName() + ".LPAS" ) ),
          _nbPa( JeveuxVectorLong( getName() + ".NBPA" ) ),
          _vale( JeveuxVectorLong( getName() + ".VALE" ) ){};
};

/**
 * @typedef ListOfIntegersPtr
 * @brief Pointeur intelligent vers un ListOfIntegersClass
 */
typedef boost::shared_ptr< ListOfIntegersClass > ListOfIntegersPtr;

#endif /* LISTOFINTEGERS_H_ */
