/**
 * @file StaticMechanicalSolver.cxx
 * @brief Fichier source contenant le source du solveur de mecanique statique
 * @author Nicolas Sellenet
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

/* person_in_charge: nicolas.sellenet at edf.fr */

#include <stdexcept>
#include "Solvers/StaticMechanicalSolver.h"
#include "RunManager/CommandSyntaxCython.h"

StaticMechanicalSolverInstance::StaticMechanicalSolverInstance():
                _supportModel( ModelPtr() ),
                _materialOnMesh( MaterialOnMeshPtr() ),
                _linearSolver( LinearSolverPtr() )
{};

ResultsContainerPtr StaticMechanicalSolverInstance::execute() throw ( std::runtime_error )
{
    ResultsContainerPtr resultC( new ResultsContainerInstance ( std::string( "EVOL_ELAS" ) ) );
    std::string nameOfSD = resultC->getName();

    CommandSyntaxCython cmdSt( "MECA_STATIQUE" );
    cmdSt.setResult( resultC->getName(), resultC->getType() );

    SyntaxMapContainer dict;
    if ( ( ! _supportModel ) || _supportModel->isEmpty() )
        throw std::runtime_error( "Support model is undefined" );
    dict.container[ "MODELE" ] = _supportModel->getName();

    // Definition du mot cle simple CHAM_MATER
    if ( _materialOnMesh )
        dict.container[ "CHAM_MATER" ] = _materialOnMesh->getName();

    if ( _listOfMechanicalLoads.size() == 0 && _listOfKinematicsLoads.size() == 0 )
        throw std::runtime_error( "At least one load is needed" );

    ListSyntaxMapContainer listeExcit;
    for ( ListMecaLoadIter curIter = _listOfMechanicalLoads.begin();
          curIter != _listOfMechanicalLoads.end();
          ++curIter )
    {
        SyntaxMapContainer dict2;
        dict2.container[ "CHARGE" ] = (*curIter)->getName();
        dict2.container[ "TYPE_CHARGE" ] = "FIXE";
        listeExcit.push_back( dict2 );
    }
    for ( ListKineLoadIter curIter = _listOfKinematicsLoads.begin();
          curIter != _listOfKinematicsLoads.end();
          ++curIter )
    {
        SyntaxMapContainer dict2;
        dict2.container[ "CHARGE" ] = (*curIter)->getName();
        dict2.container[ "TYPE_CHARGE" ] = "FIXE";
        listeExcit.push_back( dict2 );
    }
    dict.container[ "EXCIT" ] = listeExcit;

    // A mettre ailleurs ?
    ListSyntaxMapContainer listeSolver;
    SyntaxMapContainer dict3;
    dict3.container[ "METHODE" ] = _linearSolver->getSolverName();
    dict3.container[ "RENUM" ] = _linearSolver->getRenumburingName();
    dict3.container[ "GESTION_MEMOIRE" ] = "OUT_OF_CORE";
    dict3.container[ "STOP_SINGULIER" ] = "OUI";
    dict3.container[ "PRETRAITEMENTS" ] = "AUTO";
    dict3.container[ "TYPE_RESOL" ] = "AUTO";
    dict3.container[ "MATR_DISTRIBUEE" ] = "NON";
    dict3.container[ "ELIM_LAGR" ] = "LAGR2";
    dict3.container[ "POSTTRAITEMENTS" ] = "AUTO";
    dict3.container[ "PCENT_PIVOT" ] = 50;
    dict3.container[ "NPREC" ] = -1;
    dict3.container[ "RESI_RELA" ] = -1.0;
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
