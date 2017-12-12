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
#include "MemoryManager/JeveuxAllowedTypes.h"
#include "DataStructures/DataStructure.h"
#include "DataFields/SimpleFieldOnNodes.h"
#include "Discretization/DOFNumbering.h"
#include "DataFields/MeshCoordinatesField.h"

/**
 * @struct AllowedFieldType
 * @brief Structure template permettant de limiter le type instanciable de JeveuxVectorInstance
 * @tparam T Type autorise
 */
template< typename T >
struct AllowedFieldType; // undefined for bad types!

template<> struct AllowedFieldType< long >
{
    static const unsigned short numTypeJeveux = Integer;
};

template<> struct AllowedFieldType< double >
{
    static const unsigned short numTypeJeveux = Double;
};

/**
 * @class FieldOnNodesInstance
 * @brief Cette classe template permet de definir un champ aux noeuds Aster
 * @author Nicolas Sellenet
 */
template< class ValueType >
class FieldOnNodesInstance: public DataStructure, private AllowedFieldType< ValueType >
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
    /** @brief Numérotation attachée au FieldOnNodes */
    BaseDOFNumberingPtr     _dofNum;

public:
    /**
     * @typedef FieldOnNodesPtr
     * @brief Pointeur intelligent vers un FieldOnNodes
     */
    typedef boost::shared_ptr< FieldOnNodesInstance > FieldOnNodesPtr;

    /**
     * @brief Constructeur
     * @param name Nom Jeveux du champ aux noeuds
     */
    FieldOnNodesInstance( const std::string name ):
                    DataStructure( name, 19, "CHAM_NO" ),
                    _descriptor( JeveuxVectorLong( getName() + ".DESC" ) ),
                    _reference( JeveuxVectorChar24( getName() + ".REFE" ) ),
                    _valuesList( JeveuxVector< ValueType >( getName() + ".VALE" ) )
    {
    };

    /**
     * @brief Constructeur
     * @param memType Mémoire d'allocation
     */
    FieldOnNodesInstance( const JeveuxMemory memType = Permanent ):
                    DataStructure( "CHAM_NO", memType, 19 ),
                    _descriptor( JeveuxVectorLong( getName() + ".DESC" ) ),
                    _reference( JeveuxVectorChar24( getName() + ".REFE" ) ),
                    _valuesList( JeveuxVector< ValueType >( getName() + ".VALE" ) )
    {
    };

    /**
     * @brief Constructeur from a MeshCoordinatesFieldPtr&
     */
    FieldOnNodesInstance( MeshCoordinatesFieldPtr& toCopy ):
                    DataStructure( "CHAM_NO", toCopy->getMemoryType(), 19 ),
                    _descriptor( toCopy->_descriptor ),
                    _reference( toCopy->_reference ),
                    _valuesList( toCopy->_valuesList )
    {};

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
     * @brief Surcharge de l'operateur []
     * @param i Indice dans le tableau Jeveux
     * @return la valeur du tableau Jeveux a la position i
     * @todo cython n'autorise pas la présence de 2 operator[] (un avec et l'autre sans const)
     */
    const ValueType &operator[]( int i ) const
    {
        return _valuesList->operator[](i);
    };

    /**
     * @brief Addition d'un champ aux noeuds
     * @return renvoit true si l'addition s'est bien deroulée, false sinon
     * @todo ajouter une vérification sur la structure des champs
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
     * @return renvoit true
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
     * @brief Allouer un champ au noeud à partir d'un DOFNumbering
     * @return renvoit true
     */
    bool allocateFromDOFNumering( const BaseDOFNumberingPtr& dofNum )
        throw( std::runtime_error )
    {
        _dofNum = dofNum;
        if ( _dofNum->isEmpty() ) throw std::runtime_error( "DOFNumering is empty" );
        const int intType = AllowedFieldType< ValueType >::numTypeJeveux;
        CALLO_VTCREB_WRAP( getName(), JeveuxMemoryTypesNames[ getMemoryType() ],
                           JeveuxTypesNames[ intType ], _dofNum->getName() );
        return true;
    };

    /**
     * @brief Renvoit un champ aux noeuds simple (carré de taille nb_no*nbcmp)
     * @return SimpleFieldOnNodesValueTypePtr issu du FieldOnNodes
     */
    SimpleFieldOnNodesValueTypePtr exportToSimpleFieldOnNodes()
    {
        SimpleFieldOnNodesValueTypePtr toReturn( new SimpleFieldOnNodesValueTypeInstance( getMemoryType() ) );
        const std::string resultName = toReturn->getName();
        const std::string inName = getName();
        CALLO_CNOCNS( inName, JeveuxMemoryTypesNames[ getMemoryType() ],
                     resultName );
        toReturn->updateValuePointers();
        return toReturn;
    };

    bool printMedFile( const std::string fileName ) const throw ( std::runtime_error );

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

template< class ValueType >
bool FieldOnNodesInstance< ValueType >::printMedFile( const std::string fileName ) const
    throw ( std::runtime_error )
{
    LogicalUnitFileCython a( fileName, Binary, New );
    int retour = a.getLogicalUnit();
    CommandSyntax cmdSt( "IMPR_RESU" );

    SyntaxMapContainer dict;
    dict.container[ "FORMAT" ] = "MED";
    dict.container[ "UNITE" ] = retour;

    ListSyntaxMapContainer listeResu;
    SyntaxMapContainer dict2;
    dict2.container[ "CHAM_GD" ] = getName();
    listeResu.push_back( dict2 );
    dict.container[ "RESU" ] = listeResu;

    cmdSt.define( dict );

    try
    {
        ASTERINTEGER op = 39;
        CALL_EXECOP( &op );
    }
    catch( ... )
    {
        throw;
    }

    return true;
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
