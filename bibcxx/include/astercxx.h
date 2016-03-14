#ifndef ASTERCXX_H_
#define ASTERCXX_H_

/* ==================================================================== */
/* Copyright (C) 1991 - 2014  EDF R&D                www.code-aster.org */
/*                                                                      */
/* This file is part of Code_Aster.                                     */
/*                                                                      */
/* Code_Aster is free software: you can redistribute it and/or modify   */
/* it under the terms of the GNU General Public License as published by */
/* the Free Software Foundation, either version 2 of the License, or    */
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

#ifdef __cplusplus

#include <list>
#include <vector>
#include <string>
#include <map>
#include <iostream>
#include <complex>
#include <boost/shared_ptr.hpp>

typedef std::complex< double > DoubleComplex;

typedef std::vector< double > VectorDouble;

extern "C"
{

#include "Python.h"

#include "code_aster/Supervis/libCommandSyntax.h"

} // extern "C"
#endif

#endif // ASTERCXX_H_
