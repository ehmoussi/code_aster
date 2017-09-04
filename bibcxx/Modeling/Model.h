#ifndef MODEL_H_
#define MODEL_H_

/**
 * @file Model.h
 * @brief Fichier entete de la classe Model
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2017  EDF R&D                www.code-aster.org
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
#include "Meshes/Mesh.h"
#include "Meshes/ParallelMesh.h"
#include "Modeling/ElementaryModeling.h"
#include <map>

#include "Loads/PhysicalQuantity.h"
#include "Utilities/SyntaxDictionary.h"

/**
 * @enum ModelSiplitingMethod
 * @brief Methodes de partitionnement du modèle
 * @author Nicolas Sellenet
 */
enum ModelSiplitingMethod { Centralized, SubDomain, GroupOfElementsSplit };
const int nbModelSiplitingMethod = 3;
/**
 * @var ModelSiplitingMethodNames
 * @brief Nom Aster des differents partitionnement
 */
extern const char* const ModelSiplitingMethodNames[nbModelSiplitingMethod];

/**
 * @enum GraphPartitioner
 * @brief Partitionneur de graph
 * @author Nicolas Sellenet
 */
enum GraphPartitioner { ScotchPartitioner, MetisPartitioner };
const int nbGraphPartitioner = 2;
/**
 * @var GraphPartitionerNames
 * @brief Nom Aster des differents partitionneur de graph
 */
extern const char* const GraphPartitionerNames[nbGraphPartitioner];

/**
 * @class ModelInstance
 * @brief Produit une sd identique a celle produite par AFFE_MODELE
 * @author Nicolas Sellenet
 */
class ModelInstance: public DataStructure
{
    protected:
        // On redefinit le type MeshEntityPtr afin de pouvoir stocker les MeshEntity
        // dans la list
        /** @brief Pointeur intelligent vers un VirtualMeshEntity */
        typedef boost::shared_ptr< VirtualMeshEntity > MeshEntityPtr;
        /** @brief std::list de std::pair de ElementaryModeling et MeshEntityPtr */
        typedef std::vector< std::pair< ElementaryModeling, MeshEntityPtr > > listOfModsAndGrps;
        /** @brief Valeur contenue dans listOfModsAndGrps */
        typedef listOfModsAndGrps::value_type listOfModsAndGrpsValue;
        /** @brief Iterateur sur un listOfModsAndGrps */
        typedef listOfModsAndGrps::iterator listOfModsAndGrpsIter;
        /** @brief Iterateur constant sur un listOfModsAndGrps */
        typedef listOfModsAndGrps::const_iterator listOfModsAndGrpsCIter;

        /** @brief Vecteur Jeveux '.MAILLE' */
        JeveuxVectorLong     _typeOfElements;
        /** @brief Vecteur Jeveux '.NOEUD' */
        JeveuxVectorLong     _typeOfNodes;
        /** @brief Vecteur Jeveux '.PARTIT' */
        JeveuxVectorChar8    _partition;
        /** @brief Liste contenant les modelisations ajoutees par l'utilisateur */
        listOfModsAndGrps    _modelisations;
        /** @brief Maillage sur lequel repose la modelisation */
        BaseMeshPtr          _supportBaseMesh;
        /** @brief Méthode de parallélisation du modèle */
        ModelSiplitingMethod _splitMethod;
        /** @brief Graph partitioning */
        GraphPartitioner     _graphPartitioner;
        /** @brief Booleen indiquant si la sd a deja ete remplie */
        bool                 _isEmpty;

        /**
         * @brief Ajout d'une nouvelle modelisation sur tout le maillage
         * @return SyntaxMapContainer contenant la syntaxe pour AFFE et les mc obligatoires
         */
        SyntaxMapContainer buildModelingsSyntaxMapContainer() const;

        /**
         * @brief Construction (au sens Jeveux fortran) de la sd_modele
         * @return booleen indiquant que la construction s'est bien deroulee
         */
        bool buildWithSyntax( SyntaxMapContainer& ) throw ( std::runtime_error );

    public:
        /**
         * @brief Forward declaration for the XFEM enrichment
         */
        typedef boost::shared_ptr< ModelInstance > ModelPtr;

        /**
         * @brief Constructeur
         */
        ModelInstance();

