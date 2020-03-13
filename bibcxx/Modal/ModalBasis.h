#ifndef MODALBASISDEFINITION_H_
#define MODALBASISDEFINITION_H_

/**
 * @file ModalBasis.h
 * @brief Fichier entete de la classe ModalBasis
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

#include "astercxx.h"

#include "DataStructures/DataStructure.h"
#include "Interfaces/StructureInterface.h"
#include "Utilities/CapyConvertibleValue.h"
#include "Solvers/LinearSolver.h"
#include "Interfaces/StructureInterface.h"
#include "Results/ModeResult.h"
#include "Numbering/DOFNumbering.h"
#include "LinearAlgebra/AssemblyMatrix.h"

typedef std::vector< ModeResultPtr > VectorOfMechaModePtr;

/**
 * @class GenericModalBasisClass
 * @brief Cette classe permet de definir une base modale
 * @author Nicolas Sellenet
 */
class GenericModalBasisClass : public DataStructure {
  public:
    /**
     * @typedef GenericModalBasisPtr
     * @brief Pointeur intelligent vers un GenericModalBasis
     */
    typedef boost::shared_ptr< GenericModalBasisClass > GenericModalBasisPtr;

    /**
     * @brief Constructeur
     */
    GenericModalBasisClass() : GenericModalBasisClass( ResultNaming::getNewResultName() ){};

    /**
     * @brief Constructeur
     */
    GenericModalBasisClass( const std::string name )
        : DataStructure( name, 8, "MODE_MECA", Permanent ), _isEmpty( true ){};

  protected:
    CapyConvertibleContainer _container;
    BaseLinearSolverPtr _solver;
    bool _isEmpty;

    struct UnitaryModalBasis {
        GenericModalBasisPtr _basis;
        VectorOfMechaModePtr _vecOfMechaMode;
        VectorInt _vecOfInt;
        ModeResultPtr _interfaceModes;
        StructureInterfacePtr _structInterf;
        AssemblyMatrixDisplacementRealPtr _matrD;
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

        UnitaryModalBasis( const std::string &name, const ModeResultPtr &interf,
                           const VectorInt &vecOfInt = {} )
            : _interfaceModes( interf ), _vecOfInt( vecOfInt ),
              _container( CapyConvertibleContainer( name ) ) {
            _container.add( new CapyConvertibleValue< ModeResultPtr >(
                false, "MODE_INTF", _interfaceModes, true ) );

            if ( _vecOfInt.size() != 0 )
                _container.add(
                    new CapyConvertibleValue< VectorInt >( false, "NMAX_MODE", _vecOfInt, true ) );
        };

        UnitaryModalBasis( const std::string &name, const ModeResultPtr &basis,
                           const AssemblyMatrixDisplacementRealPtr &matr )
            : _interfaceModes( basis ), _matrD( matr ),
              _container( CapyConvertibleContainer( name ) ) {
            _container.add( new CapyConvertibleValue< ModeResultPtr >(
                true, "BASE", _interfaceModes, true ) );
            _container.add( new CapyConvertibleValue< AssemblyMatrixDisplacementRealPtr >(
                true, "MATRICE", _matrD, true ) );
        };

        UnitaryModalBasis( const std::string &name, const ModeResultPtr &basis,
                           const AssemblyMatrixDisplacementComplexPtr &matr )
            : _interfaceModes( basis ), _matrC( matr ),
              _container( CapyConvertibleContainer( name ) ) {
            _container.add( new CapyConvertibleValue< ModeResultPtr >(
                true, "BASE", _interfaceModes, true ) );
            _container.add( new CapyConvertibleValue< AssemblyMatrixDisplacementComplexPtr >(
                true, "MATRICE", _matrC, true ) );
        };

