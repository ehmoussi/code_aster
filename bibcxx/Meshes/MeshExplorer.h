#ifndef MESHEXPLORER_H_
#define MESHEXPLORER_H_

/**
 * @file MeshExplorer.h
 * @brief Fichier entete de la classe MeshExplorer
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

#include "MemoryManager/JeveuxVector.h"
#include "MemoryManager/JeveuxCollection.h"

class MeshElement
{
    const ASTERINTEGER        _elemNum;
    const ASTERINTEGER* const _listOfNodes;
    const ASTERINTEGER        _nbNodes;
    const ASTERINTEGER        _type;

public:
    MeshElement( const ASTERINTEGER& num, const ASTERINTEGER* const listOfNodes,
                 const ASTERINTEGER& nbNodes, const ASTERINTEGER& type ):
        _elemNum( num ),
        _listOfNodes( listOfNodes ),
        _nbNodes( nbNodes ),
        _type( type )
    {};

    const ASTERINTEGER& getNumberOfNodes() const
    {
        return _nbNodes;
    };

    const ASTERINTEGER& getElementNumber() const
    {
        return _elemNum;
    };

    const ASTERINTEGER& getType() const
    {
        return _type;
    };

    struct const_iterator
    {
        const ASTERINTEGER* positionInList;

        inline const_iterator( const ASTERINTEGER* curList ):
            positionInList( curList )
        {};

        inline const_iterator( const const_iterator& iter ):
            positionInList( iter.positionInList )
        {};

        inline const_iterator& operator=( const const_iterator& testIter )
        {
            positionInList = testIter.positionInList;
            return *this;
        };

        inline const_iterator& operator++()
        {
            ++positionInList;
            return *this;
        };

        inline bool operator==( const const_iterator& testIter ) const
        {
            if ( testIter.positionInList != positionInList ) return false;
            return true;
        };

        inline bool operator!=( const const_iterator& testIter ) const
        {
            if ( testIter.positionInList != positionInList ) return true;
            return false;
        };

        inline const ASTERINTEGER& operator->() const
        {
            return *positionInList;
        };

        inline const ASTERINTEGER& operator*() const
        {
            return *positionInList;
        };
    };

    /**
     * @brief
     */
    const_iterator begin() const
    {
        return const_iterator( _listOfNodes );
    };

    /**
     * @brief
     * @todo revoir le fonctionnement du end car il peut provoquer de segfault
     */
    const_iterator end() const
    {
        return const_iterator( &_listOfNodes[ _nbNodes ] );
    };
};

class ElementBuilderFromConnectivity
{
private:
    const JeveuxCollectionLong _connect;
    const JeveuxVectorLong     _type;

public:
    ElementBuilderFromConnectivity( const JeveuxCollectionLong& connect,
                                    const JeveuxVectorLong& type ):
        _connect( connect ),
        _type( type )
    {};

    MeshElement getElement( const int& pos ) const

    {
        const int size2 = _connect->size();
        if( size2 <= 0 )
            throw std::runtime_error ( "Connectivity not available" );

        if( pos > size2 || pos < 0 )
            return MeshElement( 0, nullptr, 0, -1 );
        const auto& obj = _connect->getObject( pos + 1 );
        const auto size = obj.size();
        const ASTERINTEGER type = (*_type)[ pos ];
        return MeshElement( pos+1, &obj.operator[]( 0 ), size, type );
    };

    int size() const
    {
        return _type->size();
    };
};

class ElementBuilderFromFiniteElementDescriptor
{
private:
    const JeveuxCollectionLong _connectAndType;

public:
    ElementBuilderFromFiniteElementDescriptor( const JeveuxCollectionLong& connect ):
        _connectAndType( connect )
    {
        _connectAndType->buildFromJeveux();
    };

    MeshElement getElement( const int& pos ) const

    {
        const int size2 = _connectAndType->size();
        if( size2 <= 0 )
            throw std::runtime_error ( "Connectivity not available" );

        if( pos > size2 || pos < 0 )
            return MeshElement( 0, nullptr, 0, -1 );
        const auto& obj = _connectAndType->getObject( pos + 1 );
        const auto size = obj.size() - 1;
        const ASTERINTEGER type = obj[ size ];
        return MeshElement( pos+1, &obj.operator[]( 0 ), size, type );
    };

    int size() const
    {
        return _connectAndType->size();
    };
};

/**
 * @class MeshExplorer
 * @brief Utility to loop over mesh elements
 * @author Nicolas Sellenet
 */
template< class ElemBuilder, typename... Args >
class MeshExplorer
{
private:
    const ElemBuilder _builder;

public:
    /**
     * @brief Constructeur
     */
    MeshExplorer( const Args... a ):
        _builder( a... )
    {};

    /**
     * @brief Destructeur
     */
    ~MeshExplorer()
    {};

    struct const_iterator
    {
        int                position;
        const ElemBuilder& builder;

        inline const_iterator( int memoryPosition, const ElemBuilder& test ):
            position( memoryPosition ), builder( test )
        {};

        inline const_iterator( const const_iterator& iter ):
            position( iter.position ), builder( iter.builder )
        {};

        inline const_iterator& operator=( const const_iterator& testIter )
        {
            position = testIter.position;
            builder = testIter.builder;
            return *this;
        };

        inline const_iterator& operator++()
        {
            ++position;
            return *this;
        };

        inline bool operator==( const const_iterator& testIter ) const
        {
            if ( testIter.position != position ) return false;
            return true;
        };

        inline bool operator!=( const const_iterator& testIter ) const
        {
            if ( testIter.position != position ) return true;
            return false;
        };

        inline MeshElement operator->() const
        {
            return builder.getElement( position );
        };

        inline MeshElement operator*() const
        {
            return builder.getElement( position );
        };
    };

    inline MeshElement operator[]( int i ) const
    {
        return _builder.getElement(i-1);
    };

    /**
     * @brief
     */
    const_iterator begin() const
    {
        return const_iterator( 0, _builder );
    };

    /**
     * @brief
     * @todo revoir le fonctionnement du end car il peut provoquer de segfault
     */
    const_iterator end() const
    {
        return const_iterator( _builder.size(), _builder );
    };

    /**
     * @brief Size of the explorer
     */
    ASTERINTEGER size() const
    {
        return _builder.size();
    };
};

#endif /* MESHEXPLORER_H_ */
