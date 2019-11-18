#ifndef JEVEUXCOLLECTION_H_
#define JEVEUXCOLLECTION_H_

/**
 * @file JeveuxCollection.h
 * @brief Fichier entete de la classe JeveuxCollection
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2019  EDF R&D                www.code-aster.org
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
#include "aster_fort.h"

// @todo prefer use JeveuxString
#include "aster_utils.h"

#include "MemoryManager/JeveuxAllowedTypes.h"
#include "MemoryManager/JeveuxString.h"
#include "MemoryManager/JeveuxObject.h"
#include "MemoryManager/JeveuxBidirectionalMap.h"
#include "Utilities/Tools.h"

#include <string>
#include <list>
#include <map>

/**
 * @class JeveuxCollectionObject
 * @brief Cette classe template permet de definir un objet de collection Jeveux
 * @author Nicolas Sellenet
 */
template < class ValueType > class JeveuxCollectionObject : private AllowedJeveuxType< ValueType > {
  private:
    /** @brief Nom Jeveux de la collection */
    std::string _collectionName;
    /** @brief Position dans la collection */
    int _numberInCollection;
    /** @brief Nom de l'objet de collection */
    std::string _nameOfObject;
    /** @brief Pointeur vers le vecteur Jeveux */
    ValueType *_valuePtr;
    /** @brief Pointeur vers le vecteur Jeveux */
    ASTERINTEGER _size;
    /** @brief Pointeur vers le vecteur Jeveux */
    ASTERINTEGER _jeveuxAdress;

    /**
     * @brief Allocation
     */
    bool allocate( int size ) {
        ASTERINTEGER taille = size, ibid = 0;

        std::string nameOfObject( "" );
        if ( _nameOfObject != "" )
            nameOfObject = _nameOfObject;
        else
            ibid = _numberInCollection;

        CALLO_JUCROC_WRAP( _collectionName, nameOfObject, &ibid, &taille, (void *)( &_valuePtr ) );

        std::string charJeveuxName( 32, ' ' );
        ASTERINTEGER num = _numberInCollection;
        CALLO_JEXNUM( charJeveuxName, _collectionName, &num );

        ASTERINTEGER valTmp;
        JeveuxChar8 param( "IADM" );
        std::string charval = std::string( 32, ' ' );
        CALLO_JELIRA( charJeveuxName, param, &valTmp, charval );
        _jeveuxAdress = valTmp;

        return true;
    };

  public:
    /**
     * @brief Constructeur
     * @param collectionName Nom de collection
     * @param number Numero de l'objet dans la collection
     * @param objectName Nom de l'objet de collection
     */
    JeveuxCollectionObject( const std::string &collectionName, const int &number, bool isNamed,
                            bool exists )
        : _collectionName( collectionName ), _numberInCollection( number ), _nameOfObject( "" ),
          _valuePtr( nullptr ), _size( 0 ), _jeveuxAdress( 0 ) {
        if ( !exists )
            return;
        std::string tmp( "L" );
        ASTERINTEGER iret = number;
        const char *charName = collectionName.c_str();
        std::string charval( 32, ' ' );
        CALLO_JEXNUM( charval, collectionName, &iret );
        CALLO_JEEXIN( charval, &iret );
        if ( iret == 0 )
            throw std::runtime_error( "Error in collection object " + collectionName );
        std::string collectionObjectName( 32, ' ' );
        if ( isNamed ) {
            CALLO_JENUNO( charval, collectionObjectName );
            _nameOfObject = trim( std::string( collectionObjectName ) );
        }
        CALLO_JEVEUOC( charval, tmp, (void *)( &_valuePtr ) );

        std::string charJeveuxName( 32, ' ' );
        ASTERINTEGER num = _numberInCollection;
        CALLO_JEXNUM( charJeveuxName, _collectionName, &num );
        ASTERINTEGER valTmp;
        JeveuxChar8 param( "LONMAX" );
        charval = std::string( 32, ' ' );
        CALLO_JELIRA( charJeveuxName, param, &valTmp, charval );
        _size = valTmp;

        param = "IADM";
        charval = std::string( 32, ' ' );
        CALLO_JELIRA( charJeveuxName, param, &valTmp, charval );
        _jeveuxAdress = valTmp;
    };

    /**
     * @brief Constructeur
     * @param collectionName Nom de collection
     * @param number Numero de l'objet dans la collection
     */
    JeveuxCollectionObject( const std::string &collectionName, const int &number, const int &size )
        : _collectionName( collectionName ), _numberInCollection( number ), _nameOfObject( "" ),
          _valuePtr( nullptr ), _size( size ), _jeveuxAdress( 0 ) {
        allocate( size );
    };

    /**
     * @brief Constructeur
     * @param collectionName Nom de collection
     * @param number Numero de l'objet dans la collection
     * @param objectName Nom de l'objet de collection
     */
    JeveuxCollectionObject( const std::string &collectionName, const int &number,
                            const std::string &objectName, const int &size )
        : _collectionName( collectionName ), _numberInCollection( number ),
          _nameOfObject( trim( objectName ) ), _valuePtr( nullptr ), _size( size ),
          _jeveuxAdress( 0 ) {
        allocate( size );
    };

    struct const_iterator {
        int position;
        const ValueType &valuePtr;

        inline const_iterator( int memoryPosition, const ValueType &val )
            : position( memoryPosition ), valuePtr( val ){};

        inline const_iterator( const const_iterator &iter )
            : position( iter.position ), valuePtr( iter.valuePtr ){};

        inline const_iterator &operator=( const const_iterator &testIter ) {
            position = testIter.position;
            valuePtr = testIter.valuePtr;
            return *this;
        };

        inline const_iterator &operator++() {
            ++position;
            return *this;
        };

        inline bool operator==( const const_iterator &testIter ) const {
            if ( testIter.position != position )
                return false;
            return true;
        };

        inline bool operator!=( const const_iterator &testIter ) const {
            if ( testIter.position != position )
                return true;
            return false;
        };

        inline const ValueType &operator->() const { return ( &valuePtr )[position]; };

        inline const ValueType &operator*() const { return ( &valuePtr )[position]; };
    };

    /**
     * @brief
     */
    const_iterator begin() const { return const_iterator( 0, *_valuePtr ); };

    /**
     * @brief
     * @todo revoir le fonctionnement du end car il peut provoquer de segfault
     */
    const_iterator end() const { return const_iterator( _size, *_valuePtr ); };

    inline const ValueType &operator[]( int i ) const { return _valuePtr[i]; };

    JeveuxChar32 getName() const { return JeveuxChar32( _nameOfObject ); };

    const std::string &getStringName() const { return _nameOfObject; };

    bool hasMoved() const {
        std::string charJeveuxName( 32, ' ' );
        ASTERINTEGER num = _numberInCollection;
        CALLO_JEXNUM( charJeveuxName, _collectionName, &num );

        ASTERINTEGER valTmp;
        JeveuxChar8 param( "IADM" );
        std::string charval = std::string( 32, ' ' );
        CALLO_JELIRA( charJeveuxName, param, &valTmp, charval );
        if ( valTmp != _jeveuxAdress )
            return true;
        return false;
    };

    /** @brief Set values of collection object */
    void setValues( const std::vector< ValueType > &toCopy ) {
        if ( toCopy.size() != size() )
            throw std::runtime_error( "Sizes do not match" );
        int pos = 0;
        for ( const auto &val : toCopy ) {
            _valuePtr[pos] = val;
            ++pos;
        }
    };

    /** @brief Set values of collection object */
    void setValues( const ValueType &toCopy ) {
        if ( size() != 1 )
            throw std::runtime_error( "Sizes do not match" );
        _valuePtr[0] = toCopy;
    };

    /** @brief Get size of collection object */
    int size() const { return _size; };

    /** @brief Convert to std::vector */
    std::vector< ValueType > toVector() const {
        if ( _valuePtr == nullptr )
            throw std::runtime_error( "Pointer is null" );
        std::vector< ValueType > toReturn;
        for ( int i = 0; i < size(); ++i )
            toReturn.push_back( _valuePtr[i] );
        return toReturn;
    };
};

