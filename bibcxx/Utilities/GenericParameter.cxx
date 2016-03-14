/**
 * @file GenericParameter.cxx
 * @brief Implementation de GenericParameter
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

#include "Utilities/GenericParameter.h"

SyntaxMapContainer buildSyntaxMapFromParamList( const ListGenParam& listParam ) throw ( std::runtime_error )
{
    SyntaxMapContainer dict;
    for ( ListGenParamCIter listIter = listParam.begin();
        listIter != listParam.end();
        ++listIter )
    {
        if ( ! (*listIter)->isSet() && (*listIter)->isMandatory() )
            throw std::runtime_error( "Value of parameter " + (*listIter)->getName() + " is not set but mandatory" );

        if ( (*listIter)->isSet() )
        {
            dict.container[ (*listIter)->getName() ] = (*listIter)->getValue();
        }
    }
    return dict;
};
