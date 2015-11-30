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
#include "aster_fort.h"

/**
 * @class PCFieldOnMeshInstance Piecewise Constant (PC) Field on Mesh template
 * @brief Cette classe permet de definir une carte (champ défini sur les mailles)
 * @author Natacha Bereux
 */
template< class ValueType >
class PCFieldOnMeshInstance: public DataStructure
{
    private:
        /** @brief Vecteur Jeveux '.NOMA' */
        JeveuxVectorChar8         _meshName;
        /** @brief Vecteur Jeveux '.DESC' */
        JeveuxVectorLong          _descriptor;
        /** @brief Vecteur Jeveux '.NOLI' */
        JeveuxVectorChar24        _nameOfLigrels;
        /** @brief Collection  '.LIMA' */
        JeveuxCollectionLong      _listOfMeshElements;
        /** @brief Vecteur Jeveux '.VALE' */
        JeveuxVector< ValueType > _valuesList;
        /** @brief Maillage sous-jacent */
        MeshPtr                   _supportMesh;
        /** @brief La carte est-elle allouée ? */
        bool                      _isAllocated;
        /** @brief Objet temporaire '.NCMP' */
        JeveuxVectorChar8         _componentNames;
        /** @brief Objet temporaire '.VALV' */
        JeveuxVector< ValueType > _valuesListTmp;

    private:
        void fortranAddValues( const long code, const std::string grp, const std::string mode,
                               const long nma, const JeveuxVectorLong limanu,
                               const std::string ligrel, JeveuxVectorChar8& component,
                               JeveuxVector< ValueType > values ) const
            throw ( std::runtime_error )
        {
            bool test = _componentNames->updateValuePointer();
            test = test && _valuesListTmp->updateValuePointer();
            if ( ! test )
                throw std::runtime_error( "PCFieldOnMeshInstance not allocate" );
            const long taille = _componentNames->size();

            const long tVerif1 = component->size();
            const long tVerif2 = values->size();
            if ( tVerif1 > taille || tVerif2 > taille || tVerif1 != tVerif2 )
                throw std::runtime_error( "Unconsistent size" );

            for ( int position = 0; position < tVerif1; ++position )
            {
                (*_componentNames)[position] = (*component)[position];
                (*_valuesListTmp)[position] = (*values)[position];
            }

            const std::string limano( " " );
            try
            {
                CALL_NOCARTC( getName().c_str(), &code, &tVerif1, grp.c_str(), mode.c_str(),
                              &nma, limano.c_str(), &( *limanu )[0], ligrel.c_str() );
            }
            catch( ... )
            {
                throw;
            }
        };

        void fortranAllocate( const std::string base, const std::string quantity ) const
            throw ( std::runtime_error )
        {
            try
            {
                CALL_ALCART( base.c_str(), getName().c_str(), _supportMesh->getName().c_str(),
                             quantity.c_str() );
            }
            catch( ... )
            {
                throw;
            }
        };

    public:
        /**
         * @brief Constructeur
         * @param name Nom Jeveux de la carte
         */
        PCFieldOnMeshInstance( std::string name ):
                                            DataStructure( name, "CARTE" ),
                                            _meshName( JeveuxVectorChar8( name + ".NOMA" ) ),
                                            _descriptor( JeveuxVectorLong( name + ".DESC" ) ),
                                            _nameOfLigrels( JeveuxVectorChar24( name + ".NOLI" ) ),
                                            _listOfMeshElements( JeveuxCollectionLong( name + ".LIMA" ) ),
                                            _valuesList( JeveuxVector<ValueType>( name + ".VALE" ) ),
                                            _supportMesh( MeshPtr() ),
                                            _isAllocated( false ),
                                            _componentNames( name + ".NCMP" ),
                                            _valuesListTmp( name + ".VALV" )
        {
            assert( name.size() == 19 );
        };

        /**
         * @brief Allocation de la carte
         * @return true si l'allocation s'est bien deroulee, false sinon
         */
        void allocate( const JeveuxMemory jeveuxBase, const std::string componant )
            throw ( std::runtime_error )
        {
            if ( _supportMesh.use_count() == 0 || _supportMesh->isEmpty() )
                throw std::runtime_error( "Mesh is empty" );

            std::string strJeveuxBase( "V" );
            if ( jeveuxBase == Permanent ) strJeveuxBase = "G";
            fortranAllocate( strJeveuxBase, componant );
            _isAllocated = true;
        };

