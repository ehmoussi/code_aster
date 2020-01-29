#ifndef INPUTVARIABLEDEFINITION_H_
#define INPUTVARIABLEDEFINITION_H_

/**
 * @file InputVariableDefinitionClass.h
 * @brief Fichier entete de la classe InputVariableDefinitionClass
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

#include "astercxx.h"
#include "Meshes/Mesh.h"
#include "Meshes/Skeleton.h"
#include "Meshes/ParallelMesh.h"
#include "DataFields/DataField.h"
#include "Results/TimeDependantResultsContainer.h"
#include "Functions/Function.h"
#include "Functions/Formula.h"

class MaterialOnMeshBuilderClass;

/**
 * @class EvolutionParameterClass
 * @brief Class EvolutionParameterClass to be used when InputVariable is time dependant
 * @author Nicolas Sellenet
 */
class EvolutionParameterClass {
  private:
    TimeDependantResultsContainerPtr _evol;
    std::string _nomCham;
    std::string _prolGauche;
    std::string _prolDroite;
    FunctionPtr _foncInst;
    FormulaPtr _formInst;

  public:
    EvolutionParameterClass( const TimeDependantResultsContainerPtr &evol )
        : _evol( evol ), _nomCham( "" ), _prolGauche( "EXCLU" ), _prolDroite( "EXCLU" ),
          _foncInst( nullptr ), _formInst( nullptr ){};

    std::string getFieldName() { return _nomCham; };

    std::string getLeftExtension() { return _prolGauche; };

    std::string getRightExtension() { return _prolDroite; };

    TimeDependantResultsContainerPtr getTimeDependantResultsContainer() { return _evol; };

    FormulaPtr getTimeFormula() { return _formInst; };

    FunctionPtr getTimeFunction() { return _foncInst; };

    void prohibitLeftExtension() { _prolGauche = "EXCLU"; };

    void prohibitRightExtension() { _prolDroite = "EXCLU"; };

    void setConstantLeftExtension() { _prolGauche = "CONSTANT"; };

    void setConstantRightExtension() { _prolDroite = "CONSTANT"; };

    void setFieldName( const std::string &name ) { _nomCham = name; };

    void setLinearLeftExtension() { _prolGauche = "LINEAIRE"; };

    void setLinearRightExtension() { _prolDroite = "LINEAIRE"; };

    void setTimeFunction( const FormulaPtr &func ) {
        _foncInst = nullptr;
        _formInst = func;
    };

    void setTimeFunction( const FunctionPtr &func ) {
        _formInst = nullptr;
        _foncInst = func;
    };
};

typedef boost::shared_ptr< EvolutionParameterClass > EvolutionParameterPtr;

struct TemperatureInputVariableTraits {
    constexpr static const char *name = "TEMP";
};

struct GeometryInputVariableTraits {
    constexpr static const char *name = "GEOM";
};

struct CorrosionInputVariableTraits {
    constexpr static const char *name = "CORR";
};

struct IrreversibleDeformationInputVariableTraits {
    constexpr static const char *name = "EPSA";
};

struct ConcreteHydratationInputVariableTraits {
    constexpr static const char *name = "HYDR";
};

struct IrradiationInputVariableTraits {
    constexpr static const char *name = "IRRA";
};

struct SteelPhasesInputVariableTraits {
    constexpr static const char *name = "M_ACIER";
};

struct ZircaloyPhasesInputVariableTraits {
    constexpr static const char *name = "M_ZIRC";
};

struct Neutral1InputVariableTraits {
    constexpr static const char *name = "NEUT1";
};

struct Neutral2InputVariableTraits {
    constexpr static const char *name = "NEUT2";
};

struct Neutral3InputVariableTraits
{
   constexpr static const char* name = "NEUT3";
};

struct ConcreteDryingInputVariableTraits {
    constexpr static const char *name = "SECH";
};

struct TotalFluidPressureInputVariableTraits {
    constexpr static const char *name = "PTOT";
};

struct VolumetricDeformationInputVariableTraits {
    constexpr static const char *name = "DIVU";
};

/**
 * @class GenericInputVariableClass
 * @brief Input Variable Definition
 * @author Nicolas Sellenet
 */
class GenericInputVariableClass {
  private:
    BaseMeshPtr _mesh;
    MeshEntityPtr _localization;
    double _refValue;
    bool _refValueSet;
    DataFieldPtr _chamGd;
    EvolutionParameterPtr _evolParam;

  public:
    typedef boost::shared_ptr< GenericInputVariableClass > GenericInputVariablePtr;

    /**
     * @brief Constructeur
     */
    GenericInputVariableClass( const BaseMeshPtr &mesh )
        : _mesh( mesh ), _localization( new AllMeshEntities() ), _refValue( 0. ),
          _refValueSet( false ){};

