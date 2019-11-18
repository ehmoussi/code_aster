#ifndef GENERICALGORITHM_H_
#define GENERICALGORITHM_H_

/**
 * @file GenericAlgorithm.h
 * @brief Fichier entete de la classe GenericAlgorithm
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2019  EDF R&D                www.code-aster.org
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

/* person_in_charge: nicolas.sellenet at edf.fr */

#include <iostream>
#include <initializer_list>
#include "astercxx.h"

#include "Algorithms/AlgorithmException.h"
#include "Algorithms/GenericUnitaryAlgorithm.h"

/**
 * @class GenericAlgorithm
 * @brief template class to iterate over an algorithm with a given Stepper and a Context
 * @author Nicolas Sellenet
 */
template < class StepperAlgo, class CurrentContext, class... GenericUnitaryAlgorithm >
class Algorithm {
  public:
    /**
     * @brief Run over an algorithm
     * @param timeStep Object to do the loop
     * @param context Context around algorithm
     */
    static bool runAllStepsOverAlgorithm( StepperAlgo &timeStep,
                                          CurrentContext &context ) {
        if ( !timeStep.update() )
            throw std::runtime_error( "Error with the Stepper" );

        typedef typename StepperAlgo::const_iterator it;
        for ( it curVal = timeStep.begin(); curVal != timeStep.end(); ++curVal ) {
            try {
                updateContextFromStepper( curVal, context );
                (void)std::initializer_list< int >{
                    ( GenericUnitaryAlgorithm::oneStep( context ), 0 )...};
            } catch ( AlgoException &exc ) {
                std::cout << exc.what() << std::endl;
                break;
            }
        }
        return true;
    };
};

#endif /* GENERICALGORITHM_H_ */
