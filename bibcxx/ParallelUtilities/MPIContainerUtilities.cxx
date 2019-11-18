/**
 * @file MPIContainerUtilities.cxx
 * @brief Implementation de MPIContainerUtilities
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

#include "astercxx.h"

#ifdef _USE_MPI

#include "ParallelUtilities/MPIContainerUtilities.h"

MPIContainerUtilities::MPIContainerUtilities()
    : _nbProcs( getMPINumberOfProcs() ), _rank( getMPIRank() ),
      _commWorld( aster_get_comm_world() ){};

#endif /* _USE_MPI */
