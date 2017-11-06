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
#include "aster_utils.h"

#include "MemoryManager/JeveuxAllowedTypes.h"
#include "MemoryManager/JeveuxObject.h"

#include <string>

/**
 * @class JeveuxVectorInstance
 * @brief Cette classe template permet de definir un vecteur Jeveux
 * @author Nicolas Sellenet
 * @todo rajouter un constructeur de nom jeveux pour que .NSLV soit bien placé (cf DOFNumbering.cxx)
 */
template< typename ValueType >
class JeveuxVectorInstance: public JeveuxObjectInstance, private AllowedJeveuxType< ValueType >
{
    private:
        /** @brief Pointeur vers la premiere position du vecteur Jeveux */
        ValueType*  _valuePtr;

    public:
        /**
         * @brief Constructeur
         * @param name Nom jeveux du vecteur
         *   Attention, le pointeur est mis a zero. Avant d'utiliser ce vecteur,
         *   il faut donc faire appel a JeveuxVectorInstance::updateValuePointer
         */
        JeveuxVectorInstance( const std::string& nom, JeveuxMemory mem = Permanent ):
            JeveuxObjectInstance( nom, mem ),
            _valuePtr( NULL )
        {};

        /**
         * @brief Destructeur
         */
        ~JeveuxVectorInstance()
        {
#ifdef __DEBUG_GC__
            std::cout << "JeveuxVector.destr: " << _name << std::endl;
#endif
            _valuePtr = NULL;
        };

        /**
         * @brief Surcharge de l'operateur =
         */
        JeveuxVectorInstance& operator=( JeveuxVectorInstance< ValueType >& toCopy )
        {
            if( this->size() != 0 )
                this->deallocate();
            this->allocate( _mem, toCopy.size() );
            toCopy.updateValuePointer();
            for( int i = 0; i < toCopy.size(); ++i )
                this->operator[](i) = toCopy[i];
            return *this;
        };

        /**
         * @brief Surcharge de l'operateur =
         */
        JeveuxVectorInstance& operator=( const std::vector< ValueType >& toCopy )
        {
            if( this->size() != 0 )
                this->deallocate();
            this->allocate( _mem, toCopy.size() );
            for( int i = 0; i < toCopy.size(); ++i )
                this->operator[](i) = toCopy[i];
            return *this;
        };

        /**
         * @brief Surcharge de l'operateur [] avec des const
         * @param i Indice dans le tableau Jeveux
         * @return la valeur du tableau Jeveux a la position i
         */
        inline const ValueType &operator[]( const int& i ) const
        {
            return _valuePtr[i];
        };

        /**
         * @brief Surcharge de l'operateur [] sans const (pour les lvalue)
         * @param i Indice dans le tableau Jeveux
         * @return la valeur du tableau Jeveux a la position i
         */
        inline ValueType &operator[]( const int& i )
        {
            return _valuePtr[i];
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
                _mem = jeveuxBase;
                std::string strJeveuxBase( "V" );
                if ( jeveuxBase == Permanent ) strJeveuxBase = "G";
                long taille = length;
                const int intType = AllowedJeveuxType< ValueType >::numTypeJeveux;
                std::string carac = strJeveuxBase + " V " + JeveuxTypesNames[intType];
                CALLO_WKVECTC( _name, carac, &taille, (void*)(&_valuePtr));
                if ( _valuePtr == NULL ) return false;
            }
            else return false;
            updateValuePointer();
            return true;
        };

        /**
         * @brief Desallocation d'un vecteur Jeveux
         */
        void deallocate()
        {
            if ( _name != "" )
                CALLO_JEDETR( _name );
        };

        /**
         * @brief Return a pointer to the vector
         */
        const ValueType* getDataPtr() const
        {
            return _valuePtr;
        };

        /**
         * @brief Get the value of DOCU parameter of jeveux object
         */
        std::string getInformationParameter() const
        {
            const std::string param( "DOCU" );
            std::string charval(4, ' ');
            long valTmp;
            CALLO_JELIRA( _name, param, &valTmp, charval );
            std::string toReturn( charval );
            return toReturn;
        };

        /**
         * @brief Return the name
         */
        std::string getName() const
        {
            return _name;
        };

        /**
         * @brief Fonction pour savoir si un vecteur est alloue
         * @return true si le vecteur est alloue
         */
        bool isAllocated()
        {
            return exists();
        };

        /**
         * @brief Set the value of DOCU parameter of jeveux object
         */
        bool setInformationParameter( const std::string value )
        {
            if( ! exists() ) return false;

            const std::string param( "DOCU" );
            CALLO_JEECRA_STRING_WRAP( _name, param, value );
        };

        /**
         * @brief Return the size of the vector
         */
        long size() const
        {
            if( ! exists() ) return 0;

            long vectSize;
            JeveuxChar8 param( "LONMAX" );
            JeveuxChar32 dummy( " " );
            CALLO_JELIRA( _name, param, &vectSize, dummy );
            return vectSize;
        };

        /**
         * @brief Mise a jour du pointeur Jeveux
         * @return true si la mise a jour s'est bien passee
         */
        bool updateValuePointer()
        {
            _valuePtr = NULL;
            if( ! exists() ) return false;

            const std::string read( "L" );
            CALLO_JEVEUOC( _name, read, (void*)(&_valuePtr) );
            if ( _valuePtr == NULL )
                return false;
            return true;
        };
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
/** @typedef Definition d'un vecteur JeveuxLogical */
typedef JeveuxVector< bool > JeveuxVectorLogical;

#endif /* JEVEUXVECTOR_H_ */