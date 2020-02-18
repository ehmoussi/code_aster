/**
 * @file ResultNaming.cxx
 * @brief Implementation of automatic naming of jeveux objects.
 * @section LICENCE
 * Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
 * This file is part of code_aster.
 *
 * code_aster is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * code_aster is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with code_aster.  If not, see <http://www.gnu.org/licenses/>.

 * person_in_charge: mathieu.courtois@edf.fr
 */

#include <stdexcept>
#include <string>
#include <vector>

#include "Functions/GenericFunction.h"
#include "Supervis/ResultNaming.h"
#include "astercxx.h"


void GenericFunctionClass::setExtrapolation( const std::string type ) {
    if ( !_property->isAllocated() )
        propertyAllocate();

    if ( type.length() != 2 )
        throw std::runtime_error( "Function: interpolation must be 2 characters long." );

    std::string auth( "CELI" );
    if ( auth.find( type[0] ) == std::string::npos )
        throw std::runtime_error( "Function: invalid extrapolation for abscissa." );

    if ( auth.find( type[1] ) == std::string::npos )
        throw std::runtime_error( "Function: invalid extrapolation for ordinates." );

    ( *_property )[4] = type.c_str();
}
