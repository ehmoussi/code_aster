#ifndef MATERIALONMESH_H_
#define MATERIALONMESH_H_

/**
 * @file MaterialField.h
 * @brief Fichier entete de la classe MaterialField
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

#include "DataFields/ConstantFieldOnCells.h"
#include "DataStructures/DataStructure.h"
#include "Materials/BehaviourDefinition.h"
#include "Materials/Material.h"
#include "MemoryManager/JeveuxVector.h"
#include "Meshes/Mesh.h"
#include "Meshes/ParallelMesh.h"
#include "Meshes/Skeleton.h"
#include "Modeling/Model.h"
#include "Supervis/ResultNaming.h"
#include "astercxx.h"
#include <stdexcept>

class MaterialFieldBuilderClass;

/**
 * @class PartOfMaterialFieldClass
 * @brief It contains a BehaviourDefinitionPtr and a MeshEntityPtr
 * @author Nicolas Sellenet
 */
class PartOfMaterialFieldClass {
  private:
    std::vector< MaterialPtr > _vecOfMater;
    MeshEntityPtr _entity;

  public:
    PartOfMaterialFieldClass() : _entity( nullptr ){};

    PartOfMaterialFieldClass( const std::vector< MaterialPtr > &vecOfMater,
                              const MeshEntityPtr &entity )
        : _vecOfMater( vecOfMater ), _entity( entity ){};

    /**
     * @brief Get the VectorOfMaterial of PartOfMaterialField
     */
    std::vector< MaterialPtr > getVectorOfMaterial() const { return _vecOfMater; };

    /**
     * @brief Get the MeshEntity of PartOfMaterialField
     */
    MeshEntityPtr getMeshEntity() const { return _entity; };
};

/**
 * @typedef PartOfMaterialFieldPtr
 * @brief Smart pointer on PartOfMaterialFieldClass
 */
typedef boost::shared_ptr< PartOfMaterialFieldClass > PartOfMaterialFieldPtr;

/**
 * @class MaterialFieldClass
 * @brief produit une sd identique a celle produite par AFFE_MATERIAU
 * @author Nicolas Sellenet
 */
class MaterialFieldClass : public DataStructure {
    friend class MaterialFieldBuilderClass;

  private:
    // On redefinit le type MeshEntityPtr afin de pouvoir stocker les MeshEntity
    // dans la list
    /** @typedef Definition d'un pointeur intelligent sur un VirtualMeshEntity */
    typedef boost::shared_ptr< VirtualMeshEntity > MeshEntityPtr;
    /** @typedef std::list d'une std::pair de MeshEntityPtr */
    typedef std::list< std::pair< std::vector< MaterialPtr >, MeshEntityPtr > > listOfMatsAndGrps;
    /** @typedef Definition de la valeur contenue dans un listOfMatsAndGrps */
    typedef listOfMatsAndGrps::value_type listOfMatsAndGrpsValue;
    /** @typedef Definition d'un iterateur sur listOfMatsAndGrps */
    typedef listOfMatsAndGrps::iterator listOfMatsAndGrpsIter;

    /** @typedef std::list d'une std::pair de MeshEntityPtr */
    typedef std::vector< std::pair< BehaviourDefinitionPtr, MeshEntityPtr > > listOfBehavAndGrps;
    /** @typedef Definition de la valeur contenue dans un listOfBehavAndGrps */
    typedef listOfBehavAndGrps::value_type listOfBehavAndGrpsValue;
    /** @typedef Definition d'un iterateur sur listOfBehavAndGrps */
    typedef listOfBehavAndGrps::iterator listOfBehavAndGrpsIter;

