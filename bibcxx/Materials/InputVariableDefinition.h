#ifndef INPUTVARIABLEDEFINITION_H_
#define INPUTVARIABLEDEFINITION_H_

/**
 * @file InputVariableDefinitionInstance.h
 * @brief Fichier entete de la classe InputVariableDefinitionInstance
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2017  EDF R&D                www.code-aster.org
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

#include "astercxx.h"
#include "Meshes/Mesh.h"
#include "DataFields/GenericDataField.h"

struct TemperatureInputVariableTraits
{
    constexpr static const char* name = "TEMP";
};

struct GeometryInputVariableTraits
{
    constexpr static const char* name = "GEOM";
};

struct CorrosionInputVariableTraits
{
    constexpr static const char* name = "CORR";
};

struct IrreversibleDeformationInputVariableTraits
{
    constexpr static const char* name = "EPSA";
};

struct ConcreteHydratationInputVariableTraits
{
    constexpr static const char* name = "HYDR";
};

struct IrradiationInputVariableTraits
{
    constexpr static const char* name = "IRRA";
};

struct SteelPhasesInputVariableTraits
{
    constexpr static const char* name = "M_ACIER";
};

struct ZircaloyPhasesInputVariableTraits
{
    constexpr static const char* name = "M_ZIRC";
};

struct Neutral1InputVariableTraits
{
    constexpr static const char* name = "NEUT1";
};

struct Neutral2InputVariableTraits
{
    constexpr static const char* name = "NEUT2";
};

struct ConcreteDryingInputVariableTraits
{
    constexpr static const char* name = "SECH";
};

struct TotalFluidPressureInputVariableTraits
{
    constexpr static const char* name = "PTOT";
};

struct VolumetricDeformationInputVariableTraits
{
    constexpr static const char* name = "DIVU";
};

/**
 * @class GenericInputVariableInstance
 * @brief Input Variable Definition
 * @author Nicolas Sellenet
 */
class GenericInputVariableInstance
{
private:
    BaseMeshPtr                  _mesh;
    MeshEntityPtr                _localization;
    double                       _refValue;
    bool                         _refValueSet;
    GenericDataFieldPtr          _chamGd;

public:
    typedef boost::shared_ptr< GenericInputVariableInstance > GenericInputVariablePtr;

    /**
     * @brief Constructeur
     */
    GenericInputVariableInstance( const BaseMeshPtr& mesh ):
        _mesh( mesh ),
        _localization( new AllMeshEntities() ),
        _refValue( 0. ),
        _refValueSet( false )
    {};

    /**
     * @brief Constructeur
     */
    GenericInputVariableInstance( const BaseMeshPtr& mesh, const std::string& nameOfGroup ):
        _mesh( mesh ),
        _localization( new GroupOfElements( nameOfGroup ) ),
        _refValue( 0. ),
        _refValueSet( false )
    {
        if ( !_mesh->hasGroupOfElements( nameOfGroup ) )
            throw std::runtime_error( nameOfGroup + " not in support mesh" );
    };

    /**
     * @brief Destructeur
     */
    ~GenericInputVariableInstance()
    {};

    /**
     * @brief Function to know if a reference value exists in input variable
     */
    bool existsReferenceValue() const
    {
        return _refValueSet;
    };

    /**
     * @brief Get the name of the variable
     */
    virtual std::string getVariableName() const throw( std::runtime_error )
    {
        throw std::runtime_error( "Reference value not set" );
        return std::string( "NOTHING" );
    };

    /**
     * @brief Get the reference value of input variable
     */
    double getReferenceValue() const
        throw( std::runtime_error )
    {
        if( !_refValueSet )
            throw std::runtime_error( "Reference value not set" );
        return _refValue;
    };

    /**
     * @brief Function to set the field of values of the imput variable
     */
    void setInputValuesField( const GenericDataFieldPtr& field )
    {
        _chamGd = field;
    };

    /**
     * @brief Function to set the reference value of input variable
     */
    void setReferenceValue( const double& value )
    {
        _refValue = value;
        _refValueSet = true;
    };
};

/**
 * @class InputVariableDefinitionInstance
 * @brief Input Variable Definition
 * @author Nicolas Sellenet
 */
