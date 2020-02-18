#ifndef EXTERNALVARIABLEDEFINITION_H_
#define EXTERNALVARIABLEDEFINITION_H_

/**
 * @file ExternalVariableDefinitionClass.h
 * @brief Fichier entete de la classe ExternalVariableDefinitionClass
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

class MaterialOnMeshBuilderClass;

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

struct TemperatureExternalVariableTraits {
    constexpr static const char *name = "TEMP";
};

struct GeometryExternalVariableTraits {
    constexpr static const char *name = "GEOM";
};

struct CorrosionExternalVariableTraits {
    constexpr static const char *name = "CORR";
};

struct IrreversibleDeformationExternalVariableTraits {
    constexpr static const char *name = "EPSA";
};

struct ConcreteHydratationExternalVariableTraits {
    constexpr static const char *name = "HYDR";
};

struct IrradiationExternalVariableTraits {
    constexpr static const char *name = "IRRA";
};

struct SteelPhasesExternalVariableTraits {
    constexpr static const char *name = "M_ACIER";
};

struct ZircaloyPhasesExternalVariableTraits {
    constexpr static const char *name = "M_ZIRC";
};

struct Neutral1ExternalVariableTraits {
    constexpr static const char *name = "NEUT1";
};

struct Neutral2ExternalVariableTraits {
    constexpr static const char *name = "NEUT2";
};

struct Neutral3ExternalVariableTraits
{
   constexpr static const char* name = "NEUT3";
};

struct ConcreteDryingExternalVariableTraits {
    constexpr static const char *name = "SECH";
};

struct TotalFluidPressureExternalVariableTraits {
    constexpr static const char *name = "PTOT";
};

struct VolumetricDeformationExternalVariableTraits {
    constexpr static const char *name = "DIVU";
};

/**
 * @class GenericExternalVariableClass
 * @brief Input Variable Definition
 * @author Nicolas Sellenet
 */
class GenericExternalVariableClass {
  private:
    BaseMeshPtr _mesh;
    MeshEntityPtr _localization;
    double _refValue;
    bool _refValueSet;
    DataFieldPtr _chamGd;
    EvolutionParameterPtr _evolParam;

  public:
    typedef boost::shared_ptr< GenericExternalVariableClass > GenericExternalVariablePtr;

    /**
     * @brief Constructeur
     */
    GenericExternalVariableClass( const BaseMeshPtr &mesh )
        : _mesh( mesh ), _localization( new AllMeshEntities() ), _refValue( 0. ),
          _refValueSet( false ){};

    /**
     * @brief Constructeur
     */
    GenericExternalVariableClass( const BaseMeshPtr &mesh, const std::string &nameOfGroup )
        : _mesh( mesh ), _localization( new GroupOfElements( nameOfGroup ) ), _refValue( 0. ),
          _refValueSet( false ) {
        if ( !_mesh->hasGroupOfElements( nameOfGroup ) )
            throw std::runtime_error( nameOfGroup + " not in mesh" );
    };

    /**
     * @brief Destructeur
     */
    ~GenericExternalVariableClass(){};

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
 * @class ExternalVariableDefinitionClass
 * @brief Input Variable Definition
 * @author Nicolas Sellenet
 */
template < typename ParameterClass >
class ExternalVariableDefinitionClass : public GenericExternalVariableClass {
  private:
    constexpr static const char *_varcName = ParameterClass::name;

  public:
    /**
     * @brief Constructeur
     */
    ExternalVariableDefinitionClass( const BaseMeshPtr &mesh )
        : GenericExternalVariableClass( mesh ){};

    /**
     * @brief Constructeur
     */
    ExternalVariableDefinitionClass( const BaseMeshPtr &mesh, const std::string &nameOfGroup )
        : GenericExternalVariableClass( mesh, nameOfGroup ){};

    /**
     * @brief Destructeur
     */
    ~ExternalVariableDefinitionClass(){};

