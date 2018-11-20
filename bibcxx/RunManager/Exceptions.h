#ifndef EXCEPTION_H_
#define EXCEPTION_H_

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

#ifdef __cplusplus

#include <exception>
#include <string>

#include "astercxx.h"

// static table of Python exceptions
static std::map< int, PyObject * > ErrorPy;

class AbstractErrorCpp : public std::exception {
  private:
    std::string _idmess;
    VectorString _valk;
    VectorLong _vali;
    VectorDouble _valr;

  public:
    AbstractErrorCpp( std::string idmess, VectorString valk = {}, VectorLong vali = {},
                   VectorDouble valr = {} )
        : _idmess( idmess ), _valk( valk ), _vali( vali ), _valr( valr ) {}

    const char *what() const noexcept { return _idmess.c_str(); }

    virtual ~AbstractErrorCpp() noexcept {}

    /* Build arguments for the Python exception */
    PyObject *py_attrs() const;
};

// Subclasses
template < int Id > class ErrorCpp : public AbstractErrorCpp {
  private:
    int _id = Id;

  public:
    ErrorCpp< Id >( std::string idmess, VectorString valk = {}, VectorLong vali = {},
                    VectorDouble valr = {} )
        : AbstractErrorCpp( idmess, valk, vali, valr ) {}
};

typedef ErrorCpp< 21 > AsterErrorCpp;

// Translation functions: C++ exception to Python exception
template < int Id >
void translateError( const ErrorCpp< Id > &exc ) {
    assert( ErrorPy[Id] != NULL );

    PyObject *py_err = exc.py_attrs();
    PyErr_SetObject( ErrorPy[Id], py_err );
    Py_DECREF( py_err );
}


PyObject *createPyException( const char *name, PyObject *baseTypeObj = PyExc_Exception );

void raiseAsterError( const std::string idmess = "VIDE_1" );

extern "C" void DEFPSPSPPPP( UEXCEP, uexcep, _IN ASTERINTEGER *exc_id, _IN char *idmess,
                             _IN STRING_SIZE lidmess, _IN ASTERINTEGER *nbk, _IN char *valk,
                             _IN STRING_SIZE lvk, _IN ASTERINTEGER *nbi, _IN ASTERINTEGER *vali,
                             _IN ASTERINTEGER *nbr, _IN ASTERDOUBLE *valr );

extern "C" {
#endif // __cplusplus
void _raiseException();

#ifdef __cplusplus
}
#endif

#endif
