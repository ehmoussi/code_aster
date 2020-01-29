#ifndef INPUTVARIABLEEVOLUTIONCONTAINER_H_
#define INPUTVARIABLEEVOLUTIONCONTAINER_H_

/**
 * @file InputVariableEvolutionContainer.h
 * @brief Fichier entete de la classe InputVariableEvolutionContainer
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
 * @class InputVariableEvolutionContainerClass
 * @brief Cette classe correspond a un evol_varc, elle hérite de ResultsContainer
          et stocke des champs
 * @author Natacha Béreux
 */
class InputVariableEvolutionContainerClass : public TimeDependantResultsContainerClass {
  private:
  public:
    /**
     * @brief Constructeur
     */
    InputVariableEvolutionContainerClass(
        const std::string name = ResultNaming::getNewResultName() )
        : TimeDependantResultsContainerClass( name, "EVOL_VARC" ){};
};

/**
 * @typedef InputVariableEvolutionContainerPtr
 * @brief Pointeur intelligent vers un InputVariableEvolutionContainerClass
 */
typedef boost::shared_ptr< InputVariableEvolutionContainerClass >
    InputVariableEvolutionContainerPtr;

#endif /* INPUTVARIABLEEVOLUTIONCONTAINER_H_ */
