#ifndef FIELDONNODES_H_
#define FIELDONNODES_H_

/**
 * @file FieldOnNodes.h
 * @brief Fichier entete de la classe FieldOnNodes
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

#include <string>
#include <assert.h>

#include "astercxx.h"
#include "aster_fort.h"

#include "MemoryManager/JeveuxVector.h"
#include "DataStructure/DataStructure.h"
#include "DataFields/SimpleFieldOnNodes.h"

/**
 * @class FieldOnNodesInstance
 * @brief Cette classe template permet de definir un champ aux noeuds Aster
 * @author Nicolas Sellenet
 */
template< class ValueType >
class FieldOnNodesInstance: public DataStructure
{
private:
    typedef SimpleFieldOnNodesInstance< ValueType > SimpleFieldOnNodesValueTypeInstance;
    typedef boost::shared_ptr< SimpleFieldOnNodesDoubleInstance > SimpleFieldOnNodesValueTypePtr;
    /** @brief Vecteur Jeveux '.DESC' */
    JeveuxVectorLong        _descriptor;
    /** @brief Vecteur Jeveux '.REFE' */
    JeveuxVectorChar24      _reference;
    /** @brief Vecteur Jeveux '.VALE' */
    JeveuxVector<ValueType> _valuesList;

public:
    /**
     * @brief Constructeur
     * @param name Nom Jeveux du champ aux noeuds
     */
    FieldOnNodesInstance( const std::string name ):
                    DataStructure( name, "CHAM_NO" ),
                    _descriptor( JeveuxVectorLong( getName() + ".DESC" ) ),
                    _reference( JeveuxVectorChar24( getName() + ".REFE" ) ),
                    _valuesList( JeveuxVector< ValueType >( getName() + ".VALE" ) )
    {
        assert( name.size() == 19 );
    };

    /**
     * @brief Constructeur
     * @param memType Mémoire d'allocation
     */
    FieldOnNodesInstance( const JeveuxMemory memType ):
                    DataStructure( "CHAM_NO", memType, 19 ),
                    _descriptor( JeveuxVectorLong( getName() + ".DESC" ) ),
                    _reference( JeveuxVectorChar24( getName() + ".REFE" ) ),
                    _valuesList( JeveuxVector< ValueType >( getName() + ".VALE" ) )
    {
        assert( getName().size() == 19 );
    };

    ~FieldOnNodesInstance()
    {
#ifdef __DEBUG_GC__
        std::cout << "FieldOnNodes.destr: " << this->getName() << std::endl;
#endif
    };

    /**
     * @brief Surcharge de l'operateur []
     * @param i Indice dans le tableau Jeveux
     * @return la valeur du tableau Jeveux a la position i
     * @todo cython n'autorise pas la présence de 2 operator[] (un avec et l'autre sans const)
     */
    ValueType &operator[]( int i )
    {
        return _valuesList->operator[](i);
    };

    /**
     * @brief Addition d'un champ aux noeuds
     * @return renvoit true si l'addition s'est bien deroulée, false sinon
     */
    bool addFieldOnNodes( FieldOnNodesInstance< ValueType >& tmp )
    {
        bool retour = tmp.updateValuePointers();
        retour = ( retour && _valuesList->updateValuePointer() );
        int taille = _valuesList->size();
        for ( int pos = 0; pos < taille; ++pos )
            ( *this )[ pos ] = ( *this )[ pos ] + tmp[ pos ];
        return retour;
    };

    /**
     * @brief Allouer un champ au noeud à partir d'un autre
     * @return renvoit true si l'addition s'est bien deroulée, false sinon
     */
    bool allocateFrom( const FieldOnNodesInstance< ValueType >& tmp )
    {
        this->_descriptor->deallocate();
        this->_reference->deallocate();
        this->_valuesList->deallocate();

        this->_descriptor->allocate( getMemoryType(), tmp._descriptor->size() );
        this->_reference->allocate( getMemoryType(), tmp._reference->size() );
        this->_valuesList->allocate( getMemoryType(), tmp._valuesList->size() );
        return true;
    };

    /**
     * @brief 
     * @return 
     */
    SimpleFieldOnNodesValueTypePtr exportToSimpleFieldOnNodes()
    {
        SimpleFieldOnNodesValueTypePtr toReturn( new SimpleFieldOnNodesValueTypeInstance( getMemoryType() ) );
        const std::string resultName = toReturn->getName();
        const std::string inName = getName();
        CALL_CNOCNS( inName.c_str(), JeveuxMemoryTypesNames[ getMemoryType() ],
                     resultName.c_str() );
        return toReturn;
    };

    /**
     * @brief Mise a jour des pointeurs Jeveux
     * @return renvoie true si la mise a jour s'est bien deroulee, false sinon
     */
    bool updateValuePointers()
    {
        bool retour = _descriptor->updateValuePointer();
        retour = ( retour && _reference->updateValuePointer() );
        retour = ( retour && _valuesList->updateValuePointer() );
        return retour;
    };
protected:
    /**
     * @brief Surcharge de l'operateur []
     * @param i Indice dans le tableau Jeveux
     * @return la valeur du tableau Jeveux a la position i
     */
//         ValueType &operator[]( int i )
//         {
//             return _valuesList->operator[](i);
//         };
};


/** @typedef FieldOnNodesInstanceDouble Instance d'une carte de double */
typedef FieldOnNodesInstance< double > FieldOnNodesDoubleInstance;

/**
 * @typedef FieldOnNodesPtrDouble
 * @brief Definition d'un champ aux noeuds de double
 */
typedef boost::shared_ptr< FieldOnNodesDoubleInstance > FieldOnNodesDoublePtr;

/** @typedef FieldOnNodesInstanceLong Instance d'une carte de long */
typedef FieldOnNodesInstance< long > FieldOnNodesLongInstance;

/**
 * @typedef FieldOnNodesPtrLong
 * @brief Definition d'un champ aux noeuds de long
 */
typedef boost::shared_ptr< FieldOnNodesLongInstance > FieldOnNodesLongPtr;

#endif /* FIELDONNODES_H_ */
