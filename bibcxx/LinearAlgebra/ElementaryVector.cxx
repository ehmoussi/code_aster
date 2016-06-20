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

ElementaryVectorInstance::ElementaryVectorInstance( const JeveuxMemory memType ):
                DataStructure( "VECT_ELEM", memType ),
                _description( JeveuxVectorChar24( getName() + "           .RERR" ) ),
                _listOfElementaryResults( JeveuxVectorChar24( getName() + "           .RELR" ) ),
                _isEmpty( true ),
                _materialOnMesh( MaterialOnMeshPtr() ),
                _listOfLoads( new ListOfLoadsInstance( memType ) ),
                _corichRept( JeveuxBidirectionalMap( "&&CORICH." + getName() + ".REPT" ) )
{};

FieldOnNodesDoublePtr ElementaryVectorInstance::assembleVector( const DOFNumberingPtr& currentNumerotation,
                                                                const double& time,
                                                                const JeveuxMemory memType )
    throw ( std::runtime_error )
{
    if ( _isEmpty )
        throw std::runtime_error( "The ElementaryVector is empty" );

    if ( (! currentNumerotation ) || currentNumerotation->isEmpty() )
        throw std::runtime_error( "Numerotation is empty" );

    FieldOnNodesDoublePtr vectTmp( new FieldOnNodesDoubleInstance( Permanent ) );
    std::string name( " " );
    name.resize( 24, ' ' );

    /* Le bloc qui suit sert à appeler CORICH car ASASVE et ASCOVA attendent un objet
       qui est construit par CORICH (tableau de correspondance resuelem <-> charge) */
    // Il n'est pas nécessaire de faire le ménage c'est ASCOVA qui s'en occupe
    _listOfLoads->build();
    CommandSyntaxCython cmdSt( "ASSE_VECT_ELEM" );
    cmdSt.setResult( getName(), getType() );
    SyntaxMapContainer dict;
    dict.container[ "OPTION" ] = "CHAR_MECA";
    cmdSt.define( dict );
//     if( _listOfLoads->getListOfMechanicalLoads().size() != _matchingVector.size() )
//         throw std::runtime_error( "Programming error" );
// 
//     _listOfElementaryResults->updateValuePointer();
//     for( long i = 1; i <= _matchingVector.size(); ++i )
//     {
//         std::string detr( "E" );
//         std::string vectElem( (*_listOfElementaryResults)[i-1].c_str() );
//         vectElem.resize( 24, ' ' );
//         long in;
//         CALL_CORICH( detr.c_str(), vectElem.c_str(), &i, &in);
//     }
    /**/

    std::string typres( "R" );
    CALL_ASASVE( getName().c_str(), currentNumerotation->getName().c_str(), typres.c_str(),
                 name.c_str() );

    std::string detr( "D" );
    std::string fomult( " " );
    const JeveuxVectorChar24 lOF = _listOfLoads->getListOfFunctions();
    if ( ! lOF.isEmpty() )
        fomult = lOF->getName();
    std::string param( "INST" );

    JeveuxVectorChar24 vectTmp2( name );
    vectTmp2->updateValuePointer();
    std::string name2( (*vectTmp2)[0].toString(), 0, 19 );
    FieldOnNodesDoublePtr vectTmp3( new FieldOnNodesDoubleInstance( name2 ) );
    vectTmp->allocateFrom( *vectTmp3 );

    CALL_ASCOVA( detr.c_str(), name.c_str(), fomult.c_str(), param.c_str(), &time,
                 typres.c_str(), vectTmp->getName().c_str() );

    return vectTmp;
};

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

    const ListMechanicalLoad listOfMechanicalLoad = _listOfLoads->getListOfMechanicalLoads();
    if ( listOfMechanicalLoad.size() != 0 )
    {
        VectorString tmp;
        int i = 0;
        for ( ListMecaLoadCIter curIter = listOfMechanicalLoad.begin();
              curIter != listOfMechanicalLoad.end();
              ++curIter )
        {
            tmp.push_back( (*curIter)->getName() );
            _matchingVector.push_back(i);
            ++i;
        }
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
    std::cout << "Impression du ElementaryVector " << _listOfElementaryResults->size() << std::endl;
    _listOfElementaryResults->updateValuePointer();
//     for( int i = 0; i < _listOfElementaryResults->size(); ++i )
//     {
//         std::cout << "Occ " << i << " " << (*_listOfElementaryResults)[i] << std::endl;
//     }

    return true;
};