/** @typedef Definition d'un objet de collection de type long */
typedef JeveuxCollectionObject< ASTERINTEGER > JeveuxCollectionObjectLong;
/** @typedef Definition d'un objet de collection de type short int */
typedef JeveuxCollectionObject< short int > JeveuxCollectionObjectShort;
/** @typedef Definition d'un objet de collection de type double */
typedef JeveuxCollectionObject< double > JeveuxCollectionObjectDouble;
/** @typedef Definition d'un objet de collection de type double complex */
typedef JeveuxCollectionObject< DoubleComplex > JeveuxCollectionObjectComplex;
/** @typedef Definition d'un objet de collection de JeveuxChar8 */
typedef JeveuxCollectionObject< JeveuxChar8 > JeveuxCollectionObjectChar8;
/** @typedef Definition d'un objet de collection de JeveuxChar16 */
typedef JeveuxCollectionObject< JeveuxChar16 > JeveuxCollectionObjectChar16;
/** @typedef Definition d'un objet de collection de JeveuxChar24 */
typedef JeveuxCollectionObject< JeveuxChar24 > JeveuxCollectionObjectChar24;
/** @typedef Definition d'un objet de collection de JeveuxChar32 */
typedef JeveuxCollectionObject< JeveuxChar32 > JeveuxCollectionObjectChar32;
/** @typedef Definition d'un objet de collection de JeveuxChar80 */
typedef JeveuxCollectionObject< JeveuxChar80 > JeveuxCollectionObjectChar80;

