#ifndef LINEARDISPLACEMENTEVOLUTIONCONTAINER_H_
#define LINEARDISPLACEMENTEVOLUTIONCONTAINER_H_

/**
 * @file ElasticResult.h
 * @brief Fichier entete de la classe ElasticResult
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

#include "Results/Result.h"
#include "Supervis/ResultNaming.h"

/**
 * @class ElasticResultClass
 * @brief Cette classe correspond a un evol_elas
 * @author Nicolas Sellenet
 */
class ElasticResultClass : public ResultClass {
  public:
    /**
     * @brief Constructeur
     * @todo  Ajouter les objets Jeveux de la SD
     */
    ElasticResultClass()
        : ElasticResultClass( ResultNaming::getNewResultName() ){};

    ElasticResultClass( const std::string &name )
        : ResultClass( name, "EVOL_ELAS" ){};
};

/**
 * @typedef ElasticResultPtr
 * @brief Pointeur intelligent vers un ElasticResultClass
 */
typedef boost::shared_ptr< ElasticResultClass >
    ElasticResultPtr;

#endif /* LINEARDISPLACEMENTEVOLUTIONCONTAINER_H_ */
