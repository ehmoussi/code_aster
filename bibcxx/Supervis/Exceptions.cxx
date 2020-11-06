/**
 * @file Exception.h
 * @brief Definition of code_aster exceptions
 * @author Mathieu Courtois
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

/* person_in_charge: mathieu.courtois@edf.fr */

#include <assert.h>
#include <boost/python.hpp>

namespace py = boost::python;
#include <exception>
#include <string>

#include "Supervis/Exceptions.h"
#include "Utilities/Tools.h"

PyObject *AbstractErrorCpp::py_attrs() const {
    int idx = 0;
    PyObject *py_err = PyTuple_New( 4 );

    PyObject *py_id = PyUnicode_FromString( _idmess.c_str() );

    PyObject *py_valk = PyTuple_New( _valk.size() );
    idx = 0;
    for ( auto it = _valk.begin(); it != _valk.end(); ++it, ++idx )
        PyTuple_SetItem( py_valk, idx, PyUnicode_FromString( it->c_str() ) );

    PyObject *py_vali = PyTuple_New( _vali.size() );
    idx = 0;
    for ( auto it = _vali.begin(); it != _vali.end(); ++it, ++idx )
        PyTuple_SetItem( py_vali, idx, PyLong_FromLong( *it ) );

    PyObject *py_valr = PyTuple_New( _valr.size() );
    idx = 0;
    for ( auto it = _valr.begin(); it != _valr.end(); ++it, ++idx )
        PyTuple_SetItem( py_valr, idx, PyFloat_FromDouble( *it ) );

    PyTuple_SetItem( py_err, 0, py_id );
    PyTuple_SetItem( py_err, 1, py_valk );
    PyTuple_SetItem( py_err, 2, py_vali );
    PyTuple_SetItem( py_err, 3, py_valr );

    return py_err;
}

PyObject *createPyException( const char *name, PyObject *baseTypeObj ) {
    namespace py = boost::python;

    std::string scopeName = py::extract< std::string >( py::scope().attr( "__name__" ) );
    std::string qualifiedName0 = scopeName + "." + name;
    char *qualifiedName1 = const_cast< char * >( qualifiedName0.c_str() );

    PyObject *typeObj = PyErr_NewException( qualifiedName1, baseTypeObj, NULL );
    if ( !typeObj ) {
        py::throw_error_already_set();
    }

    py::scope().attr( name ) = py::handle<>( py::borrowed( typeObj ) );
    return typeObj;
}

void raiseAsterError( const std::string idmess ) {
    std::cout << "Raising C++ AsterErrorCpp with id '" << idmess << "'..." << std::endl;
    throw AsterErrorCpp( idmess );
}

extern "C" void DEFPSPSPPPP( UEXCEP, uexcep, _IN ASTERINTEGER *exc_id, _IN char *idmess,
                             _IN STRING_SIZE lidmess, _IN ASTERINTEGER *nbk, _IN char *valk,
                             _IN STRING_SIZE lvk, _IN ASTERINTEGER *nbi, _IN ASTERINTEGER *vali,
                             _IN ASTERINTEGER *nbr, _IN ASTERDOUBLE *valr ) {
    VectorString argk = {};
    VectorLong argi = {};
    VectorReal argr = {};
    for ( int i = 0; i < *nbk; ++i ) {
        argk.push_back( trim( std::string( valk + i*lvk, lvk ) ) );
    }
    for ( int i = 0; i < *nbi; ++i ) {
        argi.push_back( vali[i] );
    }
    for ( int i = 0; i < *nbr; ++i ) {
        argr.push_back( valr[i] );
    }

    // The identifier of each Python exception is defined in 'LibAster.cxx'
    std::string idm( trim( std::string( idmess, lidmess ) ) );

    switch ( *exc_id ) {
    case CONVERGENCE_ERROR:
        throw ErrorCpp< CONVERGENCE_ERROR >( idm, argk, argi, argr );

    case INTEGRATION_ERROR:
        throw ErrorCpp< INTEGRATION_ERROR >( idm, argk, argi, argr );

    case SOLVER_ERROR:
        throw ErrorCpp< SOLVER_ERROR >( idm, argk, argi, argr );

    case CONTACT_ERROR:
        throw ErrorCpp< CONTACT_ERROR >( idm, argk, argi, argr );

    case TIMELIMIT_ERROR:
        throw ErrorCpp< TIMELIMIT_ERROR >( idm, argk, argi, argr );

    default:
        throw AsterErrorCpp( idm, argk, argi, argr );
    }
}

// TODO for aster_exceptions, to be removed in the future
extern "C" void _raiseException() { raiseAsterError(); }