/**
 * @enum JeveuxCollectionAccessType
 */
enum JeveuxCollectionAccessType { Numbered, Named };

/**
 * @enum JeveuxCollectionMemoryStorageType
 */
enum JeveuxCollectionMemoryStorageType { Sparse, Contiguous };

/**
 * @enum JeveuxCollectionObjectSizes
 */
enum JeveuxCollectionObjectSizes { Constant, Variable };

/**
 * @struct AllowedNamePointerType
 * @brief Structure template permettant de limiter les type dans JeveuxCollectionInstance
 * @tparam T Type autorise
 */
template < typename T > struct AllowedNamePointerType; // undefined for bad types!

template <> struct AllowedNamePointerType< int > { typedef int type; };

template <> struct AllowedNamePointerType< JeveuxBidirectionalMapChar24 > {
    typedef JeveuxBidirectionalMapChar24 type;
};

template < typename T, typename U >
using IsSame = typename std::enable_if< std::is_same< T, U >::value >::type;

template < typename T, typename U >
using IsNotSame = typename std::enable_if< !std::is_same< T, U >::value >::type;

/**
 * @class JeveuxCollectionInstance
 * @brief Cette classe template permet de definir une collection Jeveux
 * @author Nicolas Sellenet
 */
template < class ValueType, class PointerType = int >
class JeveuxCollectionInstance : public JeveuxObjectInstance,
                                 private AllowedNamePointerType< PointerType > {
  private:
    /** @brief Definition d'un objet de collection du type ValueType */
    typedef JeveuxCollectionObject< ValueType > JeveuxCollObjValType;
    /** @brief std::map associant une chaine a un JeveuxCollObjValType */
    typedef std::map< std::string, int > mapStrInt;

    /** @brief La collection est-elle vide ? */
    bool _isEmpty;
    /** @brief La collection est-elle nommée ? */
    bool _isNamed;
    /** @brief Listes de objets de collection */
    std::vector< JeveuxCollObjValType > _listObjects;
    /** @brief Correspondance nom/numéro */
    mapStrInt _mapNumObject;
    int _size;
    /**
     * @brief Pointeur vers un JeveuxBidirectionalMap
     * @todo int par defaut : pas terrible
     */
    PointerType _nameMap;

    /**
     * @brief Allocation
     */
    bool genericAllocation( JeveuxMemory mem, int size, JeveuxCollectionAccessType access = Named,
                            JeveuxCollectionMemoryStorageType storage = Sparse,
                            JeveuxCollectionObjectSizes objectSizes = Variable,
                            const std::string &name = "",
                            int totalSize = 0 ) {
        ASTERINTEGER taille = size;
        _size = size;
        std::string strJeveuxBase( "V" );
        if ( mem == Permanent )
            strJeveuxBase = "G";
        const int intType = AllowedJeveuxType< ValueType >::numTypeJeveux;
        std::string carac( strJeveuxBase + " V " + JeveuxTypesNames[intType] );

        std::string typeColl1( "NO" );
        if ( access == Numbered ) {
            typeColl1 = "NU";
        } else {
            _isNamed = true;
            typeColl1 = typeColl1 + ' ' + name;
        }

        std::string typeColl2( "DISPERSE" );
        if ( storage == Contiguous )
            typeColl2 = "CONTIG";
        std::string typeColl3( "VARIABLE" );
        if ( objectSizes == Constant )
            typeColl3 = "CONSTANT";

        CALLO_JECREC( _name, carac, typeColl1, typeColl2, typeColl3, &taille );
        _isEmpty = false;
        if ( storage == Contiguous ) {
            if ( totalSize <= 0 )
                throw std::runtime_error(
                    "Total size of a contiguous collection must be grower than 0" );
            std::string strParam( "LONT" );
            taille = totalSize;
            CALLO_JEECRA_WRAP( _name, strParam, &taille );
        }
        return true;
    };

  public:
    /**
     * @brief Constructeur dans le cas où PointerType n'a pas d'importance
     * @param name Chaine representant le nom de la collection
     */
    template < typename T1 = PointerType, typename = IsSame< T1, int > >
    JeveuxCollectionInstance( const std::string &name )
        : JeveuxObjectInstance( name ), _isNamed( false ), _isEmpty( true ), _nameMap( 0 ) {}

    /**
     * @brief Constructeur dans le cas où PointerType est un JeveuxBidirectionalMap
     * @param name Chaine representant le nom de la collection
     */
    template < typename T1 = PointerType, typename = IsNotSame< T1, int > >
    JeveuxCollectionInstance( const std::string &name, PointerType ptr )
        : JeveuxObjectInstance( name ), _isNamed( false ), _isEmpty( true ), _nameMap( ptr ){};

    ~JeveuxCollectionInstance(){};

    struct const_iterator {
        int position;
        const std::vector< JeveuxCollObjValType > &values;

        inline const_iterator( int memoryPosition, const std::vector< JeveuxCollObjValType > &vec )
            : position( memoryPosition ), values( vec ){};

        inline const_iterator( const const_iterator &iter )
            : position( iter.position ), values( iter.values ){};

        inline const_iterator &operator=( const const_iterator &testIter ) {
            position = testIter.position;
            values = testIter.values;
            return *this;
        };

        inline const_iterator &operator++() {
            ++position;
            return *this;
        };

        inline bool operator==( const const_iterator &testIter ) const {
            if ( testIter.position != position )
                return false;
            return true;
        };

        inline bool operator!=( const const_iterator &testIter ) const {
            if ( testIter.position != position )
                return true;
            return false;
        };

        inline const JeveuxCollObjValType &operator->() const { return values[position]; };

        inline const JeveuxCollObjValType &operator*() const { return values[position]; };
    };

    /**
     * @brief
     */
    const_iterator begin() const { return const_iterator( 0, _listObjects ); };

    /**
     * @brief
     * @todo revoir le fonctionnement du end car il peut provoquer de segfault
     */
    const_iterator end() const { return const_iterator( _size, _listObjects ); };

    /**
     * @brief Allocation
     * @param mem memory allocation
     * @param size number of objets in collection
     * @param access type of access
     * @param objectSizes size of objects (constant or variable)
     */
    template < typename T1 = PointerType, typename = IsNotSame< T1, int > >
    typename std::enable_if< !std::is_same< T1, int >::value, bool >::type
    allocate( JeveuxMemory mem, int size,
              JeveuxCollectionObjectSizes objectSizes = Variable ) {
        if ( !_nameMap->exists() )
            _nameMap->allocate( mem, size );
        if ( _nameMap->size() != size )
            throw std::runtime_error( "Sizes do not match" );

        return genericAllocation( mem, size, Named, Sparse, objectSizes, _nameMap->getName() );
    };

    /**
     * @brief Allocation
     * @param mem memory allocation
     * @param size number of objets in collection
     * @param totalSize total size of the collection
     * @param objectSizes size of objects (constant or variable)
     */
    template < typename T1 = PointerType, typename = IsNotSame< T1, int > >
    typename std::enable_if< !std::is_same< T1, int >::value, bool >::type allocateContiguous(
        JeveuxMemory mem, int size, int totalSize,
        JeveuxCollectionObjectSizes objectSizes = Variable ) {
        if ( !_nameMap->exists() )
            _nameMap->allocate( mem, size );
        if ( _nameMap->size() != size )
            throw std::runtime_error( "Sizes do not match" );

        return genericAllocation( mem, size, Named, Contiguous, objectSizes, _nameMap->getName(),
                                  totalSize );
    };

    /**
     * @brief Allocation
     * @param mem memory allocation
     * @param size number of objets in collection
     * @param access type of access
     * @param objectSizes size of objects (constant or variable)
     */
    template < typename T1 = PointerType, typename = IsSame< T1, int > >
    typename std::enable_if< std::is_same< T1, int >::value, bool >::type
    allocate( JeveuxMemory mem, int size, JeveuxCollectionAccessType access = Named,
              JeveuxCollectionObjectSizes objectSizes = Variable ) {
        return genericAllocation( mem, size, access, Sparse, objectSizes, "" );
    };

    /**
     * @brief Allocation
     * @param mem memory allocation
     * @param size number of objets in collection
     * @param totalSize total size of the collection
     * @param access type of access
     * @param objectSizes size of objects (constant or variable)
     */
    template < typename T1 = PointerType, typename = IsSame< T1, int > >
    typename std::enable_if< std::is_same< T1, int >::value, bool >::type allocateContiguous(
        JeveuxMemory mem, int size, int totalSize, JeveuxCollectionAccessType access = Named,
        JeveuxCollectionObjectSizes objectSizes = Variable ) {
        return genericAllocation( mem, size, access, Contiguous, objectSizes, "", totalSize );
    };

    /**
     * @brief Allocation of one object by name
     */
    bool allocateObjectByName( const std::string &name,
                               const int &size ) {
        if ( _listObjects.size() == _size )
            throw std::runtime_error( "Out of collection bound" );

        _mapNumObject[std::string( trim( name.c_str() ) )] = _listObjects.size();
        _listObjects.push_back(
            JeveuxCollObjValType( _name, _listObjects.size() + 1, name, size ) );
        return true;
    };

    /**
     * @brief Allocation of one object at the end of a existing collection
     */
    bool allocateObject( const int &size ) {
        if ( _listObjects.size() == _size )
            throw std::runtime_error( "Out of collection bound" );

        _listObjects.push_back( JeveuxCollObjValType( _name, _listObjects.size() + 1, size ) );
        return true;
    };

    /**
     * @brief Deallocate collection
     */
    void deallocate() {
        if ( _name != "" && get_sh_jeveux_status() == 1 )
            CALLO_JEDETR( _name );
    };

    /**
     * @brief Methode permettant de construire une collection a partir d'une collection
     *   existante en memoire Jeveux
     * @return Renvoit true si la construction s'est bien deroulee
     */
    bool buildFromJeveux( bool force = false );

    /**
     * @brief Methode verifiant l'existance d'un objet de collection dans la collection
     * @param name Chaine contenant le nom de l'objet
     * @return Renvoit true si l'objet existe dans la collection
     */
    bool existsObject( const std::string &name ) const;

    /**
     * @brief Methode verifiant l'existance d'un objet de collection dans la collection
     * @param number entier
     * @return Renvoit true si l'objet existe dans la collection
     */
    bool existsObject( const ASTERINTEGER &number ) const;

    /**
     * @brief Methode permettant d'obtenir la liste des objets nommés dans la collection
     * @return vecteur de noms d'objet de collection
     */
    std::vector< JeveuxChar32 > getObjectNames() const;

    const std::vector< JeveuxCollObjValType > &getVectorOfObjects() const { return _listObjects; };

    const JeveuxCollObjValType &getObject( const int &position ) const {
        if ( _isEmpty )
            throw std::runtime_error( "Collection not build" );

        if ( position > _listObjects.size() || position <= 0 )
            throw std::runtime_error( "Out of collection bound" );

        return _listObjects[position - 1];
    };

    JeveuxCollObjValType &getObject( const int &position ) {
        if ( _isEmpty )
            throw std::runtime_error( "Collection not build" );

        if ( position > _listObjects.size() || position <= 0 )
            throw std::runtime_error( "Out of collection bound" );

        return _listObjects[position - 1];
    };

    const JeveuxCollObjValType &getObjectFromName( const std::string &name ) const
        {
        if ( _isEmpty )
            throw std::runtime_error( "Collection not build" );

        if ( !_isNamed )
            throw std::runtime_error( "Collection " + _name + " is not named" );

        const auto &curIter = _mapNumObject.find( trim( name ) );
        if ( curIter == _mapNumObject.end() )
            throw std::runtime_error( "Name not in collection" );

        return _listObjects[curIter->second];
    };

    JeveuxCollObjValType &getObjectFromName( const std::string &name ) {
        if ( _isEmpty )
            throw std::runtime_error( "Collection not build" );

        if ( !_isNamed )
            throw std::runtime_error( "Collection " + _name + " is not named" );

        const auto &curIter = _mapNumObject.find( trim( name ) );
        if ( curIter == _mapNumObject.end() )
            throw std::runtime_error( "Name not in collection" );

        return _listObjects[curIter->second];
    };

    int size() const {
        if ( _isEmpty )
            return -1;
        return _listObjects.size();
    };
};

