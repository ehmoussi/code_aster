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
#include <stdexcept>

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

        /**
         * @brief Recopie securisee d'un char*
         * @param chaine char*
         * @param chaine Taille de la chaine a recopier
         */
        inline void safeCopyFromChar( const char* chaine, const int size )
        {
            if ( size < length )
            {
                memset( &currentValue, ' ', sizeof( char )*length );
                memcpy( &currentValue, chaine, sizeof( char )*size );
            }
            else
            {
                memcpy( &currentValue, chaine, sizeof( char )*length );
            }
        };

    public:
        /**
         * @brief Constructeur par defaut
         */
        inline JeveuxString()
        {};

        /**
         * @brief Constructeur a partir d'un char*
         * @param chaine Chaine a recopier en style fortran
         */
        inline JeveuxString( const JeveuxString< length >& chaine )
        {
            memcpy( &currentValue, chaine, sizeof( char )*length );
        };

        /**
         * @brief Constructeur rapide a partir d'un char*
         * @param chaine Chaine a recopier en style fortran
         * @param size Taille de la chaine a recopier
         */
        inline JeveuxString( const char* chaine, const int size )
        {
            safeCopyFromChar( chaine, size );
        };

        /**
         * @brief Constructeur a partir d'un char*
         * @param chaine Chaine a recopier en style fortran
         */
        inline JeveuxString( const char* chaine )
        {
            safeCopyFromChar( chaine, strlen( chaine ) );
        };

        /**
         * @brief Surcharge de l'operateur = pour une affectation rapide
         * @param chaine Recopie a partir d'un JeveuxString
         * @return Reference vers la chaine recopiee
         */
        inline JeveuxString& operator=( const JeveuxString< length >& chaine )
        {
            memcpy( &currentValue, &( chaine.currentValue ), sizeof( char )*length );
            return *this;
        };

        /**
         * @brief Surcharge de l'operateur = pour une affectation a partir d'un char*
         * @param chaine Recopie a partir d'un char*
         * @return reference vers la chaine recopiee
         */
        inline JeveuxString& operator=( const char* chaine )
        {
            safeCopyFromChar( chaine, strlen( chaine ) );
            return *this;
        };

        /**
         * @brief Surcharge de l'operateur = pour une affectation a partir d'une string
         * @param chaine Recopie a partir d'une string
         * @return reference vers la chaine recopiee
         */
        inline JeveuxString& operator=( const std::string& chaine )
        {
            safeCopyFromChar( chaine.c_str(), chaine.size() );
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
         * @brief Fonction permettant d'obtenir le pointeur vers le debut de la chaine
         * @return Pointeur vers le debut de la chaine. Attention pas de \0 a la fin !!
         */
        inline const char* c_str()
        {
            return currentValue;
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

        /**
         * @brief Unsafe fast copy from a char*
         * @param chaine String to copy
         */
        inline void unsafeFastCopy( const char* chaine )
#ifndef NDEBUG
            throw( std::runtime_error )
#endif
        {
#ifndef NDEBUG
            if ( strlen( chaine ) < length ) throw std::runtime_error( "String size error" );
#endif
            memcpy( &currentValue, chaine, sizeof( char )*length );
        };
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
