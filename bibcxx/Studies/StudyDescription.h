#ifndef STUDYDESCRIPTION_H_
#define STUDYDESCRIPTION_H_

/**
 * @file StudyDescription.h
 * @brief Fichier entete de la classe StudyDescription
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

#include "astercxx.h"

#include "MemoryManager/JeveuxVector.h"
#include "Modeling/Model.h"
#include "Materials/MaterialOnMesh.h"
#include "Materials/CodedMaterial.h"
#include "Loads/MechanicalLoad.h"
#include "Loads/KinematicsLoad.h"
#include "Loads/ListOfLoads.h"
#include "Discretization/DOFNumbering.h"
#include "Discretization/ElementaryCharacteristics.h"
#include "Materials/CalculationInputVariables.h"

/**
 * @class StudyDescriptionInstance
 * @brief Cette classe permet de definir une étude au sens Aster
 * @author Nicolas Sellenet
 */
class StudyDescriptionInstance {
  private:
    /** @brief Modele */
    ModelPtr _model;
    /** @brief Materiau affecté */
    MaterialOnMeshPtr _materialOnMesh;
    /** @brief Liste des chargements */
    ListOfLoadsPtr _listOfLoads;
    /** @brief Liste des chargements */
    ElementaryCharacteristicsPtr _elemChara;
    /** @brief coded material */
    CodedMaterialPtr _codedMater;
    /** @brief Input variables */
    CalculationInputVariablesPtr _varCom;

  public:
    /**
     * @brief Constructeur
     * @param ModelPtr Modèle de l'étude
     * @param MaterialOnMeshPtr Matériau de l'étude
     */
    StudyDescriptionInstance( const ModelPtr &curModel, const MaterialOnMeshPtr &curMat,
                              const ElementaryCharacteristicsPtr &cara = nullptr )
        : _model( curModel ), _materialOnMesh( curMat ),
          _listOfLoads( ListOfLoadsPtr( new ListOfLoadsInstance() ) ), _elemChara( cara ),
          _codedMater( new CodedMaterialInstance( _materialOnMesh, _model ) ),
          _varCom( new CalculationInputVariablesInstance( _model, _materialOnMesh,
                                                          _elemChara, _codedMater ) ){};

    ~StudyDescriptionInstance(){};

    /**
     * @brief Add a load (mechanical or kinematic) with function, formula...
     * @param Args... template list of arguments (load and function or formula)
     */
    template < typename... Args > void addLoad( const Args &... a ) {
        _listOfLoads->addLoad( a... );
    };

    /**
     * @brief Construction de la liste de chargements
     * @return true si tout s'est bien passé
     */
    bool buildListOfLoads() { return _listOfLoads->build(); };

    /**
     * @brief Get elementary characteristics
     */
    const ElementaryCharacteristicsPtr &getElementaryCharacteristics() const { return _elemChara; };

    /**
     * @brief Get the build coded material
     */
    const CodedMaterialPtr &getCodedMaterial() const { return _codedMater; };

    /**
     * @brief Obtenir la liste des chargements cinematiques
     */
    const ListKineLoad &getListOfKinematicsLoads() const {
        return _listOfLoads->getListOfKinematicsLoads();
    };

    /**
     * @brief Renvoit la liste de chargements
     */
    const ListOfLoadsPtr &getListOfLoads() const { return _listOfLoads; };

    /**
     * @brief Obtenir la liste des chargements mecaniques
     */
    const ListMecaLoad &getListOfMechanicalLoads() const {
        return _listOfLoads->getListOfMechanicalLoads();
    };

    /**
     * @brief Obtenir le matériau affecté
     */
    const MaterialOnMeshPtr &getMaterialOnMesh() const { return _materialOnMesh; };

    /**
     * @brief Obtenir le modèle de l'étude
     */
    const ModelPtr &getModel() const { return _model; };
};

/**
 * @typedef StudyDescriptionPtr
 * @brief Pointeur intelligent vers un StudyDescription
 */
typedef boost::shared_ptr< StudyDescriptionInstance > StudyDescriptionPtr;

#endif /* STUDYDESCRIPTION_H_ */
