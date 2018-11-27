/**
 * @file StaticMechanicalAlgorithm.cxx
 * @brief Implementation de StaticMechanicalAlgorithm
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2018  EDF R&D                www.code-aster.org
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

#include "Algorithms/StaticMechanicalAlgorithm.h"

template <>
void updateContextFromStepper< TimeStepperInstance::const_iterator, StaticMechanicalContext >(
    const TimeStepperInstance::const_iterator &curStep, StaticMechanicalContext &context ) {
    context.setStep( *curStep, curStep.rank );
};

void StaticMechanicalAlgorithm::oneStep( const CurrentContext &ctx ) {
    BaseDOFNumberingPtr dofNum1 = ctx._results->getLastDOFNumbering();

    if ( ctx._rank == 1 || !ctx._isConst ) {
        auto matrElem = ctx._discreteProblem->buildElementaryStiffnessMatrix( ctx._time );

        // Build assembly matrix
        ctx._aMatrix->clearElementaryMatrix();
        ctx._aMatrix->appendElementaryMatrix( matrElem );
        ctx._aMatrix->setDOFNumbering( dofNum1 );
        ctx._aMatrix->setListOfLoads( ctx._listOfLoads );
        ctx._aMatrix->build();

        // Matrix factorization
        ctx._linearSolver->matrixFactorization( ctx._aMatrix );
    }

    // Build Dirichlet loads
    ElementaryVectorPtr vectElem1 =
        ctx._discreteProblem->buildElementaryDirichletVector( ctx._time );
    FieldOnNodesDoublePtr chNoDir = vectElem1->assembleVector( dofNum1, ctx._time, Temporary );

    // Build Laplace forces
    ElementaryVectorPtr vectElem2 = ctx._discreteProblem->buildElementaryLaplaceVector();
    FieldOnNodesDoublePtr chNoLap = vectElem2->assembleVector( dofNum1, ctx._time, Temporary );

    // Build Neumann loads
    VectorDouble times;
    times.push_back( ctx._time );
    times.push_back( 0. );
    times.push_back( 0. );
    ElementaryVectorPtr vectElem3 = ctx._discreteProblem->buildElementaryNeumannVector( times );
    FieldOnNodesDoublePtr chNoNeu = vectElem3->assembleVector( dofNum1, ctx._time, Temporary );

    chNoDir->addFieldOnNodes( *chNoLap );
    chNoDir->addFieldOnNodes( *chNoNeu );

    ctx._varCom->compute( ctx._time );
    if ( ctx._varCom->existsMechanicalLoads() ) {
        auto varComLoad = ctx._varCom->computeMechanicalLoads( dofNum1 );
        chNoDir->addFieldOnNodes( *varComLoad );
    }

    CommandSyntax cmdSt( "MECA_STATIQUE" );
    cmdSt.setResult( ctx._results->getName(), ctx._results->getType() );

    FieldOnNodesDoublePtr kineLoadsFON =
        ctx._discreteProblem->buildKinematicsLoad( dofNum1, ctx._time, Temporary );

    FieldOnNodesDoublePtr resultField =
        ctx._results->getEmptyFieldOnNodesDouble( "DEPL", ctx._rank );

    resultField = ctx._linearSolver->solveDoubleLinearSystemWithKinematicsLoad(
        ctx._aMatrix, kineLoadsFON, chNoDir, resultField );

    const auto &study = ctx._discreteProblem->getStudyDescription();
    const auto &model = study->getSupportModel();
    const auto &mater = study->getMaterialOnMesh();
    const auto &load = study->getListOfLoads();
    const auto &cara = study->getElementaryCharacteristics();
    ctx._results->addModel( model, ctx._rank );
    ctx._results->addMaterialOnMesh( mater, ctx._rank );
    ctx._results->addTimeValue( ctx._time, ctx._rank );
    ctx._results->addListOfLoads( load, ctx._rank );
    if ( cara != nullptr ) {
        ctx._results->addElementaryCharacteristics( cara, ctx._rank );
    }
};
