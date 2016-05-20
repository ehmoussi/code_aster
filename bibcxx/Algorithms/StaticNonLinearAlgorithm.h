#ifndef STATICNONLINEARALGORITHM_H_
#define STATICNONLINEARALGORITHM_H_

/**
 * @file StaticNonLinearAlgorithm.h
 * @brief Fichier entete de la classe StaticNonLinearAlgorithm
 * @author Natacha Béreux 
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

/* person_in_charge: natacha.bereux at edf.fr */

#include "Algorithms/GenericUnitaryAlgorithm.h"
#include "Discretization/DiscreteProblem.h"
#include "LinearAlgebra/LinearSolver.h"
#include "Results/ResultsContainer.h"
#include "Loads/ListOfLoads.h"
#include "NonLinear/NonLinearMethod.h"
#include "NonLinear/State.h"

/**
 * @class StaticNonLinearAlgorithm
 * @brief Un pas de l'algorithme de l'opérateur de mécanique statique nonlinéaire
 * @author Natacha Béreux 
 */
template< class Stepper >
class StaticNonLinearAlgorithm: public GenericUnitaryAlgorithm< Stepper >
{
    private:
        /** @brief Problème discret */
        DiscreteProblemPtr  _discreteProblem;
        /** @brief Solveur non linéaire */
 //       NonLinearMethodPtr  _nonLinearMethod;
        /** @brief Sd de stockage des résultats */
        ResultsContainerPtr _results;
        /** @brief Chargements */
        ListOfLoadsPtr      _listOfLoads;
        /** @brief Pas de chargement courant */
        double              _loadStep;
        /** @brief Etat du système au pas de chargement courant */
        StatePtr _currentState;
        /** @brief Etat du système au pas de chargement précédent */
        StatePtr _lastState;
    public:
        /**
         * @brief Constructeur
         * @param DiscreteProblemPtr Problème discret a résoudre par l'algo
         * @param LinearSolverPtr Solveur linéaire qui sera utilisé
         * @param ResultContainerPtr Résultat pour le stockage des déplacements
         */
        StaticNonLinearAlgorithm( const DiscreteProblemPtr& curPb,
 //                        const NonLinearMethodPtr nLMethod,
                         const ResultsContainerPtr container ):
            _discreteProblem( curPb ),
  //          _nonLinearMethod( nLMethod ),
            _listOfLoads( _discreteProblem->getStudyDescription()->getListOfLoads() ),
            _results( container ),
            _loadStep( 0. )
{}

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
        
        void doPrediction( DiscreteProblemPtr dProblem, LinearSolverPtr linSolv, FieldOnNodesDoublePtr uField ); 
        
        void doCorrection( DiscreteProblemPtr _discreteProblem, FieldOnNodesDoublePtr duField, int nIter );
};






