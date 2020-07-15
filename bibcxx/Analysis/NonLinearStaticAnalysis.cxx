/**
 * @file NonLinearStaticAnalysis.cxx
 * @brief Fichier source contenant le source du solveur de mecanique statique
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

#include <stdexcept>

#include "Algorithms/GenericAlgorithm.h"
#include "Analysis/NonLinearStaticAnalysis.h"
#include "Discretization/DiscreteProblem.h"
#include "Supervis/CommandSyntax.h"

NonLinearStaticAnalysisClass::NonLinearStaticAnalysisClass()
    : _model( ModelPtr() ), _materialField( MaterialFieldPtr() ),
      _loadStepManager( TimeStepManagerPtr() ),
      _nonLinearMethod( NonLinearMethodPtr( new NonLinearMethodClass() ) ),
      _control( NonLinearControlPtr( new NonLinearControlClass() ) ),
      _linearSolver( BaseLinearSolverPtr( new BaseLinearSolverClass() ) ),
      _lineSearch( LineSearchMethodPtr() ){};

void NonLinearStaticAnalysisClass::addBehaviourOnCells( const BehaviourPtr &behaviour,
                                                        std::string nameOfGroup) {
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

/** @brief main routine to run a static, nonlinear analysis
 */
NonLinearResultPtr
NonLinearStaticAnalysisClass::execute() {
    // cmdSNL is the command Syntax object associated to Code_Aster STAT_NON_LINE command
    CommandSyntax cmdSNL( "STAT_NON_LINE" );
    // Init name of result
    NonLinearResultPtr resultSNL( new NonLinearResultClass() );
    cmdSNL.setResult( resultSNL->getName(), "STAT_NON_LINE" );
    // Build a dictionnary of keywords/values used to define the command syntax object
    SyntaxMapContainer dict;

    if ( !_model )
        throw std::runtime_error( "Model is undefined" );
    dict.container["MODELE"] = _model->getName();

    if ( !_materialField )
        throw std::runtime_error( "MaterialField is undefined" );
    dict.container["CHAM_MATER"] = _materialField->getName();

    if ( _listOfExcitations.size() == 0 )
        throw std::runtime_error( "Excitation is undefined" );

    CapyConvertibleFactorKeyword excitFKW( "EXCIT" );
    CapyConvertibleSyntax syntax;
    for ( ListExcitationCIter curIter = _listOfExcitations.begin();
          curIter != _listOfExcitations.end(); ++curIter ) {
        CapyConvertibleContainer toAdd = ( *curIter )->getCapyConvertibleContainer();
        excitFKW.addContainer( toAdd );
    }
    syntax.addFactorKeywordValues( excitFKW );
    SyntaxMapContainer test = syntax.toSyntaxMapContainer();
    // On ajoute le SyntaxMapContainer résultant du parcours de la liste des
    // excitations au SyntaxMapContainer qui servira à définir le CommandSyntax
    dict += test;

    ListSyntaxMapContainer listIncr;
    SyntaxMapContainer dictIncr;
    dictIncr.container["LIST_INST"] = _loadStepManager->getName();
    listIncr.push_back( dictIncr );
    dict.container["INCREMENT"] = listIncr;

    ListSyntaxMapContainer listMethod;
    const ListGenParam &listParamMethod = _nonLinearMethod->getListOfMethodParameters();
    SyntaxMapContainer dictMethod = buildSyntaxMapFromParamList( listParamMethod );
    dict += dictMethod;

    ListSyntaxMapContainer listNewton;
    const ListGenParam &listParamNewton = _nonLinearMethod->getListOfNewtonParameters();
    SyntaxMapContainer dictNewton = buildSyntaxMapFromParamList( listParamNewton );
    listNewton.push_back( dictNewton );
    dict.container["NEWTON"] = listNewton;

    CapyConvertibleFactorKeyword behaviourFKW( "COMPORTEMENT" );
    CapyConvertibleSyntax behaviourSyntax;
    if ( _listOfBehaviours.size() != 0 ) {
        for ( ListLocatedBehaviourCIter curIter = _listOfBehaviours.begin();
              curIter != _listOfBehaviours.end(); ++curIter ) {
            CapyConvertibleContainer toAdd = ( *curIter )->getCapyConvertibleContainer();
            behaviourFKW.addContainer( toAdd );
        }
    }

    behaviourSyntax.addFactorKeywordValues( behaviourFKW );
    SyntaxMapContainer behaviourTest = behaviourSyntax.toSyntaxMapContainer();
    // On ajoute le SyntaxMapContainer résultant du parcours de la liste des
    // comportements au SyntaxMapContainer qui servira à définir le CommandSyntax
    dict += behaviourTest;

    if ( _linearSolver != NULL )
        dict.container["SOLVEUR"] = _linearSolver->buildListSyntax();

    if ( _lineSearch != NULL ) {
        ListSyntaxMapContainer listLineSearch;
        const ListGenParam &listParamLineSearch = _lineSearch->getListOfParameters();
        SyntaxMapContainer dictLineSearch = buildSyntaxMapFromParamList( listParamLineSearch );
        listLineSearch.push_back( dictLineSearch );
        dict.container["RECH_LINEAIRE"] = listLineSearch;
    }
    if ( _initialState != NULL ) {
        ListSyntaxMapContainer listInitialState;
        const ListGenParam &listParamInitialState = _initialState->getListOfParameters();
        SyntaxMapContainer dictInitialState = buildSyntaxMapFromParamList( listParamInitialState );
        listInitialState.push_back( dictInitialState );
        dict.container["ETAT_INIT"] = listInitialState;
    }
    // Build Command Syntax object
    cmdSNL.define( dict );

    //  Now Command syntax is ready, call op00070
    try {
        ASTERINTEGER op = 70;
        CALL_EXECOP( &op );
    } catch ( ... ) {
        throw;
    }
    // Return result
    //    resultSNL->debugPrint(6);
    resultSNL->appendModelOnAllRanks( _model );
    resultSNL->update();
    return resultSNL;
};

