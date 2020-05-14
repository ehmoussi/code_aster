#ifndef JEVEUXBIDIRECTIONALMAP_H_
#define JEVEUXBIDIRECTIONALMAP_H_

/**
 * @file JeveuxBidirectionalMap.h
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

#include "astercxx.h"
#include "MemoryManager/JeveuxObject.h"
#include "MemoryManager/JeveuxAllowedTypes.h"
#include "aster_fort.h"
#include "aster_utils.h"

/**
 * @class JeveuxBidirectionalMapClass
 * @brief Equivalent du pointeur de nom dans Jeveux
 * @author Nicolas Sellenet
 */
template < typename ValueType >
class JeveuxBidirectionalMapClass : public JeveuxObjectClass,
                                    private AllowedJeveuxType< ValueType > {
  private:
    ASTERINTEGER _size;

  public:
    /**
     * @brief Constructeur
     * @param name Nom Jeveux de l'objet
     */
    JeveuxBidirectionalMapClass( std::string name, JeveuxMemory mem = Permanent )
        : JeveuxObjectClass( name, mem ), _size( 0 ){};

    /**
     * @brief Destructeur
     */
    ~JeveuxBidirectionalMapClass(){};

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
 * class JeveuxBidirectionalMap
 *   Enveloppe d'un pointeur intelligent vers un JeveuxBidirectionalMapClass
 * @author Nicolas Sellenet
 */
template < class ValueType > class JeveuxBidirectionalMap {
  public:
    typedef boost::shared_ptr< JeveuxBidirectionalMapClass< ValueType > >
        JeveuxBidirectionalMapPtr;

  private:
    JeveuxBidirectionalMapPtr _jeveuxBidirectionalMapPtr;

  public:
    JeveuxBidirectionalMap( std::string nom )
        : _jeveuxBidirectionalMapPtr( new JeveuxBidirectionalMapClass< ValueType >( nom ) ){};

    ~JeveuxBidirectionalMap(){};

    JeveuxBidirectionalMap &operator=( const JeveuxBidirectionalMap< ValueType > &tmp ) {
        _jeveuxBidirectionalMapPtr = tmp._jeveuxBidirectionalMapPtr;
        return *this;
    };

    const JeveuxBidirectionalMapPtr &operator->( void ) const {
        return _jeveuxBidirectionalMapPtr;
    };

    bool isEmpty() const {
        if ( _jeveuxBidirectionalMapPtr.use_count() == 0 )
            return true;
        return false;
    };
};

/** @typedef Definition d'un pointeur de nom Jeveux long */
typedef JeveuxBidirectionalMap< ASTERINTEGER > JeveuxBidirectionalMapLong;
/** @typedef Definition d'un pointeur de nom Jeveux short int */
typedef JeveuxBidirectionalMap< short int > JeveuxBidirectionalMapShort;
/** @typedef Definition d'un pointeur de nom Jeveux double */
typedef JeveuxBidirectionalMap< double > JeveuxBidirectionalMapReal;
/** @typedef Definition d'un pointeur de nom Jeveux double complex */
typedef JeveuxBidirectionalMap< RealComplex > JeveuxBidirectionalMapComplex;
/** @typedef Definition d'un vecteur de JeveuxChar8 */
typedef JeveuxBidirectionalMap< JeveuxChar8 > JeveuxBidirectionalMapChar8;
/** @typedef Definition d'un pointeur de nom JeveuxChar16 */
typedef JeveuxBidirectionalMap< JeveuxChar16 > JeveuxBidirectionalMapChar16;
/** @typedef Definition d'un pointeur de nom JeveuxChar24 */
typedef JeveuxBidirectionalMap< JeveuxChar24 > JeveuxBidirectionalMapChar24;
/** @typedef Definition d'un pointeur de nom JeveuxChar32 */
typedef JeveuxBidirectionalMap< JeveuxChar32 > JeveuxBidirectionalMapChar32;
/** @typedef Definition d'un pointeur de nom JeveuxChar80 */
typedef JeveuxBidirectionalMap< JeveuxChar80 > JeveuxBidirectionalMapChar80;
/** @typedef Definition d'un pointeur de nom JeveuxLogical */
typedef JeveuxBidirectionalMap< bool > JeveuxBidirectionalMapLogical;

#endif /* JEVEUXBIDIRECTIONALMAP_H_ */
