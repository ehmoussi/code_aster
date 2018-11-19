#ifndef FORTRAN_H_
#define FORTRAN_H_

/**
 * @file Fortran.h
 * @brief Definition of interface functions between C++ and Fortran
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

#include "astercxx.h"

void jeveux_init();

void call_oper( PyObject *syntax, int jxveri );

void call_ops( PyObject *syntax, int ops );

void call_debut( PyObject *syntax );

void call_poursuite( PyObject *syntax );

void call_affich( const std::string &code, const std::string &text );

void call_print( const std::string &text );

std::string onFatalError( const std::string value = "" );

void set_option( const std::string &option, double value );

#endif