template< class Stepper >
void StaticNonLinearAlgorithm< Stepper >::oneStep() throw( AlgoException& )
{
 /*

    // Préparation du pas courant 
    int nIter(0); 
    DOFNumberingPtr dofNum1 = _results->getLastDOFNumbering();
    // Reinit log 
    //_nonLinearMethod -> cleanLog(); 
    // Linear Solver
   // LinearSolverPtr linSolv(_nonLinearMethod->getLinearSolver());
    // C'est dans le résultat qu'on trouve le 
    // champ aux noeuds contenant les déplacements 
    FieldOnNodesDoublePtr uField = _results->getEmptyFieldOnNodesDouble( "DEPL", _loadStep );
    // Il est initialisé au déplacement au pas de chargement précédent
    // uField = copy ( _results->getEmptyFieldOnNodesDouble( "DEPL", _lastLoadStep );
    //
    // TODO pour un calcul non linéaire plus compliqué on devra aussi stocker le champ de contraintes
    // et le champ de variables internes 
    // => utiliser des objets "state" avec 3 champs 
    //
    // On crée un champ aux noeuds de même profil que le champ de déplacement.
    // Il contient l'incrément de déplacement
    // duField = uField->clone()
    // dUField -> zero()
    FieldOnNodesDoublePtr duField; 
    // ******************* 
    // Etape de prédiction
    // ******************* 
    doPrediction(_discreteProblem, linSolv, duField );
    // Add current displacement increment 
     uField->addFieldOnNodes( *duField );
    // and check if it is a satisfactory solution 
    ConvergenceState status = _nonLinearMethod->check( _discreteProblem, uField, nIter );
    // If uField is not satisfactory, proceed to the correction steps 
    // 
    
    while ( status == iterate ) 
        {
        ++nIter; 
        // Compute a displacement increment 
        // ******************* 
        // Etape de correction
        // ******************* 
        doCorrection(_discreteProblem, duField, nIter );
        // Add it to the current displacement field 
        // C'est ici que serait effectuée l'étape de recherche linéaire 
        uField->addFieldOnNodes( *duField );
        // and check if it is a satisfactory solution 
        ConvergenceState status = _nonLinearMethod->check( _discreteProblem, uField, nIter );
        }
    if ( status == failure ) 
        {
        throw std::runtime_error( " Step failed " );
        }
    _results->debugPrint(8);
}

template< class Stepper >
void StaticNonLinearAlgorithm< Stepper >::doPrediction( DiscreteProblemPtr dProblem, LinearSolverPtr linSolv, FieldOnNodesDoublePtr uField )
{
    // A déplacer
    DOFNumberingPtr dofNum1 = _results->getLastDOFNumbering();
    ElementaryMatrixPtr matrElem = _discreteProblem->buildElementaryTangentMatrix( _loadStep );
    // Build assembly matrix
    AssemblyMatrixDoublePtr aMatrix( new AssemblyMatrixDoubleInstance( Temporary ) );
    aMatrix->setElementaryMatrix( matrElem );
    aMatrix->setDOFNumbering( dofNum1 );
    aMatrix->setListOfLoads( _listOfLoads );
    aMatrix->setLinearSolver( linSolv );
    aMatrix->build();

    // Build Dirichlet loads
    ElementaryVectorPtr vectElem1 = _discreteProblem->buildElementaryDirichletVector( _loadStep );
    FieldOnNodesDoublePtr chNoDir = vectElem1->assembleVector( dofNum1, _loadStep, Temporary );

    // Build Laplace forces
    ElementaryVectorPtr vectElem2 = _discreteProblem->buildElementaryLaplaceVector();
    FieldOnNodesDoublePtr chNoLap = vectElem2->assembleVector( dofNum1, _loadStep, Temporary );

    // Build Neumann loads
    VectorDouble times;
    times.push_back( _loadStep );
    times.push_back( 0. );
    times.push_back( 0. );
    ElementaryVectorPtr vectElem3 = _discreteProblem->buildElementaryNeumannVector( times );
    FieldOnNodesDoublePtr chNoNeu = vectElem3->assembleVector( dofNum1, _loadStep, Temporary );

    chNoDir->addFieldOnNodes( *chNoLap );
    chNoDir->addFieldOnNodes( *chNoNeu );

    FieldOnNodesDoublePtr kineLoadsFON = _listOfLoads->buildKinematicsLoad( dofNum1, _loadStep,
                                                                            Temporary );


    // Matrix factorization
    linSolv->matrixFactorization( aMatrix );

    uField = linSolv->solveDoubleLinearSystem( aMatrix, kineLoadsFON,
                                                        chNoDir, uField );
*/
}


template< class Stepper >
void StaticNonLinearAlgorithm< Stepper >::doCorrection( DiscreteProblemPtr _discreteProblem, FieldOnNodesDoublePtr duField, int nIter )
{
    std::cout << " Etape de correction : " << nIter << std::endl; 
}

template< class Stepper >
void StaticNonLinearAlgorithm< Stepper >::prepareStep( AlgorithmStepperIter& curStep )
    throw( AlgoException& )
{
    _loadStep = *curStep;
    
};

#endif /* STATICNONLINEARALGORITHM_H_ */
