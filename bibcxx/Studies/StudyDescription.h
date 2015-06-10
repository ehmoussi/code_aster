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

#include "astercxx.h"

#include "MemoryManager/JeveuxVector.h"
#include "Modeling/Model.h"
#include "Materials/MaterialOnMesh.h"
#include "Loads/MechanicalLoad.h"
#include "Loads/KinematicsLoad.h"

/**
 * @class StudyDescriptionInstance
 * @brief Cette classe permet de definir une étude au sens Aster
 * @author Nicolas Sellenet
 */
class StudyDescriptionInstance
{
    private:
        /** @brief Modèle support */
        ModelPtr          _supportModel;
        /** @brief Materiau affecté */
        MaterialOnMeshPtr _materialOnMesh;
        /** @brief Chargements Mecaniques */
        ListMecaLoad      _listOfMechanicalLoads;
        /** @brief Chargements cinematiques */
        ListKineLoad      _listOfKinematicsLoads;

    public:
        /**
         * @brief Constructeur
         * @param ModelPtr Modèle de l'étude
         * @param MaterialOnMeshPtr Matériau de l'étude
         */
        StudyDescriptionInstance( const ModelPtr& curModel,
                                  const MaterialOnMeshPtr& curMat ):
            _supportModel( curModel ),
            _materialOnMesh( curMat )
        {};

        ~StudyDescriptionInstance()
        {};

        /**
         * @brief Function d'ajout d'une charge cinematique
         * @param currentLoad charge a ajouter a la sd
         */
        void addKinematicsLoad( const KinematicsLoadPtr& currentLoad )
        {
            _listOfKinematicsLoads.push_back( currentLoad );
        };

        /**
         * @brief Function d'ajout d'une charge mecanique
         * @param currentLoad charge a ajouter a la sd
         */
        void addMechanicalLoad( const GenericMechanicalLoadPtr& currentLoad )
        {
            _listOfMechanicalLoads.push_back( currentLoad );
        };

        /**
         * @brief Obtenir la liste des chargements cinematiques
         */
        const ListKineLoad& getListOfKinematicsLoads() const
        {
            return _listOfKinematicsLoads;
        };

        /**
         * @brief Obtenir la liste des chargements mecaniques
         */
        const ListMecaLoad& getListOfMechanicalLoads() const
        {
            return _listOfMechanicalLoads;
        };

        /**
         * @brief Obtenir le matériau affecté
         */
        MaterialOnMeshPtr getMaterialOnMesh() const
        {
            return _materialOnMesh;
        };

        /**
         * @brief Obtenir le modèle de l'étude
         */
        ModelPtr getModel() const
        {
            return _supportModel;
        };
};


/**
 * @typedef StudyDescriptionPtr
 * @brief Pointeur intelligent vers un StudyDescription
 */
typedef boost::shared_ptr< StudyDescriptionInstance > StudyDescriptionPtr;

#endif /* STUDYDESCRIPTION_H_ */
