#ifndef INPUTVARIABLEDEFINITION_H_
#define INPUTVARIABLEDEFINITION_H_

/**
 * @file InputVariableDefinition.h
 * @brief Fichier entete de la classe InputVariableDefinition
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
 * @class InputVariableDefinition
 * @brief Input Variable Definition
 * @author Nicolas Sellenet
 */
template< typename ParameterClass >
class InputVariableDefinition
{
private:
    constexpr static const char* _name = ParameterClass::name;
    BaseMeshPtr                  _mesh;
    MeshEntityPtr                _localization;
    std::string                  _varcName;
    double                       _refValue;
    bool                         _refValueSet;

public:
    /**
     * @brief Constructeur
     */
    InputVariableDefinition( const BaseMeshPtr mesh, const std::string name ):
        _mesh( mesh ),
        _localization( new AllMeshEntities() ),
        _varcName( name ),
        _refValue( 0. ),
        _refValueSet( false )
    {};

    /**
     * @brief Constructeur
     */
    InputVariableDefinition( const BaseMeshPtr mesh, const std::string name,
                             const std::string nameOfGroup ):
        _mesh( mesh ),
        _localization( new GroupOfElements( nameOfGroup ) ),
        _varcName( name ),
        _refValue( 0. ),
        _refValueSet( false )
    {
        if ( !_mesh->hasGroupOfElements( nameOfGroup ) )
            throw std::runtime_error( nameOfGroup + " not in support mesh" );
    };

    /**
     * @brief Destructeur
     */
    ~InputVariableDefinition()
    {};

    /**
     * @brief Function to know if a reference value exists in input variable
     */
    bool existsReferenceValue()
    {
        return _refValueSet;
    };

    /**
     * @brief Get the reference value of input variable
     */
    double getReferenceValue()
        throw( std::runtime_error )
    {
        if( !_refValueSet )
            throw std::runtime_error( "Reference value not set" );
        return _refValue;
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

typedef InputVariableDefinition< TemperatureInputVariableTraits > TemperatureInputVariableDefinition;
typedef InputVariableDefinition< GeometryInputVariableTraits > GeometryInputVariableDefinition;
typedef InputVariableDefinition< CorrosionInputVariableTraits > CorrosionInputVariableDefinition;
typedef InputVariableDefinition< IrreversibleDeformationInputVariableTraits > IrreversibleDeformationInputVariableDefinition;
typedef InputVariableDefinition< ConcreteHydratationInputVariableTraits > ConcreteHydratationInputVariableDefinition;
typedef InputVariableDefinition< IrradiationInputVariableTraits > IrradiationInputVariableDefinition;
typedef InputVariableDefinition< SteelPhasesInputVariableTraits > SteelPhasesInputVariableDefinition;
typedef InputVariableDefinition< ZircaloyPhasesInputVariableTraits > ZircaloyPhasesInputVariableDefinition;
typedef InputVariableDefinition< Neutral1InputVariableTraits > Neutral1InputVariableDefinition;
typedef InputVariableDefinition< Neutral2InputVariableTraits > Neutral2InputVariableDefinition;
typedef InputVariableDefinition< ConcreteDryingInputVariableTraits > ConcreteDryingInputVariableDefinition;
typedef InputVariableDefinition< TotalFluidPressureInputVariableTraits > TotalFluidPressureInputVariableDefinition;
typedef InputVariableDefinition< VolumetricDeformationInputVariableTraits > VolumetricDeformationInputVariableDefinition;

#endif /* INPUTVARIABLEDEFINITION_H_ */
