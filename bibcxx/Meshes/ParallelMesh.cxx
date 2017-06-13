/**
 * @file ParallelMesh.cxx
 * @brief Implementation de ParallelMeshInstance
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

#include "Meshes/ParallelMesh.h"
#include "ParallelUtilities/MPIInfos.h"
#include "aster_fort.h"

#ifdef _USE_MPI

ParallelMeshInstance::ParallelMeshInstance()
{};

bool ParallelMeshInstance::readMedFile( const std::string& fileName )
    throw ( std::runtime_error )
{
    std::string completeFileName = fileName + "/" + std::to_string( getMPIRank() ) + ".med";
    MeshInstance::readMedFile( completeFileName );

//     LogicalUnitFileCython file1( completeFileName, Binary, Old );
//     std::string fortFileName = "fort." + std::to_string( file1.getLogicalUnit() ); 
    CALL_LRMJOI_WRAP( getName().c_str(), completeFileName.c_str() );

    return true;
};

#endif /* _USE_MPI */
