/**
 * @file DOFNumbering.cxx
 * @brief Implementation de DOFNumbering
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

#include <stdexcept>
#include "astercxx.h"

#include "LinearAlgebra/DOFNumbering.h"
#include "RunManager/CommandSyntaxCython.h"

DOFNumberingInstance::DOFNumberingInstance():
            DataStructure( getNewResultObjectName(), "NUME_DDL" ),
            _nameOfSolverDataStructure( JeveuxVectorChar24( getName() + "      .NSLV" ) ),
            _supportModel( ModelPtr() ),
            _linearSolver( new LinearSolverInstance( MultFront, Metis ) ),
            _isEmpty( true )
{};

DOFNumberingInstance::DOFNumberingInstance( const std::string name ):
            DataStructure( name, "NUME_DDL" ),
            _nameOfSolverDataStructure( JeveuxVectorChar24( getName() + "      .NSLV" ) ),
            _supportModel( ModelPtr() ),
            _linearSolver( new LinearSolverInstance( MultFront, Metis ) ),
            _isEmpty( true )
{};

bool DOFNumberingInstance::computeNumerotation() throw ( std::runtime_error )
{
    CommandSyntaxCython cmdSt( "NUME_DDL" );
    cmdSt.setResult( getResultObjectName(), getType() );

    SyntaxMapContainer dict;
    if ( _supportModel )
    {
        if ( _supportModel->isEmpty() )
            throw std::runtime_error( "Support Model is empty" );
        throw std::runtime_error( "Not yet implemented" );
    }
    else if ( ! _supportMatrix.use_count() == 0 )
    {
        if ( _supportMatrix->isEmpty() )
            throw std::runtime_error( "Support ElementaryMatrix is empty" );

        dict.container[ "MATR_RIGI" ] = _supportMatrix->getName();
        dict.container[ "METHODE" ] = _linearSolver->getSolverName();
        dict.container[ "RENUM" ] = _linearSolver->getRenumburingName();
    }
    else
        throw std::runtime_error( "No support matrix and support model defined" );

    cmdSt.define( dict );

    // Maintenant que le fichier de commande est pret, on appelle OP0011
    INTEGER op = 11;
    CALL_EXECOP( &op );
    _isEmpty = false;

    return true;
};