template < class ValueType, class PointerType >
bool JeveuxCollectionInstance< ValueType, PointerType >::buildFromJeveux( bool force ) {
    ASTERINTEGER iret = 0;
    CALLO_JEEXIN( _name, &iret );
    if ( iret == 0 )
        return false;

    ASTERINTEGER nbColObj, valTmp;
    JeveuxChar8 param( "NMAXOC" );
    std::string charval( 32, ' ' );
    CALLO_JELIRA( _name, param, &nbColObj, charval );

    if ( !force && !_isEmpty && _size == nbColObj ) {
        for ( ASTERINTEGER i = 0; i < nbColObj; ++i )
            if ( _listObjects[i].hasMoved() ) {
                force = true;
                break;
            }
        if ( !force )
            return false;
    }

    _size = nbColObj;
    _listObjects.clear();

    param = "ACCES ";
    charval = std::string( 32, ' ' );
    CALLO_JELIRA( _name, param, &valTmp, charval );
    const std::string resu( charval, 0, 2 );

    if ( resu == "NO" )
        _isNamed = true;

    for ( ASTERINTEGER i = 1; i <= nbColObj; ++i ) {
        if ( !existsObject( i ) )
            _listObjects.push_back( JeveuxCollObjValType( _name, i, _isNamed, false ) );
        else
            _listObjects.push_back( JeveuxCollObjValType( _name, i, _isNamed, true ) );
        if ( _isNamed )
            _mapNumObject[trim( _listObjects[_listObjects.size() - 1].getStringName() )] = i - 1;
    }
    _isEmpty = false;
    return true;
};