    /** @brief Maillage sur lequel repose la sd_cham_mater */
    BaseMeshPtr _mesh;
    /** @brief Model */
    ModelPtr _model;
    /** @brief Carte '.CHAMP_MAT' */
    ConstantFieldOnCellsChar8Ptr _listOfMaterials;
    /** @brief Carte '.TEMPE_REF' */
    ConstantFieldOnCellsRealPtr _listOfTemperatures;
    /** @brief Carte '.COMPOR' */
    ConstantFieldOnCellsRealPtr _behaviourField;
    /** @brief Liste contenant les materiaux ajoutes par l'utilisateur */
    listOfMatsAndGrps _materialsFieldEntity;
    /** @brief Link to a  */
    listOfBehavAndGrps _behaviours;
    /** @brief Jeveux vector '.CVRCNOM' */
    JeveuxVectorChar8 _cvrcNom;
    /** @brief Jeveux vector '.CVRCGD' */
    JeveuxVectorChar8 _cvrcGd;
    /** @brief Jeveux vector '.CVRCVARC' */
    JeveuxVectorChar8 _cvrcVarc;
    /** @brief Jeveux vector '.CVRCCMP' */
    JeveuxVectorChar8 _cvrcCmp;

  public:
    /**
     * @typedef MaterialFieldPtr
     * @brief Pointeur intelligent vers un MaterialFieldClass
     */
    typedef boost::shared_ptr< MaterialFieldClass > MaterialFieldPtr;

    /**
     * @brief Constructeur
     */
    MaterialFieldClass( const MeshPtr &mesh )
        : MaterialFieldClass( ResultNaming::getNewResultName(), mesh ){};

    /**
     * @brief Constructeur
     */
    MaterialFieldClass( const SkeletonPtr &mesh )
        : MaterialFieldClass( ResultNaming::getNewResultName(), mesh ){};

    /**
     * @brief Constructeur
     */
    MaterialFieldClass( const std::string &, const MeshPtr & );

    /**
     * @brief Constructeur
     */
    MaterialFieldClass( const std::string &, const SkeletonPtr & );

#ifdef _USE_MPI
    /**
     * @brief Constructeur
     */
    MaterialFieldClass( const ParallelMeshPtr &mesh )
        : MaterialFieldClass( ResultNaming::getNewResultName(), mesh ){};

    /**
     * @brief Constructeur
     */
    MaterialFieldClass( const std::string &, const ParallelMeshPtr & );
#endif /* _USE_MPI */

    /**
     * @brief Destructor
     */
    ~MaterialFieldClass(){};

    /**
     * @brief Add a behaviour on all mesh
     * @param curBehav behaviour to add
     */
    void addBehaviourOnAllMesh( BehaviourDefinitionPtr &curBehav ) {
        _behaviours.push_back(
            listOfBehavAndGrpsValue( curBehav, MeshEntityPtr( new AllMeshEntities() ) ) );
    };

    /**
     * @brief Ajout d'un materiau sur une entite du maillage
     * @param curMater behaviour to add
     * @param nameOfGroup Name of group
     */
    void addBehaviourOnGroupOfCells( BehaviourDefinitionPtr &curBehav, std::string nameOfGroup ) {
        if ( !_mesh )
            throw std::runtime_error( "Mesh is not defined" );
        if ( !_mesh->hasGroupOfCells( nameOfGroup ) )
            throw std::runtime_error( nameOfGroup + "not in mesh" );

        _behaviours.push_back(
            listOfBehavAndGrpsValue( curBehav, MeshEntityPtr( new GroupOfCells( nameOfGroup ) ) ) );
    };

    /**
     * @brief Ajout d'un materiau sur une entite du maillage
     * @param curMater behaviour to add
     * @param nameOfGroup Name of group
     */
    void addBehaviouronCell( BehaviourDefinitionPtr &curBehav, std::string nameOfCell ) {
        if ( !_mesh )
            throw std::runtime_error( "Mesh is not defined" );

        _behaviours.push_back(
            listOfBehavAndGrpsValue( curBehav, MeshEntityPtr( new Cell( nameOfCell ) ) ) );
    };

    /**
     * @brief Ajout d'un materiau sur tout le maillage
     * @param curMaters Materiau a ajouter
     */
    void addMaterialsOnAllMesh( std::vector< MaterialPtr > curMaters ) {
        _materialsFieldEntity.push_back(
            listOfMatsAndGrpsValue( curMaters, MeshEntityPtr( new AllMeshEntities() ) ) );
    };

