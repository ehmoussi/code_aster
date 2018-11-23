#ifndef MODALBASISDEFINITION_H_
#define MODALBASISDEFINITION_H_

/**
 * @file ModalBasisDefinition.h
 * @brief Fichier entete de la classe ModalBasisDefinition
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2018  EDF R&D                www.code-aster.org
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

#include "DataStructures/DataStructure.h"
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
class GenericModalBasisInstance : public DataStructure {
  public:
    /**
     * @typedef GenericModalBasisPtr
     * @brief Pointeur intelligent vers un GenericModalBasis
     */
    typedef boost::shared_ptr< GenericModalBasisInstance > GenericModalBasisPtr;

    /**
     * @brief Constructeur
     */
    GenericModalBasisInstance() : GenericModalBasisInstance( ResultNaming::getNewResultName() ){};

    /**
     * @brief Constructeur
     */
    GenericModalBasisInstance( const std::string name )
        : DataStructure( name, 8, "MODE_MECA", Permanent ), _isEmpty( true ){};

  protected:
    CapyConvertibleContainer _container;
    BaseLinearSolverPtr _solver;
    bool _isEmpty;

    struct UnitaryModalBasis {
        GenericModalBasisPtr _basis;
        VectorOfMechaModePtr _vecOfMechaMode;
        VectorInt _vecOfInt;
        MechanicalModeContainerPtr _interfaceModes;
        StructureInterfacePtr _structInterf;
        AssemblyMatrixDisplacementDoublePtr _matrD;
        AssemblyMatrixDisplacementComplexPtr _matrC;

        CapyConvertibleContainer _container;

        UnitaryModalBasis( const std::string &name, const StructureInterfacePtr &structInterf,
                           const VectorOfMechaModePtr &vecOfMechaMode, const VectorInt &vecOfInt )
            : _structInterf( structInterf ), _vecOfMechaMode( vecOfMechaMode ),
              _vecOfInt( vecOfInt ), _container( CapyConvertibleContainer( name ) ) {
            _container.add( new CapyConvertibleValue< StructureInterfacePtr >(
                true, "INTERF_DYNA", _structInterf, true ) );

            if ( _vecOfMechaMode.size() != 0 )
                _container.add( new CapyConvertibleValue< VectorOfMechaModePtr >(
                    true, "MODE_MECA", _vecOfMechaMode, true ) );

            if ( _vecOfInt.size() != 0 )
                _container.add(
                    new CapyConvertibleValue< VectorInt >( false, "NMAX_MODE", _vecOfInt, true ) );
        };

        UnitaryModalBasis( const std::string &name, const GenericModalBasisPtr &basis,
                           const VectorInt &vecOfInt = {} )
            : _basis( basis ), _vecOfInt( vecOfInt ),
              _container( CapyConvertibleContainer( name ) ) {
            _container.add( new CapyConvertibleValue< GenericModalBasisPtr >( false, "BASE_MODALE",
                                                                              _basis, true ) );

            if ( _vecOfInt.size() != 0 )
                _container.add(
                    new CapyConvertibleValue< VectorInt >( false, "NMAX_MODE", _vecOfInt, true ) );
        };

        UnitaryModalBasis( const std::string &name, const VectorOfMechaModePtr &vecOfMechaMode,
                           const VectorInt &vecOfInt = {} )
            : _vecOfMechaMode( vecOfMechaMode ), _vecOfInt( vecOfInt ),
              _container( CapyConvertibleContainer( name ) ) {
            _container.add( new CapyConvertibleValue< VectorOfMechaModePtr >(
                false, "BASE_MODALE", _vecOfMechaMode, true ) );

            if ( _vecOfInt.size() != 0 )
                _container.add(
                    new CapyConvertibleValue< VectorInt >( false, "NMAX_MODE", _vecOfInt, true ) );
        };

        UnitaryModalBasis( const std::string &name, const MechanicalModeContainerPtr &interf,
                           const VectorInt &vecOfInt = {} )
            : _interfaceModes( interf ), _vecOfInt( vecOfInt ),
              _container( CapyConvertibleContainer( name ) ) {
            _container.add( new CapyConvertibleValue< MechanicalModeContainerPtr >(
                false, "MODE_INTF", _interfaceModes, true ) );

            if ( _vecOfInt.size() != 0 )
                _container.add(
                    new CapyConvertibleValue< VectorInt >( false, "NMAX_MODE", _vecOfInt, true ) );
        };

        UnitaryModalBasis( const std::string &name, const MechanicalModeContainerPtr &basis,
                           const AssemblyMatrixDisplacementDoublePtr &matr )
            : _interfaceModes( basis ), _matrD( matr ),
              _container( CapyConvertibleContainer( name ) ) {
            _container.add( new CapyConvertibleValue< MechanicalModeContainerPtr >(
                true, "BASE", _interfaceModes, true ) );
            _container.add( new CapyConvertibleValue< AssemblyMatrixDisplacementDoublePtr >(
                true, "MATRICE", _matrD, true ) );
        };

        UnitaryModalBasis( const std::string &name, const MechanicalModeContainerPtr &basis,
                           const AssemblyMatrixDisplacementComplexPtr &matr )
            : _interfaceModes( basis ), _matrC( matr ),
              _container( CapyConvertibleContainer( name ) ) {
            _container.add( new CapyConvertibleValue< MechanicalModeContainerPtr >(
                true, "BASE", _interfaceModes, true ) );
            _container.add( new CapyConvertibleValue< AssemblyMatrixDisplacementComplexPtr >(
                true, "MATRICE", _matrC, true ) );
        };

        UnitaryModalBasis( const std::string &name, const MechanicalModeContainerPtr &basis,
                           const VectorOfMechaModePtr &vecOfMechaMode )
            : _interfaceModes( basis ), _vecOfMechaMode( vecOfMechaMode ),
              _container( CapyConvertibleContainer( name ) ) {
            _container.add( new CapyConvertibleValue< MechanicalModeContainerPtr >(
                true, "MODE_STAT", _interfaceModes, true ) );
            _container.add( new CapyConvertibleValue< VectorOfMechaModePtr >(
                true, "MODE_MECA", _vecOfMechaMode, true ) );
        };
    };

    std::vector< UnitaryModalBasis > _vectorOfModalBasis;

  public:
    bool build() ;

    void setLinearSolver( const BaseLinearSolverPtr &solver ) { _solver = solver; };
};

