#ifndef FOURIERELASCONTAINER_H_
#define FOURIERELASCONTAINER_H_

/**
 * @file FourierElasContainer.h
 * @brief Fichier entete de la classe FourierElasContainer
 * @author Natacha Béreux
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

#include "astercxx.h"

#include "Results/ResultsContainer.h"

/**
 * @class FourierElasContainerInstance
 * @brief Cette classe correspond a un fourier_elas
 * @author Nicolas Sellenet
 */
class FourierElasContainerInstance : public ResultsContainerInstance {
  private:
  public:
    /**
     * @brief Constructeur
     */
    FourierElasContainerInstance() : ResultsContainerInstance( "FOURIER_ELAS" ){};
};

/**
 * @typedef FourierElasContainerPtr
 * @brief Pointeur intelligent vers un FourierElasContainerInstance
 */
typedef boost::shared_ptr< FourierElasContainerInstance > FourierElasContainerPtr;

#endif /* FOURIERELASCONTAINER_H_ */
