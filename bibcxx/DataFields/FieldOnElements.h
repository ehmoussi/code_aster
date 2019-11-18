#ifndef FIELDONELEMENTS_H_
#define FIELDONELEMENTS_H_

/**
 * @file FieldOnElements.h
 * @brief Fichier entete de la classe FieldOnElements
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
#include "DataFields/GenericDataField.h"
#include "DataFields/SimpleFieldOnElements.h"
#include "Modeling/Model.h"
#include "Modeling/FiniteElementDescriptor.h"

/**
 * @class FieldOnElementsInstance
 * @brief Cette classe template permet de definir un champ aux éléments Aster
 * @author Nicolas Sellenet
 */
template < class ValueType > class FieldOnElementsInstance : public GenericDataFieldInstance {
  private:
    typedef SimpleFieldOnElementsInstance< ValueType > SimpleFieldOnElementsValueTypeInstance;
    typedef boost::shared_ptr< SimpleFieldOnElementsDoubleInstance >
        SimpleFieldOnElementsValueTypePtr;

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
     * @typedef FieldOnElementsPtr
     * @brief Pointeur intelligent vers un FieldOnElements
     */
    typedef boost::shared_ptr< FieldOnElementsInstance > FieldOnElementsPtr;

    /**
     * @brief Constructeur
     * @param name Nom Jeveux du champ aux éléments
     */
    FieldOnElementsInstance( const std::string name )
        : GenericDataFieldInstance( name, "CHAM_ELEM" ),
          _descriptor( JeveuxVectorLong( getName() + ".CELD" ) ),
          _reference( JeveuxVectorChar24( getName() + ".CELK" ) ),
          _valuesList( JeveuxVector< ValueType >( getName() + ".CELV" ) ), _model( nullptr ),
          _title( JeveuxVectorChar80( getName() + ".TITR" ) ){};

    /**
     * @brief Constructeur
     * @param memType Mémoire d'allocation
     */
    FieldOnElementsInstance( const JeveuxMemory memType = Permanent )
        : GenericDataFieldInstance( memType, "CHAM_ELEM" ),
          _descriptor( JeveuxVectorLong( getName() + ".CELD" ) ),
          _reference( JeveuxVectorChar24( getName() + ".CELK" ) ),
          _valuesList( JeveuxVector< ValueType >( getName() + ".CELV" ) ), _model( nullptr ),
          _title( JeveuxVectorChar80( getName() + ".TITR" ) ){};

    ~FieldOnElementsInstance() {
#ifdef __DEBUG_GC__
        std::cout << "FieldOnElements.destr: " << this->getName() << std::endl;
#endif
    };

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
    SimpleFieldOnElementsValueTypePtr exportToSimpleFieldOnElements() {
        SimpleFieldOnElementsValueTypePtr toReturn(
            new SimpleFieldOnElementsValueTypeInstance( getMemoryType() ) );
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

    friend class FieldBuilder;
};

/** @typedef FieldOnElementsInstanceDouble Instance d'une carte de double */
typedef FieldOnElementsInstance< double > FieldOnElementsDoubleInstance;

/**
 * @typedef FieldOnElementsPtrDouble
 * @brief Definition d'un champ aux éléments de double
 */
typedef boost::shared_ptr< FieldOnElementsDoubleInstance > FieldOnElementsDoublePtr;

/** @typedef FieldOnElementsInstanceLong Instance d'une carte de long */
typedef FieldOnElementsInstance< ASTERINTEGER > FieldOnElementsLongInstance;

/**
 * @typedef FieldOnElementsPtrLong
 * @brief Definition d'un champ aux éléments de long
 */
typedef boost::shared_ptr< FieldOnElementsLongInstance > FieldOnElementsLongPtr;

#endif /* FIELDONELEMENTS_H_ */
