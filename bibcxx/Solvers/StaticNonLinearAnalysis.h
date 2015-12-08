#ifndef STATICNONLINEARANALYSIS_H_
#define STATICNONLINEARANALYSIS_H_

/**
 * @file StaticNonLinearAnalysis.h
 * @brief Definition of the static mechanical solver
 * @author Natacha Béreux
 * @section LICENCE
 *   Copyright (C) 1991 - 2014  EDF R&D                www.code-aster.org
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
#include "astercxx.h"

#include "Algorithms/StaticNonLinearAlgorithm.h"
#include "Algorithms/TimeStepper.h"
#include "LinearAlgebra/LinearSolver.h"
#include "Loads/KinematicsLoad.h"
#include "Loads/ListOfLoads.h"
#include "Loads/MechanicalLoad.h"
#include "Materials/MaterialOnMesh.h"
#include "Modeling/Model.h"
#include "NonLinear/Behaviour.h"
#include "NonLinear/State.h"
#include "Solvers/GenericSolver.h"


/**
 @brief the StaticNonLinearAnalysis class is used to perform 
 a static analysis on the FE_Model.
*/

class StaticNonLinearAnalysisInstance: public GenericSolver
{
    private:
        /** @typedef std::list de MechanicalLoad */
        typedef std::list< GenericMechanicalLoadPtr > ListMecaLoad;
        /** @typedef Iterateur sur une std::list de MechanicalLoad */
        typedef ListMecaLoad::iterator ListMecaLoadIter;
        /** @typedef std::list de KinematicsLoad */
        typedef std::list< KinematicsLoadPtr > ListKineLoad;
        /** @typedef Iterateur sur une std::list de KinematicsLoad */
        typedef ListKineLoad::iterator ListKineLoadIter;

        /** @brief Modele support */
        ModelPtr          _supportModel;
        /** @brief Champ de materiau a utiliser */
        MaterialOnMeshPtr _materialOnMesh;
        /** @brief Méthode nonlineaire */
        NonLinearMethodPtr   _nonLinearMethod;
        /** @brief Liste des chargements */
        ListOfLoadsPtr    _listOfLoads;
        /** @brief Liste de pas de chargements */
        TimeStepperPtr    _loadStep;
        /** @brief NonLinear Behaviour */
        BehaviourPtr _behaviour;
        /** @brief Initial State of the Analysis */
        StatePtr _initialState;
    public:
        /**
         * @brief Constructeur
         */
        StaticNonLinearAnalysisInstance();

        /**
         * @brief Function d'ajout d'une charge cinematique
         * @param currentLoad charge a ajouter a la sd
         */
        void addKinematicsLoad( const KinematicsLoadPtr& currentLoad )
        {
            _listOfLoads->addKinematicsLoad( currentLoad );
        };

        /**
         * @brief Function d'ajout d'une charge mecanique
         * @param currentLoad charge a ajouter a la sd
         */
        void addMechanicalLoad( const GenericMechanicalLoadPtr& currentLoad )
        {
            _listOfLoads->addMechanicalLoad( currentLoad );
        };

        /**
         * @brief Lancement de la resolution en appelant op0070 
         */
        bool execute_op70() throw ( std::runtime_error );
         /**
         * @brief Run the analysis 
         */
        ResultsContainerPtr execute() throw ( std::runtime_error );
        /**
         * @brief 
         * @param currentAnalysis Solveur lineaire
         */
        void setNonLinearMethod( const NonLinearMethodPtr& currentMethod )
        {
            _nonLinearMethod = currentMethod;
        };

        /**
         * @brief Methode permettant de definir le champ de materiau
         * @param currentMaterial objet MaterialOnMeshPtr
         */
        void setMaterialOnMesh( const MaterialOnMeshPtr& currentMaterial )
        {
            _materialOnMesh = currentMaterial;
        };

        /**
         * @brief Methode permettant de definir le modele support
         * @param currentModel Model support des matrices elementaires
         */
        void setSupportModel( const ModelPtr& currentModel )
        {
            _supportModel = currentModel;
        };

        /**
         * @brief Methode permettant de definir les pas de temps
         * @param currentStepper Liste de pas de temps
         */
        void setTimeStepper( const TimeStepperPtr& currentStepper )
        {
            _loadStep = currentStepper;
        };
        /**
         * @brief Methode permettant de definir la méthode de recherche linéaire
         * @param 
         */
        void setLineSearchMethod( const LineSearchMethodPtr& currentLineSearch )
        {
            _nonLinearMethod -> setLineSearchMethod(currentLineSearch);
        };
        /**
        * @brief method for the definition of the initial state of the analysis 
        */
        void setInitialState( const StatePtr& currentState ) 
            {
                _initialState = currentState; 
            }
};

/**
 * @typedef StaticNonLinearAnalysisPtr
 * @brief Enveloppe d'un pointeur intelligent vers un StaticNonLinearAnalysisInstance
 */
typedef boost::shared_ptr< StaticNonLinearAnalysisInstance > StaticNonLinearAnalysisPtr;

#endif /* STATICNONLINEARANALYSIS_H_ */
