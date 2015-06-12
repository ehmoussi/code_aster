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

#include "Discretization/DOFNumbering.h"
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
            _isEmpty( true )
{};

bool DOFNumberingInstance::computeNumerotation() throw ( std::runtime_error )
{
    if ( _supportModel )
    {
        if ( _supportModel->isEmpty() )
            throw std::runtime_error( "Support Model is empty" );

        if ( ! _linearSolver )
            throw std::runtime_error( "Linear solver is undefined" );

        const ListMecaLoad& mecaList = _listOfLoads->getListOfMechanicalLoads();
        const ListKineLoad& kineList = _listOfLoads->getListOfKinematicsLoads();
        long nbLoad = mecaList.size() + kineList.size();
        std::string nameOfLisCha( "&&DNICN.Charge     " );
        // Attention pour la creation des charges ce n'est pas sis simple (cf. nmdoch)
        JeveuxVectorChar24 tmp( nameOfLisCha + ".LCHA" );
        tmp->allocate( Temporary, nbLoad );

        int compteur = 0;
        for ( ListMecaLoadCIter curIter = mecaList.begin();
            curIter != mecaList.end();
            ++curIter )
        {
            ( *tmp )[compteur] = JeveuxChar24( ( *curIter )->getName().c_str(), 8 );
            ++compteur;
        };
        for ( ListKineLoadCIter curIter = kineList.begin();
            curIter != kineList.end();
            ++curIter )
        {
            ( *tmp )[compteur] = JeveuxChar24( ( *curIter )->getName().c_str(), 8 );
            ++compteur;
        };
        CALL_NUMERO_WRAP( getName().c_str(), _linearSolver->getName().c_str(), "VG", " ",
                          " ", _supportModel->getName().c_str(), nameOfLisCha.c_str() );
    }
    else if ( ! _supportMatrix.use_count() == 0 )
    {
        CommandSyntaxCython cmdSt( "NUME_DDL" );
        cmdSt.setResult( getResultObjectName(), getType() );

        SyntaxMapContainer dict;
        if ( _supportMatrix->isEmpty() )
            throw std::runtime_error( "Support ElementaryMatrix is empty" );

        dict.container[ "MATR_RIGI" ] = _supportMatrix->getName();
        dict.container[ "METHODE" ] = _linearSolver->getSolverName();
        dict.container[ "RENUM" ] = _linearSolver->getRenumburingName();

        cmdSt.define( dict );

        // Maintenant que le fichier de commande est pret, on appelle OP0011
        INTEGER op = 11;
        CALL_EXECOP( &op );
        _isEmpty = false;
    }
    else
        throw std::runtime_error( "No support matrix or support model defined" );

    return true;
};
