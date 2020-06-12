#ifndef EVOLUTIVELOAD_H_
#define EVOLUTIVELOAD_H_

/**
 * @file LoadResult.h
 * @brief Fichier entete de la classe LoadResult
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

/* person_in_charge: natacha.bereux at edf.fr */

#include "astercxx.h"

#include "Results/TransientResult.h"

/**
 * @class LoadResultClass
 * @brief Cette classe correspond a un comb_fourier
 * @author Nicolas Sellenet
 */
class LoadResultClass : public TransientResultClass {
  public:
    /**
     * @brief Constructeur
     */
    LoadResultClass( const std::string name = ResultNaming::getNewResultName() )
        : TransientResultClass( name, "EVOL_CHAR" ){};
};

/**
 * @typedef LoadResultPtr
 * @brief Pointeur intelligent vers un LoadResultClass
 */
typedef boost::shared_ptr< LoadResultClass > LoadResultPtr;

#endif /* EVOLUTIVELOAD_H_ */
