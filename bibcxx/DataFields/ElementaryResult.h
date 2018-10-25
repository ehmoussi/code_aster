#ifndef ELEMENTARYRESULT_H_
#define ELEMENTARYRESULT_H_

/**
 * @file ElementaryResult.h
 * @brief Fichier entete de la classe ElementaryResult
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

#include "DataStructures/DataStructure.h"
#include "MemoryManager/JeveuxVector.h"
#include "MemoryManager/JeveuxCollection.h"

/**
 * @class ElementaryResultInstance
 * @brief Class which describe a RESUELEM
 * @author Nicolas Sellenet
 */
template < class ValueType > class ElementaryResultInstance : public DataStructure {
  private:
    /** @brief Objet Jeveux '.NOLI' */
    JeveuxVectorChar24 _noli;
    /** @brief Objet Jeveux '.DESC' */
    JeveuxVectorLong _desc;
    /** @brief Objet Jeveux '.RESL' */
    JeveuxCollection< ValueType > _resl;

  public:
    /**
     * @typedef ElementaryResultPtr
     * @brief Pointeur intelligent vers un ElementaryResult
     */
    typedef boost::shared_ptr< ElementaryResultInstance > ElementaryResultPtr;

    /**
     * @brief Constructor
     * @param name Jeveux name
     */
    ElementaryResultInstance( const std::string name, const std::string type = "RESUELEM",
                              const JeveuxMemory memType = Permanent )
        : DataStructure( name, 19, type, memType ),
          _noli( JeveuxVectorChar24( getName() + ".NOLI" ) ),
          _desc( JeveuxVectorLong( getName() + ".DESC" ) ),
          _resl( JeveuxCollection< ValueType >( getName() + ".RESL" ) ){};

    /**
     * @brief Constructor
     * @param memType allocation memory
     */
    ElementaryResultInstance( const JeveuxMemory memType = Permanent,
                              const std::string type = "RESUELEM" )
        : DataStructure( type, memType, 19 ), _noli( JeveuxVectorChar24( getName() + ".NOLI" ) ),
          _desc( JeveuxVectorLong( getName() + ".DESC" ) ),
          _resl( JeveuxCollection< ValueType >( getName() + ".RESL" ) ){};
};

/**
 * @typedef ElementaryResultDoublePtr
 */
typedef boost::shared_ptr< ElementaryResultInstance< double > > ElementaryResultDoublePtr;

/**
 * @typedef ElementaryResultComplexPtr
 */
typedef boost::shared_ptr< ElementaryResultInstance< DoubleComplex > > ElementaryResultComplexPtr;

#endif /* ELEMENTARYRESULT_H_ */
