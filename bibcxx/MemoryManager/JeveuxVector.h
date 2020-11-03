#ifndef JEVEUXVECTOR_H_
#define JEVEUXVECTOR_H_

/**
 * @file JeveuxVector.h
 * @brief Fichier entete de la classe JeveuxVector
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

#include <string>

#include "astercxx.h"
#include "aster_fort_jeveux.h"
#include "aster_utils.h"
#include "shared_vars.h"

#include "MemoryManager/JeveuxAllowedTypes.h"
#include "MemoryManager/JeveuxObject.h"

/**
 * @class JeveuxVectorClass
 * @brief Cette classe template permet de definir un vecteur Jeveux
 * @author Nicolas Sellenet
 * @todo rajouter un constructeur de nom jeveux pour que .NSLV soit bien placé (cf DOFNumbering.cxx)
 */
template < typename ValueType >
class JeveuxVectorClass : public JeveuxObjectClass, private AllowedJeveuxType< ValueType > {
  private:
    /** @brief Pointeur vers la premiere position du vecteur Jeveux */
    ValueType *_valuePtr;

  public:
    /**
     * @brief Constructeur
     * @param name Nom jeveux du vecteur
     *   Attention, le pointeur est mis a zero. Avant d'utiliser ce vecteur,
     *   il faut donc faire appel a JeveuxVectorClass::updateValuePointer
     */
    JeveuxVectorClass( const std::string &nom, JeveuxMemory mem = Permanent )
        : JeveuxObjectClass( nom, mem ), _valuePtr( nullptr ){};

    /**
     * @brief Destructeur
     */
    ~JeveuxVectorClass() {
// #ifdef _DEBUG_CXX
//         std::cout << "DEBUG: JeveuxVector.destr: " << _name << std::endl;
// #endif
        _valuePtr = nullptr;
    };

    /**
     * @brief Surcharge de l'operateur =
     */
    JeveuxVectorClass &operator=( JeveuxVectorClass< ValueType > &toCopy ) {
        if ( this->size() != 0 )
            this->deallocate();
        this->allocate( _mem, toCopy.size() );
        toCopy.updateValuePointer();
        for ( int i = 0; i < toCopy.size(); ++i )
            this->operator[]( i ) = toCopy[i];
        return *this;
    };

    /**
     * @brief Surcharge de l'operateur =
     */
    JeveuxVectorClass &operator=( const std::vector< ValueType > &toCopy ) {
        if ( this->size() != 0 )
            this->deallocate();
        this->allocate( _mem, toCopy.size() );
        for ( int i = 0; i < int(toCopy.size()); ++i )
            this->operator[]( i ) = toCopy[i];
        return *this;
    };

    /**
     * @brief Surcharge de l'operateur [] avec des const
     * @param i Indice dans le tableau Jeveux
     * @return la valeur du tableau Jeveux a la position i
     */
    inline const ValueType &operator[]( const int &i ) const
    {
#ifdef _DEBUG_CXX
        if( _valuePtr == nullptr )
            throw std::runtime_error("Vector not allocated " + _name);
#endif
        return _valuePtr[i];
    };

    /**
     * @brief Surcharge de l'operateur [] sans const (pour les lvalue)
     * @param i Indice dans le tableau Jeveux
     * @return la valeur du tableau Jeveux a la position i
     */
    inline ValueType &operator[]( const int &i )
    {
#ifdef _DEBUG_CXX
        if( _valuePtr == nullptr )
            throw std::runtime_error("Vector not allocated " + _name);
#endif
        return _valuePtr[i];
    };

    /**
     * @brief Fonction d'allocation d'un vecteur Jeveux
     * @param jeveuxBase Base sur laquelle doit etre allouee le vecteur : 'G' ou 'V'
     * @param length Longueur du vecteur Jeveux a allouer
     * @return true si l'allocation s'est bien passee
     */
    bool allocate( JeveuxMemory jeveuxBase, unsigned ASTERINTEGER length ) {
        if ( _name != "" && length > 0 ) {
            _mem = jeveuxBase;
            std::string strJeveuxBase( "V" );
            if ( jeveuxBase == Permanent )
                strJeveuxBase = "G";
            ASTERINTEGER taille = length;
            const int intType = AllowedJeveuxType< ValueType >::numTypeJeveux;
            std::string carac = strJeveuxBase + " V " + JeveuxTypesNames[intType];
            CALLO_WKVECTC( _name, carac, &taille, (void *)( &_valuePtr ) );
            if ( _valuePtr == NULL )
                return false;
        } else
            return false;
        updateValuePointer();
        return true;
    };

    /**
     * @brief Desallocation d'un vecteur Jeveux
     */
    void deallocate() {
        if ( _name != "" && get_sh_jeveux_status() == 1 )
            CALLO_JEDETR( _name );
    };