/**
 * @typedef ModalBasisDefinitionPtr
 * @brief Enveloppe d'un pointeur intelligent vers un GenericModalBasisInstance
 */
typedef boost::shared_ptr< GenericModalBasisInstance > GenericModalBasisPtr;

class StandardModalBasisInstance : public GenericModalBasisInstance {
  public:
    /**
     * @typedef StandardModalBasisPtr
     * @brief Pointeur intelligent vers un StandardModalBasis
     */
    typedef boost::shared_ptr< StandardModalBasisInstance > StandardModalBasisPtr;

    /**
     * @brief Constructeur
     */
    StandardModalBasisInstance(){};

    /**
     * @brief Constructeur
     */
    StandardModalBasisInstance( const std::string name ) : GenericModalBasisInstance( name ){};

    void setModalBasis( const StructureInterfacePtr &structInterf,
                        const VectorOfMechaModePtr &vecOfMechaMode,
                        const VectorInt &vecOfInt = {} ) {
        if ( _vectorOfModalBasis.size() == 1 )
            throw std::runtime_error( "Only 1 basis allowed" );
        _vectorOfModalBasis.emplace_back( "CLASSIQUE", structInterf, vecOfMechaMode, vecOfInt );
    };

    void setModalBasis( const StructureInterfacePtr &structInterf,
                        const MechanicalModeContainerPtr &mechaMode,
                        const VectorInt &vecOfInt = {} ) {
        setModalBasis( structInterf, ( VectorOfMechaModePtr ){mechaMode}, vecOfInt );
    };
};

class RitzBasisInstance : public GenericModalBasisInstance {
  private:
    StructureInterfacePtr _interf;
    DOFNumberingPtr _dofNum;
    AssemblyMatrixDisplacementDoublePtr _matrD;
    AssemblyMatrixDisplacementComplexPtr _matrC;
    bool _reortho;
    VectorDouble _dampingVector;

  public:
    /**
     * @typedef RitzBasisPtr
     * @brief Pointeur intelligent vers un RitzBasis
     */
    typedef boost::shared_ptr< RitzBasisInstance > RitzBasisPtr;

    /**
     * @brief Constructeur
     */
    RitzBasisInstance() : RitzBasisInstance( ResultNaming::getNewResultName() ){};

    /**
     * @brief Constructeur
     */

    RitzBasisInstance( const std::string name )
        : GenericModalBasisInstance( name ), _reortho( false ) {
        _container.add( new CapyConvertibleValue< bool >( false, "ORTHO", _reortho, {true, false},
                                                          {"OUI", "NON"}, true ) );
    };

    void addModalBasis( const GenericModalBasisPtr &basis,
                        const VectorInt &vecOfInt = {} ) {
        if ( _vectorOfModalBasis.size() == 2 )
            throw std::runtime_error( "Only 2 basis allowed" );
        _vectorOfModalBasis.emplace_back( "RITZ", basis, vecOfInt );
    };

    void addModalBasis( const VectorOfMechaModePtr &vecOfMechaMode,
                        const VectorInt &vecOfInt = {} ) {
        if ( _vectorOfModalBasis.size() == 2 )
            throw std::runtime_error( "Only 2 basis allowed" );
        _vectorOfModalBasis.emplace_back( "RITZ", vecOfMechaMode, vecOfInt );
    };

    void addModalBasis( const MechanicalModeContainerPtr &interf,
                        const VectorInt &vecOfInt = {} ) {
        if ( _vectorOfModalBasis.size() == 2 )
            throw std::runtime_error( "Only 2 basis allowed" );
        _vectorOfModalBasis.emplace_back( "RITZ", interf, vecOfInt );
    };

