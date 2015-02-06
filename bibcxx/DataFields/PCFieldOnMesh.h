#ifndef PCFIELDONMESH_H_
#define PCFIELDONMESH_H_

/**
 * @file PCFieldOnMesh.h
 * @brief Fichier entete de la classe PCFieldOnMesh
 * @author Natacha Bereux
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

/* person_in_charge: natacha.bereux at edf.fr */

#include <stdexcept>
#include <string>
#include <assert.h>

#include "astercxx.h"
#include "MemoryManager/JeveuxCollection.h"
#include "MemoryManager/JeveuxVector.h"
#include "Mesh/Mesh.h"

/**
 * @class Piecewise Constant (PC) Field on Mesh template
 * @brief Cette classe permet de definir une carte (champ défini sur les mailles)
 * @author Natacha Bereux
 */
template<class ValueType>
class PCFieldOnMeshInstance
{
    private:
        /** @brief Nom Jeveux de la carte */
        std::string             _name;
        /** @brief Vecteur Jeveux '.NOMA' */
        JeveuxVectorChar8       _meshName;
        /** @brief Vecteur Jeveux '.DESC' */
        JeveuxVectorLong        _descriptor;
        /** @brief Vecteur Jeveux '.NOLI' */
        JeveuxVectorChar24      _nameOfLigrels;
        /** @brief Collection  '.LIMA' */
        JeveuxCollectionLong    _listOfMeshElements;
        /** @brief Vecteur Jeveux '.VALE' */
        JeveuxVector<ValueType> _valuesList;
        /** @brief Maillage sous-jacent */
        MeshPtr                 _supportMesh;

    public:
        /**
         * @brief Constructeur
         * @param name Nom Jeveux de la carte
         */
        PCFieldOnMeshInstance( std::string name ):
                                            _name( name ),
                                            _meshName( JeveuxVectorChar8( name+".NOMA" ) ),
                                            _descriptor( JeveuxVectorLong( name+".DESC" ) ),
                                            _nameOfLigrels( JeveuxVectorChar24( name+".NOLI" ) ),
                                            _listOfMeshElements( JeveuxCollectionLong( name+".LIMA" ) ),
                                            _valuesList( JeveuxVector<ValueType>( name+".VALE" ) ),
                                            _supportMesh( MeshPtr() )
        {
            assert(name.size() == 19);
        };


        /**
         * @brief Mise a jour des pointeurs Jeveux
         * @return true si la mise a jour s'est bien deroulee, false sinon
         */
        bool updateValuePointers()
        {
            bool retour = _meshName->updateValuePointer();
            retour = ( retour && _descriptor->updateValuePointer() );
            retour = ( retour && _valuesList->updateValuePointer() );
            // Les deux elements suivants sont facultatifs
            _listOfMeshElements->buildFromJeveux();
            _nameOfLigrels->updateValuePointer();
            return retour;
        };

        /**
         * @brief Définition du maillage sous-jacent
         * @param currentMesh objet Mesh sur lequel le modele reposera
         * @return renvoit true si la définition  s'est bien deroulee, false sinon
         */
        bool setSupportMesh(MeshPtr& currentMesh) throw ( std::runtime_error )
        {
            if ( currentMesh->isEmpty() )
                throw std::runtime_error( "Mesh is empty" );
            _supportMesh = currentMesh;
            return true;
        };
};

/** @typedef PCFieldOnMeshInstanceDouble Instance d'une carte de double */
typedef PCFieldOnMeshInstance< double > PCFieldOnMeshInstanceDouble;
/** @typedef PCFieldOnMeshInstanceDouble Instance d'une carte de double */
typedef PCFieldOnMeshInstance< JeveuxChar8 > PCFieldOnMeshInstanceChar8;

/**
 * @typedef PCFieldOnMeshPtrDouble
 * @brief   Definition d'une carte de double
 */
typedef boost::shared_ptr< PCFieldOnMeshInstanceDouble > PCFieldOnMeshPtrDouble;
/**
 * @typedef PCFieldOnMeshPtrChar8 Definition d'une carte de char[8]
 * @brief Pointeur intelligent vers un PCFieldOnMeshInstance
 */
typedef boost::shared_ptr< PCFieldOnMeshInstanceChar8 > PCFieldOnMeshPtrChar8;

#endif /* PCFIELDONMESH_H_ */
