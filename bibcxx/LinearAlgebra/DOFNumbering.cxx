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

#include "LinearAlgebra/DOFNumbering.h"

DOFNumberingInstance::DOFNumberingInstance():
            DataStructure( initAster->getNewResultObjectName(), "NUME_DDL" ),
            _nameOfSolverDataStructure( JeveuxVectorChar24( getName() + "      .NSLV" ) ),
            _supportModel( ModelPtr() ),
            _supportMatrix( ElementaryMatrix( false ) ),
            _load( MechanicalLoad( false ) ),
            _linearSolver( LinearSolver( MultFront, Metis ) ),
            _isEmpty( true )
{};

bool DOFNumberingInstance::computeNumerotation()
{
    // Definition du bout de fichier de commande correspondant a AFFE_MODELE
    CommandSyntax syntaxeNumeDdl( "NUME_DDL", true,
                                     initAster->getResultObjectName(), getType() );

    if ( _supportModel )
    {
        if ( _supportModel->isEmpty() )
            throw "Support Model is empty";
        throw "Not yet implemented";
    }
    else if ( ! _supportMatrix.isEmpty() )
    {
        if ( _supportMatrix->isEmpty() )
            throw "Support ElementaryMatrix is empty";

        SimpleKeyWordStr mCSMatrRigi = SimpleKeyWordStr( "MATR_RIGI" );
        mCSMatrRigi.addValues( _supportMatrix->getName() );
        syntaxeNumeDdl.addSimpleKeywordString(mCSMatrRigi);

        SimpleKeyWordStr mCSSolveur = SimpleKeyWordStr( "METHODE" );
        mCSSolveur.addValues( _linearSolver->getSolverName() );
        syntaxeNumeDdl.addSimpleKeywordString(mCSSolveur);

        SimpleKeyWordStr mCSRenum = SimpleKeyWordStr( "RENUM" );
        mCSRenum.addValues( _linearSolver->getRenumburingName() );
        syntaxeNumeDdl.addSimpleKeywordString(mCSRenum);
    }
    else
        throw "No support matrix and support model defined";

    // Maintenant que le fichier de commande est pret, on appelle OP0018
    CALL_EXECOP( 11 );
    _isEmpty = false;

    return true;
};