    void reorthonormalising( const AssemblyMatrixDisplacementComplexPtr &matr ) {
        _matrC = matr;
        _reortho = true;
        _container.add( new CapyConvertibleValue< AssemblyMatrixDisplacementComplexPtr >(
            false, "MATRICE", _matrC, true ) );
    };

    void reorthonormalising( const AssemblyMatrixDisplacementDoublePtr &matr ) {
        _matrD = matr;
        _reortho = true;
        _container.add( new CapyConvertibleValue< AssemblyMatrixDisplacementDoublePtr >(
            false, "MATRICE", _matrD, true ) );
    };

    void setListOfModalDamping( const VectorDouble &vec ) {
        _dampingVector = vec;
        _container.add(
            new CapyConvertibleValue< VectorDouble >( false, "LIST_AMOR", _dampingVector, true ) );
    };

    void setStructureInterface( const StructureInterfacePtr &interf ) {
        _interf = interf;
        _container.add( new CapyConvertibleValue< StructureInterfacePtr >( false, "INTERF_DYNA",
                                                                           _interf, true ) );
    };
    /**
    * @brief Get the internal StructureInterface
    * @return Internal StructureInterface
    */
    StructureInterfacePtr getStructureInterface() const { return _interf; };

    void setReferenceDOFNumbering( const DOFNumberingPtr &dofNum ) {
        _dofNum = dofNum;
        _container.add(
            new CapyConvertibleValue< DOFNumberingPtr >( false, "NUME_REF", _dofNum, true ) );
    };
};

class OrthonormalizedBasisInstance : public GenericModalBasisInstance {
  private:
    MechanicalModeContainerPtr _basis;
    AssemblyMatrixDisplacementDoublePtr _matrD;
    AssemblyMatrixDisplacementComplexPtr _matrC;

  public:
    /**
     * @typedef OrthonormalizedBasisPtr
     * @brief Pointeur intelligent vers un OrthonormalizedBasis
     */
    typedef boost::shared_ptr< OrthonormalizedBasisInstance > OrthonormalizedBasisPtr;

    /**
     * @brief Constructeur
     */
    OrthonormalizedBasisInstance( const MechanicalModeContainerPtr &basis,
                                  const AssemblyMatrixDisplacementDoublePtr &matr )
        : OrthonormalizedBasisInstance( ResultNaming::getNewResultName(), basis, matr ){};

    /**
     * @brief Constructeur
     */
    OrthonormalizedBasisInstance( const std::string name, const MechanicalModeContainerPtr &basis,
                                  const AssemblyMatrixDisplacementDoublePtr &matr )
        : GenericModalBasisInstance( name ), _basis( basis ), _matrD( matr ) {
        _vectorOfModalBasis.emplace_back( "ORTHO_BASE", basis, matr );
    };

    /**
     * @brief Constructeur
     */
    OrthonormalizedBasisInstance( const MechanicalModeContainerPtr &basis,
                                  const AssemblyMatrixDisplacementComplexPtr &matr )
        : OrthonormalizedBasisInstance( ResultNaming::getNewResultName(), basis, matr ){};

    /**
     * @brief Constructeur
     */
    OrthonormalizedBasisInstance( const std::string name, const MechanicalModeContainerPtr &basis,
                                  const AssemblyMatrixDisplacementComplexPtr &matr )
        : GenericModalBasisInstance( name ), _basis( basis ), _matrC( matr ) {
        _vectorOfModalBasis.emplace_back( "ORTHO_BASE", basis, matr );
    };
};

class OrthogonalBasisWithoutMassInstance : public GenericModalBasisInstance {
  private:
    MechanicalModeContainerPtr _modeStat;
    VectorOfMechaModePtr _modeMeca;

  public:
    /**
     * @typedef OrthogonalBasisWithoutMassPtr
     * @brief Pointeur intelligent vers un OrthogonalBasisWithoutMass
     */
    typedef boost::shared_ptr< OrthogonalBasisWithoutMassInstance > OrthogonalBasisWithoutMassPtr;

    /**
     * @brief Constructeur
     */
    OrthogonalBasisWithoutMassInstance( const MechanicalModeContainerPtr &basis,
                                        const VectorOfMechaModePtr &vec )
        : OrthogonalBasisWithoutMassInstance( ResultNaming::getNewResultName(), basis, vec ){};

    /**
     * @brief Constructeur
     */
    OrthogonalBasisWithoutMassInstance( const std::string name,
                                        const MechanicalModeContainerPtr &basis,
                                        const VectorOfMechaModePtr &vec )
        : GenericModalBasisInstance( name ), _modeStat( basis ), _modeMeca( vec ) {
        _vectorOfModalBasis.emplace_back( "DIAG_MASS", basis, vec );
    };
};

typedef boost::shared_ptr< StandardModalBasisInstance > StandardModalBasisPtr;
typedef boost::shared_ptr< RitzBasisInstance > RitzBasisPtr;
typedef boost::shared_ptr< OrthonormalizedBasisInstance > OrthonormalizedBasisPtr;
typedef boost::shared_ptr< OrthogonalBasisWithoutMassInstance > OrthogonalBasisWithoutMassPtr;

#endif /* MODALBASISDEFINITION_H_ */
