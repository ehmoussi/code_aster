/**
 * @file ElementaryMatrix.cxx
 * @brief Implementation de ElementaryMatrix
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

#include "LinearAlgebra/ElementaryMatrix.h"
#include "RunManager/CommandSyntaxCython.h"

ElementaryMatrixInstance::ElementaryMatrixInstance():
                DataStructure( getNewResultObjectName(), "MATR_ELEM" ),
                _description( JeveuxVectorChar24( getName() + "           .RERR" ) ),
                _listOfElementaryResults( JeveuxVectorChar24( getName() + "           .RELR" ) ),
                _isEmpty( true ),
                _supportModel( ModelPtr() ),
                _materialOnMesh( MaterialOnMeshPtr() )
{};

ElementaryMatrixInstance::ElementaryMatrixInstance( std::string type ):
                DataStructure( getNewResultObjectName(), "MATR_ELEM_" + type ),
                _description( JeveuxVectorChar24( getName() + "           .RERR" ) ),
                _listOfElementaryResults( JeveuxVectorChar24( getName() + "           .RELR" ) ),
                _isEmpty( true ),
                _supportModel( ModelPtr() ),
                _materialOnMesh( MaterialOnMeshPtr() )
{};

bool ElementaryMatrixInstance::computeMechanicalRigidity() throw ( std::runtime_error )
{
    // Comme on calcul RIGI_MECA, il faut preciser le type de la sd
    setType( getType() + "_DEPL_R" );

    // Definition du bout de fichier de commande correspondant a CALC_MATR_ELEM
    CommandSyntaxCython cmdSt( "CALC_MATR_ELEM" );
    cmdSt.setResult( getResultObjectName(), getType() );

    SyntaxMapContainer dict;
    // Definition du mot cle simple OPTION
    dict.container[ "OPTION" ] = "RIGI_MECA";

    // Definition du mot cle simple MODELE
    if ( ( ! _supportModel ) || _supportModel->isEmpty() )
        throw std::runtime_error( "Model is empty" );
    dict.container[ "MODELE" ] = _supportModel->getName();

    // Definition du mot cle simple CHAM_MATER
    if ( ! _materialOnMesh )
        throw std::runtime_error( "Material is empty" );
    dict.container[ "CHAM_MATER" ] = _materialOnMesh->getName();

    if ( _listOfMechanicalLoads.size() != 0 )
    {
        VectorString tmp;
        for ( ListMecaLoadIter curIter = _listOfMechanicalLoads.begin();
              curIter != _listOfMechanicalLoads.end();
              ++curIter )
            tmp.push_back( (*curIter)->getName() );
        dict.container[ "CHARGE" ] = tmp;
    }
    cmdSt.define( dict );
    try
    {
        INTEGER op = 9;
        CALL_EXECOP( &op );
    }
    catch( ... )
    {
        throw;
    }
    _isEmpty = false;

    return true;
};
