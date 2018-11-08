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

#include <exception>
#include <string>

#include "astercxx.h"

class AsterException : public std::exception {
  private:
    std::string _message;
    std::string _extraData;

  public:
    AsterException( std::string message, std::string extraData = "" )
        : _message( message ), _extraData( extraData ) {}

    const char *what() const throw() { return _message.c_str(); }

    ~AsterException() throw() {}

    std::string getMessage() { return _message; }

    std::string getExtraData() { return _extraData; }
};

PyObject *createExceptionClass( const char *name, PyObject *baseTypeObj = PyExc_Exception );

void raiseAsterException( const std::string message = "" ) throw( AsterException );

#endif
