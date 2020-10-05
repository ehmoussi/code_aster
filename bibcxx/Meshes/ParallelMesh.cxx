/**
 * @file ParallelMesh.cxx
 * @brief Implementation de ParallelMeshClass
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

#ifdef _USE_MPI

#include "aster_fort_mesh.h"
#include "Meshes/ParallelMesh.h"
#include "ParallelUtilities/MPIInfos.h"
#include "ParallelUtilities/MPIContainerUtilities.h"
#include "Utilities/Tools.h"


bool ParallelMeshClass::readPartitionedMedFile( const std::string &fileName ) {
    BaseMeshClass::readMedFile( fileName );

    CALLO_LRMJOI_WRAP( getName(), fileName );

    updateGlobalGroupOfNodes();
    updateGlobalGroupOfCells();

    return true;
};

bool ParallelMeshClass::updateGlobalGroupOfNodes( void ) {

    MPIContainerUtilities util;
    _groupsOfNodes->buildFromJeveux();
    auto gONNames = _groupsOfNodes->getObjectNames();
    auto allgONNames = util.gatheringVectorsOnAllProcs( gONNames );

    for ( auto &nameOfGrp : allgONNames )
        _setOfAllGON.insert( trim( nameOfGrp.toString() ) );

    if(_globalGroupOfNodes->isAllocated())
        _globalGroupOfNodes->deallocate();

    _globalGroupOfNodes->allocate( Permanent, _setOfAllGON.size() );
    int num = 0;
    for ( auto &nameOfGrp : _setOfAllGON ) {
        ( *_globalGroupOfNodes )[num] = nameOfGrp;
        ++num;
    }

    return true;
};

bool ParallelMeshClass::updateGlobalGroupOfCells( void ) {

    MPIContainerUtilities util;
    _groupsOfCells->buildFromJeveux();
    auto gOENames = _groupsOfCells->getObjectNames();
    auto allgOENames = util.gatheringVectorsOnAllProcs( gOENames );

    for ( auto &nameOfGrp : allgOENames )
        _setOfAllGOE.insert( trim( nameOfGrp.toString() ) );

    if(_globalGroupOfCells->isAllocated())
        _globalGroupOfCells->deallocate();

    _globalGroupOfCells->allocate( Permanent, _setOfAllGOE.size() );
    int num = 0;
    for ( auto &nameOfGrp : _setOfAllGOE ) {
        ( *_globalGroupOfCells )[num] = nameOfGrp;
        ++num;
    }

    return true;
};

bool ParallelMeshClass::hasGroupOfCells( const std::string &name, const bool local ) const {

    if(local)
    {
        if ( _groupsOfCells->size() < 0 && !_groupsOfCells->buildFromJeveux() ) {
                return false;
        }

        return _groupsOfCells->existsObject( name );
    }

    SetOfStringCIter curIter = _setOfAllGOE.find( name );
    if ( curIter != _setOfAllGOE.end() )
        return true;
    return false;
}

bool ParallelMeshClass::hasGroupOfNodes( const std::string &name, const bool local) const {
    if( local)
    {
        if ( _groupsOfNodes->size() < 0 && !_groupsOfNodes->buildFromJeveux() ) {
            return false;
        }
        return _groupsOfNodes->existsObject( name );
    }

    SetOfStringCIter curIter = _setOfAllGON.find( name );
    if ( curIter != _setOfAllGON.end() )
        return true;
    return false;

}

VectorString ParallelMeshClass::getGroupsOfCells(const bool local) const {

    if( local )
    {
        ASTERINTEGER size = _nameOfGrpCells->size();
        VectorString names;
        for ( int i = 0; i < size; i++ ) {
            names.push_back( trim( _nameOfGrpCells->getStringFromIndex( i + 1 ) ) );
        }
        return names;
    }

    return VectorString(_setOfAllGOE.begin(), _setOfAllGOE.end());

}

VectorString ParallelMeshClass::getGroupsOfNodes(const bool local) const {

    if( local )
    {
        ASTERINTEGER size = _nameOfGrpNodes->size();
        VectorString names;
        for ( int i = 0; i < size; i++ ) {
            names.push_back( trim( _nameOfGrpNodes->getStringFromIndex( i + 1 ) ) );
        }
        return names;
    }

    return VectorString(_setOfAllGON.begin(), _setOfAllGON.end());
}

const VectorLong ParallelMeshClass::getCells( const std::string name ) const {

    if ( name.empty())
    {
        return irange(long(1), long(getNumberOfCells()));
    }
    else if ( !hasGroupOfCells( name ) ) {
        return VectorLong();
    }

    return _groupsOfCells->getObjectFromName( name ).toVector();
}

const VectorLong ParallelMeshClass::getNodes( const std::string name , const bool local ) const {

    VectorLong listOfNodes;
    if ( name.empty())
    {
        listOfNodes = irange(long(1), long(getNumberOfNodes()));
    }
    else if ( !hasGroupOfNodes( name ) ) {
        return VectorLong();
    }
    else
    {
        listOfNodes = _groupsOfNodes->getObjectFromName( name ).toVector();
    }

    if (local)
        return listOfNodes;

    VectorLong newNumbering;
    newNumbering.reserve(listOfNodes.size());
    _globalNumbering->updateValuePointer();

    for (auto& nodeId : listOfNodes)
        newNumbering.push_back((*_globalNumbering)[nodeId-1]);

    return newNumbering;
}

const VectorLong ParallelMeshClass::getNodes( const std::string name, const bool local,
                                              const bool same_rank ) const {

    VectorLong listOfNodes;
    if ( name.empty())
    {
        listOfNodes = irange(long(1), long(getNumberOfNodes()));
    }
    else if ( !hasGroupOfNodes( name ) ) {
        return VectorLong();
    }
    else
    {
        listOfNodes = _groupsOfNodes->getObjectFromName( name ).toVector();
    }

    const int rank = getMPIRank();
    VectorLong newRank;
    newRank.reserve(listOfNodes.size());

    int size = 0;
    _outerNodes->updateValuePointer();
    for (int nodeId : listOfNodes)
    {
        if(same_rank)
        {
            if (rank == (*_outerNodes)[nodeId-1])
            {
                newRank.push_back(nodeId);
                size++;
            }
        }
        else
        {
            if (rank != (*_outerNodes)[nodeId-1])
            {
                newRank.push_back(nodeId);
                size++;
            }
        }
    }
    newRank.resize(size);

    if (local)
        return newRank;

    VectorLong newNumbering;
    newNumbering.reserve(newRank.size());
    _globalNumbering->updateValuePointer();
    for (auto& nodeId : newRank)
        newNumbering.push_back((*_globalNumbering)[nodeId-1]);

    return newNumbering;
};


#endif /* _USE_MPI */
