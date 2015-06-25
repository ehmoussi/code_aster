/**
 * @file StaticMechanicalSolver.cxx
 * @brief Fichier source contenant le source du solveur de mecanique statique
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

#include <stdexcept>

#include "Solvers/StaticMechanicalSolver.h"
#include "RunManager/CommandSyntaxCython.h"
#include "Discretization/DiscreteProblem.h"
#include "LinearAlgebra/ElementaryMatrix.h"
#include "LinearAlgebra/AssemblyMatrix.h"
#include "Discretization/DOFNumbering.h"
#include "DataStructure/TemporaryDataStructureName.h"

StaticMechanicalSolverInstance::StaticMechanicalSolverInstance():
    _supportModel( ModelPtr() ),
    _materialOnMesh( MaterialOnMeshPtr() ),
    _linearSolver( LinearSolverPtr() ),
    _listOfLoads( ListOfLoadsPtr( new ListOfLoadsInstance() ) )
{};

void StaticMechanicalSolverInstance::execute2( ResultsContainerPtr& resultC ) throw ( std::runtime_error )
{
    // Define the study
    StudyDescriptionPtr study( new StudyDescriptionInstance( _supportModel, _materialOnMesh ) );

    // Add Loads to the study
    const ListMecaLoad& mecaList = _listOfLoads->getListOfMechanicalLoads();
    for ( ListMecaLoadCIter curIter = mecaList.begin();
          curIter != mecaList.end();
          ++curIter )
        study->addMechanicalLoad( *curIter );
    const ListKineLoad& kineList = _listOfLoads->getListOfKinematicsLoads();
    for ( ListKineLoadCIter curIter = kineList.begin();
          curIter != kineList.end();
          ++curIter )
        study->addKinematicsLoad( *curIter );

    // Define the discrete problem
    DiscreteProblemPtr dProblem( new DiscreteProblemInstance( study ) );

    // Build the linear solver (sd_solver)
    _linearSolver->build();

    DOFNumberingPtr dofNum1 = resultC->getEmptyDOFNumbering();
    dofNum1->setLinearSolver( _linearSolver );
    dofNum1 = dProblem->computeDOFNumbering( dofNum1 );
    FieldOnNodesDoublePtr vecass = dofNum1->getEmptyFieldOnNodesDouble( Temporary );

    // Compute elementary rigidity matrix
    ElementaryMatrixPtr matrElem = dProblem->buildElementaryRigidityMatrix();

    // Build assembly matrix
    AssemblyMatrixDoublePtr aMatrix( new AssemblyMatrixDoubleInstance( Temporary ) );
    aMatrix->setElementaryMatrix( matrElem );
    aMatrix->setDOFNumbering( dofNum1 );
    aMatrix->setListOfLoads( _listOfLoads );
    aMatrix->setLinearSolver( _linearSolver );
    aMatrix->build();

    // Matrix factorization
    aMatrix->factorization();

    // Build Dirichlet loads
    ElementaryVectorPtr vectElem1 = dProblem->buildElementaryDirichletVector();
    FieldOnNodesDoublePtr chNoDir = vectElem1->assembleVector( dofNum1 );

    // Build Laplace forces
    ElementaryVectorPtr vectElem2 = dProblem->buildElementaryLaplaceVector();
    FieldOnNodesDoublePtr chNoLap = vectElem2->assembleVector( dofNum1 );

    // Build Neumann loads
    ElementaryVectorPtr vectElem3 = dProblem->buildElementaryNeumannVector();
    FieldOnNodesDoublePtr chNoNeu = vectElem3->assembleVector( dofNum1 );
};

ResultsContainerPtr StaticMechanicalSolverInstance::execute() throw ( std::runtime_error )
{
    ResultsContainerPtr resultC( new ResultsContainerInstance ( std::string( "EVOL_ELAS" ) ) );
    std::string nameOfSD = resultC->getName();

    execute2( resultC );

    CommandSyntaxCython cmdSt( "MECA_STATIQUE" );
    cmdSt.setResult( resultC->getName(), resultC->getType() );

    SyntaxMapContainer dict;
    if ( ( ! _supportModel ) || _supportModel->isEmpty() )
        throw std::runtime_error( "Support model is undefined" );
    dict.container[ "MODELE" ] = _supportModel->getName();

    // Definition du mot cle simple CHAM_MATER
    if ( _materialOnMesh )
        dict.container[ "CHAM_MATER" ] = _materialOnMesh->getName();

    if ( _listOfLoads->size() == 0 )
        throw std::runtime_error( "At least one load is needed" );

    ListSyntaxMapContainer listeExcit;
    const ListMecaLoad& mecaList = _listOfLoads->getListOfMechanicalLoads();
    for ( ListMecaLoadCIter curIter = mecaList.begin();
          curIter != mecaList.end();
          ++curIter )
    {
        SyntaxMapContainer dict2;
        dict2.container[ "CHARGE" ] = (*curIter)->getName();
        listeExcit.push_back( dict2 );
    }
    const ListKineLoad& kineList = _listOfLoads->getListOfKinematicsLoads();
    for ( ListKineLoadCIter curIter = kineList.begin();
          curIter != kineList.end();
          ++curIter )
    {
        SyntaxMapContainer dict2;
        dict2.container[ "CHARGE" ] = (*curIter)->getName();
        listeExcit.push_back( dict2 );
    }
    dict.container[ "EXCIT" ] = listeExcit;

    // A mettre ailleurs ?
    ListSyntaxMapContainer listeSolver;
    SyntaxMapContainer dict3;
    dict3.container[ "METHODE" ] = _linearSolver->getSolverName();
    dict3.container[ "RENUM" ] = _linearSolver->getRenumburingName();
    listeSolver.push_back( dict3 );
    dict.container[ "SOLVEUR" ] = listeSolver;

    dict.container[ "OPTION" ] = "SIEF_ELGA";
    cmdSt.define( dict );

    try
    {
        INTEGER op = 46;
        CALL_EXECOP( &op );
    }
    catch( ... )
    {
        throw;
    }

    return resultC;
};
