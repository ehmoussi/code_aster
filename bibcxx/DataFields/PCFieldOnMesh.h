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

#include <string>
#include <assert.h>

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
        string                  _name;
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
        Mesh                    _supportMesh;

    public:
        /**
         * @brief Constructeur
         * @param name Nom Jeveux de la carte
         */
        PCFieldOnMeshInstance( string name ): _name( name ),
                                              _meshName( JeveuxVectorChar8( name+".NOMA" ) ),
                                              _descriptor( JeveuxVectorLong( string( name+".DESC" ) ) ),
                                              _nameOfLigrels( JeveuxVectorChar24( string( name+".NOLI") ) ),
                                              _listOfMeshElements( JeveuxCollectionLong( string( name+".LIMA") ) ),
                                              _valuesList( JeveuxVector<ValueType>( string( name+".VALE") ) ),
                                              _supportMesh( Mesh() )
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
        bool setSupportMesh(Mesh& currentMesh)
        {
            if ( currentMesh->isEmpty() )
                throw string("Mesh is empty");
            _supportMesh = currentMesh;
            return true;
        };
};

/**
 * @class PCFieldOnMesh template
 * @brief Enveloppe d'un pointeur intelligent vers un PCFieldOnMeshInstance
 * @author Natacha Bereux
 */
template<class ValueType>
class PCFieldOnMesh
{
    public:
        typedef boost::shared_ptr< PCFieldOnMeshInstance< ValueType > > PCFieldOnMeshTypePtr;

    private:
        PCFieldOnMeshTypePtr _PCFieldOnMeshPtr;

    public:
        PCFieldOnMesh(string nom): _PCFieldOnMeshPtr( new PCFieldOnMeshInstance< ValueType > (nom) )
        {};

        ~PCFieldOnMesh()
        {};

        PCFieldOnMesh& operator=(const PCFieldOnMesh< ValueType >& tmp)
        {
            _PCFieldOnMeshPtr = tmp._PCFieldOnMeshPtr;
        };

        const PCFieldOnMeshTypePtr& operator->(void) const
        {
            return _PCFieldOnMeshPtr;
        };

        PCFieldOnMeshInstance< ValueType >* getInstance() const
        {
            return &(*_PCFieldOnMeshPtr);
        };

        void copy( PCFieldOnMesh< ValueType >& other )
        {
            _PCFieldOnMeshPtr = other._PCFieldOnMeshPtr;
        };

        bool isEmpty() const
        {
            if ( _PCFieldOnMeshPtr.use_count() == 0 ) return true;
            return false;
        };
};

/** @typedef Definition d'une carte de double */
typedef PCFieldOnMesh< double > PCFieldOnMeshDouble;
/**  @typedef Definition d'une carte de char[8] */
typedef PCFieldOnMesh< JeveuxChar8 > PCFieldOnMeshChar8;

#endif /* PCFIELDONMESH_H_ */
