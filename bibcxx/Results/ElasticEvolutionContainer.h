#ifndef ELASTICEVOLUTIONCONTAINER_H_
#define ELASTICEVOLUTIONCONTAINER_H_

/**
 * @file ElasticEvolutionContainer.h
 * @brief Fichier entete de la classe ElasticEvolutionContainer
 * @author Natacha Béreux
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

/* person_in_charge: natacha.bereux at edf.fr */

#include "astercxx.h"

#include "Results/TimeDependantResultsContainer.h"
#include "Supervis/ResultNaming.h"

/**
 * @class ElasticEvolutionContainerClass
 * @brief Cette classe correspond a un evol_elas
 * @author Natacha Béreux
 */
class ElasticEvolutionContainerClass : public TimeDependantResultsContainerClass {
  private:
  public:
    /**
     * @brief Constructeur
     */
    ElasticEvolutionContainerClass()
        : ElasticEvolutionContainerClass( ResultNaming::getNewResultName() ){};

    /**
     * @brief Constructeur
     */
    ElasticEvolutionContainerClass( const std::string name )
        : TimeDependantResultsContainerClass( name, "EVOL_ELAS" ){};
};

/**
 * @typedef ElasticEvolutionContainerPtr
 * @brief Pointeur intelligent vers un ElasticEvolutionContainerClass
 */
typedef boost::shared_ptr< ElasticEvolutionContainerClass > ElasticEvolutionContainerPtr;

#endif /* ELASTICEVOLUTIONCONTAINER_H_ */