    /**
     * @brief Return a pointer to the vector
     */
    const ValueType *getDataPtr() const { return _valuePtr; };

    /**
     * @brief Get the value of DOCU parameter of jeveux object
     */
    std::string getInformationParameter() const {
        const std::string param( "DOCU" );
        std::string charval( 4, ' ' );
        ASTERINTEGER valTmp;
        CALLO_JELIRA( _name, param, &valTmp, charval );
        std::string toReturn( charval );
        return toReturn;
    };

    /**
     * @brief Return the name
     */
    std::string getName() const { return _name; };

    /**
     * @brief Fonction pour savoir si un vecteur est alloue
     * @return true si le vecteur est alloue
     */
    bool isAllocated() { return exists(); };

    /**
     * @brief Set the value of DOCU parameter of jeveux object
     */
    bool setInformationParameter( const std::string value ) {
        if ( !exists() )
            return false;

        const std::string param( "DOCU" );
        CALLO_JEECRA_STRING_WRAP( _name, param, value );
        return true;
    };

    /**
     * @brief Set the value of LONUTI of jeveux object
     */
    bool setUsedSize( ASTERINTEGER value ) {
        if ( !exists() )
            return false;

        const std::string param( "LONUTI" );
        CALLO_JEECRA_WRAP( _name, param, &value );
        return true;
    };

    /**
     * @brief Return the size of the vector
     */
    ASTERINTEGER size() const {
        if ( !exists() )
            return 0;

        ASTERINTEGER vectSize;
        JeveuxChar8 param( "LONMAX" );
        JeveuxChar32 dummy( " " );
        CALLO_JELIRA( _name, param, &vectSize, dummy );
        return vectSize;
    };

    /**
     * @brief Return the size of the vector
     */
    ASTERINTEGER usedSize() const {
        if ( !exists() )
            return 0;

        ASTERINTEGER vectSize;
        JeveuxChar8 param( "LONUTI" );
        JeveuxChar32 dummy( " " );
        CALLO_JELIRA( _name, param, &vectSize, dummy );
        return vectSize;
    };

    /**
     * @brief Mise a jour du pointeur Jeveux
     * @return true si la mise a jour s'est bien passee
     */
    bool updateValuePointer() {
        _valuePtr = NULL;
        if ( !exists() )
            return false;

        const std::string read( "L" );
        CALLO_JEVEUOC( _name, read, (void *)( &_valuePtr ) );
        if ( _valuePtr == NULL )
            return false;
        return true;
    };

    /** @brief Convert to std::vector */
    std::vector< ValueType > toVector() const {
        if ( _valuePtr == nullptr )
            throw std::runtime_error( "Pointer is null" );
        std::vector< ValueType > toReturn;
        toReturn.reserve(size());
        for ( int i = 0; i < size(); ++i )
            toReturn.push_back( _valuePtr[i] );
        return toReturn;
    };
};

/**
 * @class JeveuxVector
 * @brief Enveloppe d'un pointeur intelligent vers un JeveuxVectorClass
 * @author Nicolas Sellenet
 * @todo Supprimer la classe enveloppe
 */
template < class ValueType > class JeveuxVector {
  public:
    typedef boost::shared_ptr< JeveuxVectorClass< ValueType > > JeveuxVectorTypePtr;

  private:
    JeveuxVectorTypePtr _jeveuxVectorPtr;

  public:
    /* Default constructor to be initialized with a null pointer
     * and really created later.
     */
    JeveuxVector() : _jeveuxVectorPtr( nullptr ){};

    JeveuxVector( std::string nom )
        : _jeveuxVectorPtr( new JeveuxVectorClass< ValueType >( nom ) ){};

    ~JeveuxVector(){};

    JeveuxVector &operator=( const JeveuxVector< ValueType > &tmp ) {
        _jeveuxVectorPtr = tmp._jeveuxVectorPtr;
        return *this;
    };

    const JeveuxVectorTypePtr &operator->( void ) const { return _jeveuxVectorPtr; };

    JeveuxVectorClass< ValueType > &operator*( void ) const { return *_jeveuxVectorPtr; };

    bool isEmpty() const {
        if ( _jeveuxVectorPtr == nullptr )
            return true;
        if ( _jeveuxVectorPtr.use_count() == 0 )
            return true;
        return false;
    };
};

/** @typedef Definition d'un vecteur Jeveux long */
typedef JeveuxVector< ASTERINTEGER > JeveuxVectorLong;
/** @typedef Definition d'un vecteur Jeveux short int */
typedef JeveuxVector< short int > JeveuxVectorShort;
/** @typedef Definition d'un vecteur Jeveux double */
typedef JeveuxVector< double > JeveuxVectorReal;
/** @typedef Definition d'un vecteur Jeveux double complex */
typedef JeveuxVector< RealComplex > JeveuxVectorComplex;
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
