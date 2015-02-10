#ifndef JEVEUXSTRING_H_
#define JEVEUXSTRING_H_

/**
 * @file JeveuxString.h
 * @brief Definition d'une chaine a la maniere Fortran (sans \0 a la fin)
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

#include <string.h>
#include <string>

#include "astercxx.h"

#include <assert.h>

/**
 * @class JeveuxString
 * @brief Cette classe template permet de definir une chaine fortran rapidement manipulable
 * @author Nicolas Sellenet
 */
template< int length >
class JeveuxString
{
    private:
        /** @brief Pointeur vers la chaine de caractere */
        char currentValue[ length ];

    public:
        /**
         * @brief Constructeur par defaut
         */
        inline JeveuxString()
        {
            memset( &currentValue, ' ', sizeof( char )*length );
        };

        /**
         * @brief Constructeur a partir d'un char*
         * @param chaine Chaine a recopier en style fortran
         */
        inline JeveuxString( const char* chaine )
        {
            assert( strlen( chaine ) <= length );
            memset( &currentValue, ' ', sizeof( char )*length );
            memcpy( &currentValue, chaine, sizeof( char )*strlen( chaine ) );
        };

        /**
         * @brief Constructeur a partir d'une reference vers une chaine
         * @param chaine Chaine a recopier en style fortran
         */
        inline JeveuxString( const char& chaine )
        {
            assert( strlen( chaine ) <= length );
            memset( &currentValue, ' ', sizeof( char )*length );
            memcpy( &currentValue, &chaine, sizeof( char )*strlen( chaine ) );
        };

        /**
         * @brief Surcharge de l'operateur = pour une affectation rapide
         * @param chaine Recopie a partir d'un JeveuxString
         * @return reference vers la chaine recopiee
         */
        inline JeveuxString& operator=( const JeveuxString< length >& chaine )
        {
            assert( strlen( chaine ) <= length );
            memcpy( &currentValue, &( chaine.currentValue ), sizeof( char )*strlen( chaine ) );
            return *this;
        };

        /**
         * @brief Surcharge de l'operateur = pour une affectation rapide a partir d'un char*
         * @param chaine Recopie a partir d'un char*
         * @return reference vers la chaine recopiee
         */
        inline JeveuxString& operator=( const char* chaine )
        {
            assert( strlen( chaine ) <= length );
            memcpy( &currentValue, chaine, sizeof( char )*strlen( chaine ) );
            return *this;
        };

        /**
         * @brief Fonction permettant d'obtenir le pointeur vers le debut de la chaine
         * @return Pointeur vers le debut de la chaine. Attention pas de \0 a la fin !!
         */
        inline const char* c_str() const
        {
            return currentValue;
        };

        /**
         * @brief Fonction renvoyant la taille de la chaine
         * @return un entier
         */
        inline int size() const
        {
            return length;
        };

        /**
         * @brief Fonction renvoyant une string correspondant a une recopie de l'objet
         * @return string contenant la chaine contenue dans l'objet
         */
        inline std::string toString() const
        {
            return std::string( currentValue, length );
        };

        std::string rstrip() const
        {
            std::string buff ( currentValue, length );
            std::string whitespaces ( " \t\f\v\n\r" );
            std::size_t found = buff.find_last_not_of( whitespaces );
            if ( found != std::string::npos )
                buff.erase( found + 1 );
            else
                buff.clear();
            return buff;
        }
};

/** @typedef Definition d'une chaine Jeveux de longueur 8 */
typedef JeveuxString< 8 > JeveuxChar8;
/** @typedef Definition d'une chaine Jeveux de longueur 16 */
typedef JeveuxString< 16 > JeveuxChar16;
/** @typedef Definition d'une chaine Jeveux de longueur 24 */
typedef JeveuxString< 24 > JeveuxChar24;
/** @typedef Definition d'une chaine Jeveux de longueur 32 */
typedef JeveuxString< 32 > JeveuxChar32;
/** @typedef Definition d'une chaine Jeveux de longueur 80 */
typedef JeveuxString< 80 > JeveuxChar80;

#endif
