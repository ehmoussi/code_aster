/**
 * @file Tools.cxx
 * @brief Implementation des outils
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

#include "aster_utils.h"
#include "Utilities/Tools.h"

std::string trim( const std::string &str, const std::string &whitespace ) {
    const int strBegin = str.find_first_not_of( whitespace );
    if ( strBegin == std::string::npos )
        return ""; // no content

    const int strEnd = str.find_last_not_of( whitespace );
    const int strRange = strEnd - strBegin + 1;

    return str.substr( strBegin, strRange );
};

char *vectorStringAsFStrArray( const VectorString &vector, const int size ) {
    char *tabFStr = MakeTabFStr( vector.size(), size );
    VectorString::const_iterator vecIt = vector.begin();
    int i = 0;
    for ( ; vecIt != vector.end(); ++vecIt ) {
        SetTabFStr( tabFStr, i, (char *)vecIt->c_str(), size );
        ++i;
    }
    return tabFStr;
}
