#ifndef MATERIALONMESHBUILDER_H_
#define MATERIALONMESHBUILDER_H_

/**
 * @file MaterialOnMeshBuilder.h
 * @brief Fichier entete de MaterialOnMeshBuilder
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2019  EDF R&D                www.code-aster.org
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

/* person_in_charge: nicolas.sellenet at edf.fr */

#include "Materials/InputVariableDefinition.h"
#include "Materials/MaterialOnMesh.h"
#include "Materials/InputVariableConverter.h"
#include "astercxx.h"
#include <stdexcept>

/**
 * @class MaterialOnMeshBuilderInstance
 * @author Nicolas Sellenet
 */
class MaterialOnMeshBuilderInstance : public DataStructure {
    friend class MaterialOnMeshInstance;

  protected:
    /**
     * @brief Build MaterialOnMeshPtr
     * @param curMater Material to build
     * @param curInputVariables Input variables to add in MaterialOnMeshPtr
     */
    static void buildInstance( MaterialOnMeshInstance &curMater,
                               const InputVariableOnMeshPtr &curInputVariables = nullptr,
                               const InputVariableConverterPtr &converter = nullptr );

  public:
    /**
     * @typedef MaterialOnMeshBuilderPtr
     * @brief Pointeur intelligent vers un MaterialOnMeshBuilderInstance
     */
    typedef boost::shared_ptr< MaterialOnMeshBuilderInstance > MaterialOnMeshBuilderPtr;

    /**
     * @brief Build MaterialOnMeshPtr
     * @param curMater Material to build
     * @param curInputVariables Input variables to add in MaterialOnMeshPtr
     */
    static MaterialOnMeshPtr build( MaterialOnMeshPtr &curMater,
                                    const InputVariableOnMeshPtr &curInputVariables = nullptr,
                                    const InputVariableConverterPtr &converter = nullptr );
};

#endif /* MATERIALONMESHBUILDER_H_ */
