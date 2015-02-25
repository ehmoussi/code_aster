/**
 * @file ElementaryVector.cxx
 * @brief Implementation de ElementaryVector
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

#include "LinearAlgebra/ElementaryVector.h"
#include "RunManager/CommandSyntaxCython.h"

ElementaryVectorInstance::ElementaryVectorInstance():
                DataStructure( getNewResultObjectName(), "VECT_ELEM" ),
                _description( JeveuxVectorChar24( getName() + "           .RERR" ) ),
                _listOfElementaryResults( JeveuxVectorChar24( getName() + "           .RELR" ) ),
                _isEmpty( true ),
                _materialOnMesh( MaterialOnMeshPtr() )
{};

FieldOnNodesDoublePtr ElementaryVectorInstance::assembleVector( const DOFNumberingPtr& currentNumerotation )
    throw ( std::runtime_error )
{
    if ( _isEmpty )
        throw std::runtime_error( "The ElementaryVector is empty" );

    if ( (! currentNumerotation ) || currentNumerotation->isEmpty() )
        throw std::runtime_error( "Numerotation is empty" );

    std::string newName( getNewResultObjectName() );
    newName.resize( 19, ' ' );
    FieldOnNodesDoublePtr vectTmp( new FieldOnNodesDoubleInstance( newName ) );

    SyntaxMapContainer dict;
    dict.container[ "VECT_ELEM" ] = this->getName();
    dict.container[ "NUME_DDL" ] = currentNumerotation->getName();

    CommandSyntaxCython cmdSt( "ASSE_VECTEUR" );
    cmdSt.setResult( newName, "CHAM_NO" );
    cmdSt.define( dict );

    try
    {
        INTEGER op = 13;
        CALL_EXECOP( &op );
    }
    catch( ... )
    {
        throw;
    }
    _isEmpty = false;

    return vectTmp;
}

bool ElementaryVectorInstance::computeMechanicalLoads() throw ( std::runtime_error )
{
    if ( ! _isEmpty )
        throw std::runtime_error( "The MechanicalLoads is already compute" );

    // Comme on calcul RIGI_MECA, il faut preciser le type de la sd
    setType( getType() + "_DEPL_R" );

    CommandSyntaxCython cmdSt( "CALC_VECT_ELEM" );
    cmdSt.setResult( getName(), getType() );

    SyntaxMapContainer dict;
    dict.container[ "OPTION" ] = "CHAR_MECA";

    if ( _materialOnMesh )
        dict.container[ "CHAM_MATER" ] = _materialOnMesh->getName();

    if ( _listOfMechanicalLoad.size() != 0 )
    {
        VectorString tmp;
        for ( ListMechanicalLoadIter curIter = _listOfMechanicalLoad.begin();
            curIter != _listOfMechanicalLoad.end();
            ++curIter )
            tmp.push_back( (*curIter)->getName() );
        dict.container[ "CHARGE" ] = tmp;
    }
    cmdSt.define( dict );

    try
    {
        INTEGER op = 8;
        CALL_EXECOP( &op );
    }
    catch( ... )
    {
        throw;
    }
    _isEmpty = false;

    return true;
};
