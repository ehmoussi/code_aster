#ifndef FULLRESULTSCONTAINER_H_
#define FULLRESULTSCONTAINER_H_

/**
 * @file FullResultsContainer.h
 * @brief Fichier entete de la classe FullResultsContainer
 * @author Natacha Béreux 
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

#include "astercxx.h"

#include "Results/DynamicResultsContainer.h"
#include "Results/ResultsContainer.h"

/**
 * @class FullResultsContainerInstance
 * @brief Cette classe correspond à un sd_dyna_phys
 * @author Natacha Béreux 
 */
class FullResultsContainerInstance: public DynamicResultsContainerInstance, public ResultsContainerInstance
{
private:

public:
    /**
     * @brief Constructeur
     * @todo  Ajouter les objets Jeveux de la SD
     */
    FullResultsContainerInstance( std::string name ): DynamicResultsContainerInstance( name ), ResultsContainerInstance( name )
    {};

    bool printMedFile( std::string fileName ) const throw ( std::runtime_error ){
    return ResultsContainerInstance::printMedFile( fileName );
    }

};

/**
 * @typedef FullResultsContainerPtr
 * @brief Pointeur intelligent vers un FullResultsContainerInstance
 */
typedef boost::shared_ptr< FullResultsContainerInstance > FullResultsContainerPtr;

#endif /* FULLRESULTSCONTAINER_H_ */
