#ifndef EXTERNALVARIABLEDEFINITION_H_
#define EXTERNALVARIABLEDEFINITION_H_

/**
 * @file ExternalVariablesClass.h
 * @brief Fichier entete de la classe ExternalVariablesClass
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
#include "Results/TransientResult.h"
#include "Functions/Function.h"
#include "Functions/Formula.h"

class MaterialFieldBuilderClass;

/**
 * @class EvolutionParameterClass
 * @brief Class EvolutionParameterClass to be used when ExternalVariable is time dependant
 * @author Nicolas Sellenet
 */
class EvolutionParameterClass {
  private:
    TransientResultPtr _evol;
    std::string _nomCham;
    std::string _prolGauche;
    std::string _prolDroite;
    FunctionPtr _foncInst;
    FormulaPtr _formInst;

  public:
    EvolutionParameterClass( const TransientResultPtr &evol )
        : _evol( evol ), _nomCham( "" ), _prolGauche( "EXCLU" ), _prolDroite( "EXCLU" ),
          _foncInst( nullptr ), _formInst( nullptr ){};

    std::string getFieldName() { return _nomCham; };

    std::string getLeftExtension() { return _prolGauche; };

    std::string getRightExtension() { return _prolDroite; };

    TransientResultPtr getTransientResult() { return _evol; };

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

struct TemperatureExternalVariablesTraits {
    constexpr static const char *name = "TEMP";
};

struct GeometryExternalVariablesTraits {
    constexpr static const char *name = "GEOM";
};

struct CorrosionExternalVariablesTraits {
    constexpr static const char *name = "CORR";
};

struct IrreversibleDeformationExternalVariablesTraits {
    constexpr static const char *name = "EPSA";
};

struct ConcreteHydratationExternalVariablesTraits {
    constexpr static const char *name = "HYDR";
};

struct IrradiationExternalVariablesTraits {
    constexpr static const char *name = "IRRA";
};

struct SteelPhasesExternalVariablesTraits {
    constexpr static const char *name = "M_ACIER";
};

struct ZircaloyPhasesExternalVariablesTraits {
    constexpr static const char *name = "M_ZIRC";
};

struct Neutral1ExternalVariablesTraits {
    constexpr static const char *name = "NEUT1";
};

struct Neutral2ExternalVariablesTraits {
    constexpr static const char *name = "NEUT2";
};

struct Neutral3ExternalVariablesTraits
{
   constexpr static const char* name = "NEUT3";
};

struct ConcreteDryingExternalVariablesTraits {
    constexpr static const char *name = "SECH";
};

struct TotalFluidPressureExternalVariablesTraits {
    constexpr static const char *name = "PTOT";
};

struct VolumetricDeformationExternalVariablesTraits {
    constexpr static const char *name = "DIVU";
};

/**
 * @class BaseExternalVariablesClass
 * @brief Input Variable Definition
 * @author Nicolas Sellenet
 */
class BaseExternalVariablesClass {
  private:
    BaseMeshPtr _mesh;
    MeshEntityPtr _localization;
    double _refValue;
    bool _refValueSet;
    DataFieldPtr _chamGd;
    EvolutionParameterPtr _evolParam;

  public:
    typedef boost::shared_ptr< BaseExternalVariablesClass > BaseExternalVariablesPtr;

    /**
     * @brief Constructeur
     */
    BaseExternalVariablesClass( const BaseMeshPtr &mesh )
        : _mesh( mesh ), _localization( new AllMeshEntities() ), _refValue( 0. ),
          _refValueSet( false ){};

    /**
     * @brief Constructeur
     */
    BaseExternalVariablesClass( const BaseMeshPtr &mesh, const std::string &nameOfGroup )
        : _mesh( mesh ), _localization( new GroupOfCells( nameOfGroup ) ), _refValue( 0. ),
          _refValueSet( false ) {
        if ( !_mesh->hasGroupOfCells( nameOfGroup ) )
            throw std::runtime_error( nameOfGroup + " not in mesh" );
    };

