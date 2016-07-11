#ifndef FIELDONELEMENTS_H_
#define FIELDONELEMENTS_H_

/**
 * @file FieldOnElements.h
 * @brief Fichier entete de la classe FieldOnElements
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2016  EDF R&D                www.code-aster.org
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
#include "DataFields/SimpleFieldOnElements.h"

/**
 * @class FieldOnElementsInstance
 * @brief Cette classe template permet de definir un champ aux éléments Aster
 * @author Nicolas Sellenet
 */
template< class ValueType >
class FieldOnElementsInstance: public DataStructure
{
private:
    typedef SimpleFieldOnElementsInstance< ValueType > SimpleFieldOnElementsValueTypeInstance;
    typedef boost::shared_ptr< SimpleFieldOnElementsDoubleInstance > SimpleFieldOnElementsValueTypePtr;

    /** @brief Vecteur Jeveux '.CELD' */
    JeveuxVectorLong        _descriptor;
    /** @brief Vecteur Jeveux '.CELK' */
    JeveuxVectorChar24      _reference;
    /** @brief Vecteur Jeveux '.CELV' */
    JeveuxVector<ValueType> _valuesList;

public:
    /**
     * @brief Constructeur
     * @param name Nom Jeveux du champ aux éléments
     */
    FieldOnElementsInstance( const std::string name ):
                    DataStructure( name, "CHAM_ELEM" ),
                    _descriptor( JeveuxVectorLong( getName() + ".CELD" ) ),
                    _reference( JeveuxVectorChar24( getName() + ".CELK" ) ),
                    _valuesList( JeveuxVector< ValueType >( getName() + ".CELV" ) )
    {
        assert( name.size() == 19 );
    };

    /**
     * @brief Constructeur
     * @param memType Mémoire d'allocation
     */
    FieldOnElementsInstance( const JeveuxMemory memType ):
                    DataStructure( "CHAM_ELEM", memType, 19 ),
                    _descriptor( JeveuxVectorLong( getName() + ".CELD" ) ),
                    _reference( JeveuxVectorChar24( getName() + ".CELK" ) ),
                    _valuesList( JeveuxVector< ValueType >( getName() + ".CELV" ) )
    {
        assert( getName().size() == 19 );
    };

    ~FieldOnElementsInstance()
    {
#ifdef __DEBUG_GC__
        std::cout << "FieldOnElements.destr: " << this->getName() << std::endl;
#endif
    };

    /**
     * @brief 
     * @return 
     */
    SimpleFieldOnElementsValueTypePtr exportToSimpleFieldOnElements()
    {
        SimpleFieldOnElementsValueTypePtr toReturn( new SimpleFieldOnElementsValueTypeInstance( getMemoryType() ) );
        const std::string resultName = toReturn->getName();
        const std::string inName = getName();
        CALL_CELCES( inName.c_str(), JeveuxMemoryTypesNames[ getMemoryType() ],
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
};


/** @typedef FieldOnElementsInstanceDouble Instance d'une carte de double */
typedef FieldOnElementsInstance< double > FieldOnElementsDoubleInstance;

/**
 * @typedef FieldOnElementsPtrDouble
 * @brief Definition d'un champ aux éléments de double
 */
typedef boost::shared_ptr< FieldOnElementsDoubleInstance > FieldOnElementsDoublePtr;

/** @typedef FieldOnElementsInstanceLong Instance d'une carte de long */
typedef FieldOnElementsInstance< long > FieldOnElementsLongInstance;

/**
 * @typedef FieldOnElementsPtrLong
 * @brief Definition d'un champ aux éléments de long
 */
typedef boost::shared_ptr< FieldOnElementsLongInstance > FieldOnElementsLongPtr;

#endif /* FIELDONELEMENTS_H_ */
