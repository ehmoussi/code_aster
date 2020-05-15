
#include "astercxx.h"

#ifdef _USE_MPI

#ifndef PARALLELMESH_H_
#define PARALLELMESH_H_

/**
 * @file ParallelMesh.h
 * @brief Fichier entete de la classe ParallelMesh
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

#include "Meshes/Mesh.h"
#include "astercxx.h"
#include "definition.h"
#include <set>

/**
 * @class ParallelMeshClass
 * @brief Cette classe decrit un maillage Aster parallèle
 * @author Nicolas Sellenet
 */
class ParallelMeshClass : public BaseMeshClass {
  private:
    typedef std::set< std::string > SetOfString;
    typedef SetOfString::iterator SetOfStringIter;
    typedef SetOfString::const_iterator SetOfStringCIter;

    /** @brief All groups of nodes (parallel mesh) */
    JeveuxVectorChar24 _globalGroupOfNodes;
    /** @brief Set of all groups of nodes (parallel mesh) */
    SetOfString _setOfAllGON;
    /** @brief All groups of cells (parallel mesh) */
    JeveuxVectorChar24 _globalGroupOfCells;
    /** @brief Set of all groups of cells (parallel mesh) */
    SetOfString _setOfAllGOE;
    /** @brief Identify outer nodes */
    JeveuxVectorLong _outerNodes;
    /** @brief Global numbering */
    JeveuxVectorLong _globalNumbering;
    /** @brief List of opposite domain */
    JeveuxVectorChar24 _listOfOppositeDomain;
    /** @brief Vector of JeveuxVectorLong which contains matching nodes */
    std::vector< JeveuxVectorLong > _vectorOfMatchingNodes;

  public:
    /**
     * @typedef ParallelMeshPtr
     * @brief Pointeur intelligent vers un ParallelMeshClass
     */
    typedef boost::shared_ptr< ParallelMeshClass > ParallelMeshPtr;

    /**
     * @brief Constructeur
     */
    ParallelMeshClass() : ParallelMeshClass( ResultNaming::getNewResultName() ){};

    /**
     * @brief Constructeur
     */
    ParallelMeshClass( const std::string &name )
        : BaseMeshClass( name, "MAILLAGE_P" ), _globalGroupOfNodes( getName() + ".PAR_GRPNOE" ),
          _globalGroupOfCells( getName() + ".PAR_GRPMAI" ), _outerNodes( getName() + ".NOEX" ),
          _globalNumbering( getName() + ".NULOGL" ),
          _listOfOppositeDomain( getName() + ".DOMJOINTS" ){};

    /**
     * @brief Get the JeveuxVector for global nodes numbering
     * @return _globalNumbering
     */
    const JeveuxVectorLong getGlobalNodesNumbering() const { return _globalNumbering; };

    /**
     * @brief Get the JeveuxVector for outer subdomain nodes
     * @return _outerNodes
     */
    const JeveuxVectorLong getOuterNodesVector() const { return _outerNodes; };

    /**
     * @brief Teste l'existence d'un groupe de mailles dans le maillage
     * @return true si le groupe existe
     */
    bool hasGroupOfCells( const std::string &name ) const {
        SetOfStringCIter curIter = _setOfAllGOE.find( name );
        if ( curIter != _setOfAllGOE.end() )
            return true;
        return false;
    };

    /**
     * @brief Teste l'existence d'un groupe de noeuds dans le maillage
     * @return true si le groupe existe
     */
    bool hasGroupOfNodes( const std::string &name ) const {
        SetOfStringCIter curIter = _setOfAllGON.find( name );
        if ( curIter != _setOfAllGON.end() )
            return true;
        return false;
    };

    /**
     * @brief Teste l'existence d'un groupe de mailles dans le maillage
     * @return true si le groupe existe
     */
    bool hasLocalGroupOfCells( const std::string &name ) const {
        return _groupsOfCells->existsObject( name );
    };

    /**
     * @brief Teste l'existence d'un groupe de noeuds dans le maillage
     * @return true si le groupe existe
     */
    bool hasLocalGroupOfNodes( const std::string &name ) const {
        return _groupsOfNodes->existsObject( name );
    };

    /**
     * @brief Fonction permettant de savoir si un maillage est parallel
     * @return retourne true si le maillage est parallel
     */
    virtual bool isParallel() const { return true; };

    /**
     * @brief Read a MED ParallelMesh file
     * @return retourne true si tout est ok
     */
    bool readMedFile( const std::string &fileName );

    /**
     * @brief Read a MED ParallelMesh file
     * @return retourne true si tout est ok
     */
    bool updateGlobalGroupOfNodes( void );

    bool updateGlobalGroupOfCells( void );
};

/**
 * @typedef ParallelMeshPtr
 * @brief Pointeur intelligent vers un ParallelMeshClass
 */
typedef boost::shared_ptr< ParallelMeshClass > ParallelMeshPtr;

#endif /* PARALLELMESH_H_ */

#endif /* _USE_MPI */