template < class ValueType, class PointerType >
bool
JeveuxCollectionInstance< ValueType, PointerType >::existsObject( const std::string &name ) const {
    std::string charJeveuxName( 32, ' ' );
    ASTERINTEGER returnBool;
    CALLO_JEXNOM( charJeveuxName, _name, name );
    CALLO_JEEXIN( charJeveuxName, &returnBool );
    if ( returnBool == 0 )
        return false;
    return true;
};

template < class ValueType, class PointerType >
bool JeveuxCollectionInstance< ValueType, PointerType >::existsObject(
    const ASTERINTEGER &number ) const {
    const char *collName = _name.c_str();
    std::string charJeveuxName( 32, ' ' );
    ASTERINTEGER returnBool = number;
    CALLO_JEXNUM( charJeveuxName, _name, &returnBool );
    CALLO_JEEXIN( charJeveuxName, &returnBool );
    if ( returnBool == 0 )
        return false;
    return true;
};

template < class ValueType, class PointerType >
std::vector< JeveuxChar32 >
JeveuxCollectionInstance< ValueType, PointerType >::getObjectNames() const {
    std::vector< JeveuxChar32 > toReturn;

    for ( auto curObject : _listObjects )
        toReturn.push_back( curObject.getName() );
    return toReturn;
};

