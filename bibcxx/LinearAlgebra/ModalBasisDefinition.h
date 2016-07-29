#ifndef MODALBASISDEFINITION_H_
#define MODALBASISDEFINITION_H_

/**
 * @file ModalBasisDefinition.h
 * @brief Fichier entete de la classe ModalBasisDefinition
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2016  EDF R&D                www.code-aster.org
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

#include "astercxx.h"

#include "DataStructure/DataStructure.h"
#include "LinearAlgebra/StructureInterface.h"
#include "Utilities/CapyConvertibleValue.h"
#include "LinearAlgebra/LinearSolver.h"
#include "LinearAlgebra/StructureInterface.h"
#include "Results/MechanicalModeContainer.h"
#include "Discretization/DOFNumbering.h"
#include "LinearAlgebra/AssemblyMatrix.h"

typedef std::vector< MechanicalModeContainerPtr > VectorOfMechaModePtr;

/**
 * @class GenericModalBasisInstance
 * @brief Cette classe permet de definir une base modale
 * @author Nicolas Sellenet
 */
class GenericModalBasisInstance: public DataStructure
{
public:
    /**
     * @brief Constructeur
     */
    GenericModalBasisInstance(): _isEmpty( true )
    {};

protected:
    typedef boost::shared_ptr< GenericModalBasisInstance > GenericModalBasisPtr;
    CapyConvertibleContainer _container;
    LinearSolverPtr          _solver;
    bool                     _isEmpty;

    struct UnitaryModalBasis
    {
        GenericModalBasisPtr       _basis;
        VectorOfMechaModePtr       _vecOfMechaMode;
        VectorInt                  _vecOfInt;
        MechanicalModeContainerPtr _interfaceModes;
        StructureInterfacePtr      _structInterf;
        AssemblyMatrixDoublePtr    _matrD;
        AssemblyMatrixComplexPtr   _matrC;

        CapyConvertibleContainer _container;

        UnitaryModalBasis( const std::string& name,
                           const StructureInterfacePtr& structInterf,
                           const VectorOfMechaModePtr& vecOfMechaMode,
                           const VectorInt& vecOfInt ):
            _structInterf( structInterf ),
            _vecOfMechaMode( vecOfMechaMode ),
            _vecOfInt( vecOfInt ),
            _container( CapyConvertibleContainer( name ) )
        {
            _container.add( new CapyConvertibleValue< StructureInterfacePtr >
                                    ( true, "INTERF_DYNA", _structInterf, true ) );

            if( _vecOfMechaMode.size() != 0 )
                _container.add( new CapyConvertibleValue< VectorOfMechaModePtr >
                                        ( true, "MODE_MECA", _vecOfMechaMode, true ) );

            if( _vecOfInt.size() != 0 )
                _container.add( new CapyConvertibleValue< VectorInt >
                                        ( false, "NMAX_MODE", _vecOfInt, true ) );
        };

        UnitaryModalBasis( const std::string& name,
                           const GenericModalBasisPtr& basis,
                           const VectorInt& vecOfInt = {} ):
            _basis( basis ),
            _vecOfInt( vecOfInt ),
            _container( CapyConvertibleContainer( name ) )
        {
            _container.add( new CapyConvertibleValue< GenericModalBasisPtr >
                                    ( false, "BASE_MODALE", _basis, true ) );

            if( _vecOfInt.size() != 0 )
                _container.add( new CapyConvertibleValue< VectorInt >
                                        ( false, "NMAX_MODE", _vecOfInt, true ) );
        };

        UnitaryModalBasis( const std::string& name,
                           const VectorOfMechaModePtr& vecOfMechaMode,
                           const VectorInt& vecOfInt = {} ):
            _vecOfMechaMode( vecOfMechaMode ),
            _vecOfInt( vecOfInt ),
            _container( CapyConvertibleContainer( name ) )
        {
            _container.add( new CapyConvertibleValue< VectorOfMechaModePtr >
                                    ( false, "BASE_MODALE", _vecOfMechaMode, true ) );

            if( _vecOfInt.size() != 0 )
                _container.add( new CapyConvertibleValue< VectorInt >
                                        ( false, "NMAX_MODE", _vecOfInt, true ) );
        };

