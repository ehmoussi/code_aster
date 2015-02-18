#ifndef JEVEUXVECTOR_H_
#define JEVEUXVECTOR_H_

/**
 * @file JeveuxVector.h
 * @brief Fichier entete de la classe JeveuxVector
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

#include "astercxx.h"
#include "aster_fort.h"

#include "MemoryManager/JeveuxAllowedTypes.h"

#include <string>

/**
 * @class JeveuxVectorInstance
 * @brief Cette classe template permet de definir un vecteur Jeveux
 * @author Nicolas Sellenet
 */
template< typename ValueType >
class JeveuxVectorInstance: private AllowedJeveuxType< ValueType >
{
    private:
        /** @brief Nom du vecteur Jeveux */
        std::string _name;
        /** @brief Pointeur vers la premiere position du vecteur Jeveux */
        ValueType*  _valuePtr;

    public:
        /**
         * @brief Constructeur
         * @param name Nom jeveux du vecteur
         *   Attention, le pointeur est mis a zero. Avant d'utiliser ce vecteur,
         *   il faut donc faire appel a JeveuxVectorInstance::updateValuePointer
         */
        JeveuxVectorInstance( std::string nom ): _name( nom ), _valuePtr( NULL )
        {};

        /**
         * @brief Destructeur
         */
        ~JeveuxVectorInstance()
        {
            if ( _name != "" )
            {
                CALL_JEDETR(  _name.c_str() );
            }
        };

        /**
         * @brief Surcharge de l'operateur [] avec des const
         * @param i Indice dans le tableau Jeveux
         * @return la valeur du tableau Jeveux a la position i
         */
        inline const ValueType &operator[]( int i ) const
        {
            return _valuePtr[i];
        };

        /**
         * @brief Surcharge de l'operateur [] sans const (pour les lvalue)
         * @param i Indice dans le tableau Jeveux
         * @return la valeur du tableau Jeveux a la position i
         */
        inline ValueType &operator[]( int i )
        {
            return _valuePtr[i];
        };

        /**
         * @brief Mise a jour du pointeur Jeveux
         * @return true si la mise a jour s'est bien passee
         */
        bool updateValuePointer()
        {
            _valuePtr = NULL;
            // Si on n'a pas de nom, on sort
            if ( _name == "" ) return false;

            long boolRetour;
            // Appel a jeexin pour verifier que le vecteur existe
            CALL_JEEXIN( _name.c_str(), &boolRetour );
            if ( boolRetour == 0 ) return false;

            const char* tmp = "L";
            CALL_JEVEUOC( _name.c_str(), tmp, (void*)(&_valuePtr) );
            if ( _valuePtr == NULL ) return false;
            return true;
        };

        /**
         * @brief Fonction d'allocation d'un vecteur Jeveux
         * @param jeveuxBase Base sur laquelle doit etre allouee le vecteur : 'G' ou 'V'
         * @param length Longueur du vecteur Jeveux a allouer
         * @return true si l'allocation s'est bien passee
         */
        bool allocate( JeveuxMemory jeveuxBase, unsigned long length )
        {
            if ( _name != "" && length > 0 )
            {
                std::string strJeveuxBase( "V" );
                if ( jeveuxBase == Permanent ) strJeveuxBase = "G";
                long taille = length;
                const int intType = AllowedJeveuxType< ValueType >::numTypeJeveux;
                std::string carac = strJeveuxBase + " V " + JeveuxTypesNames[intType];
                CALL_WKVECTC( _name.c_str(), carac.c_str(),
                              &taille, (void*)(&_valuePtr));
                if ( _valuePtr == NULL ) return false;
            }
            else return false;
            return true;
        };

        /**
         * @brief Return a pointer to the vector
         */
        const ValueType* getDataPtr() const
        {
            return _valuePtr;
        }

        /**
         * @brief Return the size of the vector
         */
        long size() const
        {
            long vectSize;
            JeveuxChar8 param( "LONMAX" );
            // JeveuxChar32 dummy( " " );
            char dummy[32] = " ";
            CALL_JELIRA( _name.c_str(), param.c_str(), &vectSize, dummy );
            return vectSize;
        }
};

/**
 * @class JeveuxVector
 * @brief Enveloppe d'un pointeur intelligent vers un JeveuxVectorInstance
 * @author Nicolas Sellenet
 * @todo Supprimer la classe enveloppe
 */
template<class ValueType>
class JeveuxVector
{
    public:
        typedef boost::shared_ptr< JeveuxVectorInstance< ValueType > > JeveuxVectorTypePtr;

    private:
        JeveuxVectorTypePtr _jeveuxVectorPtr;

    public:
        JeveuxVector(std::string nom): _jeveuxVectorPtr( new JeveuxVectorInstance< ValueType > (nom) )
        {};

        ~JeveuxVector()
        {};

        JeveuxVector& operator=(const JeveuxVector< ValueType >& tmp)
        {
            _jeveuxVectorPtr = tmp._jeveuxVectorPtr;
            return *this;
        };

        const JeveuxVectorTypePtr& operator->(void) const
        {
            return _jeveuxVectorPtr;
        };

        JeveuxVectorInstance< ValueType >& operator*(void) const
        {
            return *_jeveuxVectorPtr;
        };

        bool isEmpty() const
        {
            if ( _jeveuxVectorPtr.use_count() == 0 ) return true;
            return false;
        };
};

/** @typedef Definition d'un vecteur Jeveux long */
typedef JeveuxVector< long > JeveuxVectorLong;
/** @typedef Definition d'un vecteur Jeveux short int */
typedef JeveuxVector< short int > JeveuxVectorShort;
/** @typedef Definition d'un vecteur Jeveux double */
typedef JeveuxVector< double > JeveuxVectorDouble;
/** @typedef Definition d'un vecteur Jeveux double complex */
typedef JeveuxVector< DoubleComplex > JeveuxVectorComplex;
/** @typedef Definition d'un vecteur de JeveuxChar8 */
typedef JeveuxVector< JeveuxChar8 > JeveuxVectorChar8;
/** @typedef Definition d'un vecteur JeveuxChar16 */
typedef JeveuxVector< JeveuxChar16 > JeveuxVectorChar16;
/** @typedef Definition d'un vecteur JeveuxChar24 */
typedef JeveuxVector< JeveuxChar24 > JeveuxVectorChar24;
/** @typedef Definition d'un vecteur JeveuxChar32 */
typedef JeveuxVector< JeveuxChar32 > JeveuxVectorChar32;
/** @typedef Definition d'un vecteur JeveuxChar80 */
typedef JeveuxVector< JeveuxChar80 > JeveuxVectorChar80;

#endif /* JEVEUXVECTOR_H_ */