/**
 * @class JeveuxCollection
 * @brief Enveloppe d'un pointeur intelligent vers un JeveuxCollectionInstance
 * @author Nicolas Sellenet
 */
template < class ValueType, class PointerType = int > class JeveuxCollection {
  public:
    typedef boost::shared_ptr< JeveuxCollectionInstance< ValueType, PointerType > >
        JeveuxCollectionTypePtr;

  private:
    JeveuxCollectionTypePtr _jeveuxCollectionPtr;

  public:
    /**
     * @brief Constructeur dans le cas où PointerType n'a pas d'importance
     * @param name Chaine representant le nom de la collection
     */
    template < typename T1 = PointerType, typename = IsSame< T1, int > >
    JeveuxCollection( const std::string &nom )
        : _jeveuxCollectionPtr( new JeveuxCollectionInstance< ValueType, PointerType >( nom ) ) {}

    /**
     * @brief Constructeur dans le cas où PointerType est un JeveuxBidirectionalMap
     * @param name Chaine representant le nom de la collection
     */
    template < typename T1 = PointerType, typename = IsNotSame< T1, int > >
    JeveuxCollection( const std::string &nom, PointerType ptr )
        : _jeveuxCollectionPtr(
              new JeveuxCollectionInstance< ValueType, PointerType >( nom, ptr ) ){};

    ~JeveuxCollection(){};

    JeveuxCollection &operator=( const JeveuxCollection< ValueType, PointerType > &tmp ) {
        _jeveuxCollectionPtr = tmp._jeveuxCollectionPtr;
        return *this;
    };

    const JeveuxCollectionTypePtr &operator->() const { return _jeveuxCollectionPtr; };

    JeveuxCollectionInstance< ValueType, PointerType > &operator*( void ) const {
        return *_jeveuxCollectionPtr;
    };

    bool isEmpty() const {
        if ( _jeveuxCollectionPtr.use_count() == 0 )
            return true;
        return false;
    };
};

