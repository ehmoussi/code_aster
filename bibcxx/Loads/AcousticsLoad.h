#ifndef ACOUSTICSLOAD_H_
#define ACOUSTICSLOAD_H_

/**
 * @file AcousticsLoad.h
 * @brief Fichier entete de la classe AcousticsLoad
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2019  EDF R&D                www.code-aster.org
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
 * @class GenericUnitaryAcousticsLoadInstance
 * @brief Classe definissant une charge acoustique générique (issue d'AFFE_CHAR_ACOU)
 * @author Nicolas Sellenet
 */
struct GenericUnitaryAcousticsLoadInstance {};

/**
 * @class UnitaryAcousticsLoadInstance
 * @brief Classe template definissant une charge acoustique
 * @author Nicolas Sellenet
 */
template < typename Phys, typename Loc >
class UnitaryAcousticsLoadInstance : public Phys, public Loc {
  public:
    UnitaryAcousticsLoadInstance() : Phys(), Loc(){};

    CapyConvertibleContainer getCapyConvertibleContainer() {
        return Phys::getCapyConvertibleContainer() + Loc::getCapyConvertibleContainer();
    };
};

typedef CapyLocalizationManager< GroupOfElementsManager<>, GroupOfNodesManager<>,
                                 AllMeshEntitiesManager, GroupOfElementsManager< SANS_GROUP_MA >,
                                 GroupOfNodesManager< SANS_GROUP_NO > >
    AllNodesElementsWithoutLocalization;

typedef boost::shared_ptr< GenericUnitaryAcousticsLoadInstance > GenericAcousticsLoadPtr;

template class UnitaryAcousticsLoadInstance< PressureComplexInstance,
                                             AllNodesElementsWithoutLocalization >;
typedef UnitaryAcousticsLoadInstance< PressureComplexInstance, AllNodesElementsWithoutLocalization >
    ImposedComplexPressureInstance;
typedef boost::shared_ptr< ImposedComplexPressureInstance > ImposedComplexPressurePtr;

template class UnitaryAcousticsLoadInstance< NormalSpeedComplexInstance, AllElementsLocalization >;
typedef UnitaryAcousticsLoadInstance< NormalSpeedComplexInstance, AllElementsLocalization >
    ImposedComplexNormalSpeedInstance;
typedef boost::shared_ptr< ImposedComplexNormalSpeedInstance > ImposedComplexNormalSpeedPtr;

template class UnitaryAcousticsLoadInstance< ImpedanceComplexInstance, AllElementsLocalization >;
typedef UnitaryAcousticsLoadInstance< ImpedanceComplexInstance, AllElementsLocalization >
    ComplexImpedanceInstance;
typedef boost::shared_ptr< ComplexImpedanceInstance > ComplexImpedancePtr;

class UniformConnectionInstance {
  private:
    VectorComponent _values;
    CapyConvertibleContainer _toCapyConverter;

  public:
    UniformConnectionInstance(){};

    void setValue( const VectorComponent &values ) {
        _values = values;
        VectorString allNames( ComponentNames.size() );
        transform( ComponentNames.begin(), ComponentNames.end(), allNames.begin(), value );
        _toCapyConverter.add( new CapyConvertibleValue< VectorComponent >(
            true, "DDL", _values, allComponents, allNames, true ) );
    };

    CapyConvertibleContainer getCapyConvertibleContainer() { return _toCapyConverter; };
};

template class UnitaryAcousticsLoadInstance< UniformConnectionInstance, AllElementsLocalization >;
typedef UnitaryAcousticsLoadInstance< UniformConnectionInstance, NodesElementsLocalization >
    UniformConnection;
typedef boost::shared_ptr< UniformConnection > UniformConnectionPtr;

class AcousticsLoadInstance : public DataStructure {
  private:
    ModelPtr _supportModel;
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
     * @typedef AcousticsLoadPtr
     * @brief Pointeur intelligent vers un AcousticsLoad
     */
    typedef boost::shared_ptr< AcousticsLoadInstance > AcousticsLoadPtr;

    /**
     * @brief Constructeur
     */
    AcousticsLoadInstance( const ModelPtr &model )
        : AcousticsLoadInstance( ResultNaming::getNewResultName(), model ){};

