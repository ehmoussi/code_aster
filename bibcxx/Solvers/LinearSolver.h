#ifndef LINEARSOLVER_H_
#define LINEARSOLVER_H_

/**
 * @file LinearSolver.h
 * @brief Fichier entete de la classe LinearSolver
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

#include <list>
#include <set>
#include <stdexcept>
#include <string>

#include "DataFields/FieldOnNodes.h"
#include "DataStructures/DataStructure.h"
#include "Solvers/AllowedLinearSolver.h"
#include "LinearAlgebra/AssemblyMatrix.h"
#include "MemoryManager/JeveuxVector.h"
#include "Supervis/ResultNaming.h"
#include "Utilities/GenericParameter.h"
#include "astercxx.h"

/**
 * @struct LinearStaticAnalysisClass predefinition
 * @todo to remove
 */
class LinearStaticAnalysisClass;

/* person_in_charge: nicolas.sellenet at edf.fr */

// Ces wrappers sont la pour autoriser que les set soient const
// Sinon, on aurait pas pu passer directement des const set<> en parametre template
/**
 * @struct WrapMultFront
 * @brief Structure destinee a contenir les renumeroteurs autorises pour MultFront
 */
struct WrapMultFront {
    static const LinearSolverEnum solverType = MultFront;
    static const std::set< Renumbering > setOfAllowedRenumbering;
    static const bool isHPCCompliant = false;
    static const Renumbering defaultRenumbering = Metis;
};

/**
 * @struct WrapLdlt
 * @brief Structure destinee a contenir les renumeroteurs autorises pour Ldlt
 */
struct WrapLdlt {
    static const LinearSolverEnum solverType = Ldlt;
    static const std::set< Renumbering > setOfAllowedRenumbering;
    static const bool isHPCCompliant = false;
    static const Renumbering defaultRenumbering = RCMK;
};

/**
 * @struct WrapMumps
 * @brief Structure destinee a contenir les renumeroteurs autorises pour Mumps
 */
struct WrapMumps {
    static const LinearSolverEnum solverType = Mumps;
    static const std::set< Renumbering > setOfAllowedRenumbering;
    static const bool isHPCCompliant = true;
    static const Renumbering defaultRenumbering = Auto;
};

/**
 * @struct WrapPetsc
 * @brief Structure destinee a contenir les renumeroteurs autorises pour Petsc
 */
struct WrapPetsc {
    static const LinearSolverEnum solverType = Petsc;
    static const std::set< Renumbering > setOfAllowedRenumbering;
    static const bool isHPCCompliant = true;
    static const Renumbering defaultRenumbering = Sans;
};

/**
 * @struct WrapGcpc
 * @brief Structure destinee a contenir les renumeroteurs autorises pour Gcpc
 */
struct WrapGcpc {
    static const LinearSolverEnum solverType = Gcpc;
    static const std::set< Renumbering > setOfAllowedRenumbering;
    static const bool isHPCCompliant = false;
    static const Renumbering defaultRenumbering = Sans;
};

/**
 * @struct RenumberingChecker
 * @brief Struct statiquepermetant de verifier si un renumeroteur est autorise
         pour un solveur donne
 * @author Nicolas Sellenet
 */
template < class Wrapping > struct RenumberingChecker {
    static bool isAllowedRenumbering( Renumbering test ) {
        if ( Wrapping::setOfAllowedRenumbering.find( test ) ==
             Wrapping::setOfAllowedRenumbering.end() )
            return false;
        return true;
    }

    static bool isHPCCompliant() { return Wrapping::isHPCCompliant; }
};

/** @typedef Definition du verificateur de renumeroteur pour MultFront */
typedef RenumberingChecker< WrapMultFront > MultFrontRenumberingChecker;
/** @typedef Definition du verificateur de renumeroteur pour Ldlt */
typedef RenumberingChecker< WrapLdlt > LdltRenumberingChecker;
/** @typedef Definition du verificateur de renumeroteur pour Mumps */
typedef RenumberingChecker< WrapMumps > MumpsRenumberingChecker;
/** @typedef Definition du verificateur de renumeroteur pour Petsc */
typedef RenumberingChecker< WrapPetsc > PetscRenumberingChecker;
/** @typedef Definition du verificateur de renumeroteur pour Gcpc */
typedef RenumberingChecker< WrapGcpc > GcpcRenumberingChecker;

