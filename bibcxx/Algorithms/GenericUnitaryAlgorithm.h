#ifndef GENERICUNITARYALGORITHM_H_
#define GENERICUNITARYALGORITHM_H_

/**
 * @file GenericUnitaryAlgorithm.h
 * @brief Fichier entete de la classe GenericUnitaryAlgorithm
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

#include "Algorithms/AlgorithmException.h"

/**
 * @class GenericUnitaryAlgorithm
 * @brief Classe générique décrivant un algorithme unitaire
 * @author Nicolas Sellenet
 */
template< class Stepper >
class GenericUnitaryAlgorithm
{
    public:
        /** @typedef Définition de l'objet servant à itérer sur l'algorihtme unitaire */
        typedef Stepper AlgorithmStepper;
        /** @typedef Définition de l'itérateur constant utiliser pour préparer une étape */
        typedef typename Stepper::const_iterator AlgorithmStepperIter;

        /** @brief Méthode virtuelle pure nécessaire à l'avancer de l'algorithme */
        virtual void oneStep() throw( AlgoException& ) = 0;

        /** @typedef Méthode virtuelle pure nécessaire à la préparation d'une étape de l'algo */
        virtual void prepareStep( AlgorithmStepperIter& curStep ) throw( AlgoException& ) = 0;
};

#endif /* GENERICUNITARYALGORITHM_H_ */
