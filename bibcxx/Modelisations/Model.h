#ifndef MODEL_H_
#define MODEL_H_

/**
 * @file Model.h
 * @brief Fichier entete de la classe Model
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2014  EDF R&D                www.code-aster.org
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

#include "DataStructure/DataStructure.h"
#include "Mesh/Mesh.h"
#include "Modelisations/ElementaryModelisation.h"
#include <map>

#include "Loads/PhysicalQuantity.h"

/**
 * @class ModelInstance
 * @brief Produit une sd identique a celle produite par AFFE_MODELE
 * @author Nicolas Sellenet
 */
class ModelInstance: public DataStructure
{
    private:
        // On redefinit le type MeshEntityPtr afin de pouvoir stocker les MeshEntity
        // dans la list
        /** @brief Pointeur intelligent vers un VirtualMeshEntity */
        typedef boost::shared_ptr< VirtualMeshEntity > MeshEntityPtr;
        /** @brief std::list de std::pair de ElementaryModelisation et MeshEntityPtr */
        typedef list< pair< ElementaryModelisation, MeshEntityPtr > > listOfModsAndGrps;
        /** @brief Valeur contenue dans listOfModsAndGrps */
        typedef listOfModsAndGrps::value_type listOfModsAndGrpsValue;
        /** @brief Iterateur sur un listOfModsAndGrps */
        typedef listOfModsAndGrps::iterator listOfModsAndGrpsIter;

        /** @brief Vecteur Jeveux '.MAILLE' */
        JeveuxVectorLong  _typeOfElements;
        /** @brief Vecteur Jeveux '.NOEUD' */
        JeveuxVectorLong  _typeOfNodes;
        /** @brief Vecteur Jeveux '.PARTIT' */
        JeveuxVectorChar8 _partition;
        /** @brief Liste contenant les modelisations ajoutees par l'utilisateur */
        listOfModsAndGrps _modelisations;
        /** @brief Maillage sur lequel repose la modelisation */
        Mesh              _supportMesh;
        /** @brief Booleen indiquant si la sd a deja ete remplie */
        bool              _isEmpty;

    public:
        /**
         * @brief Constructeur
         */
        ModelInstance();

        /**
         * @brief Ajout d'une nouvelle modelisation sur tout le maillage
         * @param phys Physique a ajouter
         * @param mod Modelisation a ajouter
         */
        void addModelisationOnAllMesh( Physics phys, Modelisations mod )
        {
            _modelisations.push_back( listOfModsAndGrpsValue( ElementaryModelisation( phys, mod ),
                                                              MeshEntityPtr( new AllMeshEntitiesInstance() ) ) );
        };

        /**
         * @brief Ajout d'une nouvelle modelisation sur une entite du maillage
         * @param phys Physique a ajouter
         * @param mod Modelisation a ajouter
         * @param nameOfGroup Nom du groupe de mailles
         */
        void addModelisationOnGroupOfElements( Physics phys, Modelisations mod, string nameOfGroup )
        {
            if ( _supportMesh.isEmpty() ) throw "Support mesh is not defined";
            if ( ! _supportMesh->hasGroupOfElements( nameOfGroup ) )
                throw nameOfGroup + "not in support mesh";

            _modelisations.push_back( listOfModsAndGrpsValue( ElementaryModelisation( phys, mod ),
                                            MeshEntityPtr( new GroupOfElementsInstance(nameOfGroup) ) ) );
        };

        /**
         * @brief Ajout d'une nouvelle modelisation sur une entite du maillage
         * @param phys Physique a ajouter
         * @param mod Modelisation a ajouter
         * @param nameOfGroup Nom du groupe de noeuds
         */
        void addModelisationOnGroupOfNodes( Physics phys, Modelisations mod, string nameOfGroup )
        {
            if ( _supportMesh.isEmpty() ) throw "Support mesh is not defined";
            if ( ! _supportMesh->hasGroupOfNodes( nameOfGroup ) )
                throw nameOfGroup + "not in support mesh";

            _modelisations.push_back( listOfModsAndGrpsValue( ElementaryModelisation( phys, mod ),
                                            MeshEntityPtr( new GroupOfNodesInstance(nameOfGroup) ) ) );
        };

        /**
         * @brief Construction (au sens Jeveux fortran) de la sd_modele
         * @return booleen indiquant que la construction s'est bien deroulee
         */
        bool build();

        /**
         * @brief Methode permettant de savoir si le modele est vide
         * @return true si le modele est vide
         */
        bool isEmpty()
        {
            return _isEmpty;
        };

        /**
         * @brief Definition de la methode de partition
         */
        void setSplittingMethod()
        {
            throw "Not yet implemented";
        };

        /**
         * @brief Definition du maillage support
         * @param currentMesh objet Mesh sur lequel le modele reposera
         */
        bool setSupportMesh( Mesh& currentMesh )
        {
            if ( currentMesh->isEmpty() )
                throw string("Mesh is empty");
            _supportMesh = currentMesh;
            return true;
        };

        Mesh& getSupportMesh()
        {
            if ( _supportMesh.isEmpty() || _supportMesh->isEmpty() )
                throw string("Support mesh of current model is empty");
            return _supportMesh;
        };
};

/**
 * @class Model
 * @brief Enveloppe d'un pointeur intelligent vers un ModelInstance
 * @author Nicolas Sellenet
 */
class Model
{
    public:
        typedef boost::shared_ptr< ModelInstance > ModelPtr;

    private:
        ModelPtr _modelPtr;

    public:
        Model(bool initilisation = true): _modelPtr()
        {
            if ( initilisation == true )
                _modelPtr = ModelPtr( new ModelInstance() );
        };

        ~Model()
        {};

        Model& operator=(const Model& tmp)
        {
            _modelPtr = tmp._modelPtr;
            return *this;
        };

        const ModelPtr& operator->() const
        {
            return _modelPtr;
        };

        ModelInstance& operator*(void) const
        {
            return *_modelPtr;
        };

        ModelInstance* getInstance() const
        {
            return &(*_modelPtr);
        };

        void copy( Model& other )
        {
            _modelPtr = other._modelPtr;
        };

        bool isEmpty() const
        {
            if ( _modelPtr.use_count() == 0 ) return true;
            return false;
        };
};

#endif /* MODEL_H_ */
