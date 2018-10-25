/**
 * @file MPIInfos.cxx
 * @brief Implementation de ParallelMeshInstance
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2018  EDF R&D                www.code-aster.org
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

#ifdef _USE_MPI

#include "ParallelUtilities/MPIInfos.h"
#include "aster_fort.h"

int getMPINumberOfProcs() throw( std::runtime_error ) {
    int rank = -1, nbProcs = -1;
    aster_comm_t *comm = aster_get_comm_world();
    aster_get_mpi_info( comm, &rank, &nbProcs );
    if ( rank == -1 || nbProcs == -1 )
        throw std::runtime_error( "Error with MPI Infos" );
    return nbProcs;
};

int getMPIRank() throw( std::runtime_error ) {
    int rank = -1, nbProcs = -1;
    aster_comm_t *comm = aster_get_comm_world();
    aster_get_mpi_info( comm, &rank, &nbProcs );
    if ( rank == -1 || nbProcs == -1 )
        throw std::runtime_error( "Error with MPI Infos" );
    return rank;
};

#endif /* _USE_MPI */