    /**
     * @brief Destructeur
     */
    ~BaseExternalVariablesClass(){};

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
 * @class ExternalVariablesClass
 * @brief Input Variable Definition
 * @author Nicolas Sellenet
 */
template < typename ParameterClass >
class ExternalVariablesClass : public BaseExternalVariablesClass {
  private:
    constexpr static const char *_varcName = ParameterClass::name;

  public:
    /**
     * @brief Constructeur
     */
    ExternalVariablesClass( const BaseMeshPtr &mesh )
        : BaseExternalVariablesClass( mesh ){};

    /**
     * @brief Constructeur
     */
    ExternalVariablesClass( const BaseMeshPtr &mesh, const std::string &nameOfGroup )
        : BaseExternalVariablesClass( mesh, nameOfGroup ){};

    /**
     * @brief Destructeur
     */
    ~ExternalVariablesClass(){};

    /**
     * @brief Get the name of the variable
     */
    std::string getVariableName() const {
        return std::string( _varcName );
    };
};

typedef ExternalVariablesClass< TemperatureExternalVariablesTraits >
    TemperatureExternalVariableClass;
typedef ExternalVariablesClass< GeometryExternalVariablesTraits >
    GeometryExternalVariableClass;
typedef ExternalVariablesClass< CorrosionExternalVariablesTraits >
    CorrosionExternalVariableClass;
typedef ExternalVariablesClass< IrreversibleDeformationExternalVariablesTraits >
    IrreversibleDeformationExternalVariableClass;
typedef ExternalVariablesClass< ConcreteHydratationExternalVariablesTraits >
    ConcreteHydratationExternalVariableClass;
typedef ExternalVariablesClass< IrradiationExternalVariablesTraits >
    IrradiationExternalVariableClass;
typedef ExternalVariablesClass< SteelPhasesExternalVariablesTraits >
    SteelPhasesExternalVariableClass;
typedef ExternalVariablesClass< ZircaloyPhasesExternalVariablesTraits >
    ZircaloyPhasesExternalVariableClass;
typedef ExternalVariablesClass< Neutral1ExternalVariablesTraits >
    Neutral1ExternalVariableClass;
typedef ExternalVariablesClass< Neutral2ExternalVariablesTraits >
    Neutral2ExternalVariableClass;
typedef ExternalVariablesClass< Neutral3ExternalVariablesTraits >
    Neutral3ExternalVariableClass;
typedef ExternalVariablesClass< ConcreteDryingExternalVariablesTraits >
    ConcreteDryingExternalVariableClass;
typedef ExternalVariablesClass< TotalFluidPressureExternalVariablesTraits >
    TotalFluidPressureExternalVariableClass;
typedef ExternalVariablesClass< VolumetricDeformationExternalVariablesTraits >
    VolumetricDeformationExternalVariableClass;

typedef boost::shared_ptr< BaseExternalVariablesClass > BaseExternalVariablesPtr;
typedef boost::shared_ptr< TemperatureExternalVariableClass > TemperatureExternalVariablePtr;
typedef boost::shared_ptr< GeometryExternalVariableClass > GeometryExternalVariablePtr;
typedef boost::shared_ptr< CorrosionExternalVariableClass > CorrosionExternalVariablePtr;
typedef boost::shared_ptr< IrreversibleDeformationExternalVariableClass >
    IrreversibleDeformationExternalVariablePtr;
typedef boost::shared_ptr< ConcreteHydratationExternalVariableClass >
    ConcreteHydratationExternalVariablePtr;
typedef boost::shared_ptr< IrradiationExternalVariableClass > IrradiationExternalVariablePtr;
typedef boost::shared_ptr< SteelPhasesExternalVariableClass > SteelPhasesExternalVariablePtr;
typedef boost::shared_ptr< ZircaloyPhasesExternalVariableClass > ZircaloyPhasesExternalVariablePtr;
typedef boost::shared_ptr< Neutral1ExternalVariableClass > Neutral1ExternalVariablePtr;
typedef boost::shared_ptr< Neutral2ExternalVariableClass > Neutral2ExternalVariablePtr;
typedef boost::shared_ptr< Neutral3ExternalVariableClass > Neutral3ExternalVariablePtr;

typedef boost::shared_ptr< ConcreteDryingExternalVariableClass > ConcreteDryingExternalVariablePtr;
typedef boost::shared_ptr< TotalFluidPressureExternalVariableClass >
    TotalFluidPressureExternalVariablePtr;
typedef boost::shared_ptr< VolumetricDeformationExternalVariableClass >
    VolumetricDeformationExternalVariablePtr;

/**
 * @class ExternalVariablesFieldClass
 * @brief Input variable on mesh
 * @author Nicolas Sellenet
 */
class ExternalVariablesFieldClass {
    friend class MaterialFieldBuilderClass;

