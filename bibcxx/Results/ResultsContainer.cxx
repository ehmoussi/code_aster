/**
 * @file ResultsContainer.cxx
 * @brief Implementation de ResultsContainer
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

/* person_in_charge: nicolas.sellenet at edf.fr */

#include "aster_fort.h"

#include "Results/ResultsContainer.h"
#include "RunManager/LogicalUnitManagerCython.h"
#include "RunManager/CommandSyntaxCython.h"

bool ResultsContainerInstance::allocate( int nbRanks ) throw ( std::runtime_error )
{
    std::string base( JeveuxMemoryTypesNames[ getMemoryType() ] );
    long nbordr = nbRanks;
    CALL_RSCRSD( base.c_str(), getName().c_str(), getType().c_str(), &nbordr );
    return true;
};

DOFNumberingPtr ResultsContainerInstance::getEmptyDOFNumbering()
{
    std::string resuName( getName() );
    std::string name( "12345678.00000" );
    long a = 10, b = 14;
    CALL_GNOMSD( resuName.c_str(), name.c_str(), &a, &b );
    DOFNumberingPtr retour( new DOFNumberingInstance( name ) );
    _listOfDOFNum.push_back( retour );
    return retour;
};

FieldOnNodesDoublePtr ResultsContainerInstance::getEmptyFieldOnNodesDouble( const std::string name,
                                                                            const int rank )
{
    INTEGER retour;
    retour = 0;
    const INTEGER rankLong = rank;
    std::string returnName( 19, ' ' );
    CALL_RSEXCH( " ", getName().c_str(), name.c_str(), &rankLong, returnName.c_str(), &retour );
    CALL_RSNOCH( getName().c_str(), name.c_str(), &rankLong );
    std::string bis( returnName.c_str(), 19 );
    FieldOnNodesDoublePtr result( new FieldOnNodesDoubleInstance( bis ) );
    _listOfFields.push_back( result );
    return result;
};

FieldOnNodesDoublePtr ResultsContainerInstance::getRealFieldOnNodes( const std::string name,
                                                                     const int rank ) const
{
    INTEGER retour;
    retour = 0;
    const INTEGER rankLong = rank;
    std::string returnName( 19, ' ' );
    CALL_RSEXCH( " ", getName().c_str(), name.c_str(), &rankLong, returnName.c_str(), &retour );
    std::string bis( returnName.c_str(), 19 );
    FieldOnNodesDoublePtr result( new FieldOnNodesDoubleInstance( bis ) );
    return result;
};

bool ResultsContainerInstance::printMedFile( const std::string fileName ) const
    throw ( std::runtime_error )
{
    LogicalUnitFileCython a( fileName, Binary, New );
    int retour = a.getLogicalUnit();
    CommandSyntaxCython cmdSt( "IMPR_RESU" );

    SyntaxMapContainer dict;
    dict.container[ "FORMAT" ] = "MED";
    dict.container[ "UNITE" ] = retour;

    ListSyntaxMapContainer listeResu;
    SyntaxMapContainer dict2;
    dict2.container[ "RESULTAT" ] = getName();
    dict2.container[ "TOUT_ORDRE" ] = "OUI";
    listeResu.push_back( dict2 );
    dict.container[ "RESU" ] = listeResu;

    cmdSt.define( dict );

    try
    {
        INTEGER op = 39;
        CALL_EXECOP( &op );
    }
    catch( ... )
    {
        throw;
    }
    
    return true;
};