/** @brief Implementation of the member functions to add an excitation (source term)
 */
void NonLinearStaticAnalysisClass::addMechanicalExcitation(
    const GenericMechanicalLoadPtr &currentLoad, ExcitationEnum typeOfExcit,
    const FunctionPtr &scalF ) {
    ExcitationPtr curExcit( new ExcitationClass( typeOfExcit ) );
    curExcit->setMechanicalLoad( currentLoad );
    if ( scalF )
        curExcit->setMultiplicativeFunction( scalF );
    _listOfExcitations.push_back( curExcit );
};

void NonLinearStaticAnalysisClass::addKinematicExcitation( const KinematicsLoadPtr &currentLoad,
                                                              ExcitationEnum typeOfExcit,
                                                              const FunctionPtr &scalF ) {
    ExcitationClass *curExcit( new ExcitationClass( typeOfExcit ) );
    curExcit->setKinematicLoad( currentLoad );
    if ( scalF )
        curExcit->setMultiplicativeFunction( scalF );
    _listOfExcitations.push_back( ExcitationPtr( curExcit ) );
};

void NonLinearStaticAnalysisClass::addStandardExcitation(
    const GenericMechanicalLoadPtr &currentLoad ) {
    addMechanicalExcitation( currentLoad, StandardExcitation, nullptr );
};
void NonLinearStaticAnalysisClass::addStandardScaledExcitation(
    const GenericMechanicalLoadPtr &currentLoad, const FunctionPtr &scalF ) {
    addMechanicalExcitation( currentLoad, StandardExcitation, scalF );
};
void
NonLinearStaticAnalysisClass::addStandardExcitation( const KinematicsLoadPtr &currentLoad ) {
    addKinematicExcitation( currentLoad, StandardExcitation, nullptr );
};
void
NonLinearStaticAnalysisClass::addStandardScaledExcitation( const KinematicsLoadPtr &currentLoad,
                                                              const FunctionPtr &scalF ) {
    addKinematicExcitation( currentLoad, StandardExcitation, scalF );
};
void NonLinearStaticAnalysisClass::addDrivenExcitation(
    const GenericMechanicalLoadPtr &currentLoad ) {
    addMechanicalExcitation( currentLoad, DrivenExcitation, nullptr );
};
void NonLinearStaticAnalysisClass::addExcitationOnUpdatedGeometry(
    const GenericMechanicalLoadPtr &currentLoad ) {
    addMechanicalExcitation( currentLoad, OnUpdatedGeometryExcitation, nullptr );
};
void NonLinearStaticAnalysisClass::addScaledExcitationOnUpdatedGeometry(
    const GenericMechanicalLoadPtr &currentLoad, const FunctionPtr &scalF ) {
    addMechanicalExcitation( currentLoad, OnUpdatedGeometryExcitation, scalF );
};
void NonLinearStaticAnalysisClass::addIncrementalDirichletExcitation(
    const GenericMechanicalLoadPtr &currentLoad ) {
    addMechanicalExcitation( currentLoad, IncrementalDirichletExcitation, nullptr );
};
void NonLinearStaticAnalysisClass::addIncrementalDirichletScaledExcitation(
    const GenericMechanicalLoadPtr &currentLoad, const FunctionPtr &scalF ) {
    addMechanicalExcitation( currentLoad, IncrementalDirichletExcitation, scalF );
};
