/**
 * @file DOFNumbering.cxx
 * @brief Implementation de DOFNumbering
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
 *   This file is part of code_aster.
 *
 *   code_aster is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   code_aster is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 */

#include <stdexcept>
#include "astercxx.h"

#include "Discretization/DOFNumbering.h"
#include "Supervis/CommandSyntax.h"
#include "Supervis/ResultNaming.h"

BaseDOFNumberingInstance::BaseDOFNumberingInstance( const std::string& type,
                                                    const JeveuxMemory memType ):
            DataStructure( ResultNaming::getNewResultName(), type, memType ),
            _nameOfSolverDataStructure( JeveuxVectorChar24( getName() + "      .NSLV" ) ),
            _globalNumbering( new GlobalEquationNumberingInstance( getName() + "      .NUME" ) ),
            _localNumbering( new LocalEquationNumberingInstance( getName() + "      .NUML" ) ),
            _supportModel( ModelPtr() ),
            _listOfLoads( new ListOfLoadsInstance() ),
            _isEmpty( true )
{};

BaseDOFNumberingInstance::BaseDOFNumberingInstance( const std::string name,
                                                    const std::string& type,
                                                    const JeveuxMemory memType ):
            DataStructure( name, type, memType ),
            _nameOfSolverDataStructure( JeveuxVectorChar24( getName() + ".NSLV" ) ),
            _globalNumbering( new GlobalEquationNumberingInstance( getName() + ".NUME" ) ),
            _localNumbering( new LocalEquationNumberingInstance( getName() + ".NUML" ) ),
            _supportModel( ModelPtr() ),
            _listOfLoads( new ListOfLoadsInstance() ),
            _isEmpty( true )
{
    if ( name.size() != 14 )
        throw std::runtime_error( "Catastrophic error" );
};

bool BaseDOFNumberingInstance::computeNumerotation() throw ( std::runtime_error )
{
    if ( _supportModel )
    {
        if ( _supportModel->isEmpty() )
            throw std::runtime_error( "Support Model is empty" );

        _listOfLoads->build();
        JeveuxVectorChar24 jvListOfLoads = _listOfLoads->getListVector();
        jvListOfLoads->updateValuePointer();
        long nbLoad = jvListOfLoads->size();

        CALL_NUMERO_WRAP( getName().c_str(), "VG", " ", " ",
                          _supportModel->getName().c_str(), _listOfLoads->getName().c_str() );
    }
    else if ( ! _supportMatrix.use_count() == 0 )
    {
        CommandSyntax cmdSt( "NUME_DDL" );
        cmdSt.setResult( getName(), getType() );

        SyntaxMapContainer dict;
        if ( _supportMatrix->isEmpty() )
            throw std::runtime_error( "Support ElementaryMatrix is empty" );

        dict.container[ "MATR_RIGI" ] = _supportMatrix->getName();

        cmdSt.define( dict );

        // Maintenant que le fichier de commande est pret, on appelle OP0011
        ASTERINTEGER op = 11;
        CALL_EXECOP( &op );
    }
    else
        throw std::runtime_error( "No support matrix or support model defined" );
    _isEmpty = false;

    return true;
};