        UnitaryModalBasis( const std::string &name, const ModeResultPtr &basis,
                           const VectorOfMechaModePtr &vecOfMechaMode )
            : _interfaceModes( basis ), _vecOfMechaMode( vecOfMechaMode ),
              _container( CapyConvertibleContainer( name ) ) {
            _container.add( new CapyConvertibleValue< ModeResultPtr >(
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
 * @typedef ModalBasisPtr
 * @brief Enveloppe d'un pointeur intelligent vers un GenericModalBasisClass
 */
typedef boost::shared_ptr< GenericModalBasisClass > GenericModalBasisPtr;

class StandardModalBasisClass : public GenericModalBasisClass {
  public:
    /**
     * @typedef StandardModalBasisPtr
     * @brief Pointeur intelligent vers un StandardModalBasis
     */
    typedef boost::shared_ptr< StandardModalBasisClass > StandardModalBasisPtr;

    /**
     * @brief Constructeur
     */
    StandardModalBasisClass(){};

    /**
     * @brief Constructeur
     */
    StandardModalBasisClass( const std::string name ) : GenericModalBasisClass( name ){};

    void setModalBasis( const StructureInterfacePtr &structInterf,
                        const VectorOfMechaModePtr &vecOfMechaMode,
                        const VectorInt &vecOfInt = {} ) {
        if ( _vectorOfModalBasis.size() == 1 )
            throw std::runtime_error( "Only 1 basis allowed" );
        _vectorOfModalBasis.emplace_back( "CLASSIQUE", structInterf, vecOfMechaMode, vecOfInt );
    };

    void setModalBasis( const StructureInterfacePtr &structInterf,
                        const ModeResultPtr &mechaMode,
                        const VectorInt &vecOfInt = {} ) {
        setModalBasis( structInterf, ( VectorOfMechaModePtr ){mechaMode}, vecOfInt );
    };
};

class RitzBasisClass : public GenericModalBasisClass {
  private:
    StructureInterfacePtr _interf;
    DOFNumberingPtr _dofNum;
    AssemblyMatrixDisplacementRealPtr _matrD;
    AssemblyMatrixDisplacementComplexPtr _matrC;
    bool _reortho;
    VectorReal _dampingVector;

  public:
    /**
     * @typedef RitzBasisPtr
     * @brief Pointeur intelligent vers un RitzBasis
     */
    typedef boost::shared_ptr< RitzBasisClass > RitzBasisPtr;

    /**
     * @brief Constructeur
     */
    RitzBasisClass() : RitzBasisClass( ResultNaming::getNewResultName() ){};

    /**
     * @brief Constructeur
     */

    RitzBasisClass( const std::string name )
        : GenericModalBasisClass( name ), _reortho( false ) {
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

    void addModalBasis( const ModeResultPtr &interf,
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

    void reorthonormalising( const AssemblyMatrixDisplacementRealPtr &matr ) {
        _matrD = matr;
        _reortho = true;
        _container.add( new CapyConvertibleValue< AssemblyMatrixDisplacementRealPtr >(
            false, "MATRICE", _matrD, true ) );
    };

    void setListOfModalDamping( const VectorReal &vec ) {
        _dampingVector = vec;
        _container.add(
            new CapyConvertibleValue< VectorReal >( false, "LIST_AMOR", _dampingVector, true ) );
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

class OrthonormalizedBasisClass : public GenericModalBasisClass {
  private:
    ModeResultPtr _basis;
    AssemblyMatrixDisplacementRealPtr _matrD;
    AssemblyMatrixDisplacementComplexPtr _matrC;

  public:
    /**
     * @typedef OrthonormalizedBasisPtr
     * @brief Pointeur intelligent vers un OrthonormalizedBasis
     */
    typedef boost::shared_ptr< OrthonormalizedBasisClass > OrthonormalizedBasisPtr;

    /**
     * @brief Constructeur
     */
    OrthonormalizedBasisClass( const ModeResultPtr &basis,
                                  const AssemblyMatrixDisplacementRealPtr &matr )
        : OrthonormalizedBasisClass( ResultNaming::getNewResultName(), basis, matr ){};

    /**
     * @brief Constructeur
     */
    OrthonormalizedBasisClass( const std::string name, const ModeResultPtr &basis,
                                  const AssemblyMatrixDisplacementRealPtr &matr )
        : GenericModalBasisClass( name ), _basis( basis ), _matrD( matr ) {
        _vectorOfModalBasis.emplace_back( "ORTHO_BASE", basis, matr );
    };

    /**
     * @brief Constructeur
     */
    OrthonormalizedBasisClass( const ModeResultPtr &basis,
                                  const AssemblyMatrixDisplacementComplexPtr &matr )
        : OrthonormalizedBasisClass( ResultNaming::getNewResultName(), basis, matr ){};

    /**
     * @brief Constructeur
     */
    OrthonormalizedBasisClass( const std::string name, const ModeResultPtr &basis,
                                  const AssemblyMatrixDisplacementComplexPtr &matr )
        : GenericModalBasisClass( name ), _basis( basis ), _matrC( matr ) {
        _vectorOfModalBasis.emplace_back( "ORTHO_BASE", basis, matr );
    };
};

class OrthogonalBasisWithoutMassClass : public GenericModalBasisClass {
  private:
    ModeResultPtr _modeStat;
    VectorOfMechaModePtr _modeMeca;

  public:
    /**
     * @typedef OrthogonalBasisWithoutMassPtr
     * @brief Pointeur intelligent vers un OrthogonalBasisWithoutMass
     */
    typedef boost::shared_ptr< OrthogonalBasisWithoutMassClass > OrthogonalBasisWithoutMassPtr;

    /**
     * @brief Constructeur
     */
    OrthogonalBasisWithoutMassClass( const ModeResultPtr &basis,
                                        const VectorOfMechaModePtr &vec )
        : OrthogonalBasisWithoutMassClass( ResultNaming::getNewResultName(), basis, vec ){};

    /**
     * @brief Constructeur
     */
    OrthogonalBasisWithoutMassClass( const std::string name,
                                        const ModeResultPtr &basis,
                                        const VectorOfMechaModePtr &vec )
        : GenericModalBasisClass( name ), _modeStat( basis ), _modeMeca( vec ) {
        _vectorOfModalBasis.emplace_back( "DIAG_MASS", basis, vec );
    };
};

typedef boost::shared_ptr< StandardModalBasisClass > StandardModalBasisPtr;
typedef boost::shared_ptr< RitzBasisClass > RitzBasisPtr;
typedef boost::shared_ptr< OrthonormalizedBasisClass > OrthonormalizedBasisPtr;
typedef boost::shared_ptr< OrthogonalBasisWithoutMassClass > OrthogonalBasisWithoutMassPtr;

#endif /* MODALBASISDEFINITION_H_ */
