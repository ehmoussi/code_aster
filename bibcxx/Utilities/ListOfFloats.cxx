/**
 * @file ListOfFloats.cxx
 * @brief Implementation de ListOfFloats
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2020  EDF R&D                www.code-aster.org
 *
 *   This file is part of Code_Aster.
 *
 *   Code_Aster is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 3 of the License, or
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

#include "Utilities/ListOfFloats.h"

VectorDouble ListOfFloatsClass::getValues() const {
    if ( !_vale->exists() )
        throw std::runtime_error( "No list of values in ListOfFloats" );

    _vale->updateValuePointer();
    VectorDouble toReturn;
    auto size = _vale->size();
    for ( int pos = 0; pos < size; ++pos )
        toReturn.push_back( ( *_vale )[pos] );
    return toReturn;
};

void ListOfFloatsClass::setVectorValues( const VectorDouble &vec ) {
    ( *_vale ) = vec;
};

int ListOfFloatsClass::size() {
    _vale->updateValuePointer();
    return _vale->size();
};
