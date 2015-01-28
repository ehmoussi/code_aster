#ifndef MESH_H_
#define MESH_H_

/**
 * @file Mesh.h
 * @brief Fichier entete de la classe Mesh
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

#include "definition.h"
#include "DataStructure/DataStructure.h"
#include "RunManager/Initializer.h"
#include "MemoryManager/JeveuxBidirectionalMap.h"
#include "DataFields/FieldOnNodes.h"
#include "Mesh/MeshEntities.h"
#include <assert.h>

/**
 * @class MeshInstance
 * @brief Cette classe decrit un maillage Aster
 * @author Nicolas Sellenet
 */
class MeshInstance: public DataStructure
{
    private:
        /** @brief Nom Jeveux du maillage */
        const string           _jeveuxName;
        /** @brief Objet Jeveux '.DIME' */
        JeveuxVectorLong       _dimensionInformations;
        /** @brief Pointeur de nom Jeveux '.NOMNOE' */
        JeveuxBidirectionalMap _nameOfNodes;
        /** @brief Champ aux noeuds '.COORDO' */
        FieldOnNodesPtrDouble     _coordinates;
        /** @brief Collection Jeveux '.GROUPENO' */
        JeveuxCollectionLong   _groupsOfNodes;
        /** @brief Collection Jeveux '.CONNEX' */
        JeveuxCollectionLong   _connectivity;
        /** @brief Pointeur de nom Jeveux '.NOMMAIL' */
        JeveuxBidirectionalMap _nameOfElements;
        /** @brief Objet Jeveux '.TYPMAIL' */
        JeveuxVectorLong       _elementsType;
        /** @brief Objet Jeveux '.GROUPEMA' */
        JeveuxCollectionLong   _groupsOfElements;
        /** @brief Booleen indiquant si le maillage est vide */
        bool                   _isEmpty;

    public:
        /**
         * @brief Constructeur
         */
        MeshInstance();

        /**
         * @brief Destructeur
         */
        ~MeshInstance()
        {};

        /**
         * @brief Recuperation des coordonnees du maillage
         * @return champ aux noeuds contenant les coordonnees des noeuds du maillage
         */
        const FieldOnNodesPtrDouble getCoordinates() const
        {
            return _coordinates;
        };

        /**
         * @brief Teste l'existence d'un groupe de mailles dans le maillage
         * @return true si le groupe existe
         */
        bool hasGroupOfElements( string name ) const
        {
            return _groupsOfElements->existsObject(name) ;
        };

        /**
         * @brief Teste l'existence d'un groupe de noeuds dans le maillage
         * @return true si le groupe existe
         */
        bool hasGroupOfNodes( string name ) const
        {
            return _groupsOfNodes->existsObject(name) ;
        };

        /**
         * @brief Fonction permettant de savoir si un maillage est vide (non relu par exemple)
         * @return retourne true si le maillage est vide
         */
        bool isEmpty() const
        {
            return _isEmpty;
        };

        /**
         * @brief Fonction permettant de relire un fichier MED
         * @param pathFichier path contenant le fichier fort.1 correspondant au fichier MED
         * @return retourne true si le maillage a correctement ete relu
         */
        bool readMEDFile( string pathFichier );
};



/**
 * @typedef Mesh
 * @brief Pointeur intelligent vers un MeshInstance
 */
typedef boost::shared_ptr< MeshInstance > Mesh;

#endif /* MESH_H_ */
