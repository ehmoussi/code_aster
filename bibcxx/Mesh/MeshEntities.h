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

enum EntityType { GroupOfNodesType, GroupOfElementsType, AllMeshEntitiesType, NoType };

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
        const std::string& getEntityName()
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
        AllMeshEntities(): VirtualMeshEntity( "TOUT", AllMeshEntitiesType )
        {};

        EntityType getType() const
        {
            return _type;
        };
};

#endif /* MESHENTITES_H_ */
