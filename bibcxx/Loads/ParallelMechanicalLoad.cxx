/**
 * @file ParallelMechanicalLoad.cxx
 * @brief Implementation de ParallelMechanicalLoad
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

#include "Loads/ParallelMechanicalLoad.h"
#include "Meshes/MeshExplorer.h"
#include "ParallelUtilities/MPIInfos.h"

#ifdef _USE_MPI

ParallelMechanicalLoadInstance::ParallelMechanicalLoadInstance( const GenericMechanicalLoadPtr& load,
                                                                const ModelPtr& model ):
    DataStructure( getNewResultObjectName(), "CHAR_MECA" ),
    _FEDesc( ParallelFiniteElementDescriptorPtr() ),
    _cimpo( new PCFieldOnMeshDoubleInstance( getName() + ".CHME.CIMPO", _FEDesc ) ),
    _cmult( new PCFieldOnMeshDoubleInstance( getName() + ".CHME.CMULT", _FEDesc ) )
{
    const auto& mesh = load->getSupportModel()->getPartialMesh();
    const auto& pcField = *(load->getMechanicalLoadDescription()._cimpo);

    std::string savedName( "" );
    for( int pos = 0; pos < pcField.size(); ++pos )
    {
        const auto& zone = pcField.getZoneDescription( pos ).getFiniteElementDescriptor();
        if( zone->getName() != "" && savedName == "" )
            savedName = zone->getName();
        if( zone->getName() != savedName )
            throw std::runtime_error( "Different FiniteElementDescriptor in one PCFieldOnMesh is not allowed" );
        savedName = zone->getName();
    }
    const auto FEDesc = pcField.getZoneDescription(1).getFiniteElementDescriptor();
    _FEDesc = ParallelFiniteElementDescriptorPtr
                ( new ParallelFiniteElementDescriptorInstance( getName() + ".CHME.LIGRE",
                                                               FEDesc, mesh, model ) );
};

#endif /* _USE_MPI */
