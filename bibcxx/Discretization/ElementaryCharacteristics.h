#ifndef ELEMENTARYCHARACTERISTICS_H_
#define ELEMENTARYCHARACTERISTICS_H_

/**
 * @file ElementaryCharacteristics.h
 * @brief Fichier entete de la classe ElementaryCharacteristics
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

/* person_in_charge: nicolas.sellenet at edf.fr */

#include "astercxx.h"
#include "definition.h"
#include "DataStructures/DataStructure.h"
#include "DataFields/ConstantFieldOnCells.h"
#include "Modeling/Model.h"
#include "Supervis/ResultNaming.h"

/**
 * @class ElementaryCharacteristicsClass
 * @brief Cette classe decrit un cara_elem
 * @author Nicolas Sellenet
 */
class ElementaryCharacteristicsClass : public DataStructure {
  private:
    /** @brief Model */
    ModelPtr _model;
    /** @brief Mesh */
    BaseMeshPtr _mesh;
    /** @brief Objet Jeveux '.CANBSP' */
    ConstantFieldOnCellsLongPtr _numberOfSubpoints;
    /** @brief Objet Jeveux '.CARARCPO' */
    ConstantFieldOnCellsRealPtr _curveBeam;
    /** @brief Objet Jeveux '.CARCABLE' */
    ConstantFieldOnCellsRealPtr _cable;
    /** @brief Objet Jeveux '.CARCOQUE' */
    ConstantFieldOnCellsRealPtr _shell;
    /** @brief Objet Jeveux '.CARDISCA' */
    ConstantFieldOnCellsRealPtr _dumping;
    /** @brief Objet Jeveux '.CARDISCK' */
    ConstantFieldOnCellsRealPtr _rigidity;
    /** @brief Objet Jeveux '.CARDISCM' */
    ConstantFieldOnCellsRealPtr _mass;
    /** @brief Objet Jeveux '.CARGENBA' */
    ConstantFieldOnCellsRealPtr _bar;
    /** @brief Objet Jeveux '.CARGENPO' */
    ConstantFieldOnCellsRealPtr _beamSection;
    /** @brief Objet Jeveux '.CARGEOPO' */
    ConstantFieldOnCellsRealPtr _beamGeometry;
    /** @brief Objet Jeveux '.CARMASSI' */
    ConstantFieldOnCellsRealPtr _orthotropicBasis;
    /** @brief Objet Jeveux '.CARORIEN' */
    ConstantFieldOnCellsRealPtr _localBasis;
    /** @brief Objet Jeveux '.CARPOUFL' */
    ConstantFieldOnCellsRealPtr _beamCharacteristics;

    /** @brief Booleen indiquant si le maillage est vide */
    bool _isEmpty;

  public:
    /**
     * @typedef ElementaryCharacteristicsPtr
     * @brief Pointeur intelligent vers un ElementaryCharacteristics
     */
    typedef boost::shared_ptr< ElementaryCharacteristicsClass > ElementaryCharacteristicsPtr;

    /**
     * @brief Constructeur
     */
    ElementaryCharacteristicsClass( const std::string name, const ModelPtr &model );

    /**
     * @brief Constructeur
     */
    ElementaryCharacteristicsClass( const ModelPtr &model )
        : ElementaryCharacteristicsClass( ResultNaming::getNewResultName(), model ){};

    /**
     * @brief Destructeur
     */
    ~ElementaryCharacteristicsClass(){};

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
 * @brief Pointeur intelligent vers un ElementaryCharacteristicsClass
 */
typedef boost::shared_ptr< ElementaryCharacteristicsClass > ElementaryCharacteristicsPtr;

#endif /* ELEMENTARYCHARACTERISTICS_H_ */
