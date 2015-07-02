#ifndef STATICMECHANICALGORITHM_H_
#define STATICMECHANICALGORITHM_H_

/**
 * @file StaticMechanicalAlgorithm.h
 * @brief Fichier entete de la classe StaticMechanicalAlgorithm
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

#include "Algorithms/GenericUnitaryAlgorithm.h"
#include "Discretization/DiscreteProblem.h"
#include "LinearAlgebra/LinearSolver.h"
#include "Results/ResultsContainer.h"
#include "Loads/ListOfLoads.h"

/**
 * @class StaticMechanicalAlgorithm
 * @brief 
 * @author Nicolas Sellenet
 */
class StaticMechanicalAlgorithm: public GenericUnitaryAlgorithm
{
    private:
        /** @brief Problème discret */
        DiscreteProblemPtr  _discreteProblem;
        /** @brief Solveur linéaire */
        LinearSolverPtr     _linearSolver;
        /** @brief Sd de stockage des résultats */
        ResultsContainerPtr _results;
        /** @brief Chargements */
        ListOfLoadsPtr      _listOfLoads;

    public:
        /**
         * @brief Constructeur
         * @param DiscreteProblemPtr Problème discret a résoudre par l'algo
         * @param LinearSolverPtr Sovleur linéaire qui sera utilisé
         * @param ResultContainerPtr Résultat pour le stockage des déplacements
         */
        StaticMechanicalAlgorithm( const DiscreteProblemPtr& curPb,
                                   const LinearSolverPtr linSolv,
                                   const ResultsContainerPtr container ):
            _discreteProblem( curPb ),
            _linearSolver( linSolv ),
            _listOfLoads( _discreteProblem->getStudyDescription()->getListOfLoads() ),
            _results( container )
        {};

        void oneStep() throw( AlgoException& );
};

#endif /* STATICMECHANICALGORITHM_H_ */
