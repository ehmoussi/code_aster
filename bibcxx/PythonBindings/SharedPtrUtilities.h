#ifndef SHAREDPTRUTILITIES_H_
#define SHAREDPTRUTILITIES_H_

/**
 * @file SharedPtrUtilities.h
 * @brief Utilitaires pour convertir un vector en list et inversement
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2017  EDF R&D                www.code-aster.org
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

#include "astercxx.h"

/**
 * @brief Methode de creation d'un shared_ptr avec un constructeur quelconque
 * @author Nicolas Sellenet
 */
template< typename A, typename... Args >
static std::shared_ptr<A> createSharedPtr( Args... args )
{
    return std::shared_ptr<A>( new A( args... ) );
};

#endif /* SHAREDPTRUTILITIES_H_ */
