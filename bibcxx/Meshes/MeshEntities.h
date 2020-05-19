#ifndef MESHENTITES_H_
#define MESHENTITES_H_

/**
 * @file MeshEntities.h
 * @brief Fichier entete de la classe MeshEntities
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

#include "MemoryManager/JeveuxCollection.h"

enum EntityType {
    GroupOfNodesType,
    GroupOfCellsType,
    AllMeshEntitiesType,
    CellType,
    NodeType,
    NoType
};

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
class VirtualMeshEntity {
  private:
    /** @brief Nom de l'entite */
    const VectorString _names;

  protected:
    /** @brief Type de l'entite */
    const EntityType _type;

  public:
    /**
     * @brief Constructeur
     * @param name nom de l'entite
     */
    VirtualMeshEntity( const std::string &name, EntityType type )
        : _names( {name} ), _type( type ){};

    /**
     * @brief Constructor
     * @param names names in entity
     */
    VirtualMeshEntity( const VectorString &names, EntityType type )
        : _names( names ), _type( type ){};

    /**
     * @brief Obtenir le nom de l'entite
     * @return renvoit le nom de l'entite
     */
    const std::string &getName() const {
        if ( _names.size() > 1 )
            throw std::runtime_error( "Error in mesh entity. This entity must not be a list" );

        return _names[0];
    };

    /**
     * @brief Get the names inside the entity
     * @return vector of strings
     */
    VectorString getNames() { return _names; };

    EntityType getType() const { return _type; };
};

/**
 * @class GroupOfNodes
 * @brief Cette classe permet de definir des groupes de noeuds
 * @author Nicolas Sellenet
 */
class GroupOfNodes : public VirtualMeshEntity {
  public:
    /**
     * @brief Constructeur
     * @param name nom de l'entite
     */
    GroupOfNodes( std::string name ) : VirtualMeshEntity( name, GroupOfNodesType ){};

    /**
     * @brief Constructor
     * @param names names in entity
     */
    GroupOfNodes( const VectorString &names ) : VirtualMeshEntity( names, GroupOfNodesType ){};
};

/**
 * @class GroupOfCells
 * @brief Cette classe permet de definir des groupes de mailles
 * @author Nicolas Sellenet
 */
class GroupOfCells : public VirtualMeshEntity {
  public:
    /**
     * @brief Constructeur
     * @param name nom de l'entite
     */
    GroupOfCells( std::string name ) : VirtualMeshEntity( name, GroupOfCellsType ){};

    /**
     * @brief Constructor
     * @param names names in entity
     */
    GroupOfCells( const VectorString &names ) : VirtualMeshEntity( names, GroupOfCellsType ){};
};

/**
 * @class AllMeshEntities
 * @brief Cette classe permet de definir toutes les entites du maillage
 *        Equivalent du mot cle simple TOUT = 'OUI'
 * @author Nicolas Sellenet
 */
class AllMeshEntities : public VirtualMeshEntity {
  public:
    /**
     * @brief Constructeur
     * @param name nom de l'entite
     */
    AllMeshEntities() : VirtualMeshEntity( "OUI", AllMeshEntitiesType ){};
};

/**
 * @class Cell
 * @brief Cette classe permet de definir des éléments du maillage
 * @author Nicolas Sellenet
 */
class Cell : public VirtualMeshEntity {
  public:
    /**
     * @brief Constructeur
     * @param name nom de l'entite
     */
    Cell( std::string name ) : VirtualMeshEntity( name, CellType ){};

    /**
     * @brief Constructor
     * @param names names in entity
     */
    Cell( const VectorString &names ) : VirtualMeshEntity( names, CellType ){};
};

/**
 * @class Node
 * @brief Cette classe permet de definir des noeuds du maillage
 * @author Nicolas Sellenet
 */
class Node : public VirtualMeshEntity {
  public:
    /**
     * @brief Constructeur
     * @param name nom de l'entite
     */
    Node( std::string name ) : VirtualMeshEntity( name, NodeType ){};

    /**
     * @brief Constructor
     * @param names names in entity
     */
    Node( const VectorString &names ) : VirtualMeshEntity( names, NodeType ){};
};

typedef boost::shared_ptr< VirtualMeshEntity > MeshEntityPtr;
typedef std::vector< MeshEntityPtr > VectorOfMeshEntityPtr;

typedef boost::shared_ptr< GroupOfNodes > GroupOfNodesPtr;
typedef std::vector< GroupOfNodesPtr > VectorOfGroupOfNodesPtr;

typedef boost::shared_ptr< GroupOfCells > GroupOfCellsPtr;
typedef std::vector< GroupOfCellsPtr > VectorOfGroupOfCellsPtr;

typedef boost::shared_ptr< AllMeshEntities > AllMeshEntitiesPtr;
typedef std::vector< AllMeshEntitiesPtr > VectorOfAllMeshEntitiesPtr;

#endif /* MESHENTITES_H_ */
