#ifndef MESH_H_
#define MESH_H_

/**
 * @file Mesh.h
 * @brief Fichier entete de la classe Mesh
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

#include <assert.h>

#include "astercxx.h"
#include "definition.h"

#include "DataFields/MeshCoordinatesField.h"
#include "DataStructures/DataStructure.h"
#include "MemoryManager/JeveuxBidirectionalMap.h"
#include "Meshes/MeshEntities.h"
#include "Meshes/MeshExplorer.h"
#include "PythonBindings/LogicalUnitManager.h"
#include "Supervis/ResultNaming.h"

/**
 * @class BaseMeshClass
 * @brief Cette classe decrit un maillage Aster
 */
class BaseMeshClass : public DataStructure {
  public:
    typedef MeshExplorer< ElementBuilderFromConnectivity, const JeveuxCollectionLong &,
                          const JeveuxVectorLong & >
        ConnectivityMeshExplorer;

  protected:
    typedef JeveuxCollection< ASTERINTEGER, JeveuxBidirectionalMapChar24 >
        JeveuxCollectionLongNamePtr;
    /** @brief Objet Jeveux '.DIME' */
    JeveuxVectorLong _dimensionInformations;
    /** @brief Pointeur de nom Jeveux '.NOMNOE' */
    JeveuxBidirectionalMapChar8 _nameOfNodes;
    /** @brief Champ aux noeuds '.COORDO' */
    MeshCoordinatesFieldPtr _coordinates;
    /** @brief Pointeur de nom Jeveux '.PTRNOMNOE' */
    JeveuxBidirectionalMapChar24 _nameOfGrpNodes;
    /** @brief Collection Jeveux '.GROUPENO' */
    JeveuxCollectionLongNamePtr _groupOfNodes;
    /** @brief Collection Jeveux '.CONNEX' */
    JeveuxCollectionLong _connectivity;
    /** @brief Pointeur de nom Jeveux '.NOMMAIL' */
    JeveuxBidirectionalMapChar8 _nameOfCells;
    /** @brief Objet Jeveux '.TYPMAIL' */
    JeveuxVectorLong _elementsType;
    /** @brief Pointeur de nom Jeveux '.PTRNOMMAI' */
    JeveuxBidirectionalMapChar24 _nameOfGrpCells;
    /** @brief Objet Jeveux '.GROUPEMA' */
    JeveuxCollectionLongNamePtr _groupOfCells;
    /** @brief jeveux vector '.TITR' */
    JeveuxVectorChar80 _title;
    /** @brief Object to allow loop over connectivity */
    const ConnectivityMeshExplorer _explorer;

    /**
     * @brief Read a Aster Mesh file
     * @return retourne true si tout est ok
     */
    bool readMeshFile( const std::string &fileName, const std::string &format );

    /**
     * @brief Constructeur
     * @param name nom jeveux de l'objet
     * @param type jeveux de l'objet
     */
    BaseMeshClass( const std::string &name, const std::string &type )
        : DataStructure( name, 8, type ),
          _dimensionInformations( JeveuxVectorLong( getName() + ".DIME      " ) ),
          _nameOfNodes( JeveuxBidirectionalMapChar8( getName() + ".NOMNOE    " ) ),
          _coordinates( new MeshCoordinatesFieldClass( getName() + ".COORDO    " ) ),
          _nameOfGrpNodes( JeveuxBidirectionalMapChar24( getName() + ".PTRNOMNOE " ) ),
          _groupOfNodes(
              JeveuxCollectionLongNamePtr( getName() + ".GROUPENO  ", _nameOfGrpNodes ) ),
          _connectivity( JeveuxCollectionLong( getName() + ".CONNEX    " ) ),
          _nameOfCells( JeveuxBidirectionalMapChar8( getName() + ".NOMMAI    " ) ),
          _elementsType( JeveuxVectorLong( getName() + ".TYPMAIL   " ) ),
          _nameOfGrpCells( JeveuxBidirectionalMapChar24( getName() + ".PTRNOMMAI " ) ),
          _groupOfCells(
              JeveuxCollectionLongNamePtr( getName() + ".GROUPEMA  ", _nameOfGrpCells ) ),
          _title( JeveuxVectorChar80( getName() + "           .TITR" ) ),
          _explorer( ConnectivityMeshExplorer( _connectivity, _elementsType ) ){};

  public:
    /**
     * @typedef BaseMeshPtr
     * @brief Pointeur intelligent vers un BaseMeshClass
     */
    typedef boost::shared_ptr< BaseMeshClass > BaseMeshPtr;

    /**
     * @brief Get the connectivity
     */
    const ConnectivityMeshExplorer &getConnectivityExplorer() const {
        _elementsType->updateValuePointer();
        _connectivity->buildFromJeveux();
        return _explorer;
    };

    /**
     * @brief Recuperation des coordonnees du maillage
     * @return champ aux noeuds contenant les coordonnees des noeuds du maillage
     */
    MeshCoordinatesFieldPtr getCoordinates() const {
        _coordinates->updateValuePointers();
        return _coordinates;
    };

