/**
 * @file ListOfLoads.cxx
 * @brief Implementation de ListOfLoads
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
#include <typeinfo>
#include "astercxx.h"

#include "Loads/ListOfLoads.h"
#include "RunManager/CommandSyntaxCython.h"

ListOfLoadsInstance::ListOfLoadsInstance( const JeveuxMemory memType ):
                    DataStructure( "L_CHARGES", memType ),
                    _loadInformations( JeveuxVectorLong( getName() + "           .INFC" ) ),
                    _list( JeveuxVectorChar24( getName() + "           .LCHA" ) ),
                    _listOfFunctions( JeveuxVectorChar24( getName() + "           .FCHA" ) ),
                    _isEmpty( true )
{};

bool ListOfLoadsInstance::build() throw ( std::runtime_error )
{
    if ( ! _isEmpty )
        return true;
//     ResultsContainerPtr resultC( new ResultsContainerInstance ( std::string( "EVOL_ELAS" ) ) );
    CommandSyntaxCython cmdSt( "MECA_STATIQUE" );
//     cmdSt.setResult( resultC->getName(), resultC->getType() );
    SyntaxMapContainer dict;
    ListSyntaxMapContainer listeExcit;
    for ( ListMecaLoadCIter curIter = _listOfMechanicalLoads.begin();
          curIter != _listOfMechanicalLoads.end();
          ++curIter )
    {
        SyntaxMapContainer dict2;
        dict2.container[ "CHARGE" ] = (*curIter)->getName();
        listeExcit.push_back( dict2 );
    }
    for ( ListKineLoadCIter curIter = _listOfKinematicsLoads.begin();
          curIter != _listOfKinematicsLoads.end();
          ++curIter )
    {
        SyntaxMapContainer dict2;
        dict2.container[ "CHARGE" ] = (*curIter)->getName();
        listeExcit.push_back( dict2 );
    }
    dict.container[ "EXCIT" ] = listeExcit;
    cmdSt.define( dict );
    long iexcit = 1;
    std::string name( getName().c_str() );
    name.resize( 19, ' ' );
    std::string blank( " " );
    blank.resize( 19, ' ' );
    CALL_NMDOCH_WRAP( name.c_str(), &iexcit, blank.c_str() );
    _isEmpty = false;
    return true;
};

/* buildListExcit : construit la liste des charges utilisées pour valoriser le mot-clé facteur EXCIT 
dans STAT_NON_LINE. C'est une méthode temporaire qui disparaîtra avec la réécriture d'op0070 */
ListSyntaxMapContainer ListOfLoadsInstance::buildListExcit() throw ( std::runtime_error )
{
    ListSyntaxMapContainer listeExcit;
    for ( ListMecaLoadCIter curIter = _listOfMechanicalLoads.begin();
          curIter != _listOfMechanicalLoads.end();
          ++curIter )
    {
        SyntaxMapContainer dict2;
        dict2.container[ "CHARGE" ] = (*curIter)->getName();
        listeExcit.push_back( dict2 );
    }
    for ( ListKineLoadCIter curIter = _listOfKinematicsLoads.begin();
          curIter != _listOfKinematicsLoads.end();
          ++curIter )
    {
        SyntaxMapContainer dict2;
        dict2.container[ "CHARGE" ] = (*curIter)->getName();
        listeExcit.push_back( dict2 );
    }
    return listeExcit;
};