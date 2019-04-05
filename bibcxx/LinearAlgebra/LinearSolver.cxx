/**
 * @file LinearSolver.cxx
 * @brief Initialisation des renumeroteurs autorises pour les solvers
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2019  EDF R&D                www.code-aster.org
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
#include "Supervis/CommandSyntax.h"
#include "Supervis/ResultNaming.h"

const std::set< Renumbering > WrapMultFront::setOfAllowedRenumbering( MultFrontRenumbering,
                                                                      MultFrontRenumbering +
                                                                          nbRenumberingMultFront );

const std::set< Renumbering >
    WrapLdlt::setOfAllowedRenumbering( LdltRenumbering, LdltRenumbering + nbRenumberingLdlt );

const std::set< Renumbering >
    WrapMumps::setOfAllowedRenumbering( MumpsRenumbering, MumpsRenumbering + nbRenumberingMumps );

const std::set< Renumbering >
    WrapPetsc::setOfAllowedRenumbering( PetscRenumbering, PetscRenumbering + nbRenumberingPetsc );

const std::set< Renumbering >
    WrapGcpc::setOfAllowedRenumbering( GcpcRenumbering, GcpcRenumbering + nbRenumberingGcpc );

ListSyntaxMapContainer BaseLinearSolverInstance::buildListSyntax() {
    ListSyntaxMapContainer listeSolver;
    SyntaxMapContainer dict1 = buildSyntaxMapFromParamList( _listOfParameters );
    listeSolver.push_back( dict1 );
    return listeSolver;
};

bool BaseLinearSolverInstance::build() {
    if ( _charValues->exists() ) {
        _charValues->deallocate();
        _doubleValues->deallocate();
        _integerValues->deallocate();
    }
    std::string newName( getName() );
    newName.resize( 19, ' ' );

    // Definition du bout de fichier de commande pour SOLVEUR
    CommandSyntax cmdSt( _commandName );
    cmdSt.setResult( getName(), getType() );

    SyntaxMapContainer dict;
    ListSyntaxMapContainer listeSolver = this->buildListSyntax();

    dict.container["SOLVEUR"] = listeSolver;
    cmdSt.define( dict );

    std::string base( "G" );
    std::string xfem( "   " );
    if( _xfem ) xfem = "OUI";
    CALLO_CRESOL_WRAP( newName, base, xfem );
    _isEmpty = false;

    return true;
};

bool BaseLinearSolverInstance::matrixFactorization(
    AssemblyMatrixDisplacementDoublePtr currentMatrix ) {
    if ( _isEmpty )
        build();

    const std::string solverName( getName() + "           " );
    std::string base( "V" );
    if ( currentMatrix->getMemoryType() == Permanent )
        base = std::string( "G" );
    ASTERINTEGER cret = 0, npvneg = 0, istop = -9999;
    const std::string matpre( _matrixPrec->getName() );
    const std::string matass = currentMatrix->getName();

    // AMUMPT appel getres
    CommandSyntax cmdSt( "AUTRE" );
    cmdSt.setResult( "AUCUN", "AUCUN" );

    CALLO_MATRIX_FACTOR( solverName, base, &cret, _matrixPrec->getName(), matass, &npvneg, &istop );
    currentMatrix->_isFactorized = true;

    auto solverType = std::string( LinearSolverNames[_linearSolver] );
    currentMatrix->setSolverName( solverType );

    return true;
};

FieldOnNodesDoublePtr BaseLinearSolverInstance::solveDoubleLinearSystem(
    const AssemblyMatrixDisplacementDoublePtr &currentMatrix,
    const FieldOnNodesDoublePtr &currentRHS, FieldOnNodesDoublePtr result ) const {
    if ( result->getName() == "" )
        result = FieldOnNodesDoublePtr( new FieldOnNodesDoubleInstance( Permanent ) );

    std::string blanc( " " );
    ASTERINTEGER nsecm = 0, prepos = 1, istop = 0, iret = 0;
    std::string base( JeveuxMemoryTypesNames[result->getMemoryType()] );

    CALLO_RESOUD_WRAP( currentMatrix->getName(), _matrixPrec->getName(), getName(), blanc, &nsecm,
                       currentRHS->getName(), result->getName(), base, blanc, &prepos, &istop,
                       &iret );

    auto solverType = std::string( LinearSolverNames[_linearSolver] );
    currentMatrix->setSolverName( solverType );

    return result;
};

FieldOnNodesDoublePtr BaseLinearSolverInstance::solveDoubleLinearSystemWithKinematicsLoad(
    const AssemblyMatrixDisplacementDoublePtr &currentMatrix,
    const FieldOnNodesDoublePtr &kinematicsField, const FieldOnNodesDoublePtr &currentRHS,
    FieldOnNodesDoublePtr result ) const {
    if ( result->getName() == "" )
        result = FieldOnNodesDoublePtr( new FieldOnNodesDoubleInstance( Permanent ) );

    std::string blanc( " " );
    ASTERINTEGER nsecm = 0, prepos = 1, istop = 0, iret = 0;
    std::string base( JeveuxMemoryTypesNames[result->getMemoryType()] );

    CALLO_RESOUD_WRAP( currentMatrix->getName(), _matrixPrec->getName(), getName(),
                       kinematicsField->getName(), &nsecm, currentRHS->getName(), result->getName(),
                       base, blanc, &prepos, &istop, &iret );

    auto solverType = std::string( LinearSolverNames[_linearSolver] );
    currentMatrix->setSolverName( solverType );

    return result;
};
