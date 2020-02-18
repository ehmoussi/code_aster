/**
 * @file LinearStaticAnalysis.cxx
 * @brief Fichier source contenant le source du solveur de mecanique statique
 * @author Nicolas Sellenet
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

/* person_in_charge: nicolas.sellenet at edf.fr */

#include <stdexcept>

#include "Algorithms/GenericAlgorithm.h"
#include "Algorithms/StaticMechanicalAlgorithm.h"
#include "Algorithms/StaticMechanicalContext.h"
#include "DataStructures/TemporaryDataStructureName.h"
#include "Discretization/DOFNumbering.h"
#include "Discretization/DiscreteProblem.h"
#include "Supervis/Exceptions.h"
#include "Analysis/LinearStaticAnalysis.h"
#include "Supervis/CommandSyntax.h"

LinearStaticAnalysisClass::LinearStaticAnalysisClass(
    const ModelPtr &model, const MaterialOnMeshPtr &mater,
    const ElementaryCharacteristicsPtr &cara )
    : _model( model ), _materialOnMesh( mater ), _linearSolver( BaseLinearSolverPtr() ),
      _timeStep( TimeStepperPtr( new TimeStepperClass() ) ),
      _study( new StudyDescriptionClass( _model, _materialOnMesh, cara ) ) {
    _timeStep->setValues( VectorReal( 1, 0. ) );
};

ElasticResultPtr LinearStaticAnalysisClass::execute() {
    ElasticResultPtr resultC( new ElasticResultClass() );

    _study->getCodedMaterial()->allocate(true);

    if ( !_timeStep )
        throw std::runtime_error( "No time list" );
    if ( _timeStep->size() == 0 )
        resultC->allocate( 1 );
    else
        resultC->allocate( _timeStep->size() );

    // Define the discrete problem
    DiscreteProblemPtr dProblem( new DiscreteProblemClass( _study ) );

    if ( _model->getMesh()->isParallel() ) {
        if ( !_linearSolver->isHPCCompliant() )
            throw std::runtime_error( "ParallelMesh not allowed with this linear solver" );
        if ( _linearSolver->getPreconditioning() == SimplePrecisionLdlt )
            throw std::runtime_error( "ParallelMesh not allowed with this preconditioning" );
    }
    // Build the linear solver (sd_solver)
    _linearSolver->_commandName = "MECA_STATIQUE";
    if( _model->xfemPreconditioningEnable() ) _linearSolver->enableXfem();
    _linearSolver->build();

    BaseDOFNumberingPtr dofNum1;
#ifdef _USE_MPI
    if ( _model->getMesh()->isParallel() )
        dofNum1 = resultC->getEmptyParallelDOFNumbering();
    else
#endif /* _USE_MPI */
        dofNum1 = resultC->getEmptyDOFNumbering();
    dofNum1 = dProblem->computeDOFNumbering( dofNum1 );

    StaticMechanicalContext currentContext( dProblem, _linearSolver, resultC );
    typedef Algorithm< TimeStepperClass, StaticMechanicalContext, StaticMechanicalAlgorithm >
        MSAlgo;
    MSAlgo::runAllStepsOverAlgorithm( *_timeStep, currentContext );

    return resultC;
};
