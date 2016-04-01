/**
 * @file TimeStepManager.cxx
 * @brief Implementation de TimeStepManager
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2016  EDF R&D                www.code-aster.org
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

#include "Studies/TimeStepManager.h"
#include "RunManager/CommandSyntaxCython.h"

/* person_in_charge: nicolas.sellenet at edf.fr */

void TimeStepManagerInstance::build() throw ( std::runtime_error )
{
    CommandSyntaxCython cmdSt( "DEFI_LIST_INST" );
    cmdSt.setResult( getResultObjectName(), "LIST_INST" );

    SyntaxMapContainer dict;

    ListSyntaxMapContainer listeDEFI;
    SyntaxMapContainer dictDEFI;
    if ( _timeListVector.size() != 0 )
        dictDEFI.container["VALE"] = _timeListVector;
    else
        throw std::runtime_error( "Time list undefined" );

    if ( _isAutomatic )
    {
        dictDEFI.container["METHODE"] = "AUTO";
        if ( _minimumTS.isSet() )
            dictDEFI.container[ _minimumTS.getName() ] = _minimumTS.getValue();
        if ( _maximumTS.isSet() )
            dictDEFI.container[ _maximumTS.getName() ] = _maximumTS.getValue();
        dictDEFI.container["NB_PAS_MAXI"] = _nbMaxiOfTS;
    }
    else
    {
        dictDEFI.container["METHODE"] = "MANUEL";
    }
    listeDEFI.push_back( dictDEFI );
    dict.container["DEFI_LIST"] = listeDEFI;

    if ( _listErrorManager.size() != 0 )
    {
        ListSyntaxMapContainer listeECHEC;
        for ( ListConvErrorCIter curIter = _listErrorManager.begin();
              curIter != _listErrorManager.end();
              ++curIter )
        {
            GenericActionInstance& curAction = *( (*curIter)->getAction() );

            const ListGenParam& listParam = curAction.getListOfParameters();
            SyntaxMapContainer dict2 = buildSyntaxMapFromParamList( listParam );

            const ListGenParam& listParam2 = (*curIter)->getListOfParameters();
            SyntaxMapContainer dict3 = buildSyntaxMapFromParamList( listParam2 );

            listeECHEC.push_back( dict2 + dict3 );
        }
        dict.container["ECHEC"] = listeECHEC;
    }
    cmdSt.define( dict );

    try
    {
        INTEGER op = 28;
        CALL_EXECOP( &op );
    }
    catch( ... )
    {
        throw;
    }
    _isEmpty = false;
};