    /**
     * @brief Constructeur
     */
    AcousticsLoadInstance( const std::string name, const ModelPtr &model )
        : DataStructure( name, 8, "CHAR_ACOU" ), _supportModel( model ),
          _mesh( model->getMesh() ),
          _modelName( JeveuxVectorChar8( getName() + ".CHAC.MODEL.NOMO" ) ),
          _type( JeveuxVectorChar8( getName() + ".TYPE" ) ),
          _imposedValues( PCFieldOnMeshComplexPtr(
              new PCFieldOnMeshComplexInstance( getName() + ".CHAC.CIMPO", _mesh ) ) ),
          _multiplier( PCFieldOnMeshComplexPtr(
              new PCFieldOnMeshComplexInstance( getName() + ".CHAC.CMULT", _mesh ) ) ),
          _impedanceValues( PCFieldOnMeshComplexPtr(
              new PCFieldOnMeshComplexInstance( getName() + ".CHAC.IMPED", _mesh ) ) ),
          _speedValues( PCFieldOnMeshComplexPtr(
              new PCFieldOnMeshComplexInstance( getName() + ".CHAC.VITFA", _mesh ) ) ),
          _FEDesc( new FiniteElementDescriptorInstance( name + "CHAC.LIGRE", _mesh ) ) {
        _toCapyConverter.add(
            new CapyConvertibleValue< ModelPtr >( true, "MODELE", _supportModel, true ) );
    };

    void addImposedNormalSpeedOnAllMesh( const DoubleComplex &speed ) {
        ImposedComplexNormalSpeedPtr toAdd( new ImposedComplexNormalSpeedInstance() );
        toAdd->setValue( Vnor, speed );
        toAdd->setOnAllMeshEntities();
        _speed.push_back( toAdd );
    };

    void addImposedNormalSpeedOnGroupsOfElements( const VectorString &names,
                                                  const DoubleComplex &speed ) {
        ImposedComplexNormalSpeedPtr toAdd( new ImposedComplexNormalSpeedInstance() );
        toAdd->setValue( Vnor, speed );
        for ( auto name : names )
            toAdd->GroupOfElementsManager<>::addGroupOfElements( name );
        _speed.push_back( toAdd );
    };

    void addImpedanceOnAllMesh( const DoubleComplex &impe ) {
        ComplexImpedancePtr toAdd( new ComplexImpedanceInstance() );
        toAdd->setValue( Impe, impe );
        toAdd->setOnAllMeshEntities();
        _impedance.push_back( toAdd );
    };

    void addImpedanceOnGroupsOfElements( const VectorString &names, const DoubleComplex &impe ) {
        ComplexImpedancePtr toAdd( new ComplexImpedanceInstance() );
        toAdd->setValue( Impe, impe );
        for ( auto name : names )
            toAdd->GroupOfElementsManager<>::addGroupOfElements( name );
        _impedance.push_back( toAdd );
    };

    void addImposedPressureOnAllMesh( const DoubleComplex &pres ) {
        ImposedComplexPressurePtr toAdd( new ImposedComplexPressureInstance() );
        toAdd->setValue( Pres, pres );
        toAdd->setOnAllMeshEntities();
        _pressure.push_back( toAdd );
    };

    void addImposedPressureOnGroupsOfElements( const VectorString &names,
                                               const DoubleComplex &pres ) {
        ImposedComplexPressurePtr toAdd( new ImposedComplexPressureInstance() );
        toAdd->setValue( Pres, pres );
        for ( auto name : names )
            toAdd->GroupOfElementsManager<>::addGroupOfElements( name );
        _pressure.push_back( toAdd );
    };

    void addImposedPressureOnGroupsOfNodes( const VectorString &names, const DoubleComplex &pres ) {
        ImposedComplexPressurePtr toAdd( new ImposedComplexPressureInstance() );
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
     * @brief Get the support finite element descriptor
     */
    FiniteElementDescriptorPtr getFiniteElementDescriptor() const { return _FEDesc; };

    /**
     * @brief Get the support model
     */
    ModelPtr getModel()
    {
        return _supportModel;
    };
};

typedef boost::shared_ptr< AcousticsLoadInstance > AcousticsLoadPtr;

#endif /* ACOUSTICSLOAD_H_ */
