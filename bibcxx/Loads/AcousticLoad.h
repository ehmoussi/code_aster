#ifndef ACOUSTICLOAD_H_
#define ACOUSTICLOAD_H_

/**
 * @file AcousticLoad.h
 * @brief Fichier entete de la classe AcousticLoad
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

#include "DataFields/PCFieldOnMesh.h"
#include "DataStructures/DataStructure.h"
#include "Loads/PhysicalQuantity.h"
#include "MemoryManager/JeveuxVector.h"
#include "Meshes/LocalizationManager.h"
#include "Modeling/FiniteElementDescriptor.h"
#include "Modeling/Model.h"
#include "Supervis/ResultNaming.h"
#include "Utilities/CapyConvertibleValue.h"
#include "astercxx.h"
#include <list>
#include <stdexcept>
#include <string>

extern const char SANS_GROUP_MA[];
extern const char SANS_GROUP_NO[];

/**
 * @class GenericUnitaryAcousticsLoadClass
 * @brief Classe definissant une charge acoustique générique (issue d'AFFE_CHAR_ACOU)
 * @author Nicolas Sellenet
 */
struct GenericUnitaryAcousticLoadClass {};

/**
 * @class UnitaryAcousticLoadClass
 * @brief Classe template definissant une charge acoustique
 * @author Nicolas Sellenet
 */
template < typename Phys, typename Loc >
class UnitaryAcousticLoadClass : public Phys, public Loc {
  public:
    UnitaryAcousticLoadClass() : Phys(), Loc(){};

    CapyConvertibleContainer getCapyConvertibleContainer() {
        return Phys::getCapyConvertibleContainer() + Loc::getCapyConvertibleContainer();
    };
};

typedef CapyLocalizationManager< GroupOfElementsManager<>, GroupOfNodesManager<>,
                                 AllMeshEntitiesManager, GroupOfElementsManager< SANS_GROUP_MA >,
                                 GroupOfNodesManager< SANS_GROUP_NO > >
    AllNodesElementsWithoutLocalization;

typedef boost::shared_ptr< GenericUnitaryAcousticLoadClass > GenericAcousticLoadPtr;

template class UnitaryAcousticLoadClass< PressureComplexClass,
                                             AllNodesElementsWithoutLocalization >;
typedef UnitaryAcousticLoadClass< PressureComplexClass, AllNodesElementsWithoutLocalization >
    ImposedComplexPressureClass;
typedef boost::shared_ptr< ImposedComplexPressureClass > ImposedComplexPressurePtr;

template class UnitaryAcousticLoadClass< NormalSpeedComplexClass, AllElementsLocalization >;
typedef UnitaryAcousticLoadClass< NormalSpeedComplexClass, AllElementsLocalization >
    ImposedComplexNormalSpeedClass;
typedef boost::shared_ptr< ImposedComplexNormalSpeedClass > ImposedComplexNormalSpeedPtr;

template class UnitaryAcousticLoadClass< ImpedanceComplexClass, AllElementsLocalization >;
typedef UnitaryAcousticLoadClass< ImpedanceComplexClass, AllElementsLocalization >
    ComplexImpedanceClass;
typedef boost::shared_ptr< ComplexImpedanceClass > ComplexImpedancePtr;

class UniformConnectionClass {
  private:
    VectorComponent _values;
    CapyConvertibleContainer _toCapyConverter;

  public:
    UniformConnectionClass(){};

    void setValue( const VectorComponent &values ) {
        _values = values;
        VectorString allNames( ComponentNames.size() );
        transform( ComponentNames.begin(), ComponentNames.end(), allNames.begin(), value );
        _toCapyConverter.add( new CapyConvertibleValue< VectorComponent >(
            true, "DDL", _values, allComponents, allNames, true ) );
    };

    CapyConvertibleContainer getCapyConvertibleContainer() { return _toCapyConverter; };
};

template class UnitaryAcousticLoadClass< UniformConnectionClass, AllElementsLocalization >;
typedef UnitaryAcousticLoadClass< UniformConnectionClass, NodesElementsLocalization >
    UniformConnection;
typedef boost::shared_ptr< UniformConnection > UniformConnectionPtr;

class AcousticLoadClass : public DataStructure {
  private:
    ModelPtr _model;
    BaseMeshPtr _mesh;
    std::vector< ImposedComplexPressurePtr > _pressure;
    std::vector< ImposedComplexNormalSpeedPtr > _speed;
    std::vector< ComplexImpedancePtr > _impedance;
    std::vector< UniformConnectionPtr > _connection;

    /** @brief Conteneur des mots-clés avec traduction */
    CapyConvertibleContainer _toCapyConverter;

    JeveuxVectorChar8 _modelName;
    JeveuxVectorChar8 _type;
    PCFieldOnMeshComplexPtr _imposedValues;
    PCFieldOnMeshComplexPtr _multiplier;
    PCFieldOnMeshComplexPtr _impedanceValues;
    PCFieldOnMeshComplexPtr _speedValues;
    /** @brief FiniteElementDescriptor of load */
    FiniteElementDescriptorPtr _FEDesc;

  public:
    /**
     * @typedef AcousticLoadPtr
     * @brief Pointeur intelligent vers un AcousticLoad
     */
    typedef boost::shared_ptr< AcousticLoadClass > AcousticLoadPtr;

