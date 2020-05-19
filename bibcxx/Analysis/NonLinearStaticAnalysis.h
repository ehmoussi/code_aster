#ifndef NONLINEARSTATICANALYSIS_H_
#define NONLINEARSTATICANALYSIS_H_

/**
 * @file NonLinearStaticAnalysis.h
 * @brief Definition of the static non linear analysis
 * @author Natacha Béreux
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

#include "Algorithms/StaticNonLinearAlgorithm.h"
#include "Algorithms/TimeStepper.h"
#include "Analysis/GenericAnalysis.h"
#include "Loads/Excitation.h"
#include "Loads/KinematicsLoad.h"
#include "Loads/MechanicalLoad.h"
#include "Materials/MaterialField.h"
#include "Meshes/BaseMesh.h"
#include "Modeling/Model.h"
#include "NonLinear/Behaviour.h"
#include "NonLinear/Driving.h"
#include "NonLinear/LineSearchMethod.h"
#include "NonLinear/NonLinearControl.h"
#include "NonLinear/State.h"
#include "Results/NonLinearResult.h"
#include "Solvers/LinearSolver.h"
#include "Studies/TimeStepManager.h"

/**
 @brief the NonLinearStaticAnalysis class is used to run
 a static non linear analysis on the FE_Model.
*/

class NonLinearStaticAnalysisClass : public GenericAnalysis {
  private:
    /** @typedef std::list of Excitations */
    typedef std::list< ExcitationPtr > ListExcitation;
    /** @typedef Iterator on a std::list of Excitation */
    typedef ListExcitation::iterator ListExcitationIter;
    /** @typedef Const Iterator on a std::list of Excitation */
    typedef ListExcitation::const_iterator ListExcitationCIter;
    /** @typedef List of Behaviours */
    typedef std::list< LocatedBehaviourPtr > ListLocatedBehaviour;
    /** @typedef Iterator on a std::list of LocatedBehaviourPtr */
    typedef ListLocatedBehaviour::iterator ListLocatedBehaviourIter;
    /** @typedef Constant Iterator on a std::list of LocatedBehaviourPtr */
    typedef ListLocatedBehaviour::const_iterator ListLocatedBehaviourCIter;
    /** @brief Model */
    ModelPtr _model;
    /** @brief Material field  */
    MaterialFieldPtr _materialField;
    /** @brief List of excitations */
    ListExcitation _listOfExcitations;
    /** @brief List of load steps  */
    TimeStepManagerPtr _loadStepManager;
    /** @brief NonLinear Behaviour */
    ListLocatedBehaviour _listOfBehaviours;
    /** @brief Initial State of the Analysis */
    StatePtr _initialState;
    /** @brief Definition of the nonlinear method */
    NonLinearMethodPtr _nonLinearMethod;
    /** @brief Control of the nonlinear method :
     *         convergence criterion, tolerances ... */
    NonLinearControlPtr _control;
    /** @brief Linear solver */
    BaseLinearSolverPtr _linearSolver;
    /** @brief Definition of the line search method */
    LineSearchMethodPtr _lineSearch;
    /** @brief Definition of the driving method */
    DrivingPtr _driving;
    /**
     *  @function addMechanicalExcitation
     * @brief Add a Mechanical Excitation to the analysis
     */
    void addMechanicalExcitation( const GenericMechanicalLoadPtr &currentLoad,
                                  ExcitationEnum typeOfExcit, const FunctionPtr &scalF = nullptr );
    /**
     * @function addKinematicExcitation
     * @brief Add a Kinematic Excitation to the analysis
     */
    void addKinematicExcitation( const KinematicsLoadPtr &currentLoad, ExcitationEnum typeOfExcit,
                                 const FunctionPtr &scalF = nullptr );

