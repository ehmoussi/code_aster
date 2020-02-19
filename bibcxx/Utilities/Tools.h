#ifndef TOOLS_H_
#define TOOLS_H_

/**
 * @file Tools.h
 * @brief Fichier entete des outils
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

#include <string>

#include "astercxx.h"

std::string trim( const std::string &str, const std::string &whitespace = " \t" );

/**
 * @brief vectorStringToFStr Create an array of Fortran strings from a vector of strings.
 *      The output array must be freed by the caller.
 */
char *vectorStringAsFStrArray( const VectorString &vector, const int size );

#endif /* TOOLS_H_ */
