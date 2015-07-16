#ifndef GENERICALGORITHM_H_
#define GENERICALGORITHM_H_

/**
 * @file GenericAlgorithm.h
 * @brief Fichier entete de la classe GenericAlgorithm
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2015  EDF R&D                www.code-aster.org
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

#include <iostream>

#include "Algorithms/AlgorithmException.h"
#include "Algorithms/GenericUnitaryAlgorithm.h"

/**
 * @class GenericAlgorithm
 * @brief Classe statique template servant à itérer sur un algorithme en se servant d'un Stepper
 * @author Nicolas Sellenet
 */
template< class GenericUnitaryAlgorithm >
class Algorithm
{
    public:
        /** @typedef Définition du Stepper */
        typedef typename GenericUnitaryAlgorithm::AlgorithmStepper Stepper;

        /**
         * @brief Réalisation de l'algorithme
         * @param timeStep Objet sur lequel il faut itérer
         * @param algo Algorithme à réaliser à chaque itération
         */
        static bool runAllStepsOverAlgorithm( Stepper& timeStep, GenericUnitaryAlgorithm& algo )
        {
            typedef typename Stepper::const_iterator it;
            for( it curVal = timeStep.begin();
                curVal != timeStep.end();
                ++curVal )
            {
                try
                {
                    algo.oneStep();
                }
                catch( AlgoException& exc )
                {
                    std::cout << exc.what() << std::endl;
                    break;
                }
            }
            return true;
        };
};

#endif /* GENERICALGORITHM_H_ */
