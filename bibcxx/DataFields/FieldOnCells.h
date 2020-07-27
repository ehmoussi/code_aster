#ifndef FIELDONCELLS_H_
#define FIELDONCELLS_H_

/**
 * @file FieldOnCells.h
 * @brief Fichier entete de la classe FieldOnCells
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

#include <string>
#include <assert.h>

#include "astercxx.h"
#include "aster_fort_superv.h"

#include "aster_fort_ds.h"
#include "MemoryManager/JeveuxVector.h"
#include "DataFields/DataField.h"
#include "DataFields/SimpleFieldOnCells.h"
#include "Modeling/Model.h"
#include "Modeling/FiniteElementDescriptor.h"
#include "PythonBindings/LogicalUnitManager.h"
#include "Supervis/CommandSyntax.h"


/**
 * @class FieldOnCellsClass
 * @brief Cette classe template permet de definir un champ aux éléments Aster
 * @author Nicolas Sellenet
 */
template < class ValueType > class FieldOnCellsClass : public DataFieldClass {
  private:
    typedef SimpleFieldOnCellsClass< ValueType > SimpleFieldOnCellsValueTypeClass;
    typedef boost::shared_ptr< SimpleFieldOnCellsRealClass >
        SimpleFieldOnCellsValueTypePtr;

    /** @brief Vecteur Jeveux '.CELD' */
    JeveuxVectorLong _descriptor;
    /** @brief Vecteur Jeveux '.CELK' */
    JeveuxVectorChar24 _reference;
    /** @brief Vecteur Jeveux '.CELV' */
    JeveuxVector< ValueType > _valuesList;
    /** @brief Modele */
    ModelPtr _model;
    /** @brief Finite element description */
    FiniteElementDescriptorPtr _dofDescription;
    /** @brief jeveux vector '.TITR' */
    JeveuxVectorChar80 _title;

  public:
    /**
     * @typedef FieldOnCellsPtr
     * @brief Pointeur intelligent vers un FieldOnCells
     */
    typedef boost::shared_ptr< FieldOnCellsClass > FieldOnCellsPtr;

    /**
     * @brief Constructeur
     * @param name Nom Jeveux du champ aux éléments
     */
    FieldOnCellsClass( const std::string name )
        : DataFieldClass( name, "CHAM_ELEM" ),
          _descriptor( JeveuxVectorLong( getName() + ".CELD" ) ),
          _reference( JeveuxVectorChar24( getName() + ".CELK" ) ),
          _valuesList( JeveuxVector< ValueType >( getName() + ".CELV" ) ), _model( nullptr ),
          _title( JeveuxVectorChar80( getName() + ".TITR" ) ){};

    /**
     * @brief Constructeur
     * @param memType Mémoire d'allocation
     */
    FieldOnCellsClass( const JeveuxMemory memType = Permanent )
        : DataFieldClass( memType, "CHAM_ELEM" ),
          _descriptor( JeveuxVectorLong( getName() + ".CELD" ) ),
          _reference( JeveuxVectorChar24( getName() + ".CELK" ) ),
          _valuesList( JeveuxVector< ValueType >( getName() + ".CELV" ) ), _model( nullptr ),
          _title( JeveuxVectorChar80( getName() + ".TITR" ) ){};

    /**
     * @brief
     * @return
     */
    void deallocate() {
        _descriptor->deallocate();
        _reference->deallocate();
        _valuesList->deallocate();
    };

    /**
     * @brief
     * @return
     */
    SimpleFieldOnCellsValueTypePtr exportToSimpleFieldOnCells() {
        SimpleFieldOnCellsValueTypePtr toReturn(
            new SimpleFieldOnCellsValueTypeClass( getMemoryType() ) );
        const std::string resultName = toReturn->getName();
        const std::string inName = getName();
        const std::string copyNan( "OUI" );
        CALLO_CELCES_WRAP( inName, JeveuxMemoryTypesNames[getMemoryType()], resultName );
        toReturn->updateValuePointers();
        return toReturn;
    };

    /**
     * @brief Get the model
     */
    ModelPtr getModel() const {
        if ( _model->isEmpty() )
            throw std::runtime_error( "Model is empty" );
        return _model;
    };

    /**
     * @brief Set the description of finite elements
     * @param curDesc object FiniteElementDescriptorPtr
     */
    void setDescription( FiniteElementDescriptorPtr &curDesc ) {
        if ( _dofDescription )
            throw std::runtime_error( "FiniteElementDescriptor already set" );
        _dofDescription = curDesc;
    };

    /**
     * @brief Definition du modele
     * @param currentMesh objet Model sur lequel la charge reposera
     */
    bool setModel( ModelPtr &currentModel ) {
        if ( currentModel->isEmpty() )
            throw std::runtime_error( "Model is empty" );
        _model = currentModel;
        return true;
    };

    /**
     * @brief Update field and build FiniteElementDescriptor if necessary
     */
    bool update() {
        if ( _dofDescription == nullptr && updateValuePointers() ) {
            if ( _model == nullptr )
                throw std::runtime_error( "Model is empty" );
            _dofDescription = _model->getFiniteElementDescriptor();
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

    bool printMedFile( const std::string fileName ) const;

    friend class FieldBuilder;
};

template < class ValueType >
bool FieldOnCellsClass< ValueType >::printMedFile( const std::string fileName ) const {
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

/** @typedef FieldOnCellsClassReal Class d'une carte de double */
typedef FieldOnCellsClass< double > FieldOnCellsRealClass;

/**
 * @typedef FieldOnCellsPtrReal
 * @brief Definition d'un champ aux éléments de double
 */
typedef boost::shared_ptr< FieldOnCellsRealClass > FieldOnCellsRealPtr;

/** @typedef FieldOnCellsClassLong Class d'une carte de long */
typedef FieldOnCellsClass< ASTERINTEGER > FieldOnCellsLongClass;

/**
 * @typedef FieldOnCellsPtrLong
 * @brief Definition d'un champ aux éléments de long
 */
typedef boost::shared_ptr< FieldOnCellsLongClass > FieldOnCellsLongPtr;

#endif /* FIELDONCELLS_H_ */
