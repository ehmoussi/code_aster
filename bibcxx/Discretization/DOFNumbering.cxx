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

BaseDOFNumberingInstance::BaseDOFNumberingInstance( const std::string& type,
                                                    const JeveuxMemory memType ):
            DataStructure( getNewResultObjectName(), type, memType ),
            _nameOfSolverDataStructure( JeveuxVectorChar24( getName() + "      .NSLV" ) ),
            _supportModel( ModelPtr() ),
            _listOfLoads( new ListOfLoadsInstance() ),
            _isEmpty( true )
{};

BaseDOFNumberingInstance::BaseDOFNumberingInstance( const std::string name,
                                                    const std::string& type,
                                                    const JeveuxMemory memType ):
            DataStructure( name, type, memType ),
            _nameOfSolverDataStructure( JeveuxVectorChar24( getName() + ".NSLV" ) ),
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
        CommandSyntaxCython cmdSt( "NUME_DDL" );
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

FieldOnNodesDoublePtr BaseDOFNumberingInstance::getEmptyFieldOnNodesDouble( const JeveuxMemory memType ) const
    throw ( std::runtime_error )
{
    FieldOnNodesDoublePtr retour( new FieldOnNodesDoubleInstance( memType ) );

    std::string base( JeveuxMemoryTypesNames[ retour->getMemoryType() ] );
    std::string type( "R" );
    CALL_VTCREB_WRAP( retour->getName().c_str(), base.c_str(), type.c_str(),
                      getName().c_str() );

    return retour;
};
