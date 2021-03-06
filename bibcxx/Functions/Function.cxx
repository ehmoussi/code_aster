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

#include "Functions/Function.h"
#include "Supervis/ResultNaming.h"
#include "astercxx.h"

FunctionPtr emptyRealFunction( new FunctionClass( "" ) );

BaseFunctionClass::BaseFunctionClass( const std::string name, const std::string type,
                                      const std::string type2 )
    : GenericFunctionClass( name, type, type2 ),
      _value( JeveuxVectorReal( getName() + ".VALE" ) ) {}

BaseFunctionClass::BaseFunctionClass( const std::string type,
                                      const std::string type2 )
    : BaseFunctionClass::BaseFunctionClass( ResultNaming::getNewResultName(), type, type2 ) {}

void BaseFunctionClass::allocate( JeveuxMemory mem,
                                     ASTERINTEGER size ) {
    if ( _property->exists() )
        _property->deallocate();
    propertyAllocate();

    if ( _value->exists() )
        _value->deallocate();
    _value->allocate( mem, 2 * size );
}

void BaseFunctionClass::deallocate()
{
    _property->deallocate();
    _value->deallocate();
}

void FunctionComplexClass::allocate( JeveuxMemory mem,
                                        ASTERINTEGER size ) {
    throw std::runtime_error( "Not yet implemented!" );
}

void BaseFunctionClass::setValues( const VectorReal &absc,
                                      const VectorReal &ordo ) {
    if ( absc.size() != ordo.size() )
        throw std::runtime_error( "Function: length of abscissa and ordinates must be equal" );

    // Create Jeveux vector ".VALE"
    const int nbpts = absc.size();
    _value->allocate( Permanent, 2 * nbpts );

    // Loop on the points
    VectorReal::const_iterator abscIt = absc.begin();
    VectorReal::const_iterator ordoIt = ordo.begin();
    int idx = 0;
    for ( ; abscIt != absc.end(); ++abscIt, ++ordoIt ) {
        ( *_value )[idx] = *abscIt;
        ( *_value )[nbpts + idx] = *ordoIt;
        ++idx;
    }
}

void BaseFunctionClass::setInterpolation( const std::string type ) {
    std::string interp;
    if ( !_property->isAllocated() )
        propertyAllocate();

    if ( type.length() != 7 )
        throw std::runtime_error( "Function: interpolation must be 7 characters long." );

    interp = type.substr( 0, 3 );
    if ( interp != "LIN" && interp != "LOG" && interp != "NON" )
        throw std::runtime_error( "Function: invalid interpolation for abscissa." );

    interp = type.substr( 4, 3 );
    if ( interp != "LIN" && interp != "LOG" && interp != "NON" )
        throw std::runtime_error( "Function: invalid interpolation for ordinates." );

    ( *_property )[1] = type.c_str();
}

void BaseFunctionClass::setAsConstant() {
    if ( !_property->isAllocated() )
        propertyAllocate();
    _funct_type = "CONSTANT";
    ( *_property )[0] = _funct_type;
}

/* Complex function */
void FunctionComplexClass::setValues( const VectorReal &absc,
                                         const VectorReal &ordo ) {
    if ( absc.size() * 2 != ordo.size() )
        throw std::runtime_error(
            "Function: The length of ordinates must be twice that of abscissas." );

    // Create Jeveux vector ".VALE"
    const int nbpts = absc.size();
    _value->allocate( Permanent, 3 * nbpts );

    // Loop on the points
    VectorReal::const_iterator abscIt = absc.begin();
    VectorReal::const_iterator ordoIt = ordo.begin();
    int idx = 0;
    for ( ; abscIt != absc.end(); ++abscIt, ++ordoIt ) {
        ( *_value )[idx] = *abscIt;
        ( *_value )[nbpts + 2 * idx] = *ordoIt;
        ++ordoIt;
        ( *_value )[nbpts + 2 * idx + 1] = *ordoIt;
        ++idx;
    }
}

void FunctionComplexClass::setValues( const VectorReal &absc,
                                         const VectorComplex &ordo ) {
    throw std::runtime_error( "Not yet implemented!" );
}
