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
#include "LinearAlgebra/AssemblyMatrix.h"

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

FieldOnNodesDoublePtr LinearSolverInstance::solveDoubleLinearSystem(
            const AssemblyMatrixDouble& currentMatrix,
            const FieldOnNodesDoublePtr& currentRHS ) const
{
    const std::string newName( getNewResultObjectName() );
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
        INTEGER op = 15;
        CALL_EXECOP( &op );
    }
    catch( ... )
    {
        throw;
    }

    return returnField;
};
