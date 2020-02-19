#ifndef NonLinearResult_H_
#define NonLinearResult_H_

/**
 * @file NonLinearResult.h
 * @brief Fichier entete de la classe NonLinearResult
 * @author Natacha Béreux
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
 * @class NonLinearResultClass
 * @brief Cette classe correspond a un evol_noli, elle hérite de Result
          et stocke des champs
 * @author Natacha Béreux
 */
class NonLinearResultClass : public TransientResultClass {
  private:
  public:
    /**
     * @brief Constructeur
     */
    NonLinearResultClass() : TransientResultClass( "EVOL_NOLI" ){};

    /**
     * @brief Constructeur
     */
    NonLinearResultClass( const std::string name )
        : TransientResultClass( name, "EVOL_NOLI" ){};
};

/**
 * @typedef NonLinearResultPtr
 * @brief Pointeur intelligent vers un NonLinearResultClass
 */
typedef boost::shared_ptr< NonLinearResultClass > NonLinearResultPtr;

#endif /* NonLinearResult_H_ */