    /**
     * @brief Get the name of the variable
     */
    std::string getVariableName() const {
        return std::string( _varcName );
    };
};

typedef ExternalVariableDefinitionClass< TemperatureExternalVariableTraits >
    TemperatureExternalVariableClass;
typedef ExternalVariableDefinitionClass< GeometryExternalVariableTraits >
    GeometryExternalVariableClass;
typedef ExternalVariableDefinitionClass< CorrosionExternalVariableTraits >
    CorrosionExternalVariableClass;
typedef ExternalVariableDefinitionClass< IrreversibleDeformationExternalVariableTraits >
    IrreversibleDeformationExternalVariableClass;
typedef ExternalVariableDefinitionClass< ConcreteHydratationExternalVariableTraits >
    ConcreteHydratationExternalVariableClass;
typedef ExternalVariableDefinitionClass< IrradiationExternalVariableTraits >
    IrradiationExternalVariableClass;
typedef ExternalVariableDefinitionClass< SteelPhasesExternalVariableTraits >
    SteelPhasesExternalVariableClass;
typedef ExternalVariableDefinitionClass< ZircaloyPhasesExternalVariableTraits >
    ZircaloyPhasesExternalVariableClass;
typedef ExternalVariableDefinitionClass< Neutral1ExternalVariableTraits >
    Neutral1ExternalVariableClass;
typedef ExternalVariableDefinitionClass< Neutral2ExternalVariableTraits >
    Neutral2ExternalVariableClass;
typedef ExternalVariableDefinitionClass< Neutral3ExternalVariableTraits >
    Neutral3ExternalVariableClass;
typedef ExternalVariableDefinitionClass< ConcreteDryingExternalVariableTraits >
    ConcreteDryingExternalVariableClass;
typedef ExternalVariableDefinitionClass< TotalFluidPressureExternalVariableTraits >
    TotalFluidPressureExternalVariableClass;
typedef ExternalVariableDefinitionClass< VolumetricDeformationExternalVariableTraits >
    VolumetricDeformationExternalVariableClass;

typedef boost::shared_ptr< GenericExternalVariableClass > GenericExternalVariablePtr;
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
 * @class ExternalVariableOnMeshClass
 * @brief Input variable on mesh
 * @author Nicolas Sellenet
 */
class ExternalVariableOnMeshClass {
    friend class MaterialOnMeshBuilderClass;

  private:
    /** @typedef std::list d'une std::pair de MeshEntityPtr */
    typedef std::vector< std::pair< GenericExternalVariablePtr, MeshEntityPtr > >
        VectorOfexternalVarAndGrps;
    /** @typedef Definition de la valeur contenue dans un VectorOfexternalVarAndGrps */
    typedef VectorOfexternalVarAndGrps::value_type VectorOfexternalVarAndGrpsValue;
    /** @typedef Definition d'un iterateur sur VectorOfexternalVarAndGrps */
    typedef VectorOfexternalVarAndGrps::iterator VectorOfexternalVarAndGrpsIter;

    /** @brief Vector of GenericExternalVariableClass */
    VectorOfexternalVarAndGrps _externalVars;
    /** @brief Maillage sur lequel repose la sd_cham_mater */
    BaseMeshPtr _mesh;

  public:
    ExternalVariableOnMeshClass( const MeshPtr &mesh ) : _mesh( mesh ){};

    ExternalVariableOnMeshClass( const SkeletonPtr &mesh ) : _mesh( mesh ){};

#ifdef _USE_MPI
    ExternalVariableOnMeshClass( const ParallelMeshPtr &mesh ) : _mesh( mesh ){};
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
    void addExternalVariableOnGroupOfElements(
        const ExternalVariablePtr &curBehav,
        const std::string &nameOfGroup ) {
        if ( !_mesh )
            throw std::runtime_error( "Mesh is not defined" );
        if ( !_mesh->hasGroupOfElements( nameOfGroup ) )
            throw std::runtime_error( nameOfGroup + "not in mesh" );

        _externalVars.push_back( VectorOfexternalVarAndGrpsValue(
            curBehav, MeshEntityPtr( new GroupOfElements( nameOfGroup ) ) ) );
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
 * @typedef ExternalVariableOnMeshPtr
 * @brief Pointeur intelligent vers un ExternalVariableOnMeshClass
 */
typedef boost::shared_ptr< ExternalVariableOnMeshClass > ExternalVariableOnMeshPtr;

#endif /* EXTERNALVARIABLEDEFINITION_H_ */
