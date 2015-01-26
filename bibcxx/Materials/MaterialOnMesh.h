#ifndef MATERIALONMESH_H_
#define MATERIALONMESH_H_

/**
 * @file MaterialOnMesh.h
 * @brief Fichier entete de la classe MaterialOnMesh
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
#include "Modeling/Model.h"
#include "Materials/Material.h"
#include "DataFields/PCFieldOnMesh.h"

/**
 * @class MaterialOnMeshInstance
 * @brief produit une sd identique a celle produite par AFFE_MATERIAU
 * @author Nicolas Sellenet
 */
class MaterialOnMeshInstance: public DataStructure
{
    private:
        // On redefinit le type MeshEntityPtr afin de pouvoir stocker les MeshEntity
        // dans la list
        /** @typedef Definition d'un pointeur intelligent sur un VirtualMeshEntity */
        typedef boost::shared_ptr< VirtualMeshEntity > MeshEntityPtr;
        /** @typedef std::list d'une std::pair de MeshEntityPtr */
        typedef list< pair< Material, MeshEntityPtr > > listOfMatsAndGrps;
        /** @typedef Definition de la valeur contenue dans un listOfMatsAndGrps */
        typedef listOfMatsAndGrps::value_type listOfMatsAndGrpsValue;
        /** @typedef Definition d'un iterateur sur listOfMatsAndGrps */
        typedef listOfMatsAndGrps::iterator listOfMatsAndGrpsIter;

        /** @brief Carte '.CHAMP_MAT' */
        PCFieldOnMeshChar8  _listOfMaterials;
        /** @brief Carte '.TEMPE_REF' */
        PCFieldOnMeshDouble _listOfTemperatures;
        /** @brief Liste contenant les materiaux ajoutes par l'utilisateur */
        listOfMatsAndGrps   _materialsOnMeshEntity;
        /** @brief Maillage sur lequel repose la sd_cham_mater */
        Mesh                _supportMesh;

    public:
        /**
         * @brief Constructeur
         */
        MaterialOnMeshInstance();

        /**
         * @brief Ajout d'un materiau sur tout le maillage
         * @param curMater Materiau a ajouter
         */
        void addMaterialOnAllMesh( Material& curMater )
        {
            _materialsOnMeshEntity.push_back( listOfMatsAndGrpsValue( curMater,
                                                MeshEntityPtr( new AllMeshEntitiesInstance() ) ) );
        };

        /**
         * @brief Ajout d'un materiau sur une entite du maillage
         * @param curMater Materiau a ajouter
         * @param nameOfGroup Nom du groupe de mailles
         */
        void addMaterialOnGroupOfElements( Material& curMater, string nameOfGroup )
        {
            if ( ! _supportMesh ) throw "Support mesh is not defined";
            if ( ! _supportMesh->hasGroupOfElements( nameOfGroup ) )
                throw nameOfGroup + "not in support mesh";

            _materialsOnMeshEntity.push_back( listOfMatsAndGrpsValue( curMater,
                                                MeshEntityPtr( new GroupOfElementsInstance(nameOfGroup) ) ) );
        };

        /**
         * @brief Construction (au sens Jeveux fortran) de la sd_cham_mater
         * @return booleen indiquant que la construction s'est bien deroulee
         */
        bool build();

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

        /**
         * @brief Obtenir le maillage support
         * @return Maillage support du champ de materiau
         */
        Mesh& getSupportMesh()
        {
            if ( _supportMesh->isEmpty() )
                throw string("support mesh of current model is empty");
            return _supportMesh;
        };
};

/**
 * @class MaterialOnMesh
 * @brief Enveloppe d'un pointeur intelligent vers un MaterialOnMeshInstance
 * @author Nicolas Sellenet
 */
class MaterialOnMesh
{
    public:
        typedef boost::shared_ptr< MaterialOnMeshInstance > MaterialOnMeshPtr;

    private:
        MaterialOnMeshPtr _materAllocPtr;

    public:
        MaterialOnMesh(bool initilisation = true): _materAllocPtr()
        {
            if ( initilisation == true )
                _materAllocPtr = MaterialOnMeshPtr( new MaterialOnMeshInstance() );
        };

        ~MaterialOnMesh()
        {};

        MaterialOnMesh& operator=(const MaterialOnMesh& tmp)
        {
            _materAllocPtr = tmp._materAllocPtr;
            return *this;
        };

        const MaterialOnMeshPtr& operator->() const
        {
            return _materAllocPtr;
        };

        MaterialOnMeshInstance& operator*(void) const
        {
            return *_materAllocPtr;
        };

        bool isEmpty() const
        {
            if ( _materAllocPtr.use_count() == 0 ) return true;
            return false;
        };
};

#endif /* MATERIALONMESH_H_ */
