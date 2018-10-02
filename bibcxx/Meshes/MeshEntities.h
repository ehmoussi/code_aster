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

#include "MemoryManager/JeveuxCollection.h"

enum EntityType { GroupOfNodesType, GroupOfElementsType, AllMeshEntitiesType,
                  ElementType, NodeType, NoType };

/**
 * @todo Un MeshEntity pourrait etre concu comme un template qui prendrait
         son type et sa syntaxe Aster en argument
         Comme ca on aurait pas a faire de if dans le C++
 */

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
        const std::string _name;

    protected:
        /** @brief Type de l'entite */
        const EntityType  _type;

    public:
        /**
         * @brief Constructeur
         * @param name nom de l'entite
         */
        VirtualMeshEntity( std::string name, EntityType type ): _name( name ), _type( type )
        {};

        /**
         * @brief Obtenir le nom de l'entite
         * @return renvoit le nom de l'entite
         */
        const std::string& getName() const
        {
            return _name;
        };

        virtual EntityType getType() const = 0;
};

/**
 * @class GroupOfNodesInstance
 * @brief Cette classe permet de definir des groupes de noeuds
 * @author Nicolas Sellenet
 */
class GroupOfNodes: public VirtualMeshEntity
{
    public:
        /**
         * @brief Constructeur
         * @param name nom de l'entite
         */
        GroupOfNodes( std::string name ): VirtualMeshEntity( name, GroupOfNodesType )
        {};

        EntityType getType() const
        {
            return _type;
        };
};

/**
 * @class GroupOfElements
 * @brief Cette classe permet de definir des groupes de mailles
 * @author Nicolas Sellenet
 */
class GroupOfElements: public VirtualMeshEntity
{
    public:
        /**
         * @brief Constructeur
         * @param name nom de l'entite
         */
        GroupOfElements( std::string name ): VirtualMeshEntity( name, GroupOfElementsType )
        {};

        EntityType getType() const
        {
            return _type;
        };
};

/**
 * @class AllMeshEntities
 * @brief Cette classe permet de definir toutes les entites du maillage
 *        Equivalent du mot cle simple TOUT = 'OUI'
 * @author Nicolas Sellenet
 */
class AllMeshEntities: public VirtualMeshEntity
{
    public:
        /**
         * @brief Constructeur
         * @param name nom de l'entite
         */
        AllMeshEntities(): VirtualMeshEntity( "OUI", AllMeshEntitiesType )
        {};

        EntityType getType() const
        {
            return _type;
        };
};

/**
 * @class ElementEntities
 * @brief Cette classe permet de definir des éléments du maillage
 * @author Nicolas Sellenet
 */
class Element: public VirtualMeshEntity
{
    public:
        /**
         * @brief Constructeur
         * @param name nom de l'entite
         */
        Element( std::string name ): VirtualMeshEntity( name, ElementType )
        {};

        EntityType getType() const
        {
            return _type;
        };
};

/**
 * @class NodeEntities
 * @brief Cette classe permet de definir des noeuds du maillage
 * @author Nicolas Sellenet
 */
class Node: public VirtualMeshEntity
{
    public:
        /**
         * @brief Constructeur
         * @param name nom de l'entite
         */
        Node( std::string name ): VirtualMeshEntity( name, NodeType )
        {};

        EntityType getType() const
        {
            return _type;
        };
};

typedef boost::shared_ptr< VirtualMeshEntity > MeshEntityPtr;
typedef std::vector< MeshEntityPtr > VectorOfMeshEntityPtr;

typedef boost::shared_ptr< GroupOfNodes > GroupOfNodesPtr;
typedef std::vector< GroupOfNodesPtr > VectorOfGroupOfNodesPtr;

typedef boost::shared_ptr< GroupOfElements > GroupOfElementsPtr;
typedef std::vector< GroupOfElementsPtr > VectorOfGroupOfElementsPtr;

typedef boost::shared_ptr< Element > ElementPtr;
typedef std::vector< ElementPtr > VectorOfElementPtr;

typedef boost::shared_ptr< Node > NodePtr;
typedef std::vector< NodePtr > VectorOfNodePtr;

#endif /* MESHENTITES_H_ */
