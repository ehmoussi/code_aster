/**
 * @file PartialMesh.cxx
 * @brief Implementation de 
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

#include "Meshes/PartialMesh.h"
#include "ParallelUtilities/MPIInfos.h"

#ifdef _USE_MPI

PartialMeshInstance::PartialMeshInstance( ParallelMeshPtr& mesh, const VectorString& toFind ):
                        DataStructure( getNewResultObjectName(), "MAILLAGE_PARTIEL" ),
                        _dimensionInformations( getName() + ".DIME      " ),
                        _nameOfNodes( getName() + ".NOMNOE    " ),
                        _coordinates( new MeshCoordinatesFieldInstance( getName() + ".COORDO    " ) ),
                        _nameOfGrpNodes( JeveuxBidirectionalMapChar24( getName() + ".PTRNOMNOE " ) ),
                        _groupsOfNodes( JeveuxCollectionLongNamePtr( getName() + ".GROUPENO  ",
                                                                     _nameOfGrpNodes ) ),
                        _connectivity( getName() + ".CONNEX    " ),
                        _nameOfElements( getName() + ".NOMMAI    " ),
                        _elementsType( getName() + ".TYPMAIL   " ),
                        _isEmpty( false )
{
    aster_comm_t* commWorld = aster_get_comm_world();

    const int rank = getMPIRank();
    const int nbProcs = getMPINumberOfProcs();
    auto outers = mesh->getOuterNodesVector();
    outers->updateValuePointer();
    int nbNodes = mesh->getNumberOfNodes();
    VectorLong boolToSend( nbNodes, -1 );
    VectorLong toSend;
    typedef std::map< std::string, VectorLong > MapStringVecInt;
    MapStringVecInt myMap, gatheredMap;
    int count = 0;
    for( const auto& nameOfGrp : toFind )
    {
        if( mesh->hasLocalGroupOfNodes( nameOfGrp ) )
        {
            const auto& grp = mesh->getGroupOfNodes( nameOfGrp );
            const int nbNodesGrp = grp.size();
            VectorLong toSendGrp;
            for( int pos = 0; pos < nbNodesGrp; ++pos )
            {
                const long nodeNum = grp[pos];
                if( (*outers)[ nodeNum-1 ] == rank )
                {
                    if( boolToSend[ nodeNum-1 ] == -1 )
                    {
                        toSend.push_back( nodeNum-1 );
                        boolToSend[ nodeNum-1 ] = count;
                        ++count;
                    }
                    toSendGrp.push_back( boolToSend[ nodeNum-1 ] );
                }
            }
            myMap[ nameOfGrp ] = toSendGrp;
        }
        gatheredMap[ nameOfGrp ] = VectorLong();
    }
    boolToSend.clear();

    VectorDouble coords;
    VectorLong numbering;
    const auto& meshCoords = mesh->getCoordinates();
    meshCoords->updateValuePointers();
    const auto globalNum = mesh->getGlobalNodesNumbering();
    globalNum->updateValuePointer();
    for( const auto& nodeNum : toSend )
    {
        coords.push_back( (*meshCoords)[ nodeNum*3 ] );
        coords.push_back( (*meshCoords)[ nodeNum*3 + 1 ] );
        coords.push_back( (*meshCoords)[ nodeNum*3 + 2 ] );
        numbering.push_back( nodeNum );
        numbering.push_back( (*globalNum)[ nodeNum ] );
    }
    VectorDouble completeCoords;
    VectorLong completeMatchingNumbering;
    int offset = 0;
    for( int proc = 0; proc < nbProcs; ++proc )
    {
        int taille = coords.size();
        aster_mpi_bcast( &taille, 1, MPI_INT, proc, commWorld );
        VectorDouble buffer( taille, 0. );
        if( proc == rank )
        {
            aster_mpi_bcast( coords.data(), taille, MPI_DOUBLE, proc, commWorld );
            completeCoords.insert( completeCoords.end(), coords.begin(), coords.end() );
        }
        else
        {
            aster_mpi_bcast( buffer.data(), taille, MPI_DOUBLE, proc, commWorld );
            completeCoords.insert( completeCoords.end(), buffer.begin(), buffer.end() );
        }

        taille = numbering.size();
        aster_mpi_bcast( &taille, 1, MPI_INT, proc, commWorld );
        int addOffset = taille/2;
        VectorLong buffer2( taille, 0. );
        if( proc == rank )
        {
            aster_mpi_bcast( numbering.data(), taille, MPI_LONG, proc, commWorld );
            completeMatchingNumbering.insert( completeMatchingNumbering.end(),
                                              numbering.begin(), numbering.end() );
        }
        else
        {
            aster_mpi_bcast( buffer2.data(), taille, MPI_LONG, proc, commWorld );
            completeMatchingNumbering.insert( completeMatchingNumbering.end(),
                                              buffer2.begin(), buffer2.end() );
        }

        for( const auto& nameOfGrp : toFind )
        {
            VectorLong& vecTmp = myMap[ nameOfGrp ];
            VectorLong& vecTmp2 = gatheredMap[ nameOfGrp ];
            taille = vecTmp.size();
            aster_mpi_bcast( &taille, 1, MPI_INT, proc, commWorld );
            if( taille == 0 ) continue;

            VectorLong buffer3( taille, 0. );
            if( proc == rank )
            {
                aster_mpi_bcast( vecTmp.data(), taille, MPI_LONG, proc, commWorld );
                for( const auto& val : vecTmp )
                    vecTmp2.push_back( val + offset );
            }
            else
            {
                aster_mpi_bcast( buffer3.data(), taille, MPI_LONG, proc, commWorld );
                for( const auto& val : buffer3 )
                    vecTmp2.push_back( val + offset );
            }
        }
        offset += addOffset;
    }

    nbNodes = completeCoords.size()/3;
    *_coordinates->getFieldDescriptor() = *mesh->getCoordinates()->getFieldDescriptor();
    *_coordinates->getFieldReference() = *mesh->getCoordinates()->getFieldReference();
    auto values = _coordinates->getFieldValues();
    values->allocate( Permanent, completeCoords.size() );
    values->updateValuePointer();
    for( int position = 0; position < completeCoords.size(); ++position )
        (*values)[ position ] = completeCoords[ position ];
    _dimensionInformations->allocate( Permanent, 6 );
    (*_dimensionInformations)[0] = nbNodes;
    _nameOfNodes->allocate( Permanent, nbNodes );
    for( int position = 1; position <= nbNodes; ++position )
        _nameOfNodes->add( position, std::string( "N" + std::to_string( position ) ) );

    _groupsOfNodes->allocate( Permanent, toFind.size() );
    for( const auto& nameOfGrp : toFind )
    {
        const auto& toCopy = gatheredMap[ nameOfGrp ];
        _groupsOfNodes->allocateObjectByName( nameOfGrp, toCopy.size() );
        _groupsOfNodes->getObjectFromName( nameOfGrp ).setValues( toCopy );
    }
};

#endif /* _USE_MPI */
