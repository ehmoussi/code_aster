#ifndef ELEMENTARYCHARACTERISTICS_H_
#define ELEMENTARYCHARACTERISTICS_H_

/**
 * @file ElementaryCharacteristics.h
 * @brief Fichier entete de la classe ElementaryCharacteristics
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

#include "astercxx.h"
#include "definition.h"
#include "DataStructures/DataStructure.h"
#include "DataFields/PCFieldOnMesh.h"
#include "Modeling/Model.h"
#include "Supervis/ResultNaming.h"

/**
 * @class ElementaryCharacteristicsInstance
 * @brief Cette classe decrit un cara_elem
 * @author Nicolas Sellenet
 */
class ElementaryCharacteristicsInstance : public DataStructure {
  private:
    /** @brief Model */
    ModelPtr _model;
    /** @brief Mesh */
    BaseMeshPtr _mesh;
    /** @brief Objet Jeveux '.CANBSP' */
    PCFieldOnMeshLongPtr _numberOfSubpoints;
    /** @brief Objet Jeveux '.CARARCPO' */
    PCFieldOnMeshDoublePtr _curveBeam;
    /** @brief Objet Jeveux '.CARCABLE' */
    PCFieldOnMeshDoublePtr _cable;
    /** @brief Objet Jeveux '.CARCOQUE' */
    PCFieldOnMeshDoublePtr _shell;
    /** @brief Objet Jeveux '.CARDISCA' */
    PCFieldOnMeshDoublePtr _dumping;
    /** @brief Objet Jeveux '.CARDISCK' */
    PCFieldOnMeshDoublePtr _rigidity;
    /** @brief Objet Jeveux '.CARDISCM' */
    PCFieldOnMeshDoublePtr _mass;
    /** @brief Objet Jeveux '.CARGENBA' */
    PCFieldOnMeshDoublePtr _bar;
    /** @brief Objet Jeveux '.CARGENPO' */
    PCFieldOnMeshDoublePtr _beamSection;
    /** @brief Objet Jeveux '.CARGEOPO' */
    PCFieldOnMeshDoublePtr _beamGeometry;
    /** @brief Objet Jeveux '.CARMASSI' */
    PCFieldOnMeshDoublePtr _orthotropicBasis;
    /** @brief Objet Jeveux '.CARORIEN' */
    PCFieldOnMeshDoublePtr _localBasis;
    /** @brief Objet Jeveux '.CARPOUFL' */
    PCFieldOnMeshDoublePtr _beamCharacteristics;

    /** @brief Booleen indiquant si le maillage est vide */
    bool _isEmpty;

  public:
    /**
     * @typedef ElementaryCharacteristicsPtr
     * @brief Pointeur intelligent vers un ElementaryCharacteristics
     */
    typedef boost::shared_ptr< ElementaryCharacteristicsInstance > ElementaryCharacteristicsPtr;

    /**
     * @brief Constructeur
     */
    ElementaryCharacteristicsInstance( const std::string name, const ModelPtr &model );

    /**
     * @brief Constructeur
     */
    ElementaryCharacteristicsInstance( const ModelPtr &model )
        : ElementaryCharacteristicsInstance( ResultNaming::getNewResultName(), model ){};

    /**
     * @brief Destructeur
     */
    ~ElementaryCharacteristicsInstance(){};

    /**
     * @brief Get the model
     */
    const ModelPtr &getModel() const {
        if ( _model->isEmpty() )
            throw std::runtime_error( "Model is empty" );
        return _model;
    };

    /**
     * @brief Fonction permettant de savoir si un maillage est vide (non relu par exemple)
     * @return retourne true si le maillage est vide
     */
    bool isEmpty() const { return _isEmpty; };
};

/**
 * @typedef ElementaryCharacteristicsPtr
 * @brief Pointeur intelligent vers un ElementaryCharacteristicsInstance
 */
typedef boost::shared_ptr< ElementaryCharacteristicsInstance > ElementaryCharacteristicsPtr;

#endif /* ELEMENTARYCHARACTERISTICS_H_ */