        UnitaryModalBasis( const std::string& name,
                           const MechanicalModeContainerPtr& interf,
                           const VectorInt& vecOfInt = {} ):
            _interfaceModes( interf ),
            _vecOfInt( vecOfInt ),
            _container( CapyConvertibleContainer( name ) )
        {
            _container.add( new CapyConvertibleValue< MechanicalModeContainerPtr >
                                    ( false, "MODE_INTF", _interfaceModes, true ) );

            if( _vecOfInt.size() != 0 )
                _container.add( new CapyConvertibleValue< VectorInt >
                                        ( false, "NMAX_MODE", _vecOfInt, true ) );
        };

        UnitaryModalBasis( const std::string& name,
                           const MechanicalModeContainerPtr& basis,
                           const AssemblyMatrixDoublePtr& matr ):
            _interfaceModes( basis ),
            _matrD( matr ),
            _container( CapyConvertibleContainer( name ) )
        {
            _container.add( new CapyConvertibleValue< MechanicalModeContainerPtr >
                                    ( true, "BASE", _interfaceModes, true ) );
            _container.add( new CapyConvertibleValue< AssemblyMatrixDoublePtr >
                                    ( true, "MATRICE", _matrD, true ) );
        };

        UnitaryModalBasis( const std::string& name,
                           const MechanicalModeContainerPtr& basis,
                           const AssemblyMatrixComplexPtr& matr ):
            _interfaceModes( basis ),
            _matrC( matr ),
            _container( CapyConvertibleContainer( name ) )
        {
            _container.add( new CapyConvertibleValue< MechanicalModeContainerPtr >
                                    ( true, "BASE", _interfaceModes, true ) );
            _container.add( new CapyConvertibleValue< AssemblyMatrixComplexPtr >
                                    ( true, "MATRICE", _matrC, true ) );
        };

        UnitaryModalBasis( const std::string& name,
                           const MechanicalModeContainerPtr& basis,
                           const VectorOfMechaModePtr& vecOfMechaMode ):
            _interfaceModes( basis ),
            _vecOfMechaMode( vecOfMechaMode ),
            _container( CapyConvertibleContainer( name ) )
        {
            _container.add( new CapyConvertibleValue< MechanicalModeContainerPtr >
                                    ( true, "MODE_STAT", _interfaceModes, true ) );
            _container.add( new CapyConvertibleValue< VectorOfMechaModePtr >
                                    ( true, "MODE_MECA", _vecOfMechaMode, true ) );
        };
    };

    std::vector< UnitaryModalBasis > _vectorOfModalBasis;

public:
    bool build() throw( std::runtime_error );

    void setLinearSolver( const LinearSolverPtr& solver )
    {
        _solver = solver;
    };
};

/**
 * @typedef ModalBasisDefinitionPtr
 * @brief Enveloppe d'un pointeur intelligent vers un GenericModalBasisInstance
 */
typedef boost::shared_ptr< GenericModalBasisInstance > GenericModalBasisPtr;

class StandardModalBasisInstance: public GenericModalBasisInstance
{
public:
    /**
     * @brief Constructeur
     */
    StandardModalBasisInstance()
    {};

    void setModalBasis( const StructureInterfacePtr& structInterf,
                        const VectorOfMechaModePtr& vecOfMechaMode,
                        const VectorInt& vecOfInt = {} )
    {
        if( _vectorOfModalBasis.size() == 1 )
            throw std::runtime_error( "Only 1 basis allowed" );
        _vectorOfModalBasis.emplace_back( "CLASSIQUE", structInterf,
                                          vecOfMechaMode, vecOfInt );
    };

    void setModalBasis( const StructureInterfacePtr& structInterf,
                        const MechanicalModeContainerPtr& mechaMode,
                        const VectorInt& vecOfInt = {} )
    {
        setModalBasis( structInterf, (VectorOfMechaModePtr){ mechaMode }, vecOfInt );
    };
};

class RitzBasisInstance: public GenericModalBasisInstance
{
private:
    StructureInterfacePtr    _interf;
    DOFNumberingPtr          _dofNum;
    AssemblyMatrixDoublePtr  _matrD;
    AssemblyMatrixComplexPtr _matrC;
    bool                     _reortho;
    VectorDouble             _dampingVector;

public:
    /**
     * @brief Constructeur
     */
    RitzBasisInstance(): _reortho( false )
    {
        _container.add( new CapyConvertibleValue< bool >
                                ( false, "ORTHO", _reortho,
                                  { true, false }, { "OUI", "NON" }, true ) );
    };