  public:
    /**
     * @brief Constructor
     */
    NonLinearStaticAnalysisClass();
    /**
     * @brief Define a Constitutive Law on a MeshEntity
     * @param BehaviourPtr is the constitutive law
     * @param nameOfGroup is the name of the group defining the MeshEntity.
     * Default value corresponds to set the behaviour on the whole mesh.
     */
    void addBehaviourOnCells( const BehaviourPtr &behaviour, std::string nameOfGroup = "" ) {
        // Check that the pointer to the model is not empty
        if ( ( !_model ) || _model->isEmpty() )
            throw std::runtime_error( "Model is empty" );
        // Define the Mesh Entity
        MeshEntityPtr meshEntity;
        BaseMeshPtr currentMesh = _model->getMesh();
        // If the MeshEntity is not given, the behaviour is set on the whole mesh
        if ( nameOfGroup.size() == 0 ) {
            meshEntity = MeshEntityPtr( new AllMeshEntities() );
        }
        // otherwise, if nameOfGroup is the name of a group of cells in the mesh
        else if ( currentMesh->hasGroupOfCells( nameOfGroup ) ) {
            meshEntity = MeshEntityPtr( new GroupOfCells( nameOfGroup ) );
        } else
            //  otherwise, throw an exception
            throw std::runtime_error( nameOfGroup + " does not exist in the mesh "
                                                    "or it is not authorized as a localization "
                                                    "of the behaviour " );
        // Insert the current behaviour with its Mesh Entity in the list of behaviours
        _listOfBehaviours.push_back(
            LocatedBehaviourPtr( new LocatedBehaviourClass( behaviour, meshEntity ) ) );
    };

    /**
     * @brief run the analysis
     *        this function wraps Code_Aster's legacy operator for nonlinear analysis
     *        (op0070)
     */
    NonLinearResultPtr execute();

    /** @brief Define the nonlinear method
     */
    void setNonLinearMethod( const NonLinearMethodPtr &currentMethod ) {
        _nonLinearMethod = currentMethod;
    };

    /**
     * @brief method to define the material set on mesh
     * @param currentMaterial objet MaterialFieldPtr
     */
    void setMaterialField( const MaterialFieldPtr &currentMaterial ) {
        _materialField = currentMaterial;
    };

    /**
     * @brief definition of  the finite element model
     * @param currentModel Model
     */
    void setModel( const ModelPtr &currentModel ) { _model = currentModel; };

    /**
     * @brief definition of the load steps
     * @param curTimeStepManager load step object
     */
    void setLoadStepManager( const TimeStepManagerPtr &curTimeStepManager ) {
        _loadStepManager = curTimeStepManager;
    };
    /**
     * @brief definition of the linear search method
     * @param currentLineSearch linesearch method
     */
    void setLineSearchMethod( const LineSearchMethodPtr &currentLineSearch ) {
        _lineSearch = currentLineSearch;
    };

    /**
     * @brief definition of the linear solver
     * @param
     */
    void setLinearSolver( const BaseLinearSolverPtr &currentSolver ) {
        _linearSolver = currentSolver;
    };
    /**
     * @brief definition of the initial state of the analysis
     */
    void setInitialState( const StatePtr &currentState ) { _initialState = currentState; }
    /**
     * @brief get the linear solver
     */
    BaseLinearSolverPtr &getBaseLinearSolver() { return _linearSolver; };
    /**
     * @brief definition of the driving method
     */
    void setDriving( const DrivingPtr &currentDriving ) { _driving = currentDriving; }
    /**
     * @brief definition of several excitations
     */
    void addStandardExcitation( const GenericMechanicalLoadPtr &currentLoad );
    void addStandardScaledExcitation( const GenericMechanicalLoadPtr &currentLoad,
                                      const FunctionPtr &scalF );
    void addStandardExcitation( const KinematicsLoadPtr &currentLoad );
    void addStandardScaledExcitation( const KinematicsLoadPtr &currentLoad,
                                      const FunctionPtr &scalF );
    void addDrivenExcitation( const GenericMechanicalLoadPtr &currentLoad );
    void addExcitationOnUpdatedGeometry( const GenericMechanicalLoadPtr &currentLoad );
    void addScaledExcitationOnUpdatedGeometry( const GenericMechanicalLoadPtr &currentLoad,
                                               const FunctionPtr &scalF );
    void addIncrementalDirichletExcitation( const GenericMechanicalLoadPtr &currentLoad );
    void addIncrementalDirichletScaledExcitation( const GenericMechanicalLoadPtr &currentLoad,
                                                  const FunctionPtr &scalF );
};

/**
 * @typedef StaticNonLinearAnalysisPtr
 * @brief smart pointer to a StaticNonLinearAnalysisClass
 */
typedef boost::shared_ptr< NonLinearStaticAnalysisClass > NonLinearStaticAnalysisPtr;

#endif /* NONLINEARSTATICANALYSIS_H_ */
