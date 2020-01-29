#ifndef ELEMENTARYRESULT_H_
#define ELEMENTARYRESULT_H_

/**
 * @file ElementaryTerm.h
 * @brief Fichier entete de la classe ElementaryTerm
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

#include "DataStructures/DataStructure.h"
#include "MemoryManager/JeveuxVector.h"
#include "MemoryManager/JeveuxCollection.h"

/**
 * @class ElementaryTermClass
 * @brief Class which describe a RESUELEM
 * @author Nicolas Sellenet
 */
template < class ValueType > class ElementaryTermClass : public DataStructure {
  private:
    /** @brief Objet Jeveux '.NOLI' */
    JeveuxVectorChar24 _noli;
    /** @brief Objet Jeveux '.DESC' */
    JeveuxVectorLong _desc;
    /** @brief Objet Jeveux '.RESL' */
    JeveuxCollection< ValueType > _resl;

  public:
    /**
     * @typedef ElementaryTermPtr
     * @brief Pointeur intelligent vers un ElementaryTerm
     */
    typedef boost::shared_ptr< ElementaryTermClass > ElementaryTermPtr;

    /**
     * @brief Constructor
     * @param name Jeveux name
     */
    ElementaryTermClass( const std::string name, const std::string type = "RESUELEM",
                              const JeveuxMemory memType = Permanent )
        : DataStructure( name, 19, type, memType ),
          _noli( JeveuxVectorChar24( getName() + ".NOLI" ) ),
          _desc( JeveuxVectorLong( getName() + ".DESC" ) ),
          _resl( JeveuxCollection< ValueType >( getName() + ".RESL" ) ){};

    /**
     * @brief Constructor
     * @param memType allocation memory
     */
    ElementaryTermClass( const JeveuxMemory memType = Permanent,
                              const std::string type = "RESUELEM" )
        : DataStructure( type, memType, 19 ), _noli( JeveuxVectorChar24( getName() + ".NOLI" ) ),
          _desc( JeveuxVectorLong( getName() + ".DESC" ) ),
          _resl( JeveuxCollection< ValueType >( getName() + ".RESL" ) ){};
};

/**
 * @typedef ElementaryTermDoublePtr
 */
typedef boost::shared_ptr< ElementaryTermClass< double > > ElementaryTermDoublePtr;

/**
 * @typedef ElementaryTermComplexPtr
 */
typedef boost::shared_ptr< ElementaryTermClass< DoubleComplex > > ElementaryTermComplexPtr;

#endif /* ELEMENTARYRESULT_H_ */
