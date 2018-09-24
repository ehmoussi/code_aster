#ifndef MATERIALONMESH_H_
#define MATERIALONMESH_H_

/**
 * @file MaterialOnMesh.h
 * @brief Fichier entete de la classe MaterialOnMesh
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2018  EDF R&D                www.code-aster.org
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

class MaterialOnMeshBuilderInstance;

/**
 * @class MaterialOnMeshInstance
 * @brief produit une sd identique a celle produite par AFFE_MATERIAU
 * @author Nicolas Sellenet
 */
class MaterialOnMeshInstance: public DataStructure
{
    friend class MaterialOnMeshBuilderInstance;

    private:
        // On redefinit le type MeshEntityPtr afin de pouvoir stocker les MeshEntity
        // dans la list
        /** @typedef Definition d'un pointeur intelligent sur un VirtualMeshEntity */
        typedef boost::shared_ptr< VirtualMeshEntity > MeshEntityPtr;
        /** @typedef std::list d'une std::pair de MeshEntityPtr */
        typedef std::list< std::pair< MaterialPtr, MeshEntityPtr > > listOfMatsAndGrps;
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
        BaseMeshPtr            _supportMesh;
        /** @brief Carte '.CHAMP_MAT' */
        PCFieldOnMeshChar8Ptr  _listOfMaterials;
        /** @brief Carte '.TEMPE_REF' */
        PCFieldOnMeshDoublePtr _listOfTemperatures;
        /** @brief Carte '.COMPOR' */
        PCFieldOnMeshDoublePtr _behaviourField;
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
         * @brief Pointeur intelligent vers un MaterialOnMeshInstance
         */
        typedef boost::shared_ptr< MaterialOnMeshInstance > MaterialOnMeshPtr;

        /**
         * @brief Constructeur
         */
        MaterialOnMeshInstance( const MeshPtr& mesh ):
            MaterialOnMeshInstance( ResultNaming::getNewResultName(), mesh )
        {};

        /**
         * @brief Constructeur
         */
        MaterialOnMeshInstance( const SkeletonPtr& mesh ):
            MaterialOnMeshInstance( ResultNaming::getNewResultName(), mesh )
        {};

        /**
         * @brief Constructeur
         */
        MaterialOnMeshInstance( const std::string &, const MeshPtr& );

        /**
         * @brief Constructeur
         */
        MaterialOnMeshInstance( const std::string &, const SkeletonPtr& );

#ifdef _USE_MPI
        /**
         * @brief Constructeur
         */
        MaterialOnMeshInstance( const ParallelMeshPtr& mesh ):
            MaterialOnMeshInstance( ResultNaming::getNewResultName(), mesh )
        {};

        /**
         * @brief Constructeur
         */
        MaterialOnMeshInstance( const std::string &, const ParallelMeshPtr& );
#endif /* _USE_MPI */

        /**
         * @brief Destructor
         */
        ~MaterialOnMeshInstance()
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
                                            std::string nameOfGroup ) throw ( std::runtime_error )
        {
            if ( ! _supportMesh ) throw std::runtime_error( "Support mesh is not defined" );
            if ( ! _supportMesh->hasGroupOfElements( nameOfGroup ) )
                throw std::runtime_error( nameOfGroup + "not in support mesh" );

            _behaviours.push_back( listOfBehavAndGrpsValue( curBehav,
                                            MeshEntityPtr( new GroupOfElements(nameOfGroup) ) ) );
        };

        /**
         * @brief Ajout d'un materiau sur une entite du maillage
         * @param curMater behaviour to add
         * @param nameOfGroup Name of group
         */
        void addBehaviourOnElement( BehaviourDefinitionPtr& curBehav,
                                            std::string nameOfElement ) throw ( std::runtime_error )
        {
            if ( ! _supportMesh ) throw std::runtime_error( "Support mesh is not defined" );

            _behaviours.push_back( listOfBehavAndGrpsValue( curBehav,
                                            MeshEntityPtr( new Element(nameOfElement) ) ) );
        };

        /**
         * @brief Ajout d'un materiau sur tout le maillage
         * @param curMater Materiau a ajouter
         */
        void addMaterialOnAllMesh( MaterialPtr& curMater )
        {
            _materialsOnMeshEntity.push_back( listOfMatsAndGrpsValue( curMater,
                                              MeshEntityPtr( new AllMeshEntities() ) ) );
        };

        /**
         * @brief Ajout d'un materiau sur une entite du maillage
         * @param curMater Materiau a ajouter
         * @param nameOfGroup Nom du groupe de mailles
         */
        void addMaterialOnGroupOfElements( MaterialPtr& curMater,
                                           std::string nameOfGroup ) throw ( std::runtime_error )
        {
            if ( ! _supportMesh ) throw std::runtime_error( "Support mesh is not defined" );
            if ( ! _supportMesh->hasGroupOfElements( nameOfGroup ) )
                throw std::runtime_error( nameOfGroup + "not in support mesh" );

            _materialsOnMeshEntity.push_back( listOfMatsAndGrpsValue( curMater,
                                            MeshEntityPtr( new GroupOfElements(nameOfGroup) ) ) );
        };

        /**
         * @brief Ajout d'un materiau sur une entite du maillage
         * @param curMater Materiau a ajouter
         * @param nameOfGroup Nom du groupe de mailles
         */
        void addMaterialOnElement( MaterialPtr& curMater,
                                           std::string nameOfElement ) throw ( std::runtime_error )
        {
            if ( ! _supportMesh ) throw std::runtime_error( "Support mesh is not defined" );

            _materialsOnMeshEntity.push_back( listOfMatsAndGrpsValue( curMater,
                                            MeshEntityPtr( new Element(nameOfElement) ) ) );
        };

        /**
         * @brief Build MaterialOnMeshPtr without InputVariables
         * @return true
         */
        bool buildWithoutInputVariables() throw ( std::runtime_error );

        /**
         * @brief Return the PCFieldOnMesh of behaviour
         */
        PCFieldOnMeshDoublePtr getBehaviourField() const
        {
            _behaviourField->updateValuePointers();
            return _behaviourField;
        };

        /**
         * @brief Return a vector of MaterialPtr
         */
        std::vector< MaterialPtr > getVectorOfMaterial() const;

        /**
         * @brief Function to know if a given Calculation Input Variables exists
         * @return true if exists
         */
        bool existsCalculationInputVariable( const std::string& );

        /**
         * @brief Obtenir le maillage support
         * @return Maillage support du champ de materiau
         */
        BaseMeshPtr getSupportMesh() throw ( std::runtime_error )
        {
            if ( _supportMesh->isEmpty() )
                throw std::runtime_error( "support mesh of current model is empty" );
            return _supportMesh;
        };
};

/**
 * @typedef MaterialOnMeshPtr
 * @brief Pointeur intelligent vers un MaterialOnMeshInstance
 */
typedef boost::shared_ptr< MaterialOnMeshInstance > MaterialOnMeshPtr;

#endif /* MATERIALONMESH_H_ */
