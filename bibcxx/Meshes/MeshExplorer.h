#ifndef MESHEXPLORER_H_
#define MESHEXPLORER_H_

/**
 * @file MeshExplorer.h
 * @brief Fichier entete de la classe MeshExplorer
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2017  EDF R&D                www.code-aster.org
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

#include "MemoryManager/JeveuxVector.h"
#include "MemoryManager/JeveuxCollection.h"

class MeshElement
{
    const long* _listOfNodes;
    const int   _nbNodes;
    const long  _type;

public:
    MeshElement( const long* listOfNodes, const int& nbNodes, const long& type ):
        _listOfNodes( listOfNodes ),
        _nbNodes( nbNodes ),
        _type( type )
    {};
};

class ElementBuilderFromConnectivity
{
private:
    JeveuxCollectionLong& _connect;
    JeveuxVectorLong&     _type;

public:
    ElementBuilderFromConnectivity( JeveuxCollectionLong& connect,
                                    JeveuxVectorLong& type ):
        _connect( connect ),
        _type( type )
    {
        _connect->buildFromJeveux();
        _type->updateValuePointer();
    };

    MeshElement getElement( const int& pos ) const
        throw( std::runtime_error )
    {
        const auto& obj = _connect->getObject( pos );
        const auto size = obj.size();
        int pos2 = pos;
        const long type = (*_type)[ pos2 ];
        return MeshElement( &obj.operator[]( 0 ), size, type );
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

public:
    /**
     * @brief Constructeur
     */
    MeshExplorer( const Args... a ):
        ElemBuilder( a... )
    {};

    /**
     * @brief Destructeur
     */
    ~MeshExplorer()
    {};
};

#endif /* MESHEXPLORER_H_ */