/**
 * @class BaseLinearSolverClass
 * @brief Cette classe permet de definir un solveur lineaire
 * @author Nicolas Sellenet
 * @todo verifier que tous les mots-clés sont modifiables par des set
 */
class BaseLinearSolverClass : public DataStructure {
  protected:
    /** @brief Type du solveur lineaire */
    LinearSolverEnum _linearSolver;
    /** @brief Type du renumeroteur */
    Renumbering _renumber;
    /** @brief Le solveur est-il vide ? */
    bool _isEmpty;
    Preconditioning _preconditioning;

    JeveuxVectorChar24 _charValues;
    JeveuxVectorReal _doubleValues;
    JeveuxVectorLong _integerValues;

    GenParam _algo;
    GenParam _lagr;
    GenParam _matrFilter;
    GenParam _memory;
    GenParam _lowRankThreshold;
    GenParam _lowRankSize;
    GenParam _distMatrix;
    GenParam _method;
    GenParam _precision;
    GenParam _fillingLevel;
    GenParam _iterNumber;
    GenParam _nPrec;
    GenParam _pivotPourcent;
    GenParam _postPro;
    GenParam _precond;
    GenParam _prePro;
    GenParam _reac;
    GenParam _filling;
    GenParam _renum;
    GenParam _residual;
    GenParam _precondResidual;
    GenParam _stopSingular;
    GenParam _resolutionType;
    GenParam _acceleration;
    GenParam _optionPetsc;
    ListGenParam _listOfParameters;
    AssemblyMatrixDisplacementRealPtr _matrixPrec;
    std::string _commandName;
    bool _xfem;

  public:
    /**
     * @typedef BaseLinearSolverPtr
     * @brief Pointeur intelligent vers un BaseLinearSolverClass
     */
    typedef boost::shared_ptr< BaseLinearSolverClass > BaseLinearSolverPtr;

    /**
     * @brief Constructeur
     * @param currentBaseLinearSolver Type de solveur
     * @param currentRenumber Type de renumeroteur
     * @todo recuperer le code retour de isAllowedRenumberingForSolver
     */
    BaseLinearSolverClass( const LinearSolverEnum currentBaseLinearSolver = MultFront,
                              const Renumbering currentRenumber = Metis )
        : BaseLinearSolverClass( ResultNaming::getNewResultName(), currentBaseLinearSolver,
                                    currentRenumber ){};

    /**
     * @brief Constructeur
     * @param name Name of the DataStructure
     * @param currentBaseLinearSolver Type de solveur
     * @param currentRenumber Type de renumeroteur
     * @todo recuperer le code retour de isAllowedRenumberingForSolver
     */
    BaseLinearSolverClass( const std::string name,
                              const LinearSolverEnum currentBaseLinearSolver = MultFront,
                              const Renumbering currentRenumber = Metis );

    /**
     * @brief Destructor
     */
    ~BaseLinearSolverClass(){};

    /** @brief Returns a ListSyntaxMapContainer object "listsyntax",
        ready to be inserted  in a CommandSyntax object with the key SOLVEUR
    */
    ListSyntaxMapContainer buildListSyntax();

    /**
     * @brief Construction de la sd_solveur
     * @return vrai si tout s'est bien passé
     */
    bool build();

    /**
     * @brief Enable Xfem preconditioning
     */
    void enableXfem()
    {
        _xfem = true;
    };

    /**
     * @brief Récupération de la liste des paramètres du solveur
     * @return Liste constante des paramètres déclarés
     */
    const ListGenParam &getListOfParameters() const { return _listOfParameters; };

    /**
     * @brief Recuperer le précond
     * @return le type de preconditionneur
     */
    Preconditioning getPreconditioning() const { return _preconditioning; };

    /**
     * @brief Recuperer le nom du solveur
     * @return chaine contenant le nom Aster du solveur
     */
    const std::string getSolverName() const { return LinearSolverNames[(int)_linearSolver]; };

    /**
     * @brief Recuperer le nom du renumeroteur
     * @return chaine contenant le nom Aster du renumeroteur
     */
    const std::string getRenumberingName() const { return RenumberingNames[(int)_renumber]; };

    /**
     * @brief Methode permettant de savoir si la matrice est vide
     * @return true si vide
     */
    bool isEmpty() { return _isEmpty; };

    /**
     * @brief Methode permettant de savoir si le HPC est autorise
     * @return true si le découpage de domain est autorisé
     */
    virtual bool isHPCCompliant() { return false; };

