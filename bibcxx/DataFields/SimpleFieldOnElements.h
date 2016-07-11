#ifndef SIMPLEFIELDONELEMENTS_H_
#define SIMPLEFIELDONELEMENTS_H_

/**
 * @file SimpleFieldOnElements.h
 * @brief Fichier entete de la classe SimpleFieldOnElements
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

/**
 * @class SimpleFieldOnElementsInstance
 * @brief Cette classe template permet de definir un champ aux éléments Aster
 * @author Nicolas Sellenet
 */
template< class ValueType >
class SimpleFieldOnElementsInstance: public DataStructure
{
private:
    /** @brief Vecteur Jeveux '.CESK' */
    JeveuxVectorChar8       _descriptor;
    /** @brief Vecteur Jeveux '.CESD' */
    JeveuxVectorLong        _size;
    /** @brief Vecteur Jeveux '.CESC' */
    JeveuxVectorChar8       _component;
    /** @brief Vecteur Jeveux '.CESV' */
    JeveuxVector<ValueType> _values;
    /** @brief Vecteur Jeveux '.CESL' */
    JeveuxVectorLogical     _allocated;
    /** @brief Nombre de éléments */
    int                     _nbNodes;
    /** @brief Nombre de composantes */
    int                     _nbComp;

public:
    /**
     * @brief Constructeur
     * @param name Nom Jeveux du champ aux éléments
     */
    SimpleFieldOnElementsInstance( const std::string name ):
                    DataStructure( name, "CHAM_ELEM_S" ),
                    _descriptor( JeveuxVectorChar8( getName() + ".CESK" ) ),
                    _size( JeveuxVectorLong( getName() + ".CESD" ) ),
                    _component( JeveuxVectorChar8( getName() + ".CESC" ) ),
                    _values( JeveuxVector<ValueType>( getName() + ".CESV" ) ),
                    _allocated( JeveuxVectorLogical( getName() + ".CESL" ) ),
                    _nbNodes( 0 ),
                    _nbComp( 0 )
    {
        assert( name.size() == 19 );
    };

    /**
     * @brief Constructeur
     * @param memType Mémoire d'allocation
     */
    SimpleFieldOnElementsInstance( const JeveuxMemory memType ):
                    DataStructure( "CHAM_NO_S", memType, 19 ),
                    _descriptor( JeveuxVectorChar8( getName() + ".CESK" ) ),
                    _size( JeveuxVectorLong( getName() + ".CESD" ) ),
                    _component( JeveuxVectorChar8( getName() + ".CESC" ) ),
                    _values( JeveuxVector<ValueType>( getName() + ".CESV" ) ),
                    _allocated( JeveuxVectorLogical( getName() + ".CESL" ) ),
                    _nbNodes( 0 ),
                    _nbComp( 0 )
    {
        assert( getName().size() == 19 );
    };

    ~SimpleFieldOnElementsInstance()
    {
#ifdef __DEBUG_GC__
        std::cout << "SimpleFieldOnElements.destr: " << this->getName() << std::endl;
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
        return _values->operator[](i);
    };

    const ValueType& getValue( int nodeNumber, int compNumber ) const
#ifdef __DEBUG_GC__
        throw( std::runtime_error )
#endif
    {
#ifdef __DEBUG_GC__
        if( _nbNodes == 0 || _nbComp == 0 )
            throw std::runtime_error( "First call of updateValuePointers is mandatory" );
#endif
        const long position = nodeNumber*_nbComp + compNumber;
        return (*_values)[ position ];
    };

    /**
     * @brief Mise a jour des pointeurs Jeveux
     * @return renvoie true si la mise a jour s'est bien deroulee, false sinon
     */
    bool updateValuePointers() throw( std::runtime_error )
    {
        bool retour = _descriptor->updateValuePointer();
        retour = ( retour && _size->updateValuePointer() );
        retour = ( retour && _component->updateValuePointer() );
        retour = ( retour && _values->updateValuePointer() );
        retour = ( retour && _allocated->updateValuePointer() );
        if( retour )
        {
            _nbNodes = (*_size)[0];
            _nbComp = (*_size)[1];
            if( _values->size() != _nbNodes*_nbComp )
                throw std::runtime_error( "Programming error" );
        }
        return retour;
    };
};


/** @typedef SimpleFieldOnElementsInstanceDouble Instance d'une carte de double */
typedef SimpleFieldOnElementsInstance< double > SimpleFieldOnElementsDoubleInstance;

/**
 * @typedef SimpleFieldOnElementsPtrDouble
 * @brief Definition d'un champ aux éléments de double
 */
typedef boost::shared_ptr< SimpleFieldOnElementsDoubleInstance > SimpleFieldOnElementsDoublePtr;

/** @typedef SimpleFieldOnElementsInstanceLong Instance d'une carte de long */
typedef SimpleFieldOnElementsInstance< long > SimpleFieldOnElementsLongInstance;

/**
 * @typedef SimpleFieldOnElementsPtrLong
 * @brief Definition d'un champ aux éléments de long
 */
typedef boost::shared_ptr< SimpleFieldOnElementsLongInstance > SimpleFieldOnElementsLongPtr;

#endif /* SIMPLEFIELDONELEMENTS_H_ */
