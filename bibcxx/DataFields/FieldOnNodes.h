#ifndef FIELDONNODES_H_
#define FIELDONNODES_H_

/**
 * @file FieldOnNodes.h
 * @brief Fichier entete de la classe FieldOnNodes
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2020  EDF R&D                www.code-aster.org
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

#include <assert.h>
#include <string>

#include "astercxx.h"
#include "aster_fort_superv.h"

#include "DataFields/DataField.h"
#include "DataFields/MeshCoordinatesField.h"
#include "DataFields/SimpleFieldOnNodes.h"
#include "MemoryManager/JeveuxAllowedTypes.h"
#include "MemoryManager/JeveuxVector.h"
#include "Meshes/BaseMesh.h"
#include "Numbering/DOFNumbering.h"
#include "PythonBindings/LogicalUnitManager.h"

/**
 * @struct AllowedFieldType
 * @brief Structure template permettant de limiter le type instanciable de JeveuxVectorClass
 * @tparam T Type autorise
 */
template < typename T > struct AllowedFieldType; // undefined for bad types!

template <> struct AllowedFieldType< ASTERINTEGER > {
    static const unsigned short numTypeJeveux = Integer;
};

template <> struct AllowedFieldType< double > { static const unsigned short numTypeJeveux = Real; };

template <> struct AllowedFieldType< RealComplex > {
    static const unsigned short numTypeJeveux = Complex;
};

class FieldBuilder;

/**
 * @class FieldOnNodesClass
 * @brief Cette classe template permet de definir un champ aux noeuds Aster
 * @author Nicolas Sellenet
 */
template < class ValueType >
class FieldOnNodesClass : public DataFieldClass, private AllowedFieldType< ValueType > {
  private:
    typedef SimpleFieldOnNodesClass< ValueType > SimpleFieldOnNodesValueTypeClass;
    typedef boost::shared_ptr< SimpleFieldOnNodesValueTypeClass > SimpleFieldOnNodesValueTypePtr;

    /** @brief Vecteur Jeveux '.DESC' */
    JeveuxVectorLong _descriptor;
    /** @brief Vecteur Jeveux '.REFE' */
    JeveuxVectorChar24 _reference;
    /** @brief Vecteur Jeveux '.VALE' */
    JeveuxVector< ValueType > _valuesList;
    /** @brief Numbering of a FieldOnNodes */
    BaseDOFNumberingPtr _dofNum;
    /** @brief Dof description */
    FieldOnNodesDescriptionPtr _dofDescription;
    /** @brief Dof description */
    BaseMeshPtr _mesh;
    /** @brief jeveux vector '.TITR' */
    JeveuxVectorChar80 _title;

  public:
    /**
     * @typedef FieldOnNodesPtr
     * @brief Pointeur intelligent vers un FieldOnNodes
     */
    typedef boost::shared_ptr< FieldOnNodesClass > FieldOnNodesPtr;

    /**
     * @brief Constructeur
     * @param name Nom Jeveux du champ aux noeuds
     */
    FieldOnNodesClass( const std::string name )
        : DataFieldClass( name, "CHAM_NO" ), _descriptor( JeveuxVectorLong( getName() + ".DESC" ) ),
          _reference( JeveuxVectorChar24( getName() + ".REFE" ) ),
          _valuesList( JeveuxVector< ValueType >( getName() + ".VALE" ) ), _dofNum( nullptr ),
          _dofDescription( nullptr ), _title( JeveuxVectorChar80( getName() + ".TITR" ) ),
          _mesh( nullptr ){};

    /**
     * @brief Constructeur
     * @param memType Mémoire d'allocation
     */
    FieldOnNodesClass( const JeveuxMemory memType = Permanent )
        : DataFieldClass( memType, "CHAM_NO" ),
          _descriptor( JeveuxVectorLong( getName() + ".DESC" ) ),
          _reference( JeveuxVectorChar24( getName() + ".REFE" ) ),
          _valuesList( JeveuxVector< ValueType >( getName() + ".VALE" ) ), _dofNum( nullptr ),
          _dofDescription( nullptr ), _title( JeveuxVectorChar80( getName() + ".TITR" ) ){};

