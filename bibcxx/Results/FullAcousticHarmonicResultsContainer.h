#ifndef FULLACOUSTICHARMONICRESULTSCONTAINER_H_
#define FULLACOUSTICHARMONICRESULTSCONTAINER_H_

/**
 * @file FullAcousticHarmonicResultsContainer.h
 * @brief Fichier entete de la classe FullAcousticHarmonicResultsContainer
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

#include "Results/FullResultsContainer.h"
#include "Supervis/ResultNaming.h"

/**
 * @class FullAcousticHarmonicResultsContainerClass
 * @brief Cette classe correspond à un acou_harmo
 * @author Natacha Béreux
 */
class FullAcousticHarmonicResultsContainerClass : public FullResultsContainerClass {
  private:
  public:
    /**
     * @brief Constructeur
     * @todo  Ajouter les objets Jeveux de la SD
     */
    FullAcousticHarmonicResultsContainerClass( const std::string &name )
        : FullResultsContainerClass( name, "ACOU_HARMO" ){};
    FullAcousticHarmonicResultsContainerClass()
        : FullResultsContainerClass( ResultNaming::getNewResultName(), "ACOU_HARMO" ){};
};

/**
 * @typedef FullAcousticHarmonicResultsContainerPtr
 * @brief Pointeur intelligent vers un FullAcousticHarmonicResultsContainerClass
 */
typedef boost::shared_ptr< FullAcousticHarmonicResultsContainerClass >
    FullAcousticHarmonicResultsContainerPtr;

#endif /* FULLACOUSTICHARMONICRESULTSCONTAINER_H_ */
