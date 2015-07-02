/**
 * @file StaticMechanicalAlgorithm.cxx
 * @brief Implementation de StaticMechanicalAlgorithm
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

#include "MemoryManager/JeveuxVector.h"
#include "Algorithms/StaticMechanicalAlgorithm.h"
#include "DataFields/FieldOnNodes.h"
#include "LinearAlgebra/ElementaryMatrix.h"
#include "LinearAlgebra/ElementaryVector.h"
#include "LinearAlgebra/AssemblyMatrix.h"
#include "LinearAlgebra/LinearSolver.h"
#include "Discretization/DOFNumbering.h"
#include "Loads/ListOfLoads.h"
#include "RunManager/CommandSyntaxCython.h"

/* person_in_charge: nicolas.sellenet at edf.fr */

void StaticMechanicalAlgorithm::oneStep() throw( AlgoException& )
{
    DOFNumberingPtr dofNum1 = _results->getLastDOFNumbering();

    ElementaryMatrixPtr matrElem = _discreteProblem->buildElementaryRigidityMatrix();

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
    ElementaryVectorPtr vectElem1 = _discreteProblem->buildElementaryDirichletVector();
    FieldOnNodesDoublePtr chNoDir = vectElem1->assembleVector( dofNum1, Temporary );

    // Build Laplace forces
    ElementaryVectorPtr vectElem2 = _discreteProblem->buildElementaryLaplaceVector();
    FieldOnNodesDoublePtr chNoLap = vectElem2->assembleVector( dofNum1, Temporary );

    // Build Neumann loads
    VectorDouble times;
    times.push_back( 0. );
    times.push_back( 0. );
    times.push_back( 0. );
    ElementaryVectorPtr vectElem3 = _discreteProblem->buildElementaryNeumannVector( times );
    FieldOnNodesDoublePtr chNoNeu = vectElem3->assembleVector( dofNum1, Temporary );

//     vecass->addFieldOnNodes( *chNoDir );
//     vecass->addFieldOnNodes( *chNoLap );
//     vecass->addFieldOnNodes( *chNoNeu );
    chNoDir->addFieldOnNodes( *chNoLap );
    chNoDir->addFieldOnNodes( *chNoNeu );

    FieldOnNodesDoublePtr kineLoadsFON = _listOfLoads->buildKinematicsLoad( dofNum1, Temporary );

    FieldOnNodesDoublePtr resultField = _results->getEmptyFieldOnNodesDouble( "DEPL", 0 );

    resultField = _linearSolver->solveDoubleLinearSystem( aMatrix, kineLoadsFON,
                                                          chNoDir, resultField );
    _results->debugPrint(8);
};
