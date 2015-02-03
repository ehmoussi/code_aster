#ifndef EXCEPTIONS_H_
#define EXCEPTIONS_H_

/**
 * @file Exceptions.h
 * @brief Fichier entete de la classe Exceptions
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2014  EDF R&D                www.code-aster.org
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

#include "Python.h"

#ifdef __cplusplus

#include <iostream>
#include <stdexcept>

#define __Pyx_CppExn2PyErr AsterCythonCustomException

/**
 * @brief Catch an exception in cython to raise a python exception
 */
void AsterCythonCustomException();

extern "C" {
#endif

/**
 * @brief Raise an C++ exception from the Fortran of Aster
 */
void _raiseException();

#ifdef __cplusplus
}
#endif

#endif
