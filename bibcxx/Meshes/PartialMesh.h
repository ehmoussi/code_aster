
#include "astercxx.h"

#ifdef _USE_MPI

#ifndef PARTIALMESH_H_
#define PARTIALMESH_H_

/**
 * @file TestMesh.h
 * @brief Fichier entete de la classe 
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
#include "Meshes/ParallelMesh.h"

/**
 * @class PartialMeshInstance
 * @brief Cette classe decrit un maillage partiel reconstruit a partir d'une liste de groupe de noeuds
 * @author Nicolas Sellenet
 */
class PartialMeshInstance: public DataStructure
{
private:
    typedef JeveuxCollection< long, JeveuxBidirectionalMapChar24 > JeveuxCollectionLongNamePtr;
    /** @brief Objet Jeveux '.DIME' */
    JeveuxVectorLong             _dimensionInformations;
    /** @brief Pointeur de nom Jeveux '.NOMNOE' */
    JeveuxBidirectionalMapChar8  _nameOfNodes;
    /** @brief Champ aux noeuds '.COORDO' */
    MeshCoordinatesFieldPtr      _coordinates;
    /** @brief Pointeur de nom Jeveux '.PTRNOMNOE' */
    JeveuxBidirectionalMapChar24 _nameOfGrpNodes;
    /** @brief Collection Jeveux '.GROUPENO' */
     JeveuxCollectionLongNamePtr _groupsOfNodes;
    /** @brief Collection Je     veux '.CONNEX' */
    JeveuxCollectionLong         _connectivity;
    /** @brief Pointeur de nom Jeveux '.NOMMAIL' */
    JeveuxBidirectionalMapChar8  _nameOfElements;
    /** @brief Objet Jeveux '.TYPMAIL' */
    JeveuxVectorLong             _elementsType;
    /** @brief Booleen indiquant si le maillage est vide */
    bool                         _isEmpty;

public:
    /**
     * @typedef PartialMeshPtr
     * @brief Pointeur intelligent vers un PartialMeshInstance
     */
    typedef boost::shared_ptr< PartialMeshInstance > PartialMeshPtr;

    /**
     * @brief Constructeur
     */
    PartialMeshInstance( ParallelMeshPtr&, const VectorString& );

    /**
     * @brief Constructeur
     */
    static PartialMeshPtr create( ParallelMeshPtr& a, const VectorString& b )
    {
        return PartialMeshPtr( new PartialMeshInstance( a, b ) );
    };
};

#endif /* PARTIALMESH_H_ */

#endif /* _USE_MPI */
