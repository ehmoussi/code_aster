/**
 * @file CommunicationGraph.cxx
 * @brief Implementation of CommunicationGraph
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

#include "ParallelUtilities/CommunicationGraph.h"
#include "ParallelUtilities/MPIInfos.h"

CommunicationGraph::CommunicationGraph( const std::string &name, const JeveuxVectorLong &pFED )
    : _graph( JeveuxVectorLong( name + ".NBJO" ) ) {
    aster_comm_t *commWorld = aster_get_comm_world();
    const auto &joins = *( pFED );
    auto nbJoin = joins.size();

    int nbProcs = getMPINumberOfProcs(), rank = getMPIRank();
    VectorInt commGraph( nbProcs * nbProcs, 0 );
    for ( int i = 0; i < nbJoin; ++i )
        commGraph[rank * nbProcs + joins[i]] = 1;
    nbJoin = nbJoin / 2;

    for ( int i = 0; i < nbProcs; ++i )
        aster_mpi_bcast( (void *)( &( commGraph[i * nbProcs] ) ), nbProcs, MPI_INT, i, commWorld );

    int nbEdge = 0;
    for ( int i = 0; i < nbProcs * nbProcs - 1; ++i )
        if ( commGraph[i] == 1 )
            ++nbEdge;
    nbEdge /= 2;

    VectorInt masque( nbProcs * nbProcs, 0 );
    int nMatch = 1;
    while ( nbEdge > 0 ) {
        VectorInt tmp( nbProcs, 0 );
        for ( int i = 0; i < nbProcs; ++i )
            for ( int j = 0; j < nbProcs; ++j ) {
                const int pos = i * nbProcs + j;
                if ( commGraph[pos] == 1 && tmp[i] == 0 && tmp[j] == 0 ) {
                    commGraph[pos] = 0;
                    masque[pos] = nMatch;
                    const int pos2 = j * nbProcs + i;
                    commGraph[pos2] = 0;
                    masque[pos2] = nMatch;
                    --nbEdge;
                    tmp[i] = 1;
                    tmp[j] = 1;
                }
            }
        ++nMatch;
    }
    --nMatch;

    VectorInt joinList( nMatch, -1 );
    int nbJVer = 0;
    for ( int i = 0; i < nbProcs; ++i ) {
        const auto num = masque[rank * nbProcs + i];
        if ( num != 0 ) {
            joinList[num - 1] = i;
            ++nbJVer;
        }
    }
    _graph->allocate( Permanent, nMatch );
    for ( int i = 0; i < nMatch; ++i )
        ( *_graph )[i] = joinList[i];
};

#endif /* _USE_MPI */
