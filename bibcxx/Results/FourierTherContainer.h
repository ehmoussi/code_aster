#ifndef FOURIERTHERCONTAINER_H_
#define FOURIERTHERCONTAINER_H_

/**
 * @file FourierTherContainer.h
 * @brief Fichier entete de la classe FourierTherContainer
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
#include "Supervis/ResultNaming.h"

/**
 * @class FourierTherContainerClass
 * @brief Cette classe correspond a un fourier_elas
 * @author Nicolas Sellenet
 */
class FourierTherContainerClass : public ResultsContainerClass {
  private:
  public:
    /**
     * @brief Constructeur
     */
    FourierTherContainerClass( const std::string name = ResultNaming::getNewResultName() )
        : ResultsContainerClass( name, "FOURIER_THER" ){};
};

/**
 * @typedef FourierTherContainerPtr
 * @brief Pointeur intelligent vers un FourierTherContainerClass
 */
typedef boost::shared_ptr< FourierTherContainerClass > FourierTherContainerPtr;

#endif /* FOURIERTHERCONTAINER_H_ */
