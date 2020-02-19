#ifndef MATERIALONMESH_H_
#define MATERIALONMESH_H_

/**
 * @file MaterialOnMesh.h
 * @brief Fichier entete de la classe MaterialOnMesh
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

#include <stdexcept>
#include "astercxx.h"
#include "DataStructures/DataStructure.h"
#include "MemoryManager/JeveuxVector.h"
#include "Modeling/Model.h"
#include "Meshes/Mesh.h"
#include "Meshes/Skeleton.h"
#include "Materials/Material.h"
#include "DataFields/PCFieldOnMesh.h"
#include "Meshes/ParallelMesh.h"
#include "Supervis/ResultNaming.h"
#include "Materials/BehaviourDefinition.h"

class MaterialOnMeshBuilderClass;

/**
 * @class PartOfMaterialOnMeshClass
 * @brief It contains a BehaviourDefinitionPtr and a MeshEntityPtr
 * @author Nicolas Sellenet
 */
class PartOfMaterialOnMeshClass
{
private:
    std::vector< MaterialPtr > _vecOfMater;
    MeshEntityPtr              _entity;

public:
    PartOfMaterialOnMeshClass(): _entity( nullptr )
    {};

    PartOfMaterialOnMeshClass( const std::vector< MaterialPtr >& vecOfMater,
                                  const MeshEntityPtr& entity ):
        _vecOfMater( vecOfMater ),
        _entity( entity )
    {};

    /**
     * @brief Get the VectorOfMaterial of PartOfMaterialOnMesh
     */
    std::vector< MaterialPtr > getVectorOfMaterial() const
    {
        return _vecOfMater;
    };

    /**
     * @brief Get the MeshEntity of PartOfMaterialOnMesh
     */
    MeshEntityPtr getMeshEntity() const
    {
        return _entity;
    };
};

/**
 * @typedef PartOfMaterialOnMeshPtr
 * @brief Smart pointer on PartOfMaterialOnMeshClass
 */
typedef boost::shared_ptr< PartOfMaterialOnMeshClass > PartOfMaterialOnMeshPtr;

/**
 * @class MaterialOnMeshClass
 * @brief produit une sd identique a celle produite par AFFE_MATERIAU
 * @author Nicolas Sellenet
 */
class MaterialOnMeshClass: public DataStructure
{
    friend class MaterialOnMeshBuilderClass;

    private:
        // On redefinit le type MeshEntityPtr afin de pouvoir stocker les MeshEntity
        // dans la list
        /** @typedef Definition d'un pointeur intelligent sur un VirtualMeshEntity */
        typedef boost::shared_ptr< VirtualMeshEntity > MeshEntityPtr;
        /** @typedef std::list d'une std::pair de MeshEntityPtr */
        typedef std::list< std::pair< std::vector< MaterialPtr >,
                                      MeshEntityPtr > > listOfMatsAndGrps;
        /** @typedef Definition de la valeur contenue dans un listOfMatsAndGrps */
        typedef listOfMatsAndGrps::value_type listOfMatsAndGrpsValue;
        /** @typedef Definition d'un iterateur sur listOfMatsAndGrps */
        typedef listOfMatsAndGrps::iterator listOfMatsAndGrpsIter;

        /** @typedef std::list d'une std::pair de MeshEntityPtr */
        typedef std::vector< std::pair< BehaviourDefinitionPtr,
                                        MeshEntityPtr > > listOfBehavAndGrps;
        /** @typedef Definition de la valeur contenue dans un listOfBehavAndGrps */
        typedef listOfBehavAndGrps::value_type listOfBehavAndGrpsValue;
        /** @typedef Definition d'un iterateur sur listOfBehavAndGrps */
        typedef listOfBehavAndGrps::iterator listOfBehavAndGrpsIter;