    /**
     * @brief Constructeur
     */
    GenericInputVariableClass( const BaseMeshPtr &mesh, const std::string &nameOfGroup )
        : _mesh( mesh ), _localization( new GroupOfElements( nameOfGroup ) ), _refValue( 0. ),
          _refValueSet( false ) {
        if ( !_mesh->hasGroupOfElements( nameOfGroup ) )
            throw std::runtime_error( nameOfGroup + " not in mesh" );
    };

    /**
     * @brief Destructeur
     */
    ~GenericInputVariableClass(){};

    /**
     * @brief Function to know if a reference value exists in input variable
     */
    bool existsReferenceValue() const { return _refValueSet; };

    /**
     * @brief Get the field of values of the input variable
     */
    EvolutionParameterPtr getEvolutionParameter() const { return _evolParam; };

    /**
     * @brief Get the field of values of the input variable
     */
    DataFieldPtr getInputValuesField() const { return _chamGd; };

    /**
     * @brief Get the reference value of input variable
     */
    double getReferenceValue() const {
        if ( !_refValueSet )
            throw std::runtime_error( "Reference value not set" );
        return _refValue;
    };

    /**
     * @brief Get the name of the variable
     */
    virtual std::string getVariableName() const {
        throw std::runtime_error( "Not allowed" );
        return std::string( "NOTHING" );
    };

    /**
     * @brief Function to set the evolution parameter of the input variable
     */
    void setEvolutionParameter( const EvolutionParameterPtr &evol ) {
        _chamGd = nullptr;
        _evolParam = evol;
    };

    /**
     * @brief Function to set the field of values of the input variable
     */
    void setInputValuesField( const DataFieldPtr &field ) {
        _evolParam = nullptr;
        _chamGd = field;
    };

    /**
     * @brief Function to set the reference value of input variable
     */
    void setReferenceValue( const double &value ) {
        _refValue = value;
        _refValueSet = true;
    };
};

/**
 * @class InputVariableDefinitionClass
 * @brief Input Variable Definition
 * @author Nicolas Sellenet
 */
template < typename ParameterClass >
class InputVariableDefinitionClass : public GenericInputVariableClass {
  private:
    constexpr static const char *_varcName = ParameterClass::name;

  public:
    /**
     * @brief Constructeur
     */
    InputVariableDefinitionClass( const BaseMeshPtr &mesh )
        : GenericInputVariableClass( mesh ){};

    /**
     * @brief Constructeur
     */
    InputVariableDefinitionClass( const BaseMeshPtr &mesh, const std::string &nameOfGroup )
        : GenericInputVariableClass( mesh, nameOfGroup ){};

    /**
     * @brief Destructeur
     */
    ~InputVariableDefinitionClass(){};

    /**
     * @brief Get the name of the variable
     */
    std::string getVariableName() const {
        return std::string( _varcName );
    };
};

typedef InputVariableDefinitionClass< TemperatureInputVariableTraits >
    TemperatureInputVariableClass;
typedef InputVariableDefinitionClass< GeometryInputVariableTraits >
    GeometryInputVariableClass;
typedef InputVariableDefinitionClass< CorrosionInputVariableTraits >
    CorrosionInputVariableClass;
typedef InputVariableDefinitionClass< IrreversibleDeformationInputVariableTraits >
    IrreversibleDeformationInputVariableClass;
typedef InputVariableDefinitionClass< ConcreteHydratationInputVariableTraits >
    ConcreteHydratationInputVariableClass;
typedef InputVariableDefinitionClass< IrradiationInputVariableTraits >
    IrradiationInputVariableClass;
typedef InputVariableDefinitionClass< SteelPhasesInputVariableTraits >
    SteelPhasesInputVariableClass;
typedef InputVariableDefinitionClass< ZircaloyPhasesInputVariableTraits >
    ZircaloyPhasesInputVariableClass;
typedef InputVariableDefinitionClass< Neutral1InputVariableTraits >
    Neutral1InputVariableClass;
typedef InputVariableDefinitionClass< Neutral2InputVariableTraits >
    Neutral2InputVariableClass;
typedef InputVariableDefinitionClass< Neutral3InputVariableTraits >
    Neutral3InputVariableClass;
typedef InputVariableDefinitionClass< ConcreteDryingInputVariableTraits >
    ConcreteDryingInputVariableClass;
typedef InputVariableDefinitionClass< TotalFluidPressureInputVariableTraits >
    TotalFluidPressureInputVariableClass;
typedef InputVariableDefinitionClass< VolumetricDeformationInputVariableTraits >
    VolumetricDeformationInputVariableClass;

