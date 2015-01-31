#ifndef MESHENTITES_H_
#define MESHENTITES_H_

/**
 * @file MeshEntities.h
 * @brief Fichier entete de la classe MeshEntities
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

#include "astercxx.h"
#include "MemoryManager/JeveuxCollection.h"

/**
 * @class VirtualMeshEntity
 * @brief Cette classe permet de definir des entites de maillage :
 *        groupe de mailles ou groupe de noeuds
 * @author Nicolas Sellenet
 */
class VirtualMeshEntity
{
    private:
        /** @brief Nom de l'entite */
        const string _name;

    public:
        /**
         * @brief Constructeur
         * @param name nom de l'entite
         */
        VirtualMeshEntity( string name ): _name( name )
        {};

        /**
         * @brief Obtenir le nom de l'entite
         * @return renvoit le nom de l'entite
         */
        const string& getEntityName()
        {
            return _name;
        };

        virtual string getType() = 0;
};

/**
 * @class GroupOfNodesInstanceInstance
 * @brief Cette classe permet de definir des groupes de noeuds
 * @author Nicolas Sellenet
 */
class GroupOfNodesInstance: public VirtualMeshEntity
{
    public:
        /**
         * @brief Constructeur
         * @param name nom de l'entite
         */
        GroupOfNodesInstance(string name): VirtualMeshEntity(name)
        {};

        string getType()
        {
            return "GroupOfNodesInstance";
        }
};

/**
 * @class GroupOfElementsInstance
 * @brief Cette classe permet de definir des groupes de mailles
 * @author Nicolas Sellenet
 */
class GroupOfElementsInstance: public VirtualMeshEntity
{
    public:
        /**
         * @brief Constructeur
         * @param name nom de l'entite
         */
        GroupOfElementsInstance(string name): VirtualMeshEntity(name)
        {};

        string getType()
        {
            return "GroupOfElementsInstance";
        }
};

/**
 * @class AllMeshEntitiesInstance
 * @brief Cette classe permet de definir toutes les entites du maillage
 *        Equivalent du mot cle simple TOUT = 'OUI'
 * @author Nicolas Sellenet
 */
class AllMeshEntitiesInstance: public VirtualMeshEntity
{
    public:
        /**
         * @brief Constructeur
         * @param name nom de l'entite
         */
        AllMeshEntitiesInstance(): VirtualMeshEntity( "TOUT" )
        {};

        string getType()
        {
            return "AllMeshEntitiesInstance";
        }
};

/**
 * @class WrapperMeshEntity
 * @brief Enveloppe d'un pointeur intelligent vers un MeshEntityInstance
 * @author Nicolas Sellenet
 */
template< class MeshEntityInstance >
class WrapperMeshEntity
{
    public:
        typedef boost::shared_ptr< MeshEntityInstance > MeshEntityPtr;

    private:
        MeshEntityPtr _meshEntityPtr;

    public:
        WrapperMeshEntity(bool initialisation = true): _meshEntityPtr()
        {
            if ( initialisation == true )
                _meshEntityPtr = MeshEntityPtr( new MeshEntityInstance() );
        };

        WrapperMeshEntity(string name, JeveuxCollectionLong& grpOfEntities,
                          bool initialisation = true): _meshEntityPtr()
        {
            if ( initialisation == true )
                _meshEntityPtr = MeshEntityPtr( new MeshEntityInstance(name, grpOfEntities) );
        };

        WrapperMeshEntity(string name, bool initialisation = true): _meshEntityPtr()
        {
            if ( initialisation == true )
                _meshEntityPtr = MeshEntityPtr( new MeshEntityInstance(name) );
        };

        ~WrapperMeshEntity()
        {};

        const MeshEntityPtr& getPointer() const
        {
            return _meshEntityPtr;
        };

        WrapperMeshEntity& operator=(const WrapperMeshEntity& tmp)
        {
            _meshEntityPtr = tmp._meshEntityPtr;
            return *this;
        };

        const MeshEntityPtr& operator->() const
        {
            return _meshEntityPtr;
        };

        MeshEntityInstance& operator*(void) const
        {
            return *_meshEntityPtr;
        };

        bool isEmpty() const
        {
            if ( _meshEntityPtr.use_count() == 0 ) return true;
            return false;
        };
};

/** @typedef Definition d'un MeshEntity */
typedef class WrapperMeshEntity< VirtualMeshEntity > MeshEntity;
/** @typedef Definition d'un GroupOfNodes */
typedef class WrapperMeshEntity< GroupOfNodesInstance > GroupOfNodes;
/** @typedef Definition d'un GroupOfElements */
typedef class WrapperMeshEntity< GroupOfElementsInstance > GroupOfElements;
/** @typedef Definition d'un AllMeshEntities */
typedef class WrapperMeshEntity< AllMeshEntitiesInstance > AllMeshEntities;

#endif /* MESHENTITES_H_ */