        /** @brief Maillage sur lequel repose la sd_cham_mater */
        BaseMeshPtr            _mesh;
        /** @brief Model */
        ModelPtr               _model;
        /** @brief Carte '.CHAMP_MAT' */
        PCFieldOnMeshChar8Ptr  _listOfMaterials;
        /** @brief Carte '.TEMPE_REF' */
        PCFieldOnMeshRealPtr _listOfTemperatures;
        /** @brief Carte '.COMPOR' */
        PCFieldOnMeshRealPtr _behaviourField;
        /** @brief Liste contenant les materiaux ajoutes par l'utilisateur */
        listOfMatsAndGrps      _materialsOnMeshEntity;
        /** @brief Link to a  */
        listOfBehavAndGrps     _behaviours;
        /** @brief Jeveux vector '.CVRCNOM' */
        JeveuxVectorChar8      _cvrcNom;
        /** @brief Jeveux vector '.CVRCGD' */
        JeveuxVectorChar8      _cvrcGd;
        /** @brief Jeveux vector '.CVRCVARC' */
        JeveuxVectorChar8      _cvrcVarc;
        /** @brief Jeveux vector '.CVRCCMP' */
        JeveuxVectorChar8      _cvrcCmp;

    public:
        /**
         * @typedef MaterialOnMeshPtr
         * @brief Pointeur intelligent vers un MaterialOnMeshClass
         */
        typedef boost::shared_ptr< MaterialOnMeshClass > MaterialOnMeshPtr;

        /**
         * @brief Constructeur
         */
        MaterialOnMeshClass( const MeshPtr& mesh ):
            MaterialOnMeshClass( ResultNaming::getNewResultName(), mesh )
        {};

        /**
         * @brief Constructeur
         */
        MaterialOnMeshClass( const SkeletonPtr& mesh ):
            MaterialOnMeshClass( ResultNaming::getNewResultName(), mesh )
        {};

        /**
         * @brief Constructeur
         */
        MaterialOnMeshClass( const std::string &, const MeshPtr& );

        /**
         * @brief Constructeur
         */
        MaterialOnMeshClass( const std::string &, const SkeletonPtr& );

#ifdef _USE_MPI
        /**
         * @brief Constructeur
         */
        MaterialOnMeshClass( const ParallelMeshPtr& mesh ):
            MaterialOnMeshClass( ResultNaming::getNewResultName(), mesh )
        {};

        /**
         * @brief Constructeur
         */
        MaterialOnMeshClass( const std::string &, const ParallelMeshPtr& );
#endif /* _USE_MPI */

        /**
         * @brief Destructor
         */
        ~MaterialOnMeshClass()
        {};

        /**
         * @brief Add a behaviour on all mesh
         * @param curBehav behaviour to add
         */
        void addBehaviourOnAllMesh( BehaviourDefinitionPtr& curBehav )
        {
            _behaviours.push_back( listOfBehavAndGrpsValue( curBehav,
                                                       MeshEntityPtr( new AllMeshEntities() ) ) );
        };

        /**
         * @brief Ajout d'un materiau sur une entite du maillage
         * @param curMater behaviour to add
         * @param nameOfGroup Name of group
         */
        void addBehaviourOnGroupOfElements( BehaviourDefinitionPtr& curBehav,
                                            std::string nameOfGroup )
        {
            if ( ! _mesh ) throw std::runtime_error( "Mesh is not defined" );
            if ( ! _mesh->hasGroupOfElements( nameOfGroup ) )
                throw std::runtime_error( nameOfGroup + "not in mesh" );

            _behaviours.push_back( listOfBehavAndGrpsValue( curBehav,
                                            MeshEntityPtr( new GroupOfElements(nameOfGroup) ) ) );
        };

        /**
         * @brief Ajout d'un materiau sur une entite du maillage
         * @param curMater behaviour to add
         * @param nameOfGroup Name of group
         */
        void addBehaviourOnElement( BehaviourDefinitionPtr& curBehav,
                                            std::string nameOfElement )
        {
            if ( ! _mesh ) throw std::runtime_error( "Mesh is not defined" );

            _behaviours.push_back( listOfBehavAndGrpsValue( curBehav,
                                            MeshEntityPtr( new Element(nameOfElement) ) ) );
        };

        /**
         * @brief Ajout d'un materiau sur tout le maillage
         * @param curMaters Materiau a ajouter
         */
        void addMaterialsOnAllMesh( std::vector< MaterialPtr > curMaters )
        {
            _materialsOnMeshEntity.push_back( listOfMatsAndGrpsValue( curMaters,
                                              MeshEntityPtr( new AllMeshEntities() ) ) );
        };