/** @typedef Definition d'une collection de type long */
typedef JeveuxCollection< ASTERINTEGER > JeveuxCollectionLong;
/** @typedef Definition d'une collection de type short int */
typedef JeveuxCollection< short int > JeveuxCollectionShort;
/** @typedef Definition d'une collection de type double */
typedef JeveuxCollection< double > JeveuxCollectionDouble;
/** @typedef Definition d'une collection de type double complex */
typedef JeveuxCollection< DoubleComplex > JeveuxCollectionComplex;
/** @typedef Definition d'une collection de JeveuxChar8 */
typedef JeveuxCollection< JeveuxChar8 > JeveuxCollectionChar8;
/** @typedef Definition d'une collection de JeveuxChar16 */
typedef JeveuxCollection< JeveuxChar16 > JeveuxCollectionChar16;
/** @typedef Definition d'une collection de JeveuxChar24 */
typedef JeveuxCollection< JeveuxChar24 > JeveuxCollectionChar24;
/** @typedef Definition d'une collection de JeveuxChar32 */
typedef JeveuxCollection< JeveuxChar32 > JeveuxCollectionChar32;
/** @typedef Definition d'une collection de JeveuxChar80 */
typedef JeveuxCollection< JeveuxChar80 > JeveuxCollectionChar80;

#endif /* JEVEUXCOLLECTION_H_ */
