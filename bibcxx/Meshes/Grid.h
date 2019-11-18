#ifndef GRID_H_
#define GRID_H_

/**
 * @file Grid.h
 * @brief Fichier entete de la classe Grid
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2019  EDF R&D                www.code-aster.org
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

/* person_in_charge: nicolas.sellenet at edf.fr */

#include "MemoryManager/JeveuxVector.h"
#include "Meshes/Mesh.h"
#include "Supervis/ResultNaming.h"
#include "astercxx.h"

/**
 * @class GridInstance
 * @brief Cette classe decrit une sd_grille
 * @author Nicolas Sellenet
 */
class GridInstance : public MeshInstance {
  private:
    /** @brief Objet Jeveux '.GRLR' */
    JeveuxVectorDouble _grlr;
    /** @brief Objet Jeveux '.GRLI' */
    JeveuxVectorLong _grli;

  public:
    /**
     * @typedef GridPtr
     * @brief Pointeur intelligent vers un GridInstance
     */
    typedef boost::shared_ptr< GridInstance > GridPtr;

    /**
     * @brief Constructeur
     */
    GridInstance( const std::string name = ResultNaming::getNewResultName() );
};

/**
 * @typedef GridPtr
 * @brief Pointeur intelligent vers un GridInstance
 */
typedef boost::shared_ptr< GridInstance > GridPtr;

#endif /* GRID_H_ */
