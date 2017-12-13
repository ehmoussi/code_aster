#ifndef GENERALIZEDMODECONTAINER_H_
#define GENERALIZEDMODECONTAINER_H_

/**
 * @file GeneralizedModeContainer.h
 * @brief Fichier entete de la classe GeneralizedModeContainer
 * @author Nicolas Tardieu
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

/**
 * @class GeneralizedModeContainerInstance
 * @brief Cette classe correspond à un mode_gene
 * @author Nicolas Sellenet
 */
class GeneralizedModeContainerInstance: public DynamicResultsContainerInstance
{
private:

public:
    /**
     * @brief Constructeur
     * @todo  Ajouter les objets Jeveux de la SD
     */
    GeneralizedModeContainerInstance(): DynamicResultsContainerInstance( "MODE_GENE" )
    {};

};

/**
 * @typedef GeneralizedModeContainerPtr
 * @brief Pointeur intelligent vers un GeneralizedModeContainerInstance
 */
typedef boost::shared_ptr< GeneralizedModeContainerInstance > GeneralizedModeContainerPtr;

#endif /* GENERALIZEDMODECONTAINER_H_ */
