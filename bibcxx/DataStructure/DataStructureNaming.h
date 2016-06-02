#ifndef DATASTRUCTURENAMING_H_
#define DATASTRUCTURENAMING_H_

/**
 * @file DataStructureNaming.h
 * @brief Fichier entete de la classe DataStructureNaming
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
/* person_in_charge: nicolas.sellenet at edf.fr */

#include <assert.h>
#include <string>
#include <sstream>

#include "MemoryManager/JeveuxAllowedTypes.h"
#include "DataStructure/TemporaryDataStructureName.h"

/**
 * @class DataStructureNaming
 * @brief Classe permet de donner un nom temporaire a une sd
 * @author Nicolas Sellenet
 */
class DataStructureNaming
{
    public:
        /**
         * @brief Function membre getNewName
         */
        static std::string getNewName( JeveuxMemory memoryType, int lengthName = 8 )
            throw ( std::runtime_error )
        {
            if ( memoryType == Permanent )
            {
                std::string tmpName = getNewResultObjectName();
                return std::string( tmpName + "                        ", 0, lengthName );
            }
            else if ( memoryType == Temporary )
                return TemporaryDataStructure::getNewTemporaryName( lengthName );
            else
                throw std::runtime_error( "Programming error" );
            return "";
        };
};

#endif /* DATASTRUCTURENAMING_H_ */
