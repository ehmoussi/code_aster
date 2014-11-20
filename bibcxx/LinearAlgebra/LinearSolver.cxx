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

#include "LinearAlgebra/LinearSolver.h"
#include "LinearAlgebra/AssemblyMatrix.h"

const set< Renumbering > WrapMultFront::setOfAllowedRenumbering( MultFrontRenumbering,
                                                                 MultFrontRenumbering + nbRenumberingMultFront );

const set< Renumbering > WrapLdlt::setOfAllowedRenumbering( LdltRenumbering,
                                                            LdltRenumbering + nbRenumberingLdlt );

const set< Renumbering > WrapMumps::setOfAllowedRenumbering( MumpsRenumbering,
                                                             MumpsRenumbering + nbRenumberingMumps );

const set< Renumbering > WrapPetsc::setOfAllowedRenumbering( PetscRenumbering,
                                                             PetscRenumbering + nbRenumberingPetsc );

const set< Renumbering > WrapGcpc::setOfAllowedRenumbering( GcpcRenumbering,
                                                            GcpcRenumbering + nbRenumberingGcpc );

FieldOnNodesDouble LinearSolverInstance::solveDoubleLinearSystem( const AssemblyMatrixDouble& currentMatrix,
                                                                  const FieldOnNodesDouble& currentRHS ) const
{
    const string newName( initAster->getNewResultObjectName() );
    FieldOnNodesDouble returnField( newName );

    // Definition du bout de fichier de commande correspondant a RESOUDRE
    CommandSyntax syntaxeResoudre( "RESOUDRE", true, newName, "CHAM_NO" );

    // Definition du mot cle simple MATR
    SimpleKeyWordStr mCSMatr = SimpleKeyWordStr( "MATR" );
    mCSMatr.addValues( currentMatrix->getName() );
    syntaxeResoudre.addSimpleKeywordString( mCSMatr );

    SimpleKeyWordStr mCSChamNo = SimpleKeyWordStr( "CHAM_NO" );
    mCSChamNo.addValues( currentRHS->getName() );
    syntaxeResoudre.addSimpleKeywordString( mCSChamNo );

    SimpleKeyWordInt mCSMaxIter = SimpleKeyWordInt( "NMAX_ITER" );
    mCSMaxIter.addValues( 0 );
    syntaxeResoudre.addSimpleKeywordInteger( mCSMaxIter );

    SimpleKeyWordStr mCSAlgo = SimpleKeyWordStr( "ALGORITHME" );
    mCSAlgo.addValues( "GMRES" );
    syntaxeResoudre.addSimpleKeywordString( mCSAlgo );

    SimpleKeyWordDbl mCSResiRela = SimpleKeyWordDbl( "RESI_RELA" );
    mCSResiRela.addValues( 1e-6 );
    syntaxeResoudre.addSimpleKeywordDouble( mCSResiRela );

    SimpleKeyWordStr mCSPost = SimpleKeyWordStr( "POSTTRAITEMENTS" );
    mCSPost.addValues( "AUTO" );
    syntaxeResoudre.addSimpleKeywordString( mCSPost );

    CALL_EXECOP( 15 );

    return returnField;
};