    /**
     * @brief Recuperation d'un groupe de noeuds
     * @return Objet de collection contenant la liste des noeuds
     */
    const JeveuxCollectionObject< ASTERINTEGER > &
    getGroupOfNodesObject( const std::string &name ) const {
        if ( _groupOfNodes->size() == -1 )
            _groupOfNodes->buildFromJeveux();
        return _groupOfNodes->getObjectFromName( name );
    };

    /**
     * @brief Get all the names of group of elements
     * @return JeveuxBidirectionalMapChar24 _nameOfGrpCells
     */
    const JeveuxBidirectionalMapChar24 &getGroupsOfNodesMap() const { return _nameOfGrpCells; };

    /**
     * @brief Returns the number of nodes
     */
    int getNumberOfNodes() const;

    /**
     * @brief Returns the number of cells
     */
    int getNumberOfCells() const;

    /**
     * @brief Recuperation de la dimension du maillage
     */
    int getDimension() const;

    /**
     * @brief Teste l'existence d'un groupe de mailles dans le maillage
     * @return true si le groupe existe
     */
    virtual bool hasGroupOfCells( const std::string &name ) const {
        throw std::runtime_error( "Not allowed" );
    };

    /**
     * @brief Teste l'existence d'un groupe de noeuds dans le maillage
     * @return true si le groupe existe
     */
    virtual bool hasGroupOfNodes( const std::string &name ) const {
        throw std::runtime_error( "Not allowed" );
    };

    /**
     * @brief Returns the names of the groups of cells
     * @return VectorString
     */
    VectorString getGroupsOfCells() const {
        VectorString names;
        return names;
    };

    /**
     * @brief Returns the names of the groups of nodes
     * @return VectorString
     */
    VectorString getGroupsOfNodes() const {
        VectorString names;
        return names;
    };

    /**
     * @brief Fonction permettant de savoir si un maillage est vide (non relu par exemple)
     * @return retourne true si le maillage est vide
     */
    bool isEmpty() const { return !_dimensionInformations->exists(); };

    /**
     * @brief Fonction permettant de savoir si un maillage est parallel
     * @return retourne true si le maillage est parallel
     */
    virtual bool isParallel() const { return false; };

    /**
     * @brief Fonction permettant de savoir si un maillage est partiel
     * @return retourne true si le maillage est partiel
     */
    virtual bool isPartial() const { return false; };

    /**
     * @brief Read a MED Mesh file
     * @return retourne true si tout est ok
     */
    virtual bool readMedFile( const std::string &fileName );
};

/**
 * @class MeshClass
 * @brief Cette classe decrit un maillage Aster
 */
class MeshClass : public BaseMeshClass {
  protected:
    /**
     * @brief Constructeur
     */
    MeshClass( const std::string name, const std::string type ) : BaseMeshClass( name, type ){};

  public:
    /**
     * @typedef MeshPtr
     * @brief Pointeur intelligent vers un MeshClass
     */
    typedef boost::shared_ptr< MeshClass > MeshPtr;

    /**
     * @brief Constructeur
     */
    MeshClass() : BaseMeshClass( ResultNaming::getNewResultName(), "MAILLAGE" ){};

    /**
     * @brief Constructeur
     */
    MeshClass( const std::string name ) : BaseMeshClass( name, "MAILLAGE" ){};

    /**
     * @brief Ajout d'un groupe de noeuds au maillage en partant d'une liste noeuds
     * @param name nom du groupe à créer
     * @param vec liste des noeuds
     * @return Retourne true si tout s'est bien déroulé
     */
    bool addGroupOfNodesFromNodes( const std::string &name, const VectorString &vec );

    /**
     * @brief Teste l'existence d'un groupe de mailles dans le maillage
     * @return true si le groupe existe
     */
    bool hasGroupOfCells( const std::string &name ) const {
        return _groupOfCells->existsObject( name );
    };

    /**
     * @brief Teste l'existence d'un groupe de noeuds dans le maillage
     * @return true si le groupe existe
     */
    bool hasGroupOfNodes( const std::string &name ) const {
        return _groupOfNodes->existsObject( name );
    };

    VectorString getGroupsOfCells() const;

    VectorString getGroupsOfNodes() const;

    /**
     * @brief Read a Aster Mesh file
     * @return retourne true si tout est ok
     */
    bool readAsterFile( const std::string &fileName );

    /**
     * @brief Read a Gibi Mesh file
     * @return retourne true si tout est ok
     */
    bool readGibiFile( const std::string &fileName );

    /**
     * @brief Read a Gmsh Mesh file
     * @return retourne true si tout est ok
     */
    bool readGmshFile( const std::string &fileName );
};

/**
 * @typedef BaseMeshPtr
 * @brief Pointeur intelligent vers un BaseMeshClass
 */
typedef boost::shared_ptr< BaseMeshClass > BaseMeshPtr;

/**
 * @typedef MeshPtr
 * @brief Pointeur intelligent vers un MeshClass
 */
typedef boost::shared_ptr< MeshClass > MeshPtr;

#endif /* MESH_H_ */