    /**
     * @brief Constructeur from a MeshCoordinatesFieldPtr&
     */
    FieldOnNodesClass( MeshCoordinatesFieldPtr &toCopy )
        : DataFieldClass( toCopy->getMemoryType(), "CHAM_NO" ), _descriptor( toCopy->_descriptor ),
          _reference( toCopy->_reference ), _valuesList( toCopy->_valuesList ), _dofNum( nullptr ),
          _dofDescription( nullptr ), _title( JeveuxVectorChar80( getName() + ".TITR" ) ){};

    /**
     * @brief Surcharge de l'operateur []
     * @param i Indice dans le tableau Jeveux
     * @return la valeur du tableau Jeveux a la position i
     */
    ValueType &operator[]( int i ) { return _valuesList->operator[]( i ); };

    /**
     * @brief Surcharge de l'operateur []
     * @param i Indice dans le tableau Jeveux
     * @return la valeur du tableau Jeveux a la position i
     */
    const ValueType &operator[]( int i ) const { return _valuesList->operator[]( i ); };

    /**
     * @brief Addition d'un champ aux noeuds
     * @return renvoit true si l'addition s'est bien deroulée, false sinon
     * @todo ajouter une vérification sur la structure des champs
     */
    bool addFieldOnNodes( FieldOnNodesClass< ValueType > &tmp ) {
        bool retour = tmp.updateValuePointers();
        retour = ( retour && _valuesList->updateValuePointer() );
        int taille = _valuesList->size();
        for ( int pos = 0; pos < taille; ++pos )
            ( *this )[pos] = ( *this )[pos] + tmp[pos];
        return retour;
    };