    /**
     * @brief Factorisation d'une matrice
     * @param currentMatrix Matrice assemblee
     */
    bool matrixFactorization( AssemblyMatrixDisplacementRealPtr currentMatrix );

    /**
     * @brief Inversion du systeme lineaire
     * @param currentMatrix Matrice assemblee
     * @param kinematicsField Charge cinématique
     * @param currentRHS Second membre
     * @param result champ aux noeuds résultat (optionnel)
     * @return champ aux noeuds resultat
     */
    FieldOnNodesRealPtr
    solveRealLinearSystem( const AssemblyMatrixDisplacementRealPtr &currentMatrix,
                             const FieldOnNodesRealPtr &currentRHS,
                             FieldOnNodesRealPtr result = FieldOnNodesRealPtr(
                                 new FieldOnNodesRealClass( Permanent ) ) ) const;

    /**
     * @brief Inversion du systeme lineaire
     * @param currentMatrix Matrice assemblee
     * @param kinematicsField Charge cinématique
     * @param currentRHS Second membre
     * @param result champ aux noeuds résultat (optionnel)
     * @return champ aux noeuds resultat
     */
    FieldOnNodesRealPtr solveRealLinearSystemWithKinematicsLoad(
        const AssemblyMatrixDisplacementRealPtr &currentMatrix,
        const FieldOnNodesRealPtr &kinematicsField, const FieldOnNodesRealPtr &currentRHS,
        FieldOnNodesRealPtr result =
            FieldOnNodesRealPtr( new FieldOnNodesRealClass( Permanent ) ) ) const;

    void disablePreprocessing() {
        if ( _linearSolver != Mumps )
            throw std::runtime_error( "Algorithm only allowed with Mumps" );
        _prePro = "SANS";
    };

    void setAcceleration( MumpsAcceleration post ) {
        if ( _linearSolver != Mumps )
            throw std::runtime_error( "Only allowed with Mumps" );
        _acceleration = MumpsAccelerationNames[(int)post];
    };

    void setAlgorithm( IterativeSolverAlgorithm algo ) {
        if ( _linearSolver != Petsc )
            throw std::runtime_error( "Algorithm only allowed with Petsc" );
        _algo = std::string( IterativeSolverAlgorithmNames[(int)algo] );
    };

    void setPetscOption( std::string option ) {
        if ( _linearSolver != Petsc )
            throw std::runtime_error( "Options only allowed with Petsc" );
        _optionPetsc = option;
    };

    void setDistributedMatrix( bool matDist ) {
        if ( _linearSolver != Petsc && _linearSolver != Mumps )
            throw std::runtime_error( "Distributed matrix only allowed with Mumps or Petsc" );
        if ( matDist )
            _distMatrix = "OUI";
        else
            _distMatrix = "NON";
    };

    void setErrorOnMatrixSingularity( bool error ) {
        if ( error )
            _stopSingular = "OUI";
        else
            _stopSingular = "NON";
    };

    void setFilling( double filLevel ) {
        if ( _linearSolver != Petsc && _linearSolver != Gcpc )
            throw std::runtime_error( "Filling level only allowed with Gcpc or Petsc" );
        if ( _preconditioning != IncompleteLdlt )
            throw std::runtime_error( "Filling level only allowed with IncompleteLdlt" );
        _filling = filLevel;
    };

    void setFillingLevel( ASTERINTEGER filLevel ) {
        if ( _linearSolver != Petsc && _linearSolver != Gcpc )
            throw std::runtime_error( "Filling level only allowed with Gcpc or Petsc" );
        if ( _preconditioning != IncompleteLdlt )
            throw std::runtime_error( "Filling level only allowed with IncompleteLdlt" );
        _fillingLevel = filLevel;
    };

    void setLagrangeElimination( LagrangeTreatment lagrTreat ) {
        _lagr = std::string( LagrangeTreatmentNames[(int)lagrTreat] );
    };

    void setLowRankSize( double size ) { _lowRankSize = size; };

    void setLowRankThreshold( double threshold ) { _lowRankThreshold = threshold; };

    void setMatrixFilter( double filter ) { _matrFilter = filter; };

    void setMatrixType( MatrixType matType ) { _resolutionType = MatrixTypeNames[(int)matType]; };

    void setMaximumNumberOfIteration( ASTERINTEGER number ) {
        if ( _linearSolver != Petsc && _linearSolver != Gcpc )
            throw std::runtime_error( "Only allowed with Gcpc or Petsc" );
        _iterNumber = number;
    };

