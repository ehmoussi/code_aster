#ifndef NONLINEAREVOLUTIONCONTAINER_H_
#define NONLINEAREVOLUTIONCONTAINER_H_

/**
 * @file NonLinearEvolutionContainer.h
 * @brief Fichier entete de la classe NonLinearEvolutionContainer
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

/**
 * @class NonLinearEvolutionContainerClass
 * @brief Cette classe correspond a un evol_noli, elle hérite de ResultsContainer
          et stocke des champs
 * @author Natacha Béreux
 */
class NonLinearEvolutionContainerClass : public TimeDependantResultsContainerClass {
  private:
  public:
    /**
     * @brief Constructeur
     */
    NonLinearEvolutionContainerClass() : TimeDependantResultsContainerClass( "EVOL_NOLI" ){};

    /**
     * @brief Constructeur
     */
    NonLinearEvolutionContainerClass( const std::string name )
        : TimeDependantResultsContainerClass( name, "EVOL_NOLI" ){};
};

/**
 * @typedef NonLinearEvolutionContainerPtr
 * @brief Pointeur intelligent vers un NonLinearEvolutionContainerClass
 */
typedef boost::shared_ptr< NonLinearEvolutionContainerClass > NonLinearEvolutionContainerPtr;

#endif /* NONLINEAREVOLUTIONCONTAINER_H_ */
