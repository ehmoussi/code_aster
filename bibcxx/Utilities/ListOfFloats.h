#ifndef LISTOFFLOATS_H_
#define LISTOFFLOATS_H_

/**
 * @file ListOfFloats.h
 * @brief Fichier entete de la classe ListOfFloats
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
#include "MemoryManager/JeveuxVector.h"

/**
 * @class ListOfFloatsInstance
 * @brief Cette classe correspond a une listr8
 * @author Nicolas Sellenet
 */
class ListOfFloatsInstance : public DataStructure {
  private:
    /** @brief Objet Jeveux '.BINT' */
    JeveuxVectorDouble _bint;
    /** @brief Objet Jeveux '.LPAS' */
    JeveuxVectorDouble _lpas;
    /** @brief Objet Jeveux '.NBPA' */
    JeveuxVectorLong _nbPa;
    /** @brief Objet Jeveux '.VALE' */
    JeveuxVectorDouble _vale;

  public:
    /**
     * @typedef ListOfFloatsPtr
     * @brief Pointeur intelligent vers un ListOfFloats
     */
    typedef boost::shared_ptr< ListOfFloatsInstance > ListOfFloatsPtr;

    /**
     * @brief Constructeur
     */
    ListOfFloatsInstance() : ListOfFloatsInstance( ResultNaming::getNewResultName() ){};

    /**
     * @brief Constructeur
     */
    ListOfFloatsInstance( const std::string name )
        : DataStructure( name, 19, "LISTR8", Permanent ),
          _bint( JeveuxVectorDouble( getName() + ".BINT" ) ),
          _lpas( JeveuxVectorDouble( getName() + ".LPAS" ) ),
          _nbPa( JeveuxVectorLong( getName() + ".NBPA" ) ),
          _vale( JeveuxVectorDouble( getName() + ".VALE" ) ){};

    VectorDouble getValues() const throw( std::runtime_error );

    void setVectorValues( const VectorDouble & ) throw( std::runtime_error );

    int size();
};

/**
 * @typedef ListOfFloatsPtr
 * @brief Pointeur intelligent vers un ListOfFloatsInstance
 */
typedef boost::shared_ptr< ListOfFloatsInstance > ListOfFloatsPtr;

#endif /* LISTOFFLOATS_H_ */
