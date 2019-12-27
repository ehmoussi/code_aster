#ifndef SIMPLEFIELDONNODES_H_
#define SIMPLEFIELDONNODES_H_

/**
 * @file SimpleFieldOnNodes.h
 * @brief Fichier entete de la classe SimpleFieldOnNodes
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2019  EDF R&D                www.code-aster.org
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

#include <string>
#include <assert.h>

#include "astercxx.h"
#include "aster_fort.h"

#include "MemoryManager/JeveuxVector.h"
#include "DataStructures/DataStructure.h"

/**
 * @class SimpleFieldOnNodesInstance
 * @brief Cette classe template permet de definir un champ aux noeuds Aster
 * @author Nicolas Sellenet
 */
template < class ValueType > class SimpleFieldOnNodesInstance : public DataStructure {
  private:
    /** @brief Vecteur Jeveux '.CNSK' */
    JeveuxVectorChar8 _descriptor;
    /** @brief Vecteur Jeveux '.CNSD' */
    JeveuxVectorLong _size;
    /** @brief Vecteur Jeveux '.CNSC' */
    JeveuxVectorChar8 _component;
    /** @brief Vecteur Jeveux '.CNSV' */
    JeveuxVector< ValueType > _values;
    /** @brief Vecteur Jeveux '.CNSL' */
    JeveuxVectorLogical _allocated;
    /** @brief Nombre de noeuds */
    int _nbNodes;
    /** @brief Nombre de composantes */
    int _nbComp;

  public:
    /**
     * @typedef SimpleFieldOnNodesPtr
     * @brief Pointeur intelligent vers un SimpleFieldOnNodes
     */
    typedef boost::shared_ptr< SimpleFieldOnNodesInstance > SimpleFieldOnNodesPtr;

    /**
     * @brief Constructeur
     * @param name Nom Jeveux du champ aux noeuds
     */
    SimpleFieldOnNodesInstance( const std::string name )
        : DataStructure( name, 19, "CHAM_NO_S" ),
          _descriptor( JeveuxVectorChar8( getName() + ".CNSK" ) ),
          _size( JeveuxVectorLong( getName() + ".CNSD" ) ),
          _component( JeveuxVectorChar8( getName() + ".CNSC" ) ),
          _values( JeveuxVector< ValueType >( getName() + ".CNSV" ) ),
          _allocated( JeveuxVectorLogical( getName() + ".CNSL" ) ), _nbNodes( 0 ), _nbComp( 0 ){};

    /**
     * @brief Constructeur
     * @param memType Mémoire d'allocation
     */
    SimpleFieldOnNodesInstance( const JeveuxMemory memType = Permanent )
        : DataStructure( "CHAM_NO_S", memType, 19 ),
          _descriptor( JeveuxVectorChar8( getName() + ".CNSK" ) ),
          _size( JeveuxVectorLong( getName() + ".CNSD" ) ),
          _component( JeveuxVectorChar8( getName() + ".CNSC" ) ),
          _values( JeveuxVector< ValueType >( getName() + ".CNSV" ) ),
          _allocated( JeveuxVectorLogical( getName() + ".CNSL" ) ), _nbNodes( 0 ), _nbComp( 0 ){};


    /**
     * @brief Surcharge de l'operateur []
     * @param i Indice dans le tableau Jeveux
     * @return la valeur du tableau Jeveux a la position i
     */
    ValueType &operator[]( int i ) { return _values->operator[]( i ); };

    const ValueType &getValue( int nodeNumber, int compNumber ) const
    {
#ifdef _DEBUG_CXX
        if ( _nbNodes == 0 || _nbComp == 0 )
            throw std::runtime_error( "First call of updateValuePointers is mandatory" );
#endif
        const long position = nodeNumber * _nbComp + compNumber;
        return ( *_values )[position];
    };

    /**
     * @brief Mise a jour des pointeurs Jeveux
     * @return renvoie true si la mise a jour s'est bien deroulee, false sinon
     */
    bool updateValuePointers() {
        bool retour = _descriptor->updateValuePointer();
        retour = ( retour && _size->updateValuePointer() );
        retour = ( retour && _component->updateValuePointer() );
        retour = ( retour && _values->updateValuePointer() );
        retour = ( retour && _allocated->updateValuePointer() );
        if ( retour ) {
            _nbNodes = ( *_size )[0];
            _nbComp = ( *_size )[1];
            if ( _values->size() != _nbNodes * _nbComp )
                throw std::runtime_error( "Programming error" );
        }
        return retour;
    };
};

/** @typedef SimpleFieldOnNodesDoubleInstance Instance d'une champ simple de doubles */
typedef SimpleFieldOnNodesInstance< double > SimpleFieldOnNodesDoubleInstance;

/**
 * @typedef SimpleFieldOnNodesPtrDouble
 * @brief Definition d'un champ simple de doubles
 */
typedef boost::shared_ptr< SimpleFieldOnNodesDoubleInstance > SimpleFieldOnNodesDoublePtr;

/** @typedef SimpleFieldOnNodesInstanceLong Instance d'un champ simple de long */
typedef SimpleFieldOnNodesInstance< long > SimpleFieldOnNodesLongInstance;

/**
 * @typedef SimpleFieldOnNodesPtrLong
 * @brief Definition d'un champ simple de long
 */
typedef boost::shared_ptr< SimpleFieldOnNodesLongInstance > SimpleFieldOnNodesLongPtr;

/** @typedef SimpleFieldOnNodesComplexInstance
    @brief Instance d'un champ simple de complexes */
typedef SimpleFieldOnNodesInstance< DoubleComplex > SimpleFieldOnNodesComplexInstance;

/**
 * @typedef SimpleFieldOnNodesComplexPtr
 * @brief Definition d'un champ simple aux noeuds de complexes
 */
typedef boost::shared_ptr< SimpleFieldOnNodesComplexInstance > SimpleFieldOnNodesComplexPtr;
#endif /* SIMPLEFIELDONNODES_H_ */
