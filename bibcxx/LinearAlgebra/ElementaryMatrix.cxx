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

#include "astercxx.h"

#include "LinearAlgebra/ElementaryMatrix.h"
#include "RunManager/CommandSyntax.h"

ElementaryMatrixInstance::ElementaryMatrixInstance():
                DataStructure( getNewResultObjectName(), "MATR_ELEM" ),
                _description( JeveuxVectorChar24( getName() + "           .RERR" ) ),
                _listOfElementaryResults( JeveuxVectorChar24( getName() + "           .RELR" ) ),
                _isEmpty( true ),
                _supportModel( ModelPtr() ),
                _material( MaterialOnMesh( false ) )
{};

bool ElementaryMatrixInstance::computeMechanicalRigidity()
{
    // Comme on calcul RIGI_MECA, il faut preciser le type de la sd
    setType( getType() + "_DEPL_R" );

    // Definition du bout de fichier de commande correspondant a CALC_MATR_ELEM
    CommandSyntax syntaxeCalcMatrElem( "CALC_MATR_ELEM", true,
                                       getResultObjectName(), getType() );

    // Definition du mot cle simple OPTION
    SimpleKeyWordStr mCSOption = SimpleKeyWordStr( "OPTION" );
    mCSOption.addValues( "RIGI_MECA" );
    syntaxeCalcMatrElem.addSimpleKeywordString( mCSOption );

    // Definition du mot cle simple MODELE
    // ??? Ajouter des verifs pour savoir si l'interieur du modele est vide ???
    SimpleKeyWordStr mCSModele = SimpleKeyWordStr( "MODELE" );
    if ( ( ! _supportModel ) || _supportModel->isEmpty() )
        throw string("Support model is undefined");
    mCSModele.addValues( _supportModel->getName() );
    syntaxeCalcMatrElem.addSimpleKeywordString( mCSModele );

    // Definition du mot cle simple CHAM_MATER
    SimpleKeyWordStr mCSChamMater = SimpleKeyWordStr( "CHAM_MATER" );
    if ( _material.isEmpty() )
        throw string("Material is empty");
    mCSChamMater.addValues( _material->getName() );
    syntaxeCalcMatrElem.addSimpleKeywordString( mCSChamMater );

    if ( _listOfMechanicalLoads.size() != 0 )
    {
        SimpleKeyWordStr mCSCharge( "CHARGE" );
        for ( ListMecaLoadIter curIter = _listOfMechanicalLoads.begin();
              curIter != _listOfMechanicalLoads.end();
              ++curIter )
        {
            mCSCharge.addValues( (*curIter)->getName() );
        }
        syntaxeCalcMatrElem.addSimpleKeywordString( mCSCharge );
    }

    INTEGER op = 9;
    CALL_EXECOP( &op );
    _isEmpty = false;

    return true;
};
