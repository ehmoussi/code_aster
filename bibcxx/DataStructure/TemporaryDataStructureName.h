#ifndef TEMPORARYDATASTRUCTURE_H_
#define TEMPORARYDATASTRUCTURE_H_

/**
 * @file TemporaryDataStructure.h
 * @brief Fichier entete de la classe TemporaryDataStructure
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

/**
 * @class TemporaryDataStructure
 * @brief Classe permet de donner un nom temporaire a une sd
 * @author Nicolas Sellenet
 */
class TemporaryDataStructure
{
    private:
        /** @brief Numéro du no temporaire */
        static unsigned long int _number;
        static const unsigned long int _maxNumberOfAsterObjects = 268435455;

    public:
        /**
         * @brief Function membre getNewTemporaryName
         */
        static std::string getNewTemporaryName( int lengthName = 8 )
        {
            std::ostringstream oss;
            assert( _number <= _maxNumberOfAsterObjects );
            oss << "&" << std::hex << _number;
            ++_number;
            return std::string( oss.str() + "                        ", 0, lengthName );
        };
};

#endif /* TEMPORARYDATASTRUCTURE_H_ */