        /**
         * @brief Ajout d'une nouvelle modelisation sur tout le maillage
         * @param phys Physique a ajouter
         * @param mod Modelisation a ajouter
         */
        void addModelingOnAllMesh( Physics phys, Modelings mod ) throw ( std::runtime_error )
        {
            _modelisations.push_back( listOfModsAndGrpsValue( ElementaryModeling( phys, mod ),
                                                              MeshEntityPtr( new AllMeshEntities() ) ) );
        };

        /**
         * @brief Ajout d'une nouvelle modelisation sur une entite du maillage
         * @param phys Physique a ajouter
         * @param mod Modelisation a ajouter
         * @param nameOfGroup Nom du groupe de mailles
         */
        void addModelingOnGroupOfElements( Physics phys, Modelings mod,
                                           std::string nameOfGroup ) throw ( std::runtime_error )
        {
            if ( ! _supportBaseMesh ) throw std::runtime_error( "Support mesh is not defined" );
            if ( ! _supportBaseMesh->hasGroupOfElements( nameOfGroup ) )
                throw std::runtime_error( nameOfGroup + " not in support mesh" );

            _modelisations.push_back( listOfModsAndGrpsValue( ElementaryModeling( phys, mod ),
                                            MeshEntityPtr( new GroupOfElements(nameOfGroup) ) ) );
        };

        /**
         * @brief Ajout d'une nouvelle modelisation sur une entite du maillage
         * @param phys Physique a ajouter
         * @param mod Modelisation a ajouter
         * @param nameOfGroup Nom du groupe de noeuds
         */
        void addModelingOnGroupOfNodes( Physics phys, Modelings mod,
                                        std::string nameOfGroup ) throw ( std::runtime_error )
        {
            if ( ! _supportBaseMesh ) throw std::runtime_error( "Support mesh is not defined" );
            if ( ! _supportBaseMesh->hasGroupOfNodes( nameOfGroup ) )
                throw std::runtime_error( nameOfGroup + " not in support mesh" );

            _modelisations.push_back( listOfModsAndGrpsValue( ElementaryModeling( phys, mod ),
                                            MeshEntityPtr( new GroupOfNodes(nameOfGroup) ) ) );
        };

        /**
         * @brief Construction (au sens Jeveux fortran) de la sd_modele
         * @return booleen indiquant que la construction s'est bien deroulee
         */
        virtual bool build() throw ( std::runtime_error );

        BaseMeshPtr getSupportMesh() throw ( std::runtime_error )
        {
            if ( ( ! _supportBaseMesh ) || _supportBaseMesh->isEmpty() )
                throw std::runtime_error( "Support mesh of current model is empty" );
            return _supportBaseMesh;
        };

        /**
         * @brief Methode permettant de savoir si le modele est vide
         * @return true si le modele est vide
         */
        bool isEmpty()
        {
            return ! _typeOfElements->exists();
        };

        /**
         * @brief Definition de la methode de partition
         */
        void setSplittingMethod( ModelSiplitingMethod split, GraphPartitioner partitioner )
        {
            _splitMethod = split;
            _graphPartitioner = partitioner;
        };

        /**
         * @brief Definition de la methode de partition
         */
        void setSplittingMethod( ModelSiplitingMethod split )
        {
            _splitMethod = split;
        };

        /**
         * @brief Definition du maillage support
         * @param currentMesh objet MeshPtr sur lequel le modele reposera
         */
        bool setSupportMesh( MeshPtr& currentMesh ) throw ( std::runtime_error )
        {
            if ( currentMesh->isEmpty() )
                throw std::runtime_error( "Mesh is empty" );
            _supportBaseMesh = currentMesh;
            return true;
        };

        /**
         * @brief Definition du maillage support
         * @param currentMesh objet MeshPtr sur lequel le modele reposera
         */
#ifdef _USE_MPI
        bool setSupportMesh( ParallelMeshPtr& currentMesh ) throw ( std::runtime_error )
        {
            if ( currentMesh->isEmpty() )
                throw std::runtime_error( "Mesh is empty" );
            _supportBaseMesh = currentMesh;
            return true;
        };
#endif /* _USE_MPI */
};

/**
 * @typedef Model
 * @brief Pointeur intelligent vers un ModelInstance
 */
typedef boost::shared_ptr< ModelInstance > ModelPtr;

#endif /* MODEL_H_ */