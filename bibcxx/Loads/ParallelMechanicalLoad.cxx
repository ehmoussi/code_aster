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

#ifdef _USE_MPI

ParallelMechanicalLoadInstance::ParallelMechanicalLoadInstance( GenericMechanicalLoadPtr& load ):
                    GenericMechanicalLoadInstance( load->getSupportModel() )
{
    const auto& mesh = load->getSupportModel()->getPartialMesh();
    const auto& mecaLoad = load->getMechanicalLoadDescription();
    std::cout << "Size "  << mecaLoad._cimpo->getSize() << std::endl;
    const auto& pcField = *(mecaLoad._cimpo);

    for( const auto b : mesh->getConnectivityExplorer() )
        for( const auto d : b )
            std::cout << "Noeuds " << d << std::endl;

    const auto FEDesc = pcField.getZoneDescription(1).getFiniteElementDescriptor();
    for( const auto b : FEDesc->getDelayedElementsExplorer() )
        for( const auto d : b )
            std::cout << "Noeuds2 " << d << std::endl;

    for( int pos = 0; pos < pcField.getSize(); ++pos )
    {
        const auto& zone = pcField.getZoneDescription( pos );
        std::cout << "Localization " << zone.getLocalizationType() << std::endl;
        if( zone.getLocalizationType() == PCFieldZone::ListOfDelayedElements )
        {
            for( auto& val : zone.getListOfElements() )
                std::cout << val << std::endl;
        }
        else
            continue;
    }
};

#endif /* _USE_MPI */
