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
#include <set>

#include "astercxx.h"

#ifdef _USE_MPI

#include "Meshes/BaseMesh.h"

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
     * @brief Get the JeveuxVector for outer subdomain nodes
     * @return _outerNodes
     */
    const JeveuxVectorLong getNodesRank() const { return _outerNodes; };


    bool hasGroupOfCells( const std::string &name, const bool local) const;

    bool hasGroupOfCells( const std::string &name) const
    {
        return hasGroupOfCells(name, false);
    };

    bool hasGroupOfNodes( const std::string &name, const bool local) const;

    bool hasGroupOfNodes( const std::string &name ) const
    {
        return hasGroupOfNodes(name, false);
    };

    VectorString getGroupsOfCells(const bool local) const;

    VectorString getGroupsOfCells() const
    {
        return getGroupsOfCells(false);
    };

    VectorString getGroupsOfNodes(const bool local) const;

    VectorString getGroupsOfNodes() const
    {
        return getGroupsOfNodes(false);
    };

    const VectorLong getCells( const std::string name ) const;

    const VectorLong getCells(  ) const
    {
        return getCells( std::string() );
    };

    /**
     * @brief Return list of nodes
     * @param name name of group (if empty all the nodes)
     * @param local node id in local or global numbering
     * @param same_rank keep or not the nodes owned by the current domain
     * @return list of Nodes
     */

    const VectorLong getNodes( const std::string name, const bool local,
                               const bool same_rank) const; // 0

    const VectorLong getNodes( const std::string name, const bool local) const; // 0

    const VectorLong getNodes(  ) const
    {
        return getNodes ( std::string(), true);// ->0
    };

    const VectorLong getNodes( const std::string name ) const
    {
        return getNodes ( name, true);// ->0
    };

    const VectorLong getNodes( const bool local) const
    {
        return getNodes(std::string(), local); // ->0
    };

    const VectorLong getNodes( const bool local, const bool same_rank) const
    {
        return getNodes(std::string(), local, same_rank); // ->0
    };

    // const VectorLong getNodes( const bool same_rank ) const; //not possible

    // const VectorLong getNodes( const std::string name, const bool same_rank )
    // const; //not possible


    /**
     * @brief Fonction permettant de savoir si un maillage est parallel
     * @return retourne true si le maillage est parallel
     */
    virtual bool isParallel() const { return true; };

    /**
     * @brief Read a MED ParallelMesh file (already partitioned mesh)
     * @return retourne true si tout est ok
     */
    bool readPartitionedMedFile( const std::string &fileName );

    bool updateGlobalGroupOfNodes( void );

    bool updateGlobalGroupOfCells( void );
};

/**
 * @typedef ParallelMeshPtr
 * @brief Pointeur intelligent vers un ParallelMeshClass
 */
typedef boost::shared_ptr< ParallelMeshClass > ParallelMeshPtr;
#endif /* _USE_MPI */

#endif /* PARALLELMESH_H_ */
