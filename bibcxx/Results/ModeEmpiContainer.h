#ifndef MODEEMPICONTAINER_H_
#define MODEEMPICONTAINER_H_

/**
 * @file ModeEmpiContainer.h
 * @brief Fichier entete de la classe ModeEmpiContainer
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

#include "astercxx.h"

#include "Results/ResultsContainer.h"

/**
 * @class ModeEmpiContainerClass
 * @brief Cette classe correspond a un mode_empi
 * @author Nicolas Sellenet
 */
class ModeEmpiContainerClass : public ResultsContainerClass {
  private:
  public:
    /**
     * @brief Constructeur
     */
    ModeEmpiContainerClass() : ResultsContainerClass( "MODE_EMPI" ){};

    /**
     * @brief Constructeur
     */
    ModeEmpiContainerClass( const std::string &name )
        : ResultsContainerClass( name, "MODE_EMPI" ){};
};

/**
 * @typedef ModeEmpiContainerPtr
 * @brief Pointeur intelligent vers un ModeEmpiContainerClass
 */
typedef boost::shared_ptr< ModeEmpiContainerClass > ModeEmpiContainerPtr;

#endif /* MODEEMPICONTAINER_H_ */
