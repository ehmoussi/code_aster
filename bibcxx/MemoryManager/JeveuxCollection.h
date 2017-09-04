#ifndef JEVEUXCOLLECTION_H_
#define JEVEUXCOLLECTION_H_

/**
 * @file JeveuxCollection.h
 * @brief Fichier entete de la classe JeveuxCollection
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
template< class ValueType >
class JeveuxCollectionObject: private AllowedJeveuxType< ValueType >
{
private:
    /** @brief Nom Jeveux de la collection */
    std::string _collectionName;
    /** @brief Position dans la collection */
    int         _numberInCollection;
    /** @brief Nom de l'objet de collection */
    std::string _nameOfObject;
    /** @brief Pointeur vers le vecteur Jeveux */
    ValueType*  _valuePtr;
    /** @brief Pointeur vers le vecteur Jeveux */
    long        _size;

public:
    /**
     * @brief Constructeur
     * @param collectionName Nom de collection
     * @param number Numero de l'objet dans la collection
     * @param ptr Pointeur vers le vecteur Jeveux
     */
    JeveuxCollectionObject( const std::string& collectionName, const int& number,
                            ValueType* ptr = NULL ): _collectionName(collectionName),
                                                     _numberInCollection(number),
                                                     _nameOfObject(""),
                                                     _valuePtr(ptr), _size( -1 )
    {};

    /**
     * @brief Constructeur
     * @param collectionName Nom de collection
     * @param number Numero de l'objet dans la collection
     * @param objectName Nom de l'objet de collection
     * @param ptr Pointeur vers le vecteur Jeveux
     */
    JeveuxCollectionObject( const std::string& collectionName, const int& number,
                            const std::string& objectName,
                            ValueType* ptr = NULL ): _collectionName(collectionName),
                                                     _numberInCollection(number),
                                                     _nameOfObject(objectName),
                                                     _valuePtr(ptr), _size( -1 )
    {};

    inline const ValueType &operator[]( int i ) const
    {
        return _valuePtr[i];
    };

    /**
     * @brief Allocation
     */
    bool allocate( int size ) throw( std::runtime_error )
    {
        long taille = size, ibid = 0;

        CALL_JUCROC_WRAP( _collectionName.c_str(), _nameOfObject.c_str(),
                          &ibid, &taille, (void*)(&_valuePtr) );
        return true;
    };

    JeveuxChar32 getName() const
    {
        return JeveuxChar32( _nameOfObject.c_str() );
    };

    /** @brief Get size of collection object */
    void setValues( const std::vector< ValueType >& toCopy ) throw( std::runtime_error )
    {
        if( toCopy.size() != size() )
            throw std::runtime_error( "Sizes do not match" );
        int pos = 0;
        for( const auto& val : toCopy )
        {
            _valuePtr[ pos ] = val;
            ++pos;
        }
    };

    /** @brief Get size of collection object */
    int size() const
    {
        const char* collName = _collectionName.c_str();
        char* charJeveuxName = MakeBlankFStr(32);
        long num = _numberInCollection;
        CALL_JEXNUM( charJeveuxName, collName, &num );
        long valTmp;
        JeveuxChar8 param( "LONMAX" );
        char* charval = MakeBlankFStr(32);
        CALL_JELIRA( charJeveuxName, param.c_str(), &valTmp, charval );
        return (int)valTmp;
    };
};

/**
 * @struct AllowedNamePointerType
 * @brief Structure template permettant de limiter les type dans JeveuxCollectionInstance
 * @tparam T Type autorise
 */
template< typename T >
struct AllowedNamePointerType; // undefined for bad types!

template<> struct AllowedNamePointerType< int >
{
    typedef int type;
};

template<> struct AllowedNamePointerType< JeveuxBidirectionalMapChar24 >
{
    typedef JeveuxBidirectionalMapChar24 type;
};

template< typename T, typename U >
using IsSame = typename std::enable_if< std::is_same< T, U >::value >::type;

template< typename T, typename U >
using IsNotSame = typename std::enable_if< ! std::is_same< T, U >::value >::type;

/**
 * @class JeveuxCollectionInstance
 * @brief Cette classe template permet de definir une collection Jeveux
 * @author Nicolas Sellenet
 */
