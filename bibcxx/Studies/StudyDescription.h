#ifndef STUDYDESCRIPTION_H_
#define STUDYDESCRIPTION_H_

/**
 * @file StudyDescription.h
 * @brief Fichier entete de la classe StudyDescription
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2015  EDF R&D                www.code-aster.org
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

#include <string>
#include <assert.h>

#include "astercxx.h"
#include "aster_fort.h"

#include "MemoryManager/JeveuxVector.h"
#include "Modeling/Model.h"
#include "Materials/MaterialOnMesh.h"

/**
 * @class StudyDescriptionInstance
 * @brief Cette classe permet de definir une étude au sens Aster
 * @author Nicolas Sellenet
 */
class StudyDescriptionInstance
{
    private:
        /** @brief Modèle support */
        ModelPtr _supportModel;
        /** @brief Materiau affecté */
        MaterialOnMeshPtr _supportMaterialOnMesh;

    public:
        /**
         * @brief Constructeur
         * @param ModelPtr Modèle de l'étude
         * @param MaterialOnMeshPtr Matériau de l'étude
         */
        StudyDescriptionInstance( ModelPtr& curModel,
                                  MaterialOnMeshPtr& curMat):
            _supportModel( curModel ),
            _supportMaterialOnMesh( curMat )
        {};

        ~StudyDescriptionInstance()
        {};
};


/**
 * @typedef StudyDescriptionPtr
 * @brief Pointeur intelligent vers un StudyDescription
 */
typedef boost::shared_ptr< StudyDescriptionInstance > StudyDescriptionPtr;

#endif /* STUDYDESCRIPTION_H_ */
