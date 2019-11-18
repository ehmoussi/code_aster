#ifndef STATICMECHANICALSOLVER_H_
#define STATICMECHANICALSOLVER_H_

/**
 * @file StaticMechanicalSolver.h
 * @brief Definition of the static mechanical solver
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
#include "astercxx.h"

#include "Algorithms/TimeStepper.h"
#include "LinearAlgebra/LinearSolver.h"
#include "Loads/KinematicsLoad.h"
#include "Loads/ListOfLoads.h"
#include "Loads/MechanicalLoad.h"
#include "Loads/ParallelMechanicalLoad.h"
#include "Materials/MaterialOnMesh.h"
#include "Modeling/Model.h"
#include "Results/ElasticEvolutionContainer.h"
#include "RunManager/Exceptions.h"
#include "Solvers/GenericSolver.h"
#include "Studies/StudyDescription.h"

class StaticMechanicalSolverInstance : public GenericSolver {
  private:
    /** @typedef std::list de MechanicalLoad */
    typedef std::list< GenericMechanicalLoadPtr > ListMecaLoad;
    /** @typedef Iterateur sur une std::list de MechanicalLoad */
    typedef ListMecaLoad::iterator ListMecaLoadIter;
    /** @typedef std::list de KinematicsLoad */
    typedef std::list< KinematicsLoadPtr > ListKineLoad;
    /** @typedef Iterateur sur une std::list de KinematicsLoad */
    typedef ListKineLoad::iterator ListKineLoadIter;
#ifdef _USE_MPI
    /** @typedef std::list de ParallelMechanicalLoad */
    typedef std::list< ParallelMechanicalLoadPtr > ListParaMechaLoad;
    /** @typedef Iterateur sur une std::list de ParallelMechanicalLoad */
    typedef ListKineLoad::iterator ListParaMechaLoadIter;
#endif /* _USE_MPI */

    /** @brief Modele */
    ModelPtr _model;
    /** @brief Champ de materiau a utiliser */
    MaterialOnMeshPtr _materialOnMesh;
    /** @brief Solveur lineaire */
    BaseLinearSolverPtr _linearSolver;
    /** @brief Liste de pas de temps */
    TimeStepperPtr _timeStep;
    /** @brief Study */
    StudyDescriptionPtr _study;

  public:
    /**
     * @brief Constructeur
     */
    StaticMechanicalSolverInstance( const ModelPtr &, const MaterialOnMeshPtr &,
                                    const ElementaryCharacteristicsPtr &cara = nullptr );

    /**
     * @brief Function d'ajout d'un chargement
     * @param Args... Liste d'arguments template
     */
    template < typename... Args > void addLoad( const Args &... a ) { _study->addLoad( a... ); };

    /**
     * @brief Lancement de la resolution
     */
    ElasticEvolutionContainerPtr execute();

    /**
     * @brief Methode permettant de definir le solveur lineaire
     * @param currentSolver Solveur lineaire
     */
    void setLinearSolver( const BaseLinearSolverPtr &currentSolver ) {
        _linearSolver = currentSolver;
    };

    /**
     * @brief Methode permettant de definir les pas de temps
     * @param curVec Liste de pas de temps
     */
    void setTimeStepManager( const VectorDouble &curVec ) { *_timeStep = curVec; };
};

/**
 * @typedef StaticMechanicalSolverPtr
 * @brief Enveloppe d'un pointeur intelligent vers un StaticMechanicalSolverInstance
 */
typedef boost::shared_ptr< StaticMechanicalSolverInstance > StaticMechanicalSolverPtr;

#endif /* STATICMECHANICALSOLVER_H_ */