        /**
         * @brief Définition du maillage sous-jacent
         * @param currentMesh objet Mesh sur lequel le modele reposera
         * @return renvoit true si la définition s'est bien deroulee, false sinon
         */
        bool setSupportMesh( MeshPtr& currentMesh ) throw ( std::runtime_error )
        {
            if ( currentMesh->isEmpty() )
                throw std::runtime_error( "Mesh is empty" );
            _supportMesh = currentMesh;
            return true;
        };

        /**
         * @brief Fixer une valeur sur tout le maillage
         * @param component JeveuxVectorChar8 contenant le nom des composantes à fixer
         * @param values JeveuxVector< ValueType > contenant les valeurs
         * @param ligrel TEMPORAIRE
         * @return renvoit true si l'ajout s'est bien deroulee, false sinon
         * @todo Ajouter la possibilite de donner un ligrel (n'existe pas encore)
         */
        bool setValueOnAllMesh( JeveuxVectorChar8& component, JeveuxVector< ValueType > values,
                                std::string ligrel = " " )
            throw ( std::runtime_error )
        {
            if ( _supportMesh.use_count() == 0 || _supportMesh->isEmpty() )
                throw std::runtime_error( "Mesh is empty" );
            if ( ligrel != " " )
                throw std::runtime_error( "Build a PCFieldOnMeshInstance with a ligrel not yet available" );

            const long code = 1;
            const std::string grp( " " );
            const std::string mode( " " );
            const long nbMa = 0;
            JeveuxVectorLong limanu( "empty" );
            limanu->allocate( Temporary, 1 );
            fortranAddValues( code, grp, mode, nbMa, limanu, ligrel, component, values );
            return true;
        };

        /**
         * @brief Fixer une valeur sur un groupe de mailles
         * @param component JeveuxVectorChar8 contenant le nom des composantes à fixer
         * @param values JeveuxVector< ValueType > contenant les valeurs
         * @param grp Groupe de mailles
         * @param ligrel TEMPORAIRE
         * @return renvoit true si l'ajout s'est bien deroulee, false sinon
         * @todo Ajouter la possibilite de donner un ligrel (n'existe pas encore)
         */
        bool setValueOnGroupOfElements( JeveuxVectorChar8& component, JeveuxVector< ValueType > values,
                                        GroupOfElements grp, std::string ligrel = " " )
            throw ( std::runtime_error )
        {
            if ( _supportMesh.use_count() == 0 || _supportMesh->isEmpty() )
                throw std::runtime_error( "Mesh is empty" );
            if ( ligrel != " " )
                throw std::runtime_error( "Build a PCFieldOnMeshInstance with a ligrel not yet available" );
            if ( ! _supportMesh->hasGroupOfElements( grp.getEntityName() ) )
                throw std::runtime_error( "Group " + grp.getEntityName() + " not in mesh" );

            const long code = 2;
            const std::string mode( " " );
            const long nbMa = 0;
            JeveuxVectorLong limanu( "empty" );
            limanu->allocate( Temporary, 1 );
            fortranAddValues( code, grp.getEntityName(), mode, nbMa, limanu, ligrel, component, values );
            return true;
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
};

/** @typedef PCFieldOnMeshInstanceDouble Instance d'une carte de double */
typedef PCFieldOnMeshInstance< double > PCFieldOnMeshInstanceDouble;
/** @typedef PCFieldOnMeshInstanceDouble Instance d'une carte de char*8 */
typedef PCFieldOnMeshInstance< JeveuxChar8 > PCFieldOnMeshInstanceChar8;
/** @typedef PCFieldOnMeshInstanceDouble Instance d'une carte de char*16 */
typedef PCFieldOnMeshInstance< JeveuxChar8 > PCFieldOnMeshInstanceChar16;
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
/**
 * @typedef PCFieldOnMeshPtrChar16 Definition d'une carte de char[16]
 * @brief Pointeur intelligent vers un PCFieldOnMeshInstance
 */
typedef boost::shared_ptr< PCFieldOnMeshInstanceChar16 > PCFieldOnMeshPtrChar16;
#endif /* PCFIELDONMESH_H_ */
