/**
 * @file AcousticsLoad.cxx
 * @brief Implementation de AcousticsLoad
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

#include "Loads/AcousticsLoad.h"
#include "RunManager/CommandSyntaxCython.h"

const char SANS_GROUP_MA[] = "SANS_GROUP_MA";
const char SANS_GROUP_NO[] = "SANS_GROUP_NO";

bool AcousticsLoadInstance::build()
{
    if ( ! _supportModel )
        throw std::runtime_error( "Support Model not set" );

    CommandSyntaxCython cmdSt( "AFFE_CHAR_ACOU" );
    cmdSt.setResult( getResultObjectName(), "CHAR_ACOU" );

    CapyConvertibleSyntax syntax;
    syntax.setSimpleKeywordValues( _toCapyConverter );

    if( _pressure.size() != 0 )
    {
        CapyConvertibleFactorKeyword zonePres( "PRES_IMPO" );
        for( const auto& curPresPtr : _pressure )
            zonePres.addContainer( curPresPtr->UnitaryAcousticsLoadInstance::getCapyConvertibleContainer() );
        syntax.addFactorKeywordValues( zonePres );
    }
    if( _speed.size() != 0 )
    {
        CapyConvertibleFactorKeyword zoneVite( "VITE_FACE" );
        for( const auto& curPresPtr : _speed )
            zoneVite.addContainer( curPresPtr->UnitaryAcousticsLoadInstance::getCapyConvertibleContainer() );
        syntax.addFactorKeywordValues( zoneVite );
    }
    if( _impedance.size() != 0 )
    {
        CapyConvertibleFactorKeyword zoneImpe( "IMPE_FACE" );
        for( const auto& curPresPtr : _impedance )
            zoneImpe.addContainer( curPresPtr->UnitaryAcousticsLoadInstance::getCapyConvertibleContainer() );
        syntax.addFactorKeywordValues( zoneImpe );
    }
    if( _connection.size() != 0 )
    {
        CapyConvertibleFactorKeyword zoneConnect( "LIAISON_UNIF" );
        for( const auto& curPresPtr : _connection )
            zoneConnect.addContainer( curPresPtr->UnitaryAcousticsLoadInstance::getCapyConvertibleContainer() );
        syntax.addFactorKeywordValues( zoneConnect );
    }

    SyntaxMapContainer test = syntax.toSyntaxMapContainer();
    cmdSt.define( test );

    // Maintenant que le fichier de commande est pret, on appelle OP0030
    try
    {
        INTEGER op = 68;
        CALL_EXECOP( &op );
    }
    catch( ... )
    {
        throw;
    }
    return true;
};