    /**
     * @brief Allouer un champ au noeud à partir d'un autre
     * @return renvoit true
     */
    bool allocateFrom( const FieldOnNodesClass< ValueType > &tmp ) {
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
    bool allocateFromDOFNumering( const BaseDOFNumberingPtr &dofNum ) {
        _dofNum = dofNum;
        if ( _dofNum->isEmpty() )
            throw std::runtime_error( "DOFNumering is empty" );
        const int intType = AllowedFieldType< ValueType >::numTypeJeveux;
        CALLO_VTCREB_WRAP( getName(), JeveuxMemoryTypesNames[getMemoryType()],
                           JeveuxTypesNames[intType], _dofNum->getName() );
        return true;
    };

    /**
     * @brief Renvoit un champ aux noeuds simple (carré de taille nb_no*nbcmp)
     * @return SimpleFieldOnNodesValueTypePtr issu du FieldOnNodes
     */
    SimpleFieldOnNodesValueTypePtr exportToSimpleFieldOnNodes() {
        SimpleFieldOnNodesValueTypePtr toReturn(
            new SimpleFieldOnNodesValueTypeClass( getMemoryType() ) );
        const std::string resultName = toReturn->getName();
        const std::string inName = getName();
        CALLO_CNOCNS( inName, JeveuxMemoryTypesNames[getMemoryType()], resultName );
        toReturn->updateValuePointers();
        return toReturn;
    };

    /**
     * @brief Get mesh
     */
    BaseMeshPtr getMesh() const { return _mesh; };

    bool printMedFile( const std::string fileName ) const;

    /**
     * @brief Set DOFNumering
     */
    void setDOFNumbering( const BaseDOFNumberingPtr &dofNum ) {
        if ( _dofNum )
            throw std::runtime_error( "DOFNumbering already set" );
        _dofNum = dofNum;
        if ( _mesh != nullptr ) {
            const auto name1 = _mesh->getName();
            const auto name2 = _dofNum->getMesh()->getName();
            if ( name1 != name2 )
                throw std::runtime_error( "Meshes inconsistents" );
        }
    };

    /**
     * @brief Set FieldOnNodes description
     * @param desc object FieldOnNodesDescriptionPtr
     */
    void setDescription( const FieldOnNodesDescriptionPtr &desc ) {
        if ( _dofDescription )
            throw std::runtime_error( "FieldOnNodesDescription already set" );
        _dofDescription = desc;
    };

    /**
     * @brief Set mesh
     * @param mesh object BaseMeshPtr
     */
    void setMesh( const BaseMeshPtr &mesh ) {
        if ( _mesh )
            throw std::runtime_error( "Mesh already set" );
        _mesh = mesh;
        if ( _dofNum != nullptr ) {
            const auto name1 = _mesh->getName();
            const auto name2 = _dofNum->getMesh()->getName();
            if ( name1 != name2 )
                throw std::runtime_error( "Meshes inconsistents" );
        }
    };

    /**
     * @brief Update field and build FieldOnNodesDescription if necessary
     */
    bool update() {
        if ( _dofNum != nullptr ) {
            _dofDescription = _dofNum->getFieldOnNodesDescription();
        } else if ( _dofDescription == nullptr && updateValuePointers() ) {
            typedef FieldOnNodesDescriptionClass FONDesc;
            typedef FieldOnNodesDescriptionPtr FONDescP;

            const std::string name2 = trim( ( *_reference )[1].toString() );
            _dofDescription = FONDescP( new FONDesc( name2, getMemoryType() ) );
        }
        return true;
    };

    /**
     * @brief Mise a jour des pointeurs Jeveux
     * @return renvoie true si la mise a jour s'est bien deroulee, false sinon
     */
    bool updateValuePointers() {
        bool retour = _descriptor->updateValuePointer();
        retour = ( retour && _reference->updateValuePointer() );
        retour = ( retour && _valuesList->updateValuePointer() );
        return retour;
    };

    friend class FieldBuilder;
};

template < class ValueType >
bool FieldOnNodesClass< ValueType >::printMedFile( const std::string fileName ) const {
    LogicalUnitFile a( fileName, Binary, New );
    int retour = a.getLogicalUnit();
    CommandSyntax cmdSt( "IMPR_RESU" );

    SyntaxMapContainer dict;
    dict.container["FORMAT"] = "MED";
    dict.container["UNITE"] = (ASTERINTEGER)retour;

    ListSyntaxMapContainer listeResu;
    SyntaxMapContainer dict2;
    dict2.container["CHAM_GD"] = getName();
    listeResu.push_back( dict2 );
    dict.container["RESU"] = listeResu;

    cmdSt.define( dict );

    try {
        ASTERINTEGER op = 39;
        CALL_EXECOP( &op );
    } catch ( ... ) {
        throw;
    }

    return true;
};

/** @typedef FieldOnNodesClassReal Class d'un champ aux noeuds de double */
typedef FieldOnNodesClass< double > FieldOnNodesRealClass;

/**
 * @typedef FieldOnNodesPtrReal
 * @brief Definition d'un champ aux noeuds de double
 */
typedef boost::shared_ptr< FieldOnNodesRealClass > FieldOnNodesRealPtr;

/** @typedef FieldOnNodesLongClass Class d'une carte de long */
typedef FieldOnNodesClass< ASTERINTEGER > FieldOnNodesLongClass;

/**
 * @typedef FieldOnNodesLongPtr
 * @brief Definition d'un champ aux noeuds de long
 */
typedef boost::shared_ptr< FieldOnNodesLongClass > FieldOnNodesLongPtr;

/** @typedef FieldOnNodesClassComplex Class d'un champ aux noeuds de complexes */
typedef FieldOnNodesClass< RealComplex > FieldOnNodesComplexClass;

/**
 * @typedef FieldOnNodesComplexPtr
 * @brief Definition d'un champ aux noeuds de complexes
 */
typedef boost::shared_ptr< FieldOnNodesComplexClass > FieldOnNodesComplexPtr;

#endif /* FIELDONNODES_H_ */
