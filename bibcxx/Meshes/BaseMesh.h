#ifndef BASEMESH_H_
#define BASEMESH_H_

/**
 * @file BaseMesh.h
 * @brief Fichier entete de la classe BaseMesh
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

#include "astercxx.h"

#include "DataFields/MeshCoordinatesField.h"
#include "DataStructures/DataStructure.h"
#include "MemoryManager/NamesMap.h"
#include "Meshes/MeshExplorer.h"

/**
 * @class BaseMeshClass
 * @brief This object is the base class for all meshes variants
 */
class BaseMeshClass : public DataStructure {
  public:
    typedef MeshExplorer< CellsIteratorFromConnectivity, const JeveuxCollectionLong &,
                          const JeveuxVectorLong & >
        ConnectivityMeshExplorer;

  protected:
    typedef JeveuxCollection< ASTERINTEGER, NamesMapChar24 > JeveuxCollectionLongNamePtr;
    /** @brief Objet Jeveux '.DIME' */
    JeveuxVectorLong _dimensionInformations;
    /** @brief Pointeur de nom Jeveux '.NOMNOE' */
    NamesMapChar8 _nameOfNodes;
    /** @brief Champ aux noeuds '.COORDO' */
    MeshCoordinatesFieldPtr _coordinates;
    /** @brief Pointeur de nom Jeveux '.PTRNOMNOE' */
    NamesMapChar24 _nameOfGrpNodes;
    /** @brief Collection Jeveux '.GROUPENO' */
    JeveuxCollectionLongNamePtr _groupsOfNodes;
    /** @brief Collection Jeveux '.CONNEX' */
    JeveuxCollectionLong _connectivity;
    /** @brief Pointeur de nom Jeveux '.NOMMAIL' */
    NamesMapChar8 _nameOfCells;
    /** @brief Objet Jeveux '.TYPMAIL' */
    JeveuxVectorLong _cellsType;
    /** @brief Pointeur de nom Jeveux '.PTRNOMMAI' */
    NamesMapChar24 _nameOfGrpCells;
    /** @brief Objet Jeveux '.GROUPEMA' */
    JeveuxCollectionLongNamePtr _groupsOfCells;
    /** @brief jeveux vector '.TITR' */
    JeveuxVectorChar80 _title;
    /** @brief Object to allow loop over connectivity */
    const ConnectivityMeshExplorer _explorer;

    /**
     * @brief Constructeur
     * @param name nom jeveux de l'objet
     * @param type jeveux de l'objet
     */
    BaseMeshClass( const std::string &name, const std::string &type )
        : DataStructure( name, 8, type ),
          _dimensionInformations( JeveuxVectorLong( getName() + ".DIME      " ) ),
          _nameOfNodes( NamesMapChar8( getName() + ".NOMNOE    " ) ),
          _coordinates( new MeshCoordinatesFieldClass( getName() + ".COORDO    " ) ),
          _nameOfGrpNodes( NamesMapChar24( getName() + ".PTRNOMNOE " ) ),
          _groupsOfNodes(
              JeveuxCollectionLongNamePtr( getName() + ".GROUPENO  ", _nameOfGrpNodes ) ),
          _connectivity( JeveuxCollectionLong( getName() + ".CONNEX    " ) ),
          _nameOfCells( NamesMapChar8( getName() + ".NOMMAI    " ) ),
          _cellsType( JeveuxVectorLong( getName() + ".TYPMAIL   " ) ),
          _nameOfGrpCells( NamesMapChar24( getName() + ".PTRNOMMAI " ) ),
          _groupsOfCells(
              JeveuxCollectionLongNamePtr( getName() + ".GROUPEMA  ", _nameOfGrpCells ) ),
          _title( JeveuxVectorChar80( getName() + "           .TITR" ) ),
          _explorer( ConnectivityMeshExplorer( _connectivity, _cellsType ) ){};

    /**
     * @brief Read a Mesh file
     * @return return true if it succeeds, false otherwise
     */
    bool readMeshFile( const std::string &fileName, const std::string &format );

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
        _cellsType->updateValuePointer();
        _connectivity->buildFromJeveux();
        return _explorer;
    };

    /**
     * @brief Return the connectivity
     */
    const JeveuxCollectionLong getConnectivity() const { return _connectivity; }

    /**
     * @brief Return the connectivity with MED numberings
     */
    const JeveuxCollectionLong getMedConnectivity() const;

    /**
     * @brief Return the MED type for each cell
     */
    const JeveuxVectorLong getMedCellsTypes() const;

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
        if ( _groupsOfNodes->size() == -1 )
            _groupsOfNodes->buildFromJeveux();
        return _groupsOfNodes->getObjectFromName( name );
    };

    /**
     * @brief Get all the names of group of cells
     * @return NamesMapChar24 _nameOfGrpCells
     */
    const NamesMapChar24 &getGroupsOfNodesMap() const { return _nameOfGrpCells; };

    /**
     * @brief Returns the number of nodes
     */
    int getNumberOfNodes() const;

    /**
     * @brief Returns the number of cells
     */
    int getNumberOfCells() const;

    /**
     * @brief Get all the names of nodes
     * @return NamesMapChar8 _nameOfNodes
     */
    const NamesMapChar8 &getNameOfNodesMap() const { return _nameOfNodes; };

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
    virtual VectorString getGroupsOfCells() const { throw std::runtime_error( "Not allowed" ); };

    /**
     * @brief Returns the names of the groups of nodes
     * @return VectorString
     */
    virtual VectorString getGroupsOfNodes() const { throw std::runtime_error( "Not allowed" ); };

    /**
     * @brief Returns the cells indexes of a group of cells
     * @return VectorLong
     */
    virtual const VectorLong getCells( const std::string name ) const {
        throw std::runtime_error( "Not allowed" );
    }

    /**
     * @brief Returns the nodes indexes of a group of nodes
     * @return VectorLong
     */
    virtual const VectorLong getNodes( const std::string name ) const {
        throw std::runtime_error( "Not allowed" );
    }

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
 * @typedef BaseMeshPtr
 * @brief Pointeur intelligent vers un BaseMeshClass
 */
typedef boost::shared_ptr< BaseMeshClass > BaseMeshPtr;

#endif /* BASEMESH_H_ */
