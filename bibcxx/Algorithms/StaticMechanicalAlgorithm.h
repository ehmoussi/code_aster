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
 * @brief Un pas de l'algorithme de l'opérateur de mécanqiue statique linéaire
 * @author Nicolas Sellenet
 */
template< class Stepper >
class StaticMechanicalAlgorithm: public GenericUnitaryAlgorithm< Stepper >
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
        /** @brief Pas de temps courant */
        double              _time;

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
            _results( container ),
            _time( 0. )
        {};

        /**
         * @brief Avancer d'un pas dans un algorithme
         */
        void oneStep() throw( AlgoException& );

        /** @typedef Rappel du typedef de GenericUnitaryAlgorithm */
        typedef typename Stepper::const_iterator AlgorithmStepperIter;

        /**
         * @brief Préparation de l'itération suivante
         * @param curStep Iterateur courant issu du Stepper
         */
        void prepareStep( AlgorithmStepperIter& curStep ) throw( AlgoException& );
};

template< class Stepper >
void StaticMechanicalAlgorithm< Stepper >::oneStep() throw( AlgoException& )
{
    DOFNumberingPtr dofNum1 = _results->getLastDOFNumbering();

    ElementaryMatrixPtr matrElem = _discreteProblem->buildElementaryRigidityMatrix( _time );

    // Build assembly matrix
    AssemblyMatrixDoublePtr aMatrix( new AssemblyMatrixDoubleInstance( Temporary ) );
    aMatrix->setElementaryMatrix( matrElem );
    aMatrix->setDOFNumbering( dofNum1 );
    aMatrix->setListOfLoads( _listOfLoads );
    aMatrix->setLinearSolver( _linearSolver );
    aMatrix->build();

    // Matrix factorization
    _linearSolver->matrixFactorization( aMatrix );

    CommandSyntaxCython cmdSt( "MECA_STATIQUE" );
    cmdSt.setResult( _results->getName(), _results->getType() );

    // Build Dirichlet loads
    ElementaryVectorPtr vectElem1 = _discreteProblem->buildElementaryDirichletVector( _time );
    FieldOnNodesDoublePtr chNoDir = vectElem1->assembleVector( dofNum1, _time, Temporary );

    // Build Laplace forces
    ElementaryVectorPtr vectElem2 = _discreteProblem->buildElementaryLaplaceVector();
    FieldOnNodesDoublePtr chNoLap = vectElem2->assembleVector( dofNum1, _time, Temporary );

    // Build Neumann loads
    VectorDouble times;
    times.push_back( _time );
    times.push_back( 0. );
    times.push_back( 0. );
    ElementaryVectorPtr vectElem3 = _discreteProblem->buildElementaryNeumannVector( times );
    FieldOnNodesDoublePtr chNoNeu = vectElem3->assembleVector( dofNum1, _time, Temporary );

    chNoDir->addFieldOnNodes( *chNoLap );
    chNoDir->addFieldOnNodes( *chNoNeu );

    FieldOnNodesDoublePtr kineLoadsFON = _listOfLoads->buildKinematicsLoad( dofNum1, _time,
                                                                            Temporary );

    FieldOnNodesDoublePtr resultField = _results->getEmptyFieldOnNodesDouble( "DEPL", 0 );

    resultField = _linearSolver->solveDoubleLinearSystem( aMatrix, kineLoadsFON,
                                                          chNoDir, resultField );
    _results->debugPrint(8);
};

template< class Stepper >
void StaticMechanicalAlgorithm< Stepper >::prepareStep( AlgorithmStepperIter& curStep )
    throw( AlgoException& )
{
    _time = *curStep;
};

#endif /* STATICMECHANICALGORITHM_H_ */
