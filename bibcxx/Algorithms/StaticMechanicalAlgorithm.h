#ifndef STATICMECHANICALGORITHM_H_
#define STATICMECHANICALGORITHM_H_

/**
 * @file StaticMechanicalAlgorithm.h
 * @brief Fichier entete de la classe StaticMechanicalAlgorithm
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

#include "Algorithms/StaticMechanicalContext.h"
#include "Algorithms/GenericContextUpdater.h"
#include "Algorithms/TimeStepper.h"
#include "Algorithms/AlgorithmException.h"

template <>
void updateContextFromStepper< TimeStepperInstance::const_iterator, StaticMechanicalContext >(
    const TimeStepperInstance::const_iterator &curStep, StaticMechanicalContext &context );

/**
 * @class StaticMechanicalAlgorithm
 * @brief Un pas de l'algorithme de l'opérateur de mécanqiue statique linéaire
 * @author Nicolas Sellenet
 */
class StaticMechanicalAlgorithm {
    typedef StaticMechanicalContext CurrentContext;

  public:
    /**
     * @brief Avancer d'un pas dans un algorithme
     */
    static void oneStep( const CurrentContext & );
};

#endif /* STATICMECHANICALGORITHM_H_ */
