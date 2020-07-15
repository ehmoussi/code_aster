/**
 * @file LinearSolver.cxx
 * @brief Initialisation des renumeroteurs autorises pour les solvers
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

#include "Solvers/LinearSolver.h"
#include "Supervis/CommandSyntax.h"
#include "Supervis/ResultNaming.h"

const std::set< Renumbering > WrapMultFront::setOfAllowedRenumbering( MultFrontRenumbering,
                                                                      MultFrontRenumbering +
                                                                          nbRenumberingMultFront );

const std::set< Renumbering >
    WrapLdlt::setOfAllowedRenumbering( LdltRenumbering, LdltRenumbering + nbRenumberingLdlt );

const std::set< Renumbering >
    WrapMumps::setOfAllowedRenumbering( MumpsRenumbering, MumpsRenumbering + nbRenumberingMumps );

const std::set< Renumbering >
    WrapPetsc::setOfAllowedRenumbering( PetscRenumbering, PetscRenumbering + nbRenumberingPetsc );

const std::set< Renumbering >
    WrapGcpc::setOfAllowedRenumbering( GcpcRenumbering, GcpcRenumbering + nbRenumberingGcpc );

ListSyntaxMapContainer BaseLinearSolverClass::buildListSyntax() {
    ListSyntaxMapContainer listeSolver;
    SyntaxMapContainer dict1 = buildSyntaxMapFromParamList( _listOfParameters );
    listeSolver.push_back( dict1 );
    return listeSolver;
};


BaseLinearSolverClass::BaseLinearSolverClass( const std::string name,
                              const LinearSolverEnum currentBaseLinearSolver,
                              const Renumbering currentRenumber):
        DataStructure( name, 19, "SOLVEUR" ), _linearSolver( currentBaseLinearSolver ),
        _renumber( currentRenumber ), _isEmpty( true ), _preconditioning( Without ),
        _charValues( JeveuxVectorChar24( getName() + ".SLVK" ) ),
        _doubleValues( JeveuxVectorReal( getName() + ".SLVR" ) ),
        _integerValues( JeveuxVectorLong( getName() + ".SLVI" ) ), _algo( "ALGORITHME", false ),
        _lagr( "ELIM_LAGR", false ), _matrFilter( "FILTRAGE_MATRICE", false ),
        _memory( "GESTION_MEMOIRE", false ), _lowRankThreshold( "LOW_RANK_SEUIL", false ),
        _lowRankSize( "LOW_RANK_TAILLE", false ), _distMatrix( "MATR_DISTRIBUEE", false ),
        _method( "METHODE", false ), _precision( "MIXER_PRECISION", false ),
        _fillingLevel( "NIVE_REMPLISSAGE", false ), _iterNumber( "NMAX_ITER", false ),
        _nPrec( "NPREC", false ), _pivotPourcent( "PCENT_PIVOT", false ),
        _postPro( "POSTTRAITEMENTS", false ), _precond( "PRE_COND", false ),
        _prePro( "PRETRAITEMENTS", false ), _reac( "REAC_PRECOND", false ),
        _filling( "REMPLISSAGE", false ), _renum( "RENUM", false ),
        _residual( "RESI_RELA", false ), _precondResidual( "RESI_RELA_PC", false ),
        _stopSingular( "STOP_SINGULIER", false ), _resolutionType( "TYPE_RESOL", false ),
        _acceleration( "ACCELERATION", false ),
        _matrixPrec( new AssemblyMatrixDisplacementRealClass(
            ResultNaming::getNewResultName() + ".PREC" ) ),
        _commandName( "SOLVEUR" ),
        _xfem( false )
    {
        _renum = RenumberingNames[(int)_renumber];

        _method = std::string( LinearSolverNames[(int)_linearSolver] );
        _lagr = "NON";
        if ( currentBaseLinearSolver == Petsc ) {
            _algo = "FGMRES";
            _distMatrix = "NON";
            _iterNumber = (ASTERINTEGER)0;
            _preconditioning = SimplePrecisionLdlt;
            _precond = PreconditioningNames[(int)_preconditioning];
            _residual = 1.e-6;
            _precondResidual = -1.0;
            _reac = (ASTERINTEGER)30;
            _pivotPourcent = (ASTERINTEGER)20;
            _memory = "AUTO";
        }
        if ( currentBaseLinearSolver == Mumps ) {
            _lagr = "LAGR2";
            _memory = "AUTO";
            _lowRankThreshold = 0.;
            _lowRankSize = -1.0;
            _distMatrix = "NON";
            _precision = "NON";
            _nPrec = (ASTERINTEGER)8;
            _pivotPourcent = (ASTERINTEGER)20;
            _postPro = "AUTO";
            _prePro = "AUTO";
            _residual = -1.0;
            _stopSingular = "OUI";
            _resolutionType = "AUTO";
            _acceleration = "AUTO";
        }
        if ( currentBaseLinearSolver == MultFront ) {
            _nPrec = (ASTERINTEGER)8;
            _stopSingular = "OUI";
        }
        if ( currentBaseLinearSolver == Ldlt ) {
            _nPrec = (ASTERINTEGER)8;
            _stopSingular = "OUI";
        }
        if ( currentBaseLinearSolver == Gcpc ) {
            _iterNumber = (ASTERINTEGER)0;
            _preconditioning = IncompleteLdlt;
            _precond = PreconditioningNames[(int)_preconditioning];
            _residual = 1.e-6;
        }
        _listOfParameters.push_back( &_algo );
        _listOfParameters.push_back( &_lagr );
        _listOfParameters.push_back( &_matrFilter );
        _listOfParameters.push_back( &_memory );
        _listOfParameters.push_back( &_lowRankThreshold );
        _listOfParameters.push_back( &_lowRankSize );
        _listOfParameters.push_back( &_distMatrix );
        _listOfParameters.push_back( &_method );
        _listOfParameters.push_back( &_precision );
        _listOfParameters.push_back( &_fillingLevel );
        _listOfParameters.push_back( &_iterNumber );
        _listOfParameters.push_back( &_nPrec );
        _listOfParameters.push_back( &_pivotPourcent );
        _listOfParameters.push_back( &_postPro );
        _listOfParameters.push_back( &_precond );
        _listOfParameters.push_back( &_prePro );
        _listOfParameters.push_back( &_reac );
        _listOfParameters.push_back( &_filling );
        _listOfParameters.push_back( &_renum );
        _listOfParameters.push_back( &_residual );
        _listOfParameters.push_back( &_precondResidual );
        _listOfParameters.push_back( &_stopSingular );
        _listOfParameters.push_back( &_resolutionType );
        _listOfParameters.push_back( &_acceleration );
};

void BaseLinearSolverClass::setPreconditioning( Preconditioning precond ) {
        if ( _linearSolver != Petsc && _linearSolver != Gcpc )
            throw std::runtime_error( "Preconditionong only allowed with Gcpc or Petsc" );
        _preconditioning = precond;
        _precond = PreconditioningNames[(int)_preconditioning];
        if ( _preconditioning == IncompleteLdlt ) {
            _fillingLevel = (ASTERINTEGER)0;
            if ( _linearSolver == Petsc )
                _filling = 1.0;
        }
        if ( _preconditioning == SimplePrecisionLdlt ) {
            _pivotPourcent = (ASTERINTEGER)20;
            _reac = (ASTERINTEGER)30;
            _renumber = Sans;
            _renum = std::string( RenumberingNames[(int)Sans] );
        }
};

bool BaseLinearSolverClass::build() {
    if ( _charValues->exists() ) {
        _charValues->deallocate();
        _doubleValues->deallocate();
        _integerValues->deallocate();
    }
    std::string newName( getName() );
    newName.resize( 19, ' ' );

    // Definition du bout de fichier de commande pour SOLVEUR
    CommandSyntax cmdSt( _commandName );
    cmdSt.setResult( getName(), getType() );

    SyntaxMapContainer dict;
    ListSyntaxMapContainer listeSolver = this->buildListSyntax();

    dict.container["SOLVEUR"] = listeSolver;
    cmdSt.define( dict );

    std::string base( "G" );
    std::string xfem( "   " );
    if( _xfem ) xfem = "OUI";
    CALLO_CRESOL_WRAP( newName, base, xfem );
    _isEmpty = false;

    return true;
};

bool BaseLinearSolverClass::matrixFactorization(
    AssemblyMatrixDisplacementRealPtr currentMatrix ) {
    if ( _isEmpty )
        build();

    const std::string solverName( getName() + "           " );
    std::string base( "V" );
    if ( currentMatrix->getMemoryType() == Permanent )
        base = std::string( "G" );
    ASTERINTEGER cret = 0, npvneg = 0, istop = -9999;
    const std::string matpre( _matrixPrec->getName() );
    const std::string matass = currentMatrix->getName();

    // AMUMPT appel getres
    CommandSyntax cmdSt( "AUTRE" );
    cmdSt.setResult( "AUCUN", "AUCUN" );

    CALLO_MATRIX_FACTOR( solverName, base, &cret, _matrixPrec->getName(), matass, &npvneg, &istop );
    currentMatrix->_isFactorized = true;

    auto solverType = std::string( LinearSolverNames[_linearSolver] );
    currentMatrix->setSolverName( solverType );

    return true;
};

FieldOnNodesRealPtr BaseLinearSolverClass::solveRealLinearSystem(
    const AssemblyMatrixDisplacementRealPtr &currentMatrix,
    const FieldOnNodesRealPtr &currentRHS, FieldOnNodesRealPtr result ) const {
    if ( result->getName() == "" )
        result = FieldOnNodesRealPtr( new FieldOnNodesRealClass( Permanent ) );

    std::string blanc( " " );
    ASTERINTEGER nsecm = 0, prepos = 1, istop = 0, iret = 0;
    std::string base( JeveuxMemoryTypesNames[result->getMemoryType()] );

    CALLO_RESOUD_WRAP( currentMatrix->getName(), _matrixPrec->getName(), getName(), blanc, &nsecm,
                       currentRHS->getName(), result->getName(), base, blanc, &prepos, &istop,
                       &iret );

    auto solverType = std::string( LinearSolverNames[_linearSolver] );
    currentMatrix->setSolverName( solverType );

    return result;
};

FieldOnNodesRealPtr BaseLinearSolverClass::solveRealLinearSystemWithKinematicsLoad(
    const AssemblyMatrixDisplacementRealPtr &currentMatrix,
    const FieldOnNodesRealPtr &kinematicsField, const FieldOnNodesRealPtr &currentRHS,
    FieldOnNodesRealPtr result ) const {
    if ( result->getName() == "" )
        result = FieldOnNodesRealPtr( new FieldOnNodesRealClass( Permanent ) );

    std::string blanc( " " );
    ASTERINTEGER nsecm = 0, prepos = 1, istop = 0, iret = 0;
    std::string base( JeveuxMemoryTypesNames[result->getMemoryType()] );

    CALLO_RESOUD_WRAP( currentMatrix->getName(), _matrixPrec->getName(), getName(),
                       kinematicsField->getName(), &nsecm, currentRHS->getName(), result->getName(),
                       base, blanc, &prepos, &istop, &iret );

    auto solverType = std::string( LinearSolverNames[_linearSolver] );
    currentMatrix->setSolverName( solverType );

    return result;
};