typedef boost::shared_ptr< GenericInputVariableClass > GenericInputVariablePtr;
typedef boost::shared_ptr< TemperatureInputVariableClass > TemperatureInputVariablePtr;
typedef boost::shared_ptr< GeometryInputVariableClass > GeometryInputVariablePtr;
typedef boost::shared_ptr< CorrosionInputVariableClass > CorrosionInputVariablePtr;
typedef boost::shared_ptr< IrreversibleDeformationInputVariableClass >
    IrreversibleDeformationInputVariablePtr;
typedef boost::shared_ptr< ConcreteHydratationInputVariableClass >
    ConcreteHydratationInputVariablePtr;
typedef boost::shared_ptr< IrradiationInputVariableClass > IrradiationInputVariablePtr;
typedef boost::shared_ptr< SteelPhasesInputVariableClass > SteelPhasesInputVariablePtr;
typedef boost::shared_ptr< ZircaloyPhasesInputVariableClass > ZircaloyPhasesInputVariablePtr;
typedef boost::shared_ptr< Neutral1InputVariableClass > Neutral1InputVariablePtr;
typedef boost::shared_ptr< Neutral2InputVariableClass > Neutral2InputVariablePtr;
typedef boost::shared_ptr< Neutral3InputVariableClass > Neutral3InputVariablePtr;

typedef boost::shared_ptr< ConcreteDryingInputVariableClass > ConcreteDryingInputVariablePtr;
typedef boost::shared_ptr< TotalFluidPressureInputVariableClass >
    TotalFluidPressureInputVariablePtr;
typedef boost::shared_ptr< VolumetricDeformationInputVariableClass >
    VolumetricDeformationInputVariablePtr;

/**
 * @class InputVariableOnMeshClass
 * @brief Input variable on mesh
 * @author Nicolas Sellenet
 */
class InputVariableOnMeshClass {
    friend class MaterialOnMeshBuilderClass;

  private:
    /** @typedef std::list d'une std::pair de MeshEntityPtr */
    typedef std::vector< std::pair< GenericInputVariablePtr, MeshEntityPtr > >
        VectorOfInputVarAndGrps;
    /** @typedef Definition de la valeur contenue dans un VectorOfInputVarAndGrps */
    typedef VectorOfInputVarAndGrps::value_type VectorOfInputVarAndGrpsValue;
    /** @typedef Definition d'un iterateur sur VectorOfInputVarAndGrps */
    typedef VectorOfInputVarAndGrps::iterator VectorOfInputVarAndGrpsIter;

    /** @brief Vector of GenericInputVariableClass */
    VectorOfInputVarAndGrps _inputVars;
    /** @brief Maillage sur lequel repose la sd_cham_mater */
    BaseMeshPtr _mesh;

  public:
    InputVariableOnMeshClass( const MeshPtr &mesh ) : _mesh( mesh ){};

    InputVariableOnMeshClass( const SkeletonPtr &mesh ) : _mesh( mesh ){};

#ifdef _USE_MPI
    InputVariableOnMeshClass( const ParallelMeshPtr &mesh ) : _mesh( mesh ){};
#endif /* _USE_MPI */

    /**
     * @brief Add an input variable on all mesh
     */
    template < class InputVariablePtr >
    void addInputVariableOnAllMesh( const InputVariablePtr &curBehav ) {
        _inputVars.push_back(
            VectorOfInputVarAndGrpsValue( curBehav, MeshEntityPtr( new AllMeshEntities() ) ) );
    };

    /**
     * @brief Add an input variable on a group of mesh
     */
    template < class InputVariablePtr >
    void addInputVariableOnGroupOfElements(
        const InputVariablePtr &curBehav,
        const std::string &nameOfGroup ) {
        if ( !_mesh )
            throw std::runtime_error( "Mesh is not defined" );
        if ( !_mesh->hasGroupOfElements( nameOfGroup ) )
            throw std::runtime_error( nameOfGroup + "not in mesh" );

        _inputVars.push_back( VectorOfInputVarAndGrpsValue(
            curBehav, MeshEntityPtr( new GroupOfElements( nameOfGroup ) ) ) );
    };

    /**
     * @brief Add an input variable on an element
     */
    template < class InputVariablePtr >
    void addInputVariableOnElement( const InputVariablePtr &curBehav,
                                    const std::string &nameOfElement ) {
        if ( !_mesh )
            throw std::runtime_error( "Mesh is not defined" );

        _inputVars.push_back( VectorOfInputVarAndGrpsValue(
            curBehav, MeshEntityPtr( new Element( nameOfElement ) ) ) );
    };
};

/**
 * @typedef InputVariableOnMeshPtr
 * @brief Pointeur intelligent vers un InputVariableOnMeshClass
 */
typedef boost::shared_ptr< InputVariableOnMeshClass > InputVariableOnMeshPtr;

#endif /* INPUTVARIABLEDEFINITION_H_ */
