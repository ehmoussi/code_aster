#ifndef LINEARSOLVER_H_
#define LINEARSOLVER_H_

/**
 * @file LinearSolver.h
 * @brief Fichier entete de la classe LinearSolver
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2014  EDF R&D                www.code-aster.org
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

#include <stdexcept>
#include <list>
#include <set>
#include <string>

#include "astercxx.h"
#include "DataFields/FieldOnNodes.h"
#include "LinearAlgebra/AllowedLinearSolver.h"
#include "LinearAlgebra/AssemblyMatrix.h"
#include "DataStructure/DataStructure.h"
#include "MemoryManager/JeveuxVector.h"

/* person_in_charge: nicolas.sellenet at edf.fr */

// Ces wrappers sont la pour autoriser que les set soient const
// Sinon, on aurait pas pu passer directement des const set<> en parametre template
/**
 * @struct WrapMultFront
 * @brief Structure destinee a contenir les renumeroteurs autorises pour MultFront
 */
struct WrapMultFront
{
    static const std::set< Renumbering > setOfAllowedRenumbering;
};

/**
 * @struct WrapLdlt
 * @brief Structure destinee a contenir les renumeroteurs autorises pour Ldlt
 */
struct WrapLdlt
{
    static const std::set< Renumbering > setOfAllowedRenumbering;
};

/**
 * @struct WrapMumps
 * @brief Structure destinee a contenir les renumeroteurs autorises pour Mumps
 */
struct WrapMumps
{
    static const std::set< Renumbering > setOfAllowedRenumbering;
};

/**
 * @struct WrapPetsc
 * @brief Structure destinee a contenir les renumeroteurs autorises pour Petsc
 */
struct WrapPetsc
{
    static const std::set< Renumbering > setOfAllowedRenumbering;
};

/**
 * @struct WrapGcpc
 * @brief Structure destinee a contenir les renumeroteurs autorises pour Gcpc
 */
struct WrapGcpc
{
    static const std::set< Renumbering > setOfAllowedRenumbering;
};

/**
 * @struct RenumberingChecker
 * @brief Struct statiquepermetant de verifier si un renumeroteur est autorise
         pour un solveur donne
 * @author Nicolas Sellenet
 */
template< class Wrapping >
struct RenumberingChecker
{
    static bool isAllowedRenumbering( Renumbering test )
    {
        if ( Wrapping::setOfAllowedRenumbering.find( test ) == Wrapping::setOfAllowedRenumbering.end() )
            return false;
        return true;
    }
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
 * @struct SolverChecker
 * @brief permet de verifier si un couple solveur, renumeroteur est autorise
 * @author Nicolas Sellenet
 */
struct SolverChecker
{
    /**
     * @brief Fonction statique qui verifie un couple solveur, renumeroteur
     * @param solver Type de solveur
     * @param renumber Type de renumeroteur
     * @return vrai si le couple est valide
     */
    static bool isAllowedRenumberingForSolver( LinearSolverEnum solver, Renumbering renumber ) throw ( std::runtime_error )
    {
        switch ( solver )
        {
            case MultFront:
                return MultFrontRenumberingChecker::isAllowedRenumbering( renumber );
            case Ldlt:
                return LdltRenumberingChecker::isAllowedRenumbering( renumber );
            case Mumps:
                return MumpsRenumberingChecker::isAllowedRenumbering( renumber );
            case Petsc:
                return PetscRenumberingChecker::isAllowedRenumbering( renumber );
            case Gcpc:
                return GcpcRenumberingChecker::isAllowedRenumbering( renumber );
            default:
                throw std::runtime_error( "Not a valid linear solver" );
        }
    };
};

/**
 * @class LinearSolverInstance
 * @brief Cette classe permet de definir un solveur lineaire
 * @author Nicolas Sellenet
 */
class LinearSolverInstance: public DataStructure
{
    private:
        /** @brief Type du solveur lineaire */
        LinearSolverEnum    _linearSolver;
        /** @brief Type du renumeroteur */
        Renumbering         _renumber;
        /** @brief Le solveur est-il vide ? */
        bool                _isEmpty;

        JeveuxVectorChar24  _charValues;
        JeveuxVectorDouble  _doubleValues;
        JeveuxVectorLong    _integerValues;

    public:
        /**
         * @brief Constructeur
         * @param currentLinearSolver Type de solveur
         * @param currentRenumber Type de renumeroteur
         * @todo recuperer le code retour de isAllowedRenumberingForSolver
         */
        LinearSolverInstance( const LinearSolverEnum currentLinearSolver,
                              const Renumbering currentRenumber ):
                    DataStructure( getNewResultObjectName(), "SOLVEUR" ),
                    _linearSolver( currentLinearSolver ),
                    _renumber( currentRenumber ),
                    _isEmpty( true ),
                    _charValues( JeveuxVectorChar24( getName() + "           .SLVK" ) ),
                    _doubleValues( JeveuxVectorDouble( getName() + "           .SLVR" ) ),
                    _integerValues( JeveuxVectorLong( getName() + "           .SLVI" ) )
        {
            SolverChecker::isAllowedRenumberingForSolver( currentLinearSolver, currentRenumber );
        };

        /**
         * @brief Construction de la sd_solveur
         * @return vrai si tout s'est bien passé
         */
        bool build();

        /**
         * @brief Recuperer le nom du solveur
         * @return chaine contenant le nom Aster du solveur
         */
        const std::string getSolverName() const
        {
            return LinearSolverNames[ (int)_linearSolver ];
        };

        /**
         * @brief Recuperer le nom du renumeroteur
         * @return chaine contenant le nom Aster du renumeroteur
         */
        const std::string getRenumberingName() const
        {
            return RenumberingNames[ (int)_renumber ];
        };

        /**
         * @brief Methode permettant de savoir si la matrice est vide
         * @return true si vide
         */
        bool isEmpty()
        {
            return _isEmpty;
        };

        /**
         * @brief Factorisation d'une matrice
         * @param currentMatrix Matrice assemblee
         */
        bool matrixFactorization( const AssemblyMatrixDoublePtr currentMatrix ) const;

        /**
         * @brief Inversion du systeme lineaire
         * @param currentMatrix Matrice assemblee
         * @param currentRHS Second membre
         * @return champ aux noeuds resultat
         */
        FieldOnNodesDoublePtr solveDoubleLinearSystem( const AssemblyMatrixDoublePtr& currentMatrix,
                                                       const FieldOnNodesDoublePtr& currentRHS ) const;

        /**
         * @brief Inversion du systeme lineaire
         * @param currentMatrix Matrice assemblee
         * @param currentRHS Second membre
         * @return champ aux noeuds resultat
         */
        FieldOnNodesDoublePtr solveDoubleLinearSystem( const AssemblyMatrixDoublePtr& currentMatrix,
                                                       const FieldOnNodesDoublePtr& kinematicsField,
                                                       const FieldOnNodesDoublePtr& currentRHS,
                                                       FieldOnNodesDoublePtr result = FieldOnNodesDoublePtr( new FieldOnNodesDoubleInstance( "" ) ) ) const;
};

/**
 * @typedef LinearSolverPtr
 * @brief Enveloppe d'un pointeur intelligent vers un LinearSolverInstance
 */
typedef boost::shared_ptr< LinearSolverInstance > LinearSolverPtr;

#endif /* LINEARSOLVER_H_ */
