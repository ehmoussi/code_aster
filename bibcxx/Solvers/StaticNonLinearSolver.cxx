/**
 * @file StaticNonLinearSolver.cxx
 * @brief Fichier source contenant le source du solveur de mecanique statique
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

#include <stdexcept>

#include "Solvers/StaticNonLinearSolver.h"
#include "Discretization/DiscreteProblem.h"
#include "RunManager/CommandSyntaxCython.h"

StaticNonLinearSolverInstance::StaticNonLinearSolverInstance():
    _supportModel( ModelPtr() ),
    _materialOnMesh( MaterialOnMeshPtr() ),
    _listOfLoads( ListOfLoadsPtr( new ListOfLoadsInstance() ) ),
    _timeStep( TimeStepperPtr( new TimeStepperInstance( Temporary ) ) ), 
    _nonLinearMethod( NonLinearMethodPtr() ),  
    _lineSearchMethod( LineSearchMethodPtr())
{};


ResultsContainerPtr StaticNonLinearSolverInstance::execute() throw ( std::runtime_error )
{
    ResultsContainerPtr resultC( new ResultsContainerInstance ( std::string( "EVOL_NOLI" ) ) );
    std::string nameOfSD = resultC->getName();

    if ( _timeStep->size() == 0 )
        resultC->allocate( 1 );
    else
        resultC->allocate( _timeStep->size() );

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
    _listOfLoads->build();

    // Define the discrete problem
    DiscreteProblemPtr dProblem( new DiscreteProblemInstance( study ) );
/*
    // Build the linear solver (sd_solver)
    _linearSolver->build();

    DOFNumberingPtr dofNum1 = resultC->getEmptyDOFNumbering();
    dofNum1->setLinearSolver( _linearSolver );
    dofNum1 = dProblem->computeDOFNumbering( dofNum1 );
    FieldOnNodesDoublePtr vecass = dofNum1->getEmptyFieldOnNodesDouble( Temporary );



    typedef StaticMechanicalAlgorithm< TimeStepperInstance > MSAlgo;
    MSAlgo unitaryAlgo( dProblem, _linearSolver, resultC );
    Algorithm< MSAlgo > algoMS;
    algoMS.runAllStepsOverAlgorithm( *_timeStep, unitaryAlgo );
*/
    return resultC;
};
/* On appelle op0070 */
bool StaticNonLinearSolverInstance::execute_op70() throw ( std::runtime_error )
{

    std::cout << " Entrée dans execute_op70 " << std::endl; 
    CommandSyntaxCython cmdSt( "STAT_NON_LINE");
    cmdSt.setResult( getResultObjectName(), "STAT_NON_LINE" );

    SyntaxMapContainer dict;
    if ( ! _supportModel )
       throw std::runtime_error("Support model is undefined");
    std::cout << " Modèle : " << _supportModel->getName() << std::endl ; 
    dict.container["MODELE"] = _supportModel->getName();
    std::cout << " Matériau : " << _materialOnMesh->getName() << std::endl ; 
    dict.container[ "CHAM_MATER" ] =  _materialOnMesh->getName();
   
    ListSyntaxMapContainer listExcit(_listOfLoads->buildListExcit()); 
    dict.container[ "EXCIT" ] = listExcit;
    std::cout << " Après la liste des charges " << std::endl ; 
    ListSyntaxMapContainer listBehaviour; 
    SyntaxMapContainer dict2; 
    dict2.container["RELATION"] = "ELAS";
    listBehaviour.push_back( dict2 );
    dict.container["COMPORTEMENT"] = listBehaviour; 
    std::cout << " Après le comportement " << std::endl ; 
    //ListSyntaxMapContainer listLineSearch( _lineSearchMethod->buildListLineSearch() );
    //dict.container[ "RECH_LINEAIRE" ] = listLineSearch;
    //std::cout << " Après la recherche linéaire " << std::endl ; 
    cmdSt.define( dict );
    std::cout << " Fin de la construction de l'objet CommandSyntax" << std::endl;
    try
    {
        INTEGER op = 70;
        std::cout << " Appel d'op0070 " << std::endl;
        CALL_EXECOP( &op );
    }
    catch( ... )
    {
        throw;
    }
    
    return true;
};

