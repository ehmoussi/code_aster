#ifndef FULLHARMONICRESULTSCONTAINER_H_
#define FULLHARMONICRESULTSCONTAINER_H_

/**
 * @file FullHarmonicResultsContainer.h
 * @brief Fichier entete de la classe FullHarmonicResultsContainer
 * @author Natacha Béreux
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

#include "astercxx.h"

#include "Results/FullResultsContainer.h"
#include "Supervis/ResultNaming.h"

/**
 * @class FullHarmonicResultsContainerInstance
 * @brief Cette classe correspond à un dyna_harmo
 * @author Natacha Béreux
 */
class FullHarmonicResultsContainerInstance : public FullResultsContainerInstance {
  private:
  public:
    /**
     * @brief Constructeur
     * @todo  Ajouter les objets Jeveux de la SD
     */
    FullHarmonicResultsContainerInstance( const std::string &name )
        : FullResultsContainerInstance( name, "DYNA_HARMO" ){};
    FullHarmonicResultsContainerInstance()
        : FullHarmonicResultsContainerInstance( ResultNaming::getNewResultName() ){};
};

/**
 * @typedef FullHarmonicResultsContainerPtr
 * @brief Pointeur intelligent vers un FullHarmonicResultsContainerInstance
 */
typedef boost::shared_ptr< FullHarmonicResultsContainerInstance > FullHarmonicResultsContainerPtr;

#endif /* FULLHARMONICRESULTSCONTAINER_H_ */
