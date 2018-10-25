#ifndef TIMEDEPENDANTRESULTSCONTAINER_H_
#define TIMEDEPENDANTRESULTSCONTAINER_H_

/**
 * @file TimeDependantResultsContainer.h
 * @brief Fichier entete de la classe TimeDependantResultsContainer
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

#include "Results/ResultsContainer.h"
#include "Supervis/ResultNaming.h"

/**
 * @class TimeDependantResultsContainerInstance
 * @brief Cette classe correspond a un evol_sd_aster
 * @author Natacha Béreux
 */
class TimeDependantResultsContainerInstance : public ResultsContainerInstance {
  private:
  public:
    /**
     * @brief Constructeur
     */
    TimeDependantResultsContainerInstance( const std::string resuTyp = "EVOL" )
        : TimeDependantResultsContainerInstance( ResultNaming::getNewResultName(), resuTyp ){};

    /**
     * @brief Constructeur
     */
    TimeDependantResultsContainerInstance( const std::string name, const std::string resuTyp )
        : ResultsContainerInstance( name, resuTyp ){};
};

/**
 * @typedef TimeDependantResultsContainerPtr
 * @brief Pointeur intelligent vers un TimeDependantResultsContainerInstance
 */
typedef boost::shared_ptr< TimeDependantResultsContainerInstance > TimeDependantResultsContainerPtr;

#endif /* TIMEDEPENDANTRESULTSCONTAINER_H_ */