    /**
     * @brief Constructeur
     */
    AcousticLoadClass( const ModelPtr &model )
        : AcousticLoadClass( ResultNaming::getNewResultName(), model ){};

    /**
     * @brief Constructeur
     */
    AcousticLoadClass( const std::string name, const ModelPtr &model )
        : DataStructure( name, 8, "CHAR_ACOU" ), _model( model ),
          _mesh( model->getMesh() ),
          _modelName( JeveuxVectorChar8( getName() + ".CHAC.MODEL.NOMO" ) ),
          _type( JeveuxVectorChar8( getName() + ".TYPE" ) ),
          _imposedValues( PCFieldOnMeshComplexPtr(
              new PCFieldOnMeshComplexClass( getName() + ".CHAC.CIMPO", _mesh ) ) ),
          _multiplier( PCFieldOnMeshComplexPtr(
              new PCFieldOnMeshComplexClass( getName() + ".CHAC.CMULT", _mesh ) ) ),
          _impedanceValues( PCFieldOnMeshComplexPtr(
              new PCFieldOnMeshComplexClass( getName() + ".CHAC.IMPED", _mesh ) ) ),
          _speedValues( PCFieldOnMeshComplexPtr(
              new PCFieldOnMeshComplexClass( getName() + ".CHAC.VITFA", _mesh ) ) ),
          _FEDesc( new FiniteElementDescriptorClass( name + "CHAC.LIGRE", _mesh ) ) {
        _toCapyConverter.add(
            new CapyConvertibleValue< ModelPtr >( true, "MODELE", _model, true ) );
    };

    void addImposedNormalSpeedOnAllMesh( const RealComplex &speed ) {
        ImposedComplexNormalSpeedPtr toAdd( new ImposedComplexNormalSpeedClass() );
        toAdd->setValue( Vnor, speed );
        toAdd->setOnAllMeshEntities();
        _speed.push_back( toAdd );
    };

    void addImposedNormalSpeedOnGroupsOfElements( const VectorString &names,
                                                  const RealComplex &speed ) {
        ImposedComplexNormalSpeedPtr toAdd( new ImposedComplexNormalSpeedClass() );
        toAdd->setValue( Vnor, speed );
        for ( auto name : names )
            toAdd->GroupOfElementsManager<>::addGroupOfElements( name );
        _speed.push_back( toAdd );
    };

    void addImpedanceOnAllMesh( const RealComplex &impe ) {
        ComplexImpedancePtr toAdd( new ComplexImpedanceClass() );
        toAdd->setValue( Impe, impe );
        toAdd->setOnAllMeshEntities();
        _impedance.push_back( toAdd );
    };

    void addImpedanceOnGroupsOfElements( const VectorString &names, const RealComplex &impe ) {
        ComplexImpedancePtr toAdd( new ComplexImpedanceClass() );
        toAdd->setValue( Impe, impe );
        for ( auto name : names )
            toAdd->GroupOfElementsManager<>::addGroupOfElements( name );
        _impedance.push_back( toAdd );
    };

    void addImposedPressureOnAllMesh( const RealComplex &pres ) {
        ImposedComplexPressurePtr toAdd( new ImposedComplexPressureClass() );
        toAdd->setValue( Pres, pres );
        toAdd->setOnAllMeshEntities();
        _pressure.push_back( toAdd );
    };

    void addImposedPressureOnGroupsOfElements( const VectorString &names,
                                               const RealComplex &pres ) {
        ImposedComplexPressurePtr toAdd( new ImposedComplexPressureClass() );
        toAdd->setValue( Pres, pres );
        for ( auto name : names )
            toAdd->GroupOfElementsManager<>::addGroupOfElements( name );
        _pressure.push_back( toAdd );
    };

    void addImposedPressureOnGroupsOfNodes( const VectorString &names, const RealComplex &pres ) {
        ImposedComplexPressurePtr toAdd( new ImposedComplexPressureClass() );
        toAdd->setValue( Pres, pres );
        for ( auto name : names )
            toAdd->GroupOfNodesManager<>::addGroupOfNodes( name );
        _pressure.push_back( toAdd );
    };

    void addUniformConnectionOnGroupsOfElements( const VectorString &names,
                                                 const VectorComponent &val ) {
        UniformConnectionPtr toAdd( new UniformConnection() );
        toAdd->setValue( val );
        for ( auto name : names )
            toAdd->GroupOfElementsManager<>::addGroupOfElements( name );
        _connection.push_back( toAdd );
    };

    void addUniformConnectionOnGroupsOfNodes( const VectorString &names,
                                              const VectorComponent &val ) {
        UniformConnectionPtr toAdd( new UniformConnection() );
        toAdd->setValue( val );
        for ( auto name : names )
            toAdd->GroupOfNodesManager<>::addGroupOfNodes( name );
        _connection.push_back( toAdd );
    };

    bool build();

    /**
     * @brief Get the finite element descriptor
     */
    FiniteElementDescriptorPtr getFiniteElementDescriptor() const { return _FEDesc; };

    /**
     * @brief Get the model
     */
    ModelPtr getModel()
    {
        return _model;
    };
};

typedef boost::shared_ptr< AcousticLoadClass > AcousticLoadPtr;

#endif /* ACOUSTICLOAD_H_ */