    void addModalBasis( const GenericModalBasisPtr& basis,
                        const VectorInt& vecOfInt = {} )
        throw( std::runtime_error )
    {
        if( _vectorOfModalBasis.size() == 2 )
            throw std::runtime_error( "Only 2 basis allowed" );
        _vectorOfModalBasis.emplace_back( "RITZ", basis, vecOfInt );
    };

    void addModalBasis( const VectorOfMechaModePtr& vecOfMechaMode,
                        const VectorInt& vecOfInt = {} )
        throw( std::runtime_error )
    {
        if( _vectorOfModalBasis.size() == 2 )
            throw std::runtime_error( "Only 2 basis allowed" );
        _vectorOfModalBasis.emplace_back( "RITZ", vecOfMechaMode, vecOfInt );
    };

    void addModalBasis( const MechanicalModeContainerPtr& interf,
                        const VectorInt& vecOfInt = {} )
        throw( std::runtime_error )
    {
        if( _vectorOfModalBasis.size() == 2 )
            throw std::runtime_error( "Only 2 basis allowed" );
        _vectorOfModalBasis.emplace_back( "RITZ", interf, vecOfInt );
    };

    void reorthonormalising( const AssemblyMatrixComplexPtr& matr )
    {
        _matrC = matr;
        _reortho = true;
        _container.add( new CapyConvertibleValue< AssemblyMatrixComplexPtr >
                                ( false, "MATRICE", _matrC, true ) );
    };

    void reorthonormalising( const AssemblyMatrixDoublePtr& matr )
    {
        _matrD = matr;
        _reortho = true;
        _container.add( new CapyConvertibleValue< AssemblyMatrixDoublePtr >
                                ( false, "MATRICE", _matrD, true ) );
    };

    void setListOfModalDamping( const VectorDouble& vec )
    {
        _dampingVector = vec;
        _container.add( new CapyConvertibleValue< VectorDouble >
                                ( false, "LIST_AMOR", _dampingVector, true ) );
    };

    void setStructureInterface( const StructureInterfacePtr& interf )
    {
        _interf = interf;
        _container.add( new CapyConvertibleValue< StructureInterfacePtr >
                                ( false, "INTERF_DYNA", _interf, true ) );
    };

    void setReferenceDOFNumbering( const DOFNumberingPtr& dofNum )
    {
        _dofNum = dofNum;
        _container.add( new CapyConvertibleValue< DOFNumberingPtr >
                                ( false, "NUME_REF", _dofNum, true ) );
    };
};

class OrthonormalizedBasisInstance: public GenericModalBasisInstance
{
private:
    MechanicalModeContainerPtr _basis;
    AssemblyMatrixDoublePtr    _matrD;
    AssemblyMatrixComplexPtr   _matrC;

public:
    /**
     * @brief Constructeur
     */
    OrthonormalizedBasisInstance( const MechanicalModeContainerPtr& basis,
                                  const AssemblyMatrixDoublePtr& matr ):
        _basis( basis ),
        _matrD( matr )
    {
        _vectorOfModalBasis.emplace_back( "ORTHO_BASE", basis, matr );
    };

    /**
     * @brief Constructeur
     */
    OrthonormalizedBasisInstance( const MechanicalModeContainerPtr& basis,
                                  const AssemblyMatrixComplexPtr& matr ):
        _basis( basis ),
        _matrC( matr )
    {
        _vectorOfModalBasis.emplace_back( "ORTHO_BASE", basis, matr );
    };
};

class OrthogonalBasisWithoutMassInstance: public GenericModalBasisInstance
{
private:
    MechanicalModeContainerPtr _modeStat;
    VectorOfMechaModePtr       _modeMeca;

public:
    /**
     * @brief Constructeur
     */
    OrthogonalBasisWithoutMassInstance( const MechanicalModeContainerPtr& basis,
                                        const VectorOfMechaModePtr& vec ):
        _modeStat( basis ),
        _modeMeca( vec )
    {
        _vectorOfModalBasis.emplace_back( "DIAG_MASS", basis, vec );
    };
};

typedef boost::shared_ptr< StandardModalBasisInstance > StandardModalBasisPtr;
typedef boost::shared_ptr< RitzBasisInstance > RitzBasisPtr;
typedef boost::shared_ptr< OrthonormalizedBasisInstance > OrthonormalizedBasisPtr;
typedef boost::shared_ptr< OrthogonalBasisWithoutMassInstance > OrthogonalBasisWithoutMassPtr;

#endif /* MODALBASISDEFINITION_H_ */
