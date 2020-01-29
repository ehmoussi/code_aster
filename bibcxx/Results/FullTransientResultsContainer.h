#ifndef FULLTRANSIENTRESULTSCONTAINER_H_
#define FULLTRANSIENTRESULTSCONTAINER_H_

/**
 * @file FullTransientResultsContainer.h
 * @brief Fichier entete de la classe FullTransientResultsContainer
 * @author Nicolas Tardieu
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
 * @class FullTransientResultsContainerClass
 * @brief Cette classe correspond à un dyna_tran
 * @author Nicolas Tardieu
 */
class FullTransientResultsContainerClass : public FullResultsContainerClass {
  private:
  public:
    /**
     * @brief Constructeur
     * @todo  Ajouter les objets Jeveux de la SD
     */
    FullTransientResultsContainerClass( const std::string &name )
        : FullResultsContainerClass( name, "DYNA_TRANS" ){};
    FullTransientResultsContainerClass()
        : FullResultsContainerClass( ResultNaming::getNewResultName(), "DYNA_TRANS" ){};
};

/**
 * @typedef FullTransientResultsContainerPtr
 * @brief Pointeur intelligent vers un FullTransientResultsContainerClass
 */
typedef boost::shared_ptr< FullTransientResultsContainerClass > FullTransientResultsContainerPtr;

#endif /* FULLTRANSIENTRESULTSCONTAINER_H_ */