template< typename ParameterClass >
class InputVariableDefinitionInstance: public GenericInputVariableInstance
{
private:
    constexpr static const char* _varcName = ParameterClass::name;

public:
    /**
     * @brief Constructeur
     */
    InputVariableDefinitionInstance( const BaseMeshPtr& mesh ):
        GenericInputVariableInstance( mesh )
    {};

    /**
     * @brief Constructeur
     */
    InputVariableDefinitionInstance( const BaseMeshPtr& mesh, const std::string& nameOfGroup ):
        GenericInputVariableInstance( mesh, nameOfGroup )
    {};

    /**
     * @brief Destructeur
     */
    ~InputVariableDefinitionInstance()
    {};

    /**
     * @brief Get the name of the variable
     */
    std::string getVariableName() const throw( std::runtime_error )
    {
        return std::string( _varcName );
    };
};

typedef InputVariableDefinitionInstance< TemperatureInputVariableTraits > TemperatureInputVariableInstance;
typedef InputVariableDefinitionInstance< GeometryInputVariableTraits > GeometryInputVariableInstance;
typedef InputVariableDefinitionInstance< CorrosionInputVariableTraits > CorrosionInputVariableInstance;
typedef InputVariableDefinitionInstance< IrreversibleDeformationInputVariableTraits > IrreversibleDeformationInputVariableInstance;
typedef InputVariableDefinitionInstance< ConcreteHydratationInputVariableTraits > ConcreteHydratationInputVariableInstance;
typedef InputVariableDefinitionInstance< IrradiationInputVariableTraits > IrradiationInputVariableInstance;
typedef InputVariableDefinitionInstance< SteelPhasesInputVariableTraits > SteelPhasesInputVariableInstance;
typedef InputVariableDefinitionInstance< ZircaloyPhasesInputVariableTraits > ZircaloyPhasesInputVariableInstance;
typedef InputVariableDefinitionInstance< Neutral1InputVariableTraits > Neutral1InputVariableInstance;
typedef InputVariableDefinitionInstance< Neutral2InputVariableTraits > Neutral2InputVariableInstance;
typedef InputVariableDefinitionInstance< ConcreteDryingInputVariableTraits > ConcreteDryingInputVariableInstance;
typedef InputVariableDefinitionInstance< TotalFluidPressureInputVariableTraits > TotalFluidPressureInputVariableInstance;
typedef InputVariableDefinitionInstance< VolumetricDeformationInputVariableTraits > VolumetricDeformationInputVariableInstance;

typedef boost::shared_ptr< TemperatureInputVariableInstance > TemperatureInputVariablePtr;
typedef boost::shared_ptr< GeometryInputVariableInstance > GeometryInputVariablePtr;
typedef boost::shared_ptr< CorrosionInputVariableInstance > CorrosionInputVariablePtr;
typedef boost::shared_ptr< IrreversibleDeformationInputVariableInstance > IrreversibleDeformationInputVariablePtr;
typedef boost::shared_ptr< ConcreteHydratationInputVariableInstance > ConcreteHydratationInputVariablePtr;
typedef boost::shared_ptr< IrradiationInputVariableInstance > IrradiationInputVariablePtr;
typedef boost::shared_ptr< SteelPhasesInputVariableInstance > SteelPhasesInputVariablePtr;
typedef boost::shared_ptr< ZircaloyPhasesInputVariableInstance > ZircaloyPhasesInputVariablePtr;
typedef boost::shared_ptr< Neutral1InputVariableInstance > Neutral1InputVariablePtr;
typedef boost::shared_ptr< Neutral2InputVariableInstance > Neutral2InputVariablePtr;
typedef boost::shared_ptr< ConcreteDryingInputVariableInstance > ConcreteDryingInputVariablePtr;
typedef boost::shared_ptr< TotalFluidPressureInputVariableInstance > TotalFluidPressureInputVariablePtr;
typedef boost::shared_ptr< VolumetricDeformationInputVariableInstance > VolumetricDeformationInputVariablePtr;

#endif /* INPUTVARIABLEDEFINITION_H_ */
