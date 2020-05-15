#ifndef NAMESMAP_H_
#define NAMESMAP_H_

/**
 * @file NamesMap.h
 * @brief Fichier entete de la classe JeveuxBidirectionnalMap
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

#include "MemoryManager/JeveuxAllowedTypes.h"
#include "MemoryManager/JeveuxObject.h"
#include "aster_fort.h"
#include "aster_utils.h"
#include "astercxx.h"

/**
 * @class NamesMapClass
 * @brief Equivalent du pointeur de nom dans Jeveux
 * @author Nicolas Sellenet
 */
template < typename ValueType >
class NamesMapClass : public JeveuxObjectClass, private AllowedJeveuxType< ValueType > {
  private:
    ASTERINTEGER _size;

  public:
    /**
     * @brief Constructeur
     * @param name Nom Jeveux de l'objet
     */
    NamesMapClass( std::string name, JeveuxMemory mem = Permanent )
        : JeveuxObjectClass( name, mem ), _size( 0 ){};

    /**
     * @brief Destructeur
     */
    ~NamesMapClass(){};

    /**
     * @brief Ajout d'un élément
     * @param position position of element to add
     * @param toAdd value to add
     * @return true if adding is ok
     */
    bool add( const int &position, const ValueType &toAdd ) {
        if ( position <= _size ) {
            JeveuxChar32 objName( " " );
            CALLO_JEXNOM( objName, _name, toAdd );
            CALLO_JECROC( objName );
            return true;
        }
        return false;
    };

    /**
     * @brief Allocation
     * @param mem Mémoire d'allocation
     * @param size Taille
     * @return vrai en cas d'allocation
     */
    bool allocate( JeveuxMemory mem, int size ) {
        _mem = mem;
        if ( _name != "" && size > 0 ) {
            std::string strJeveuxBase( "V" );
            if ( mem == Permanent )
                strJeveuxBase = "G";
            ASTERINTEGER taille = size;
            const int intType = AllowedJeveuxType< ValueType >::numTypeJeveux;
            std::string carac = strJeveuxBase + " N " + JeveuxTypesNames[intType];
            CALLO_JECREO( _name, carac );
            std::string param( "NOMMAX" );
            CALLO_JEECRA_WRAP( _name, param, &taille );
            _size = size;
            return true;
        }
        return false;
    };

    /**
     * @brief Recuperation de la chaine correspondante a l'entier
     * @param index Numero de l'element demande
     * @return Chaine de caractere correspondante
     */
    std::string getStringFromIndex( ASTERINTEGER index ) const {
        JeveuxChar32 objName( " " );
        JeveuxChar32 charName( " " );
        CALLO_JEXNUM( objName, _name, &index );
        CALLO_JENUNO( objName, charName );
        return charName.toString();
    };

    /**
     * @brief Recuperation de l'entier correspondant a une chaine
     * @param string Chaine recherchee
     * @return Entier correspondant
     */
    ASTERINTEGER getIndexFromString( const std::string &string ) const {
        JeveuxChar32 objName( " " );
        CALLO_JEXNOM( objName, _name, string );
        ASTERINTEGER resu = -1;
        CALLO_JENONU( objName, &resu );
        return resu;
    };

    /**
     * @brief Get the size
     * @return size of object
     */
    ASTERINTEGER size() const {
        if ( !exists() )
            return 0;

        ASTERINTEGER vectSize;
        JeveuxChar8 param( "NOMMAX" );
        JeveuxChar32 dummy( " " );
        CALLO_JELIRA( _name, param, &vectSize, dummy );
        return vectSize;
    };
};

/**
 * class NamesMap
 *   Enveloppe d'un pointeur intelligent vers un NamesMapClass
 * @author Nicolas Sellenet
 */
template < class ValueType > class NamesMap {
  public:
    typedef boost::shared_ptr< NamesMapClass< ValueType > > NamesMapPtr;

  private:
    NamesMapPtr _namesMapPtr;

  public:
    NamesMap( std::string nom ) : _namesMapPtr( new NamesMapClass< ValueType >( nom ) ){};

    ~NamesMap(){};

    NamesMap &operator=( const NamesMap< ValueType > &tmp ) {
        _namesMapPtr = tmp._namesMapPtr;
        return *this;
    };

    const NamesMapPtr &operator->(void)const { return _namesMapPtr; };

    bool isEmpty() const {
        if ( _namesMapPtr.use_count() == 0 )
            return true;
        return false;
    };
};

/** @typedef Definition d'un pointeur de nom Jeveux long */
typedef NamesMap< ASTERINTEGER > NamesMapLong;
/** @typedef Definition d'un pointeur de nom Jeveux short int */
typedef NamesMap< short int > NamesMapShort;
/** @typedef Definition d'un pointeur de nom Jeveux double */
typedef NamesMap< double > NamesMapReal;
/** @typedef Definition d'un pointeur de nom Jeveux double complex */
typedef NamesMap< RealComplex > NamesMapComplex;
/** @typedef Definition d'un vecteur de JeveuxChar8 */
typedef NamesMap< JeveuxChar8 > NamesMapChar8;
/** @typedef Definition d'un pointeur de nom JeveuxChar16 */
typedef NamesMap< JeveuxChar16 > NamesMapChar16;
/** @typedef Definition d'un pointeur de nom JeveuxChar24 */
typedef NamesMap< JeveuxChar24 > NamesMapChar24;
/** @typedef Definition d'un pointeur de nom JeveuxChar32 */
typedef NamesMap< JeveuxChar32 > NamesMapChar32;
/** @typedef Definition d'un pointeur de nom JeveuxChar80 */
typedef NamesMap< JeveuxChar80 > NamesMapChar80;
/** @typedef Definition d'un pointeur de nom JeveuxLogical */
typedef NamesMap< bool > NamesMapLogical;

#endif /* NAMESMAP_H_ */