template< class ValueType, class PointerType = int >
class JeveuxCollectionInstance: public JeveuxObjectInstance,
                                private AllowedNamePointerType< PointerType >
{
private:
    /** @brief Definition d'un objet de collection du type ValueType */
    typedef JeveuxCollectionObject< ValueType > JeveuxCollObjValType;
    /** @brief std::map associant une chaine a un JeveuxCollObjValType */
    typedef std::map< std::string, int > mapStrInt;

    /** @brief La collection est-elle vide ? */
    bool                                               _isEmpty;
    /** @brief La collection est-elle nommée ? */
    bool                                               _isNamed;
    /** @brief Listes de objets de collection */
    std::vector< JeveuxCollectionObject< ValueType > > _listObjects;
    /** @brief Correspondance nom/numéro */
    mapStrInt                                          _mapNumObject;
    int                                                _size;
    /**
     * @brief Pointeur vers un JeveuxBidirectionalMap
     * @todo int par defaut : pas terrible
     */
    PointerType                                        _nameMap;

public:
    /**
     * @brief Constructeur dans le cas où PointerType n'a pas d'importance
     * @param name Chaine representant le nom de la collection
     */
    template< typename T1 = PointerType, typename = IsSame< T1, int > >
    JeveuxCollectionInstance( const std::string& name ):
        JeveuxObjectInstance( name ),
        _isNamed( false ),
        _isEmpty( true ),
        _nameMap( 0 )
    {}

    /**
     * @brief Constructeur dans le cas où PointerType est un JeveuxBidirectionalMap
     * @param name Chaine representant le nom de la collection
     */
    template< typename T1 = PointerType, typename = IsNotSame< T1, int > >
    JeveuxCollectionInstance( const std::string& name, PointerType ptr ):
        JeveuxObjectInstance( name ),
        _isNamed( false ),
        _isEmpty( true ),
        _nameMap( ptr )
    {};

    ~JeveuxCollectionInstance()
    {
        // pas d'objet maître "distinct" pour une collection
        _name = "";
    };

    /**
     * @brief Allocation
     */
    template< typename T1 = PointerType, typename = IsNotSame< T1, int > >
    bool allocate( JeveuxMemory mem, int size ) throw( std::runtime_error )
    {
        if( ! _nameMap->exists() )
            _nameMap->allocate( mem, size );
        if( _nameMap->size() != size )
            throw std::runtime_error( "Sizes do not match" );

        long taille = size;
        _size = size;
        std::string strJeveuxBase( "V" );
        if ( mem == Permanent ) strJeveuxBase = "G";
        const int intType = AllowedJeveuxType< ValueType >::numTypeJeveux;
        std::string carac( strJeveuxBase + " V " + JeveuxTypesNames[intType] );
        std::string typeColl1( "NO " + _nameMap->getName() );
        std::string typeColl2( "DISPERSE" );
        std::string typeColl3( "VARIABLE" );

        CALL_JECREC( _name.c_str(), carac.c_str(), typeColl1.c_str(),
                     typeColl2.c_str(), typeColl3.c_str(), &taille );
        _isEmpty = false;
        _isNamed = true;
        return true;
    };

    /**
     * @brief Allocation of one object by name
     */
    bool allocateObjectByName( const std::string& name, const int& size )
        throw( std::runtime_error )
    {
        if( _listObjects.size() == _size )
            throw std::runtime_error( "Out of collection bound" );
        _mapNumObject[ std::string( trim( name.c_str() ) ) ] = _listObjects.size();
        _listObjects.push_back( JeveuxCollObjValType( _name.c_str(), _listObjects.size() + 1,
                                                      name.c_str() ) );
        _listObjects[ _listObjects.size() - 1 ].allocate( size );
        return true;
    };

    /**
     * @brief Methode permettant de construire une collection a partir d'une collection
     *   existante en memoire Jeveux
     * @return Renvoit true si la construction s'est bien deroulee
     */
    bool buildFromJeveux();

    /**
     * @brief Methode verifiant l'existance d'un objet de collection dans la collection
     * @param name Chaine contenant le nom de l'objet
     * @return Renvoit true si l'objet existe dans la collection
     */
    bool existsObject( const std::string& name ) const;

    /**
     * @brief Methode permettant d'obtenir la liste des objets nommés dans la collection
     * @return vecteur de noms d'objet de collection
     */
    std::vector< JeveuxChar32 > getObjectNames() const;

    const std::vector< JeveuxCollectionObject< ValueType > >& getVectorOfObjects() const
    {
        return _listObjects;
    };

    const JeveuxCollectionObject< ValueType >& getObject( const int& position ) const
        throw( std::runtime_error )
    {
        if( _isEmpty )
            throw std::runtime_error( "Collection not build" );

        if( position >= _listObjects.size() )
            throw std::runtime_error( "Out of collection bound" );

        return _listObjects[position];
    };

    const JeveuxCollectionObject< ValueType >& getObjectFromName( const std::string& name ) const
        throw( std::runtime_error )
    {
        if( _isEmpty )
            throw std::runtime_error( "Collection not build" );

        if( ! _isNamed )
            throw std::runtime_error( "Collection " + _name + " is not named" );

        const auto& curIter = _mapNumObject.find( name );
        if( curIter == _mapNumObject.end() )
            throw std::runtime_error( "Name not in collection" );

        return _listObjects[ curIter->second ];
    };

    JeveuxCollectionObject< ValueType >& getObjectFromName( const std::string& name )
        throw( std::runtime_error )
    {
        if( _isEmpty )
            throw std::runtime_error( "Collection not build" );

        if( ! _isNamed )
            throw std::runtime_error( "Collection " + _name + " is not named" );

        const auto& curIter = _mapNumObject.find( name );
        if( curIter == _mapNumObject.end() )
            throw std::runtime_error( "Name not in collection" );

        return _listObjects[ curIter->second ];
    };

    int size() const
    {
        if( _isEmpty ) return -1;
        return _listObjects.size();
    };
};

