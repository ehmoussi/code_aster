#ifndef FULLTRANSIENTRESULTSCONTAINER_H_
#define FULLTRANSIENTRESULTSCONTAINER_H_

/**
 * @file FullTransientResult.h
 * @brief Fichier entete de la classe FullTransientResult
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

#include "Results/FullResult.h"
#include "Supervis/ResultNaming.h"
/**
 * @class FullTransientResultClass
 * @brief Cette classe correspond à un dyna_tran
 * @author Nicolas Tardieu
 */
class FullTransientResultClass : public FullResultClass {
  private:
  public:
    /**
     * @brief Constructeur
     * @todo  Ajouter les objets Jeveux de la SD
     */
    FullTransientResultClass( const std::string &name )
        : FullResultClass( name, "DYNA_TRANS" ){};
    FullTransientResultClass()
        : FullResultClass( ResultNaming::getNewResultName(), "DYNA_TRANS" ){};
};

/**
 * @typedef FullTransientResultPtr
 * @brief Pointeur intelligent vers un FullTransientResultClass
 */
typedef boost::shared_ptr< FullTransientResultClass > FullTransientResultPtr;

#endif /* FULLTRANSIENTRESULTSCONTAINER_H_ */
