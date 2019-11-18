
#include "astercxx.h"

#ifdef _USE_MPI

#ifndef MPICONTAINERUTILITIES_H_
#define MPICONTAINERUTILITIES_H_

/**
 * @file MPIContainerUtilities.h
 * @brief Fichier entete contenant des utilitaires de manipulation de containers STL en parallèle
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

#include "ParallelUtilities/MPIInfos.h"
#include "aster_fort.h"

#include "MemoryManager/JeveuxString.h"
#include <set>

class MPIContainerUtilities {
  private:
    int _nbProcs;
    int _rank;
    aster_comm_t *_commWorld;

  public:
    MPIContainerUtilities();

    template < int length >
    std::vector< JeveuxString< length > >
    gatheringVectorsOnAllProcs( std::vector< JeveuxString< length > > &toGather ) const {
        typedef JeveuxString< length > JeveuxChar;
        VectorInt sizes( _nbProcs, 0 );
        VectorInt sizes2( _nbProcs, 0 );
        sizes[0] = toGather.size();
        aster_mpi_allgather( sizes.data(), 1, MPI_INTEGER, sizes2.data(), 1, MPI_INTEGER,
                             _commWorld );
        int sum = 0;
        for ( auto taille : sizes2 )
            sum += taille;

        std::vector< JeveuxChar > toReturn;
        for ( int rank = 0; rank < _nbProcs; ++rank ) {
            JeveuxChar *retour = new JeveuxChar[sizes2[rank]];

            if ( rank == _rank )
                for ( int position = 0; position < sizes2[rank]; ++position )
                    retour[position] = toGather[position];

            aster_mpi_bcast( retour, length * sizes2[rank], MPI_CHAR, rank, _commWorld );
            for ( int position = 0; position < sizes2[rank]; ++position )
                toReturn.push_back( JeveuxChar( retour[position] ) );
            delete[] retour;
        }

        return toReturn;
    };
};

#endif /* MPICONTAINERUTILITIES_H_ */

#endif /* _USE_MPI */
