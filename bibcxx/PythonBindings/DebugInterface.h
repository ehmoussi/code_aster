#ifndef DEBUGINTERFACE_H_
#define DEBUGINTERFACE_H_

/**
 * @file DebugInterface.h
 * @brief Debugging utilities
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

#include "astercxx.h"
#include <boost/python.hpp>

namespace py = boost::python;

template< typename T >
static long libaster_debugRefCount( T &ptr ) {
    long value = ptr.use_count();
#ifdef _DEBUG_CXX
    std::cout << "DEBUG: use_count=" << value
        << " addr=" << std::ios::hex << ptr.get()
        << std::endl;
#endif
    return value;
}

void exportDebugToPython();

#endif /* DEBUGINTERFACE_H_ */