    void setMemoryManagement( MemoryManagement memManagt ) {
        _memory = MemoryManagementNames[(int)memManagt];
    };

    void setPivotingMemory( ASTERINTEGER mem ) { _pivotPourcent = mem; };

    void setPostTreatment( MumpsPostTreatment post ) {
        if ( _linearSolver != Mumps )
            throw std::runtime_error( "Only allowed with Mumps" );
        _postPro = MumpsPostTreatmentNames[(int)post];
    };

    void setPrecisionMix( bool precMix ) {
        if ( _linearSolver != Petsc && _linearSolver != Mumps )
            throw std::runtime_error( "Precision mixing only allowed with Mumps or Petsc" );
        if ( precMix )
            _precision = "OUI";
        else
            _precision = "NON";
    };

    void setPreconditioning( Preconditioning precond ) ;

    void setPreconditioningResidual( double residual ) { _precondResidual = residual; };

    void setRenumbering( Renumbering reum ) { _renumber = reum; };

    void setSingularityDetectionThreshold( ASTERINTEGER nprec ) { _nPrec = nprec; };

    void setSolverResidual( double residual )
    {
        _residual = residual;
    };

    void setUpdatePreconditioningParameter( ASTERINTEGER value ) {
        if ( _linearSolver != Petsc && _linearSolver != Gcpc )
            throw std::runtime_error( "Preconditionong only allowed with Gcpc or Petsc" );
        if ( _preconditioning != SimplePrecisionLdlt )
            throw std::runtime_error(
                "Update preconditioning parameter only allowed with IncompleteLdlt" );
        _reac = value;
    };

    friend class LinearStaticAnalysisClass;
};

/**
 * @typedef BaseLinearSolverPtr
 * @brief Pointeur intelligent vers un BaseLinearSolverClass
 */
typedef boost::shared_ptr< BaseLinearSolverClass > BaseLinearSolverPtr;

/**
 * @class LinearSolverClass
 * @brief Cette classe permet de definir un solveur lineaire
 * @author Nicolas Sellenet
 * @todo verifier que tous les mots-clés sont modifiables par des set
 */
template < typename linSolvWrap > class LinearSolverClass : public BaseLinearSolverClass {
  public:
    /**
     * @typedef LinearSolverPtr
     * @brief Pointeur intelligent vers un LinearSolver
     */
    typedef boost::shared_ptr< LinearSolverClass< linSolvWrap > > LinearSolverPtr;

    /**
     * @brief Constructeur
     */
    LinearSolverClass( const Renumbering currentRenumber = Metis )
        : LinearSolverClass( ResultNaming::getNewResultName(), currentRenumber )
    {};

    LinearSolverClass( const std::string name, const Renumbering currentRenumber = Metis )
        : BaseLinearSolverClass( name, linSolvWrap::solverType, currentRenumber )
    {
        RenumberingChecker< linSolvWrap >::isAllowedRenumbering( currentRenumber );
    };

    bool isHPCCompliant() { return RenumberingChecker< linSolvWrap >::isHPCCompliant(); };
};

typedef LinearSolverClass< WrapMultFront > MultFrontSolverClass;
typedef LinearSolverClass< WrapLdlt > LdltSolverClass;
typedef LinearSolverClass< WrapMumps > MumpsSolverClass;
typedef LinearSolverClass< WrapPetsc > PetscSolverClass;
typedef LinearSolverClass< WrapGcpc > GcpcSolverClass;

/** @brief Enveloppe d'un pointeur intelligent vers un BaseLinearSolverClass< MultFront > */
typedef boost::shared_ptr< MultFrontSolverClass > MultFrontSolverPtr;

/** @brief Enveloppe d'un pointeur intelligent vers un BaseLinearSolverClass< Ldlt > */
typedef boost::shared_ptr< LdltSolverClass > LdltSolverPtr;

/** @brief Enveloppe d'un pointeur intelligent vers un BaseLinearSolverClass< Mumps > */
typedef boost::shared_ptr< MumpsSolverClass > MumpsSolverPtr;

/** @brief Enveloppe d'un pointeur intelligent vers un BaseLinearSolverClass< Petsc > */
typedef boost::shared_ptr< PetscSolverClass > PetscSolverPtr;

/** @brief Enveloppe d'un pointeur intelligent vers un BaseLinearSolverClass< Gcpc > */
typedef boost::shared_ptr< GcpcSolverClass > GcpcSolverPtr;

#endif /* LINEARSOLVER_H_ */