template< class ValueType, class PointerType >
bool JeveuxCollectionInstance< ValueType, PointerType >::buildFromJeveux()
{
    _listObjects.clear();
    long nbColObj, valTmp;
    const char* charName = _name.c_str();
    JeveuxChar8 param( "NMAXOC" );
    char* charval = MakeBlankFStr(32);
    long iret=0;
    CALL_JEEXIN( charName, &iret);
    if ( iret == 0) return false;
    CALL_JELIRA( charName, param.c_str(), &nbColObj, charval );
    _size = nbColObj;

    param = "ACCES ";
    CALL_JELIRA( charName, param.c_str(), &valTmp, charval );
    const std::string resu( charval, 2 );
    FreeStr( charval );

    if ( resu == "NO" ) _isNamed = true;

    const char* tmp = "L";
    charval = MakeBlankFStr(32);
    char* collectionObjectName = MakeBlankFStr(32);
    for ( long i = 1; i <= nbColObj; ++i )
    {
        ValueType* valuePtr;
        CALL_JEXNUM( charval, charName, &i );
        CALL_JEEXIN( charval, &iret);
        if( iret == 0 ) continue;
        if ( _isNamed )
            CALL_JENUNO( charval, collectionObjectName );
        CALL_JEVEUOC( charval, tmp, (void*)(&valuePtr) );
        if ( _isNamed )
        {
            _listObjects.push_back( JeveuxCollObjValType( charName, i,
                                                          collectionObjectName, valuePtr ) );
            _mapNumObject[ std::string( trim( collectionObjectName ) ) ] = i-1;
        }
        else
        {
            _listObjects.push_back( JeveuxCollObjValType( charName, i, valuePtr ) );
        }
    }
    FreeStr( charval );
    FreeStr( collectionObjectName );
    _isEmpty = false;
    return true;
};

template< class ValueType, class PointerType >
bool JeveuxCollectionInstance< ValueType, PointerType >::existsObject( const std::string& name ) const
{
    const char* collName = _name.c_str();
    char* charJeveuxName = MakeBlankFStr(32);
    long returnBool;
    CALL_JEXNOM( charJeveuxName, collName, name.c_str() );
    CALL_JEEXIN( charJeveuxName, &returnBool );
    if ( returnBool == 0 ) return false;
    return true;
};

template< class ValueType, class PointerType >
std::vector< JeveuxChar32 > JeveuxCollectionInstance< ValueType, PointerType >::getObjectNames() const
{
    std::vector< JeveuxChar32 > toReturn;

    for( auto curObject : _listObjects )
        toReturn.push_back( curObject.getName() );
    return toReturn;
};

/**
 * @class JeveuxCollection
 * @brief Enveloppe d'un pointeur intelligent vers un JeveuxCollectionInstance
 * @author Nicolas Sellenet
 */
template< class ValueType, class PointerType = int >
class JeveuxCollection
{
public:
    typedef boost::shared_ptr< JeveuxCollectionInstance< ValueType, PointerType > > JeveuxCollectionTypePtr;

private:
    JeveuxCollectionTypePtr _jeveuxCollectionPtr;

public:
    /**
     * @brief Constructeur dans le cas où PointerType n'a pas d'importance
     * @param name Chaine representant le nom de la collection
     */
    template< typename T1 = PointerType, typename = IsSame< T1, int > >
    JeveuxCollection( const std::string& nom ):
        _jeveuxCollectionPtr( new JeveuxCollectionInstance< ValueType, PointerType > (nom) )
    {}

    /**
     * @brief Constructeur dans le cas où PointerType est un JeveuxBidirectionalMap
     * @param name Chaine representant le nom de la collection
     */
    template< typename T1 = PointerType, typename = IsNotSame< T1, int > >
    JeveuxCollection( const std::string& nom, PointerType ptr ):
        _jeveuxCollectionPtr( new JeveuxCollectionInstance< ValueType, PointerType > (nom, ptr) )
    {};

    ~JeveuxCollection()
    {};

    JeveuxCollection& operator=( const JeveuxCollection< ValueType, PointerType >& tmp )
    {
        _jeveuxCollectionPtr = tmp._jeveuxCollectionPtr;
        return *this;
    };

    const JeveuxCollectionTypePtr& operator->() const
    {
        return _jeveuxCollectionPtr;
    };

    bool isEmpty() const
    {
        if ( _jeveuxCollectionPtr.use_count() == 0 ) return true;
        return false;
    };
};

/** @typedef Definition d'une collection de type long */
typedef JeveuxCollection< long > JeveuxCollectionLong;
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