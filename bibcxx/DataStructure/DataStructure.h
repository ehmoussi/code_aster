#ifndef DATASTRUCTURE_H_
#define DATASTRUCTURE_H_

/**
 * @file DataStructure.h
 * @brief Fichier entete de la classe DataStructure
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

#ifdef __cplusplus

#include <stdexcept>
#include <string>
#include <map>

#include "astercxx.h"
#include "aster_fort.h"


/**
 * @class DataStructure
 * @brief Classe mere des classes representant des sd_aster
 * @author Nicolas Sellenet
 */
class DataStructure
{
    private:
        /** @brief Nom de la sd */
        /** @todo remettre le const */
        std::string _name;
        /** @brief Type de la sd */
        std::string _type;

    public:
        /**
         * @brief Constructeur
         * @param name Nom Jeveux de la sd
         * @param type Type Aster de la sd
         */
        DataStructure( std::string name, std::string type );

        /**
         * @brief Constructeur
         */
        DataStructure();

        /**
         * @brief Destructeur
         */
        ~DataStructure() throw ( std::runtime_error );

        /**
         * @brief Function membre getName
         * @return une chaine contenant le nom de la sd
         */
        const std::string& getName() const
        {
            return _name;
        };

        /**
         * @brief Function membre getType
         * @return le type de la sd
         */
        const std::string& getType() const
        {
            return _type;
        };

        /**
         * @brief Function membre debugPrint
         * @param logicalUnit Unite logique d'impression
         */
        void debugPrint( const int logicalUnit ) const;

    protected:
        /**
         * @brief Methode servant a fixer a posteriori le type d'une sd
         * @param newType chaine contenant le nouveau type
         */
        void setType( const std::string newType )
        {
            _type = newType;
        };
};

/** @typedef std::map d'une chaine et des pointers vers toutes les DataStructure */
typedef std::map< std::string, DataStructure* > mapStrSD;
/** @typedef Iterateur sur le std::map */
typedef mapStrSD::iterator mapStrSDIterator;
/** @typedef Valeur contenue dans mapStrSD */
typedef mapStrSD::value_type mapStrSDValue;

/**
 * @brief map< string, DataStructure* > mapNameDataStructure
 *   Ce map contient toutes les DataStructures initialisees
 */
extern mapStrSD mapNameDataStructure;

#endif

#ifdef __cplusplus
extern "C" {
#endif

/**
 * @fn getSDType
 * @brief Obtention du type de la sd dont le nom est passe en argument
 */
char* getSDType(char*);

#ifdef __cplusplus
}
#endif

#endif /* DATASTRUCTURE_H_ */
