/**
 * @file Exception.h
 * @brief Definition of code_aster exceptions
 * @author Mathieu Courtois
 * @section LICENCE
 *   Copyright (C) 1991 - 2018  EDF R&D                www.code-aster.org
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

/* person_in_charge: mathieu.courtois@edf.fr */

#include <assert.h>
#include <boost/python.hpp>
#include <exception>
#include <string>

#include "Supervis/Exception.h"

PyObject *createExceptionClass( const char *name, PyObject *baseTypeObj ) {
    namespace py = boost::python;

    std::string scopeName = py::extract< std::string >( py::scope().attr( "__name__" ) );
    std::string qualifiedName0 = scopeName + "." + name;
    char *qualifiedName1 = const_cast< char * >( qualifiedName0.c_str() );

    PyObject *typeObj = PyErr_NewException( qualifiedName1, baseTypeObj, 0 );
    if ( !typeObj ) {
        py::throw_error_already_set();
    }

    py::scope().attr( name ) = py::handle<>( py::borrowed( typeObj ) );
    return typeObj;
}

void raiseAsterException( const std::string message ) throw( AsterException ) {
    std::cout << "Raising C++ AsterException..." << std::endl;
    throw AsterException( message );
}