    /**
     * @brief Ajout d'un materiau sur une entite du maillage
     * @param curMaters Materiau a ajouter
     * @param nameOfGroup Nom du groupe de mailles
     */
    void addMaterialsOnGroupOfCells( std::vector< MaterialPtr > curMaters,
                                     VectorString namesOfGroup ) {
        if ( !_mesh )
            throw std::runtime_error( "Mesh is not defined" );
        for ( const auto &nameOfGroup : namesOfGroup )
            if ( !_mesh->hasGroupOfCells( nameOfGroup ) )
                throw std::runtime_error( nameOfGroup + "not in mesh" );

        _materialsFieldEntity.push_back( listOfMatsAndGrpsValue(
            curMaters, MeshEntityPtr( new GroupOfCells( namesOfGroup ) ) ) );
    };

    /**
     * @brief Ajout d'un materiau sur une entite du maillage
     * @param curMaters Materiau a ajouter
     * @param nameOfCell Nom des mailles
     */
    void addMaterialsonCell( std::vector< MaterialPtr > curMaters, VectorString namesOfCells ) {
        if ( !_mesh )
            throw std::runtime_error( "Mesh is not defined" );

        _materialsFieldEntity.push_back(
            listOfMatsAndGrpsValue( curMaters, MeshEntityPtr( new Cell( namesOfCells ) ) ) );
    };

    /**
     * @brief Ajout d'un materiau sur tout le maillage
     * @param curMater Materiau a ajouter
     */
    void addMaterialOnAllMesh( MaterialPtr &curMater ) {
        _materialsFieldEntity.push_back(
            listOfMatsAndGrpsValue( {curMater}, MeshEntityPtr( new AllMeshEntities() ) ) );
    };

    /**
     * @brief Ajout d'un materiau sur une entite du maillage
     * @param curMater Materiau a ajouter
     * @param nameOfGroup Nom du groupe de mailles
     */
    void addMaterialOnGroupOfCells( MaterialPtr &curMater, VectorString namesOfGroup ) {
        if ( !_mesh )
            throw std::runtime_error( "Mesh is not defined" );
        for ( const auto &nameOfGroup : namesOfGroup )
            if ( !_mesh->hasGroupOfCells( nameOfGroup ) )
                throw std::runtime_error( nameOfGroup + "not in mesh" );

        _materialsFieldEntity.push_back( listOfMatsAndGrpsValue(
            {curMater}, MeshEntityPtr( new GroupOfCells( namesOfGroup ) ) ) );
    };

    /**
     * @brief Ajout d'un materiau sur une entite du maillage
     * @param curMater Materiau a ajouter
     * @param nameOfCell Nom des mailles
     */
    void addMaterialonCell( MaterialPtr &curMater, VectorString namesOfCells ) {
        if ( !_mesh )
            throw std::runtime_error( "Mesh is not defined" );

        _materialsFieldEntity.push_back(
            listOfMatsAndGrpsValue( {curMater}, MeshEntityPtr( new Cell( namesOfCells ) ) ) );
    };

    /**
     * @brief Build MaterialFieldPtr without ExternalVariable
     * @return true
     */
    bool buildWithoutExternalVariable();

    /**
     * @brief Return the ConstantFieldOnCells of behaviour
     */
    ConstantFieldOnCellsRealPtr getBehaviourField() const {
        _behaviourField->updateValuePointers();
        return _behaviourField;
    };

    /**
     * @brief Return a vector of MaterialPtr
     */
    std::vector< MaterialPtr > getVectorOfMaterial() const;

    /**
     * @brief Return a vector of MaterialPtr
     */
    std::vector< PartOfMaterialFieldPtr > getVectorOfPartOfMaterialField() const;

    /**
     * @brief Function to know if a given Calculation Input Variables exists
     * @return true if exists
     */
    bool existsExternalVariablesComputation( const std::string & );

    /**
     * @brief Obtenir le maillage
     * @return Maillage du champ de materiau
     */
    BaseMeshPtr getMesh() {
        if ( _mesh->isEmpty() )
            throw std::runtime_error( "mesh of current model is empty" );
        return _mesh;
    };

    /**
     * @brief Set the model
     */
    void setModel( ModelPtr model ) { _model = model; };
};

/**
 * @typedef MaterialFieldPtr
 * @brief Pointeur intelligent vers un MaterialFieldClass
 */
typedef boost::shared_ptr< MaterialFieldClass > MaterialFieldPtr;

#endif /* MATERIALONMESH_H_ */