  private:
    /** @typedef std::list d'une std::pair de MeshEntityPtr */
    typedef std::vector< std::pair< BaseExternalVariablesPtr, MeshEntityPtr > >
        VectorOfexternalVarAndGrps;
    /** @typedef Definition de la valeur contenue dans un VectorOfexternalVarAndGrps */
    typedef VectorOfexternalVarAndGrps::value_type VectorOfexternalVarAndGrpsValue;
    /** @typedef Definition d'un iterateur sur VectorOfexternalVarAndGrps */
    typedef VectorOfexternalVarAndGrps::iterator VectorOfexternalVarAndGrpsIter;

    /** @brief Vector of BaseExternalVariablesClass */
    VectorOfexternalVarAndGrps _externalVars;
    /** @brief Maillage sur lequel repose la sd_cham_mater */
    BaseMeshPtr _mesh;

  public:
    ExternalVariablesFieldClass( const MeshPtr &mesh ) : _mesh( mesh ){};

    ExternalVariablesFieldClass( const SkeletonPtr &mesh ) : _mesh( mesh ){};

#ifdef _USE_MPI
    ExternalVariablesFieldClass( const ParallelMeshPtr &mesh ) : _mesh( mesh ){};
#endif /* _USE_MPI */

    /**
     * @brief Add an input variable on all mesh
     */
    template < class ExternalVariablePtr >
    void addExternalVariableOnAllMesh( const ExternalVariablePtr &curBehav ) {
        _externalVars.push_back(
            VectorOfexternalVarAndGrpsValue( curBehav, MeshEntityPtr( new AllMeshEntities() ) ) );
    };

    /**
     * @brief Add an input variable on a group of mesh
     */
    template < class ExternalVariablePtr >
    void addExternalVariableOnGroupOfCells(
        const ExternalVariablePtr &curBehav,
        const std::string &nameOfGroup ) {
        if ( !_mesh )
            throw std::runtime_error( "Mesh is not defined" );
        if ( !_mesh->hasGroupOfCells( nameOfGroup ) )
            throw std::runtime_error( nameOfGroup + "not in mesh" );

        _externalVars.push_back( VectorOfexternalVarAndGrpsValue(
            curBehav, MeshEntityPtr( new GroupOfCells( nameOfGroup ) ) ) );
    };

    /**
     * @brief Add an input variable on an element
     */
    template < class ExternalVariablePtr >
    void addExternalVariableOnElement( const ExternalVariablePtr &curBehav,
                                    const std::string &nameOfElement ) {
        if ( !_mesh )
            throw std::runtime_error( "Mesh is not defined" );

        _externalVars.push_back( VectorOfexternalVarAndGrpsValue(
            curBehav, MeshEntityPtr( new Element( nameOfElement ) ) ) );
    };
};

/**
 * @typedef ExternalVariablesFieldPtr
 * @brief Pointeur intelligent vers un ExternalVariablesFieldClass
 */
typedef boost::shared_ptr< ExternalVariablesFieldClass > ExternalVariablesFieldPtr;

#endif /* EXTERNALVARIABLEDEFINITION_H_ */