        /**
         * @brief Ajout d'un materiau sur une entite du maillage
         * @param curMaters Materiau a ajouter
         * @param nameOfGroup Nom du groupe de mailles
         */
        void addMaterialsOnGroupOfElements( std::vector< MaterialPtr > curMaters,
                                            VectorString namesOfGroup )
        {
            if ( ! _mesh ) throw std::runtime_error( "Mesh is not defined" );
            for( const auto& nameOfGroup : namesOfGroup )
                if ( ! _mesh->hasGroupOfElements( nameOfGroup ) )
                    throw std::runtime_error( nameOfGroup + "not in mesh" );

            _materialsOnMeshEntity.push_back( listOfMatsAndGrpsValue( curMaters,
                                           MeshEntityPtr( new GroupOfElements(namesOfGroup) ) ) );
        };

        /**
         * @brief Ajout d'un materiau sur une entite du maillage
         * @param curMaters Materiau a ajouter
         * @param nameOfElement Nom des mailles
         */
        void addMaterialsOnElement( std::vector< MaterialPtr > curMaters,
                                    VectorString namesOfElement )
        {
            if ( ! _mesh ) throw std::runtime_error( "Mesh is not defined" );

            _materialsOnMeshEntity.push_back( listOfMatsAndGrpsValue( curMaters,
                                            MeshEntityPtr( new Element(namesOfElement) ) ) );
        };

        /**
         * @brief Ajout d'un materiau sur tout le maillage
         * @param curMater Materiau a ajouter
         */
        void addMaterialOnAllMesh( MaterialPtr& curMater )
        {
            _materialsOnMeshEntity.push_back( listOfMatsAndGrpsValue( { curMater },
                                              MeshEntityPtr( new AllMeshEntities() ) ) );
        };

        /**
         * @brief Ajout d'un materiau sur une entite du maillage
         * @param curMater Materiau a ajouter
         * @param nameOfGroup Nom du groupe de mailles
         */
        void addMaterialOnGroupOfElements( MaterialPtr& curMater,
                                           VectorString namesOfGroup )
        {
            if ( ! _mesh ) throw std::runtime_error( "Mesh is not defined" );
            for( const auto& nameOfGroup : namesOfGroup )
                if ( ! _mesh->hasGroupOfElements( nameOfGroup ) )
                    throw std::runtime_error( nameOfGroup + "not in mesh" );

            _materialsOnMeshEntity.push_back( listOfMatsAndGrpsValue( { curMater },
                                           MeshEntityPtr( new GroupOfElements(namesOfGroup) ) ) );
        };

        /**
         * @brief Ajout d'un materiau sur une entite du maillage
         * @param curMater Materiau a ajouter
         * @param nameOfElement Nom des mailles
         */
        void addMaterialOnElement( MaterialPtr& curMater,
                                   VectorString namesOfElement )
        {
            if ( ! _mesh ) throw std::runtime_error( "Mesh is not defined" );

            _materialsOnMeshEntity.push_back( listOfMatsAndGrpsValue( { curMater },
                                            MeshEntityPtr( new Element(namesOfElement) ) ) );
        };

        /**
         * @brief Build MaterialOnMeshPtr without ExternalVariable
         * @return true
         */
        bool buildWithoutExternalVariable() ;

        /**
         * @brief Return the PCFieldOnMesh of behaviour
         */
        PCFieldOnMeshRealPtr getBehaviourField() const
        {
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
        std::vector< PartOfMaterialOnMeshPtr > getVectorOfPartOfMaterialOnMesh() const;

        /**
         * @brief Function to know if a given Calculation Input Variables exists
         * @return true if exists
         */
        bool existsCalculationExternalVariable( const std::string& );

        /**
         * @brief Obtenir le maillage
         * @return Maillage du champ de materiau
         */
        BaseMeshPtr getMesh()
        {
            if ( _mesh->isEmpty() )
                throw std::runtime_error( "mesh of current model is empty" );
            return _mesh;
        };

        /**
         * @brief Set the model
         */
        void setModel( ModelPtr model )
        {
            _model = model;
        };
};

/**
 * @typedef MaterialOnMeshPtr
 * @brief Pointeur intelligent vers un MaterialOnMeshClass
 */
typedef boost::shared_ptr< MaterialOnMeshClass > MaterialOnMeshPtr;

#endif /* MATERIALONMESH_H_ */
