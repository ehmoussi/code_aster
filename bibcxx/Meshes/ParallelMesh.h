
#include "astercxx.h"

#ifdef _USE_MPI

#ifndef PARALLELMESH_H_
#define PARALLELMESH_H_

/**
 * @file ParallelMesh.h
 * @brief Fichier entete de la classe ParallelMesh
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2017  EDF R&D                www.code-aster.org
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
#include "definition.h"
#include "Meshes/Mesh.h"
#include <set>

/**
 * @class ParallelMeshInstance
 * @brief Cette classe decrit un maillage Aster parallèle
 * @author Nicolas Sellenet
 */
class ParallelMeshInstance: public BaseMeshInstance
{
private:
    typedef std::set< std::string > SetOfString;
    typedef SetOfString::iterator SetOfStringIter;
    typedef SetOfString::const_iterator SetOfStringCIter;

    /** @brief All groups of nodes (parallel mesh) */
    JeveuxVectorChar32  _allGroupOfNodes;
    /** @brief Set of all groups of nodes (parallel mesh) */
    SetOfString         _setOfAllGON;
    /** @brief All groups of elements (parallel mesh) */
    JeveuxVectorChar32  _allGroupOfEements;
    /** @brief Set of all groups of elements (parallel mesh) */
    SetOfString         _setOfAllGOE;
    /** @brief Identify outer nodes */
    JeveuxVectorLong    _outerNodes;
    /** @brief Global numbering */
    JeveuxVectorLong    _globalNumbering;
    /** @brief List of joins (send) */
    JeveuxVectorChar24  _listOfSendingJoins;
    /** @brief List of joins (receive) */
    JeveuxVectorChar24  _listOfReceivingJoins;
    /** @brief List of opposite domain */
    JeveuxVectorChar24  _listOfOppositeDomain;
    /** @brief Vector of JeveuxVectorLong which contains matching nodes */
    std::vector< JeveuxVectorLong > _vectorOfMatchingNodes;

public:
    /**
     * @typedef ParallelMeshPtr
     * @brief Pointeur intelligent vers un ParallelMeshInstance
     */
    typedef boost::shared_ptr< ParallelMeshInstance > ParallelMeshPtr;

    /**
     * @brief Constructeur
     */
    static ParallelMeshPtr create()
    {
        return ParallelMeshPtr( new ParallelMeshInstance );
    };

    /**
     * @brief Constructeur
     */
    ParallelMeshInstance();

    /**
     * @brief Destructeur
     */
    ~ParallelMeshInstance() throw ( std::runtime_error )
    {
#ifdef __DEBUG_GC__
        std::cout << "ParallelMesh.destr: " << this->getName() << std::endl;
#endif
    };

    /**
     * @brief Get the JeveuxVector for global nodes numbering
     * @return _globalNumbering
     */
    const JeveuxVectorLong getGlobalNodesNumbering() const
    {
        return _globalNumbering;
    };

    /**
     * @brief Get the JeveuxVector for outer subdomain nodes
     * @return _outerNodes
     */
    const JeveuxVectorLong getOuterNodesVector() const
    {
        return _outerNodes;
    };

    /**
     * @brief Teste l'existence d'un groupe de mailles dans le maillage
     * @return true si le groupe existe
     */
    bool hasGroupOfElements( const std::string& name ) const
    {
        SetOfStringCIter curIter = _setOfAllGOE.find( name );
        if( curIter != _setOfAllGOE.end() )
            return true;
        return false;
    };

    /**
     * @brief Teste l'existence d'un groupe de noeuds dans le maillage
     * @return true si le groupe existe
     */
    bool hasGroupOfNodes( const std::string& name ) const
    {
        SetOfStringCIter curIter = _setOfAllGON.find( name );
        if( curIter != _setOfAllGON.end() )
            return true;
        return false;
    };

    /**
     * @brief Teste l'existence d'un groupe de mailles dans le maillage
     * @return true si le groupe existe
     */
    bool hasLocalGroupOfElements( const std::string& name ) const
    {
        return _groupsOfElements->existsObject(name);
    };

    /**
     * @brief Teste l'existence d'un groupe de noeuds dans le maillage
     * @return true si le groupe existe
     */
    bool hasLocalGroupOfNodes( const std::string& name ) const
    {
        return _groupsOfNodes->existsObject(name);
    };

    /**
     * @brief Fonction permettant de savoir si un maillage est parallel
     * @return retourne true si le maillage est parallel
     */
    virtual bool isParallel() const
    {
        return true;
    };

    /**
     * @brief Read a MED ParallelMesh file
     * @return retourne true si tout est ok
     */
    bool readMedFile( const std::string& fileName ) throw ( std::runtime_error );
};

/**
 * @typedef ParallelMeshPtr
 * @brief Pointeur intelligent vers un ParallelMeshInstance
 */
typedef boost::shared_ptr< ParallelMeshInstance > ParallelMeshPtr;

#endif /* PARALLELMESH_H_ */

#endif /* _USE_MPI */