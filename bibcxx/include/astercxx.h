#ifndef ASTERCXX_H_
#define ASTERCXX_H_

/* ==================================================================== */
/* Copyright (C) 1991 - 2018  EDF R&D                www.code-aster.org */
/*                                                                      */
/* This file is part of Code_Aster.                                     */
/*                                                                      */
/* Code_Aster is free software: you can redistribute it and/or modify   */
/* it under the terms of the GNU General Public License as published by */
/* the Free Software Foundation, either version 3 of the License, or    */
/* (at your option) any later version.                                  */
/*                                                                      */
/* Code_Aster is distributed in the hope that it will be useful,        */
/* but WITHOUT ANY WARRANTY; without even the implied warranty of       */
/* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the        */
/* GNU General Public License for more details.                         */
/*                                                                      */
/* You should have received a copy of the GNU General Public License    */
/* along with Code_Aster.  If not, see <http://www.gnu.org/licenses/>.  */
/* ==================================================================== */

/* person_in_charge: mathieu.courtois@edf.fr */

#include "asterc_config.h"
#include "aster.h"

#ifdef __cplusplus

#include <stdexcept>
#include <list>
#include <vector>
#include <string>
#include <map>
#include <iostream>
#include <complex>
#include <boost/shared_ptr.hpp>

typedef std::complex< double > RealComplex;

typedef std::vector< int > VectorInt;
typedef std::vector< ASTERINTEGER > VectorLong;
typedef std::vector< double > VectorReal;
typedef std::vector< RealComplex > VectorComplex;
typedef std::vector< std::string > VectorString;

extern "C" {

#include "Python.h"

} // extern "C"
#endif

// Exceptions identifiers - keep consistency with asterf.h
#define ASTER_ERROR 1
#define CONVERGENCE_ERROR 2
#define INTEGRATION_ERROR 3
#define SOLVER_ERROR 4
#define CONTACT_ERROR 5
#define TIMELIMIT_ERROR 6

#endif // ASTERCXX_H_
