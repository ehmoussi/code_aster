#ifndef FOURIERCOMBINATION_H_
#define FOURIERCOMBINATION_H_

/**
 * @file CombinedFourierResult.h
 * @brief Fichier entete de la classe CombinedFourierResult
 * @author Nicolas Sellenet
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

#include "Results/Result.h"
#include "Supervis/ResultNaming.h"

/**
 * @class CombinedFourierResultClass
 * @brief Cette classe correspond a un comb_fourier
 * @author Nicolas Sellenet
 */
class CombinedFourierResultClass : public ResultClass {
  public:
    /**
     * @brief Constructeur
     */
    CombinedFourierResultClass( const std::string name = ResultNaming::getNewResultName() )
        : ResultClass( name, "COMB_FOURIER" ){};
};

/**
 * @typedef CombinedFourierResultPtr
 * @brief Pointeur intelligent vers un CombinedFourierResultClass
 */
typedef boost::shared_ptr< CombinedFourierResultClass > CombinedFourierResultPtr;

#endif /* FOURIERCOMBINATION_H_ */
