/**
 * @file ConnectionMesh.cxx
 * @brief Implementation de
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

#include <algorithm>

#include "aster_fort_mesh.h"
#include "aster_mpi.h"
#include "Meshes/ConnectionMesh.h"
#include "ParallelUtilities/MPIInfos.h"

#ifdef _USE_MPI

ConnectionMeshClass::ConnectionMeshClass( const std::string &name, const ParallelMeshPtr &mesh,
                                          const VectorString &toFind )
    : BaseMeshClass( name, "MAILLAGE_PARTIEL" ), _pMesh( mesh ),
      _localNumbering( getName() + ".LOCAL" ), _globalNumbering( getName() + ".GLOBAL" ),
      _owner( getName() + ".POSSESSEUR" ) {
    aster_comm_t *commWorld = aster_get_comm_world();
    VectorString toFind2( toFind );
    std::sort( toFind2.begin(), toFind2.end() );

    const int rank = getMPIRank();
    const int nbProcs = getMPINumberOfProcs();
    auto outers = mesh->getOuterNodesVector();
    outers->updateValuePointer();
    int nbNodes = mesh->getNumberOfNodes();
    VectorLong boolToSend( nbNodes, -1 );
    VectorLong toSend;
    typedef std::map< std::string, VectorLong > MapStringVecInt;
    MapStringVecInt myMap, gatheredMap;
    int count = 1;
    for ( const auto &nameOfGrp : toFind2 ) {
        if ( mesh->hasLocalGroupOfNodes( nameOfGrp ) ) {
            const auto &grp = mesh->getGroupOfNodesObject( nameOfGrp );
            const int nbNodesGrp = grp.size();
            VectorLong toSendGrp;
            for ( int pos = 0; pos < nbNodesGrp; ++pos ) {
                const long nodeNum = grp[pos];
                if ( ( *outers )[nodeNum - 1] == rank ) {
                    if ( boolToSend[nodeNum - 1] == -1 ) {
                        toSend.push_back( nodeNum - 1 );
                        boolToSend[nodeNum - 1] = count;
                        ++count;
                    }
                    toSendGrp.push_back( boolToSend[nodeNum - 1] );
                }
            }
            myMap[nameOfGrp] = toSendGrp;
        }
        gatheredMap[nameOfGrp] = VectorLong();
    }
    // recup mailles connexes et nouveaux noeuds
    int taille = toSend.size();
    VectorLong cellsTypes;
    std::vector< VectorLong > connectivity;
    for ( const auto cell : mesh->getConnectivityExplorer() ) {
        bool keepCell = false;
        for ( auto nodeNum : cell ) {
            if ( keepCell )
                break;
            for ( int i = 0; i < taille; i++ ) {
                if ( nodeNum - 1 == toSend[i] )
                    keepCell = true;
                break;
            }
        }
        if ( keepCell ) {
            cellsTypes.push_back( cell.getType() );
            VectorLong listOfNodes;
            for ( auto nodeNum : cell ) {
                if ( boolToSend[nodeNum - 1] == -1 ) {
                    toSend.push_back( nodeNum - 1 );
                    boolToSend[nodeNum - 1] = count;
                    ++count;
                }
                listOfNodes.push_back( boolToSend[nodeNum - 1] );
            }
            connectivity.push_back( listOfNodes );
        }
    }
    boolToSend.clear();

    VectorReal coords;
    VectorLong numbering;
    const auto &meshCoords = mesh->getCoordinates();
    meshCoords->updateValuePointers();
    const auto globalNum = mesh->getGlobalNodesNumbering();
    globalNum->updateValuePointer();

    for ( const auto &nodeNum : toSend ) {
        coords.push_back( ( *meshCoords )[nodeNum * 3] );
        coords.push_back( ( *meshCoords )[nodeNum * 3 + 1] );
        coords.push_back( ( *meshCoords )[nodeNum * 3 + 2] );
        numbering.push_back( nodeNum + 1 );
        numbering.push_back( ( *globalNum )[nodeNum] );
        numbering.push_back( rank );
    }
    VectorReal completeCoords;
    VectorLong completeMatchingNumbering;
    VectorLong completeCellsType;
    std::vector< VectorLong > completeConnectivity;
    int completeConnectivitySize = 0;
    int offset = 0;
    for ( int proc = 0; proc < nbProcs; ++proc ) {
        int taille = coords.size();
        aster_mpi_bcast( &taille, 1, MPI_INT, proc, commWorld );
        if ( proc == rank ) {
            aster_mpi_bcast( coords.data(), taille, MPI_DOUBLE, proc, commWorld );
            completeCoords.insert( completeCoords.end(), coords.begin(), coords.end() );
        } else {
            VectorReal buffer( taille, 0. );
            aster_mpi_bcast( buffer.data(), taille, MPI_DOUBLE, proc, commWorld );
            completeCoords.insert( completeCoords.end(), buffer.begin(), buffer.end() );
        }

        taille = numbering.size();
        aster_mpi_bcast( &taille, 1, MPI_INT, proc, commWorld );
        int addOffset = taille / 3;
        if ( proc == rank ) {
            aster_mpi_bcast( numbering.data(), taille, MPI_LONG, proc, commWorld );
            completeMatchingNumbering.insert( completeMatchingNumbering.end(), numbering.begin(),
                                              numbering.end() );
        } else {
            VectorLong buffer( taille, 0. );
            aster_mpi_bcast( buffer.data(), taille, MPI_LONG, proc, commWorld );
            completeMatchingNumbering.insert( completeMatchingNumbering.end(), buffer.begin(),
                                              buffer.end() );
        }

        for ( const auto &nameOfGrp : toFind2 ) {
            VectorLong &vecTmp = myMap[nameOfGrp];
            VectorLong &vecTmp2 = gatheredMap[nameOfGrp];
            taille = vecTmp.size();
            aster_mpi_bcast( &taille, 1, MPI_INT, proc, commWorld );
            if ( taille == 0 )
                continue;

            if ( proc == rank ) {
                aster_mpi_bcast( vecTmp.data(), taille, MPI_LONG, proc, commWorld );
                for ( const auto &val : vecTmp )
                    vecTmp2.push_back( val + offset );
            } else {
                VectorLong buffer( taille, 0. );
                aster_mpi_bcast( buffer.data(), taille, MPI_LONG, proc, commWorld );
                for ( const auto &val : buffer )
                    vecTmp2.push_back( val + offset );
            }
        }
        taille = cellsTypes.size();
        aster_mpi_bcast( &taille, 1, MPI_INT, proc, commWorld );
        if ( proc == rank ) {
            aster_mpi_bcast( cellsTypes.data(), taille, MPI_LONG, proc, commWorld );
            completeCellsType.insert( completeCellsType.end(), cellsTypes.begin(),
                                      cellsTypes.end() );
        } else {
            VectorLong buffer( taille, 0. );
            aster_mpi_bcast( buffer.data(), taille, MPI_LONG, proc, commWorld );
            completeCellsType.insert( completeCellsType.end(), buffer.begin(), buffer.end() );
        }
        taille = connectivity.size();
        aster_mpi_bcast( &taille, 1, MPI_INT, proc, commWorld );
        for ( int i = 0; i < taille; i++ ) {
            VectorLong listOfNodes;
            int taille2;
            if ( proc == rank )
                taille2 = connectivity[i].size();
            aster_mpi_bcast( &taille2, 1, MPI_INT, proc, commWorld );
            if ( proc == rank ) {
                aster_mpi_bcast( connectivity[i].data(), taille2, MPI_LONG, proc, commWorld );
                for ( const auto &val : connectivity[i] )
                    listOfNodes.push_back( val + offset );
            } else {
                VectorLong buffer( taille2, 0. );
                aster_mpi_bcast( buffer.data(), taille2, MPI_LONG, proc, commWorld );
                for ( const auto &val : buffer )
                    listOfNodes.push_back( val + offset );
            }
            completeConnectivity.push_back( listOfNodes );
            completeConnectivitySize += taille2;
        }
        offset += addOffset;
    }

    nbNodes = completeCoords.size() / 3;

    _localNumbering->allocate( Permanent, nbNodes );
    _globalNumbering->allocate( Permanent, nbNodes );
    _owner->allocate( Permanent, nbNodes );
    for ( int i = 0; i < nbNodes; ++i ) {
        ( *_localNumbering )[i] = completeMatchingNumbering[3 * i];
        ( *_globalNumbering )[i] = completeMatchingNumbering[3 * i + 1];
        ( *_owner )[i] = completeMatchingNumbering[3 * i + 2];
    }

    *_coordinates->getDescriptor() = *mesh->getCoordinates()->getDescriptor();
    *_coordinates->getReference() = *mesh->getCoordinates()->getReference();
    auto values = _coordinates->getValues();
    values->allocate( Permanent, completeCoords.size() );
    values->updateValuePointer();
    for ( int position = 0; position < completeCoords.size(); ++position )
        ( *values )[position] = completeCoords[position];
    _dimensionInformations->allocate( Permanent, 6 );
    ( *_dimensionInformations )[0] = nbNodes;
    int nbElems = completeConnectivity.size();
    ( *_dimensionInformations )[2] = nbElems;
    ( *_dimensionInformations )[5] = mesh->getDimension();
    _nameOfNodes->allocate( Permanent, nbNodes );
    for ( int position = 1; position <= nbNodes; ++position )
        _nameOfNodes->add( position, std::string( "N" + std::to_string( position ) ) );

    _groupsOfNodes->allocate( Permanent, toFind2.size() );
    for ( const auto &nameOfGrp : toFind2 ) {
        const auto &toCopy = gatheredMap[nameOfGrp];
        _groupsOfNodes->allocateObjectByName( nameOfGrp, toCopy.size() );
        _groupsOfNodes->getObjectFromName( nameOfGrp ).setValues( toCopy );
    }
    _nameOfCells->allocate( Permanent, nbElems );
    _cellsType->allocate( Permanent, nbElems );
    _connectivity->allocateContiguous( Permanent, nbElems, completeConnectivitySize, Numbered );
    for ( int position = 1; position <= nbElems; ++position ) {
        _nameOfCells->add( position, std::string( "M" + std::to_string( position ) ) );
        _connectivity->allocateObject( completeConnectivity[position - 1].size() );
        _connectivity->getObject( position ).setValues( completeConnectivity[position - 1] );
        ( *_cellsType )[position - 1] = completeCellsType[position - 1];
    }
    CALLO_CARGEO( getName() );
};

#endif /* _USE_MPI */
