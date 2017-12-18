#ifndef MECHANICALMODECONTAINER_H_
#define MECHANICALMODECONTAINER_H_

/**
 * @file MechanicalModeContainer.h
 * @brief Fichier entete de la classe MechanicalModeContainer
 * @author Natacha Béreux 
 * @section LICENCE
 *   Copyright (C) 1991 - 2016  EDF R&D                www.code-aster.org
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

#include "astercxx.h"

#include "Results/FullResultsContainer.h"
#include "LinearAlgebra/StructureInterface.h"

/**
 * @class MechanicalModeContainerInstance
 * @brief Cette classe correspond a un mode_meca
 * @author Nicolas Sellenet
 */
class MechanicalModeContainerInstance: public FullResultsContainerInstance
{
private:
    StructureInterfacePtr _structureInterface;
public:
    /**
     * @brief Constructeur
     */
    MechanicalModeContainerInstance(): FullResultsContainerInstance( "MODE_MECA" ), 
    _structureInterface( StructureInterfacePtr() )
    {};
    
    /**
     * @brief set interf_dyna
     * @param structureInterface objet StructureInterfacePtr
     */
    bool setStructureInterface( StructureInterfacePtr& structureInterface ) throw ( std::runtime_error )
    {
        _structureInterface = structureInterface;
        return true;
    };
    
};

/**
 * @typedef MechanicalModeContainerPtr
 * @brief Pointeur intelligent vers un MechanicalModeContainerInstance
 */
typedef boost::shared_ptr< MechanicalModeContainerInstance > MechanicalModeContainerPtr;

#endif /* MECHANICALMODECONTAINER_H_ */
