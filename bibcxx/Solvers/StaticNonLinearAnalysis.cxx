/**
 * @file StaticNonLinearAnalysis.cxx
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

#include "Algorithms/GenericAlgorithm.h"
#include "Solvers/StaticNonLinearAnalysis.h"
#include "Discretization/DiscreteProblem.h"
#include "RunManager/CommandSyntaxCython.h"

StaticNonLinearAnalysisInstance::StaticNonLinearAnalysisInstance():
    _supportModel( ModelPtr() ),
    _materialOnMesh( MaterialOnMeshPtr() ),
    _listOfLoads( ListOfLoadsPtr( new ListOfLoadsInstance() ) ),
    _loadStepManager( TimeStepManagerPtr( ) ), 
    _nonLinearMethod( NonLinearMethodPtr( new NonLinearMethodInstance() ) ),
    _control( NonLinearControlPtr ( new NonLinearControlInstance() ) ),  
    _linearSolver( LinearSolverPtr ( new LinearSolverInstance() ) ),
    _lineSearch ( LineSearchMethodPtr() ) 
{};

/** @brief main routine to run a static, nonlinear analysis */
ResultsContainerPtr StaticNonLinearAnalysisInstance::execute() throw ( std::runtime_error )
{
    std::cout << " Entree dans execute()" << std::endl; 
// cmdSNL is the command Syntax object associated to Code_Aster STAT_NON_LINE command 
    CommandSyntaxCython cmdSNL( "STAT_NON_LINE");
// Init name of result 
    ResultsContainerPtr resultSNL( new ResultsContainerInstance ( std::string( "EVOL_NOLI" ) ) );
    cmdSNL.setResult( resultSNL->getName(), "STAT_NON_LINE" );
// Build a dictionnary of keywords/values used to define the command syntax object    
   SyntaxMapContainer dict;
//
    if ( ! _supportModel )
       throw std::runtime_error("Support model is undefined");
    dict.container["MODELE"] = _supportModel->getName();
    std::cout<< "Model: "<< _supportModel->getName() << " is a string of length "<< _supportModel->getName().length() << std::endl; 
    if ( ! _materialOnMesh )
       throw std::runtime_error("MaterialOnMesh is undefined");
    dict.container[ "CHAM_MATER" ] =  _materialOnMesh->getName();
    std::cout<< "Cham_mater: "<< _materialOnMesh->getName() << " is a string of length "<< _materialOnMesh->getName().length() << std::endl;
   
    ListSyntaxMapContainer listExcit(_listOfLoads->buildListExcit()); 
    dict.container[ "EXCIT" ] = listExcit;

    ListSyntaxMapContainer listBehaviour; 
    SyntaxMapContainer dictBEHAV; 
    dictBEHAV.container["RELATION"] = "ELAS";
    listBehaviour.push_back( dictBEHAV );
    dict.container["COMPORTEMENT"] = listBehaviour; 

    ListSyntaxMapContainer listIncr;
    SyntaxMapContainer dictIncr;
    dictIncr.container["LIST_INST"] = _loadStepManager-> getName();
    listIncr.push_back( dictIncr );
    dict.container["INCREMENT"] = listIncr;
   
    ListSyntaxMapContainer listMethod; 
    const ListGenParam& listParamMethod = _nonLinearMethod->getListOfMethodParameters();
    SyntaxMapContainer dictMethod = buildSyntaxMapFromParamList( listParamMethod);
    listMethod.push_back( dictMethod);
    dict.container[ "METHODE" ] = listMethod;
    std::cout << " Après le mot-clé Method " << std::endl ;

    ListSyntaxMapContainer listNewton; 
    const ListGenParam& listParamNewton = _nonLinearMethod->getListOfNewtonParameters();
    SyntaxMapContainer dictNewton = buildSyntaxMapFromParamList( listParamNewton );
    listNewton.push_back( dictNewton);
    dict.container[ "NEWTON" ] = listNewton;
    std::cout << " Après le mot-clé Newton " << std::endl ;

    if ( _listOfBehaviours.size() != 0 )
    {
        ListSyntaxMapContainer listeComportement;
        for ( ListLocatedBehaviourCIter curIter = _listOfBehaviours.begin();
              curIter != _listOfBehaviours.end();
              ++curIter )
        {
            BehaviourPtr& curBehaviour =  (*curIter)->first; 

            const ListGenParam& listParam = curBehaviour->getListOfParameters();
            SyntaxMapContainer dict2 = buildSyntaxMapFromParamList( listParam );

            MeshEntityPtr& curMeshEntity = (*curIter) ->second;
            if ( curMeshEntity->getType() == AllMeshEntitiesType )
                dict2.container["TOUT"] = "OUI";
            else if ( curMeshEntity->getType()  == GroupOfElementsType )
                dict2.container["GROUP_MA"] = curMeshEntity->getName();

            listeComportement.push_back( dict2 );
        }
        dict.container["COMPORTEMENT"] = listeComportement;
    }
    
    if ( _linearSolver != NULL ) 
        dict.container[ "SOLVEUR" ] = _linearSolver->buildListSyntax();

    if (_lineSearch != NULL )
    	{ ListSyntaxMapContainer listLineSearch;
    	const ListGenParam& listParamLineSearch = _lineSearch->getListOfParameters();
    	SyntaxMapContainer dictLineSearch = buildSyntaxMapFromParamList( listParamLineSearch );
    	listLineSearch.push_back( dictLineSearch );
    	dict.container[ "RECH_LINEAIRE" ] = listLineSearch;
    	std::cout << " Après la recherche linéaire " << std::endl ; 
        }
// Build Command Syntax object 
    cmdSNL.define( dict );
    std::cout << " Appel de debugPrint pour CommandSyntax " << std::endl;
    cmdSNL.debugPrint();
 
//  Now op00070 may be called   
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
// Return result 
    resultSNL->debugPrint(8);
    return resultSNL;
};


