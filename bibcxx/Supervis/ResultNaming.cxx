/**
 * @file ResultNaming.cxx
 * @brief Implementation of automatic naming of jeveux objects.
 * @section LICENCE
 * Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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

#include <sstream>
#include <iomanip>

#include "ResultNaming.h"

long ResultNaming::numberOfObjects = 0;

void ResultNaming::initCounter( const long initValue ) {
    // do not decrease value to avoid conflicts
    if ( initValue >= numberOfObjects ) {
        numberOfObjects = initValue;
    }
}

std::string ResultNaming::getCurrentName() {
    std::stringstream sstream;
    sstream << std::setfill( '0' ) << std::setw( 8 ) << std::hex << ResultNaming::numberOfObjects;
    return sstream.str();
}

std::string ResultNaming::getNewResultName() {
    numberOfObjects += 1;
    return getCurrentName();
}
