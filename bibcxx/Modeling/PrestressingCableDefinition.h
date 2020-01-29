#ifndef PRESTRESSINGCABLEDEFINITION_H_
#define PRESTRESSINGCABLEDEFINITION_H_

/**
 * @file PrestressingCableDefinition.h
 * @brief Fichier entete de la classe PrestressingCableDefinition
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

#include "DataStructures/DataStructure.h"
#include "astercxx.h"
#include <stdexcept>

#include "DataFields/PCFieldOnMesh.h"
#include "DataFields/Table.h"
#include "Discretization/ElementaryCharacteristics.h"
#include "Loads/ListOfLinearRelations.h"
#include "Materials/MaterialOnMesh.h"
#include "Meshes/Mesh.h"
#include "Modeling/Model.h"
#include "Supervis/ResultNaming.h"

/**
 * @class PrestressingCableDefinitionClass
 * @brief Produit une sd identique a celle produite par DEFI_CABLE_BP
 * @author Nicolas Sellenet
 * @todo ajouter un test pour valider des qu'on aura les macros
 */
class PrestressingCableDefinitionClass : public DataStructure {
  private:
    ModelPtr _model;
    ElementaryCharacteristicsPtr _cara;
    MaterialOnMeshPtr _mater;
    MeshPtr _mesh;
    /** @brief Carte '.CHME.SIGIN' */
    PCFieldOnMeshDoublePtr _sigin;
    /** @brief Table 'CABLEBP' */
    TablePtr _cableBP;
    /** @brief Table 'CABLEGL' */
    TablePtr _cableGL;
    /** @brief Table '.LIRELA' */
    ListOfLinearRelationsDoublePtr _lirela;
    /** @brief Booleen indiquant si la sd a deja ete remplie */
    bool _isEmpty;

  public:
    /**
     * @typedef PrestressingCableDefinition
     * @brief Pointeur intelligent vers un PrestressingCableDefinitionClass
     */
    typedef boost::shared_ptr< PrestressingCableDefinitionClass > PrestressingCableDefinitionPtr;

    /**
     * @brief Constructeur
     */
    PrestressingCableDefinitionClass( const ModelPtr &, const MaterialOnMeshPtr &,
                                         const ElementaryCharacteristicsPtr & );

    PrestressingCableDefinitionClass( const std::string jeveuxName, const ModelPtr &,
                                         const MaterialOnMeshPtr &,
                                         const ElementaryCharacteristicsPtr & );

    // Since no constructor allows to have null or empty objects,
    // it is not necessary to check if they exist.
    ModelPtr getModel() const { return _model; };

    MaterialOnMeshPtr getMaterialOnMesh() const { return _mater; };

    ElementaryCharacteristicsPtr getElementaryCharacteristics() const { return _cara; };

    /**
     * @brief Methode permettant de savoir si l'objet est vide
     * @return true si le modele est vide
     */
    bool isEmpty() { return _isEmpty; };
};

/**
 * @typedef PrestressingCableDefinition
 * @brief Pointeur intelligent vers un PrestressingCableDefinitionClass
 */
typedef boost::shared_ptr< PrestressingCableDefinitionClass > PrestressingCableDefinitionPtr;

#endif /* PRESTRESSINGCABLEDEFINITION_H_ */
