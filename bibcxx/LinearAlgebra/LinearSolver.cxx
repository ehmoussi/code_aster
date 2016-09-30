/**
 * @file LinearSolver.cxx
 * @brief Initialisation des renumeroteurs autorises pour les solvers
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

#include "astercxx.h"

#include "LinearAlgebra/LinearSolver.h"
#include "RunManager/CommandSyntaxCython.h"

const std::set< Renumbering > WrapMultFront::setOfAllowedRenumbering( MultFrontRenumbering,
                                                                 MultFrontRenumbering + nbRenumberingMultFront );

const std::set< Renumbering > WrapLdlt::setOfAllowedRenumbering( LdltRenumbering,
                                                            LdltRenumbering + nbRenumberingLdlt );

const std::set< Renumbering > WrapMumps::setOfAllowedRenumbering( MumpsRenumbering,
                                                             MumpsRenumbering + nbRenumberingMumps );

const std::set< Renumbering > WrapPetsc::setOfAllowedRenumbering( PetscRenumbering,
                                                             PetscRenumbering + nbRenumberingPetsc );

const std::set< Renumbering > WrapGcpc::setOfAllowedRenumbering( GcpcRenumbering,
                                                            GcpcRenumbering + nbRenumberingGcpc );



ListSyntaxMapContainer LinearSolverInstance::buildListSyntax()
{
    ListSyntaxMapContainer listeSolver;
    SyntaxMapContainer dict1;
    dict1.container[ "METHODE" ] = getSolverName();
    dict1.container[ "RENUM" ] = getRenumberingName();
    dict1.container[ "PCENT_PIVOT" ] = 20;
    dict1.container[ "TYPE_RESOL" ] = "AUTO";
    dict1.container[ "PRETRAITEMENTS" ] = "AUTO";
    dict1.container[ "ELIM_LAGR" ] = "LAGR2";
    dict1.container[ "GESTION_MEMOIRE" ] = "AUTO";
    dict1.container[ "LOW_RANK_TAILLE" ] = -1.0;
    dict1.container[ "LOW_RANK_SEUIL" ] = 0.0;
    listeSolver.push_back( dict1 );
    return listeSolver; 
};

bool LinearSolverInstance::build()
{
    std::string newName( getName() );
    newName.resize( 19, ' ' );

    // Definition du bout de fichier de commande pour SOLVEUR
    CommandSyntaxCython cmdSt( "SOLVEUR" );
    cmdSt.setResult( getName(), getType() );

    SyntaxMapContainer dict;
    ListSyntaxMapContainer listeSolver = this->buildListSyntax(); 
   
    dict.container[ "SOLVEUR" ] = listeSolver;
    cmdSt.define( dict );

    CALL_CRESOL_WRAP( newName.c_str(), "G" );
    _isEmpty = false;

    return true;
};

bool LinearSolverInstance::matrixFactorization( const AssemblyMatrixDoublePtr currentMatrix ) const
{
    const std::string solverName = getName();
    std::string base( "V" );
    if ( currentMatrix->getMemoryType() == Permanent )
        base = std::string( "G" );
    long cret = 0, npvneg = 0, istop = -9999;
    const std::string matpre( " " );
    const std::string matass = currentMatrix->getName();

    // AMUMPT appel getres
    CommandSyntaxCython cmdSt( "AUTRE" );
    cmdSt.setResult( "AUCUN", "AUCUN" );

    CALL_MATRIX_FACTOR( solverName.c_str(), base.c_str(), &cret, matpre.c_str(),
                        matass.c_str(), &npvneg, &istop );

    return true;
};

FieldOnNodesDoublePtr LinearSolverInstance::solveDoubleLinearSystem(
            const AssemblyMatrixDoublePtr& currentMatrix,
            const FieldOnNodesDoublePtr& currentRHS ) const
{
    std::string newName( getNewResultObjectName() );
    newName.resize( 19, ' ' );
    FieldOnNodesDoublePtr returnField( new FieldOnNodesDoubleInstance( newName ) );

    // Definition du bout de fichier de commande correspondant a RESOUDRE
    CommandSyntaxCython cmdSt( "RESOUDRE" );
    cmdSt.setResult( newName, "CHAM_NO" );

    SyntaxMapContainer dict;
    // Definition du mot cle simple MATR
    dict.container[ "MATR" ] = currentMatrix->getName();
    dict.container[ "CHAM_NO" ] = currentRHS->getName();
    dict.container[ "NMAX_ITER" ] = 0;
    dict.container[ "ALGORITHME" ] = "GMRES";
    dict.container[ "RESI_RELA" ] = 1e-6;
    dict.container[ "POSTTRAITEMENTS" ] = "AUTO";
    cmdSt.define( dict );

    try
    {
        ASTERINTEGER op = 15;
        CALL_EXECOP( &op );
    }
    catch( ... )
    {
        throw;
    }

    return returnField;
};

FieldOnNodesDoublePtr LinearSolverInstance::solveDoubleLinearSystem(
            const AssemblyMatrixDoublePtr& currentMatrix,
            const FieldOnNodesDoublePtr& kinematicsField,
            const FieldOnNodesDoublePtr& currentRHS,
            FieldOnNodesDoublePtr result ) const
{
    if ( result->getName() == "" )
        result = FieldOnNodesDoublePtr( new FieldOnNodesDoubleInstance( Permanent ) );

    std::string blanc( " " );
    long nsecm = 0, prepos = 1, istop = 0, iret = 0;
    std::string base( JeveuxMemoryTypesNames[ result->getMemoryType() ] );

    CALL_RESOUD_WRAP( currentMatrix->getName().c_str(), blanc.c_str(), getName().c_str(),
                      kinematicsField->getName().c_str(), &nsecm, currentRHS->getName().c_str(),
                      result->getName().c_str(), base.c_str(), blanc.c_str(),
                      &prepos, &istop, &iret );

    return result;
};
