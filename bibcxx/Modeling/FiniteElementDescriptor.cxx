/**
 * @file FiniteElementDescriptor.cxx
 * @brief Implementation de FiniteElementDescriptor
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

#include "aster_mpi.h"
#include "Modeling/FiniteElementDescriptor.h"
#include "Meshes/BaseMesh.h"
#include "Meshes/ConnectionMesh.h"
#include "Modeling/PhysicalQuantityManager.h"
#include "ParallelUtilities/MPIInfos.h"

FiniteElementDescriptorClass::FiniteElementDescriptorClass( const std::string &name,
                                                            const BaseMeshPtr mesh,
                                                            const JeveuxMemory memType )
    : DataStructure( name, 19, "LIGREL", memType ),
      _numberOfDelayedNumberedConstraintNodes( getName() + ".NBNO" ),
      _parameters( getName() + ".LGRF" ), _dofDescriptor( getName() + ".PRNM" ),
      _listOfGroupOfCells( getName() + ".LIEL" ),
      _groupsOfCellsNumberByElement( getName() + ".REPE" ),
      _delayedNumberedConstraintElementsDescriptor( getName() + ".NEMA" ),
      _dofOfDelayedNumberedConstraintNodes( getName() + ".PRNS" ),
      _delayedNodesNumbering( getName() + ".LGNS" ),
      _superElementsDescriptor( getName() + ".SSSA" ),
      _nameOfNeighborhoodStructure( getName() + ".NVGE" ), _mesh( mesh ),
      _explorer(
          ConnectivityDelayedElementsExplorer( _delayedNumberedConstraintElementsDescriptor ) ),
      _explorer2( ConnectivityDelayedElementsExplorer( _listOfGroupOfCells ) ){};

#ifdef _USE_MPI
void FiniteElementDescriptorClass::transferDofDescriptorFrom( FiniteElementDescriptorPtr &other ) {
    if ( !getMesh()->isPartial() )
        throw std::runtime_error(
            "the mesh associated to finiteElementDescriptorClass is not a partial mesh" );
    const ConnectionMeshPtr connectionMesh =
        boost::static_pointer_cast< ConnectionMeshClass >( getMesh() );
    if ( connectionMesh->getParallelMesh() != other->getMesh() )
        throw std::runtime_error(
            "parallel mesh associated to partial mesh of FiniteElementDescriptorClass \n"
            "does not correspond to other FiniteElementDescriptorClass mesh" );
    getPhysicalNodesComponentDescriptor();

    const int rank = getMPIRank();
    aster_comm_t *commWorld = aster_get_comm_world();
    int nbNodes = connectionMesh->getNumberOfNodes();
    int nec = _dofDescriptor->size() / nbNodes;

    const JeveuxVectorLong &localNumbering = connectionMesh->getLocalNumbering();
    const JeveuxVectorLong &owner = connectionMesh->getOwner();
    const JeveuxVectorLong &otherDofDescriptor = other->getPhysicalNodesComponentDescriptor();
    for ( int i = 0; i < nbNodes; ++i ) {
        int proc = ( *owner )[i];
        int nodeNum = ( *localNumbering )[i] - 1;
        VectorLong buffer( nec, 0. );
        if ( proc == rank ) {
            for ( int j = 0; j < nec; ++j )
                buffer[j] = ( *otherDofDescriptor )[nodeNum * nec + j];
        }
        aster_mpi_bcast( buffer.data(), nec, MPI_LONG, proc, commWorld );
        for ( int j = 0; j < nec; ++j )
            ( *_dofDescriptor )[i * nec + j] = buffer[j];
    }
};
#endif /* _USE_MPI */
