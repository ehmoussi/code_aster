#ifndef FULLACOUSTICHARMONICRESULTSCONTAINER_H_
#define FULLACOUSTICHARMONICRESULTSCONTAINER_H_

/**
 * @file FullHarmonicAcousticResult.h
 * @brief Fichier entete de la classe FullHarmonicAcousticResult
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

#include "astercxx.h"

#include "Results/FullResult.h"
#include "Supervis/ResultNaming.h"

/**
 * @class FullHarmonicAcousticResultClass
 * @brief Cette classe correspond à un acou_harmo
 * @author Natacha Béreux
 */
class FullHarmonicAcousticResultClass : public FullResultClass {
  private:
  public:
    /**
     * @brief Constructeur
     * @todo  Ajouter les objets Jeveux de la SD
     */
    FullHarmonicAcousticResultClass( const std::string &name )
        : FullResultClass( name, "ACOU_HARMO" ){};
    FullHarmonicAcousticResultClass()
        : FullResultClass( ResultNaming::getNewResultName(), "ACOU_HARMO" ){};
};

/**
 * @typedef FullHarmonicAcousticResultPtr
 * @brief Pointeur intelligent vers un FullHarmonicAcousticResultClass
 */
typedef boost::shared_ptr< FullHarmonicAcousticResultClass >
    FullHarmonicAcousticResultPtr;

#endif /* FULLACOUSTICHARMONICRESULTSCONTAINER_H_ */
