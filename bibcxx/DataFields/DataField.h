#ifndef GENERICDATAFIELD_H_
#define GENERICDATAFIELD_H_

/**
 * @file DataField.h
 * @brief Fichier entete de la classe DataField
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

/**
 * @class DataFieldClass
 * @brief Generic class which describe a field of data
 * @author Nicolas Sellenet
 */
class DataFieldClass : public DataStructure {
  private:
  public:
    /**
     * @typedef DataFieldPtr
     * @brief Pointeur intelligent vers un DataField
     */
    typedef boost::shared_ptr< DataFieldClass > DataFieldPtr;

    /**
     * @brief Constructor
     * @param name Jeveux name
     */
    DataFieldClass( const std::string name, const std::string type = "CHAM_GD",
                              const JeveuxMemory memType = Permanent )
        : DataStructure( name, 19, type, memType ){};

    /**
     * @brief Constructor
     * @param memType allocation memory
     */
    DataFieldClass( const JeveuxMemory memType = Permanent,
                              const std::string type = "CHAM_GD" )
        : DataStructure( type, memType, 19 ){};
};

/**
 * @typedef DataFieldPtrDouble
 */
typedef boost::shared_ptr< DataFieldClass > DataFieldPtr;

#endif /* GENERICDATAFIELD_H_ */
