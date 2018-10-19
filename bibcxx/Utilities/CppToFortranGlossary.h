#ifndef CPPTOFORTRANGLOSSARY_H_
#define CPPTOFORTRANGLOSSARY_H_

/**
 * @file CppToFortranGlossary.h
 * @brief Fichier entete de la struct CppToFortranGlossary
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
#include <stdexcept>

#include "Modeling/PhysicsAndModelings.h"
#include "Loads/PhysicalQuantity.h"
#include "LinearAlgebra/AllowedLinearSolver.h"

/**
 * @class Glossary
 * @brief Classe de correspondance entre les noms Aster vers des types C++
 * @author Nicolas Sellenet
 */
class Glossary {
  private:
    /**
      * @typedef std::map d'une chaine et d'un entier
      * @todo Ce sera à changer quand on se passera des enums pour PhysicalQuantity, etc.
      */
    typedef std::map< std::string, int > MapStrInt;
    typedef MapStrInt::const_iterator MapStrIntIter;

    MapStrInt _strToInt;
    MapStrInt _memManagement;
    MapStrInt _renum;
    MapStrInt _precond;
    MapStrInt _lagrTreatment;
    MapStrInt _matrTyp;
    MapStrInt _algo;
    MapStrInt _post;
    MapStrInt _acce;

  public:
    /**
     * @brief Constructeur vide
     */
    Glossary();

    /**
     * @brief Destructeur vide
     */
    ~Glossary(){};

    /**
     * @brief getPhysics
     * @param searchPhysics Nom d'un nom de composante dans le fichier de commande
     * @return une valeur dans l'enum PhysicalQuantityComponent
     */
    PhysicalQuantityComponent getComponent( std::string searchComp ) const
        throw( std::runtime_error ) {
        MapStrIntIter curIter = _strToInt.find( searchComp );
        if ( curIter == _strToInt.end() )
            throw std::runtime_error( "Unknown component" );
        return ( PhysicalQuantityComponent )( curIter->second );
    };

    /**
     * @brief getIterativeSolverAlgorithm
     */
    IterativeSolverAlgorithm getIterativeSolverAlgorithm( std::string searchMod ) const
        throw( std::runtime_error ) {
        MapStrIntIter curIter = _algo.find( searchMod );
        if ( curIter == _algo.end() )
            throw std::runtime_error( "Unknown iterative solver algorithm" );
        return ( IterativeSolverAlgorithm )( curIter->second );
    };

    /**
     * @brief getLagrangeTreatment
     */
    LagrangeTreatment getLagrangeTreatment( std::string searchMod ) const
        throw( std::runtime_error ) {
        MapStrIntIter curIter = _lagrTreatment.find( searchMod );
        if ( curIter == _lagrTreatment.end() )
            throw std::runtime_error( "Unknown Lagrange treatment" );
        return ( LagrangeTreatment )( curIter->second );
    };

    /**
     * @brief getMatrixType
     */
    MatrixType getMatrixType( std::string searchMod ) const throw( std::runtime_error ) {
        MapStrIntIter curIter = _matrTyp.find( searchMod );
        if ( curIter == _matrTyp.end() )
            throw std::runtime_error( "Unknown matrix type" );
        return ( MatrixType )( curIter->second );
    };

    /**
     * @brief getMemoryManagement
     */
    MemoryManagement getMemoryManagement( std::string searchMod ) const
        throw( std::runtime_error ) {
        MapStrIntIter curIter = _memManagement.find( searchMod );
        if ( curIter == _memManagement.end() )
            throw std::runtime_error( "Unknown memory management" );
        return ( MemoryManagement )( curIter->second );
    };

    /**
     * @brief getModeling
     * @param searchMod Nom d'une physique dans le fichier de commande
     * @return une valeur dans l'enum Modelings
     */
    Modelings getModeling( std::string searchMod ) const throw( std::runtime_error ) {
        MapStrIntIter curIter = _strToInt.find( searchMod );
        if ( curIter == _strToInt.end() )
            throw std::runtime_error( "Unknown modeling" );
        return ( Modelings )( curIter->second );
    };

    /**
     * @brief getMumpsAcceleration
     */
    MumpsAcceleration getMumpsAcceleration( std::string searchMod ) const
        throw( std::runtime_error ) {
        MapStrIntIter curIter = _acce.find( searchMod );
        if ( curIter == _acce.end() )
            throw std::runtime_error( "Unknown acceleration" );
        return ( MumpsAcceleration )( curIter->second );
    };

    /**
     * @brief getMumpsPostTreatment
     */
    MumpsPostTreatment getMumpsPostTreatment( std::string searchMod ) const
        throw( std::runtime_error ) {
        MapStrIntIter curIter = _post.find( searchMod );
        if ( curIter == _post.end() )
            throw std::runtime_error( "Unknown post treatment" );
        return ( MumpsPostTreatment )( curIter->second );
    };

    /**
     * @brief getPhysics
     * @param searchPhysics Nom d'une physique dans le fichier de commande
     * @return une valeur dans l'enum Physics
     */
    Physics getPhysics( std::string searchPhysics ) const throw( std::runtime_error ) {
        MapStrIntIter curIter = _strToInt.find( searchPhysics );
        if ( curIter == _strToInt.end() )
            throw std::runtime_error( "Unknown physics" );
        return ( Physics )( curIter->second );
    };

    /**
     * @brief getRenumbering
     * @param searchRenum Nom d'un solveur dans le fichier de commande
     * @return une valeur dans l'enum Renumbering
     */
    Renumbering getRenumbering( std::string searchRenum ) const throw( std::runtime_error ) {
        MapStrIntIter curIter = _renum.find( searchRenum );
        if ( curIter == _renum.end() )
            throw std::runtime_error( "Unknown renumbering" );
        return ( Renumbering )( curIter->second );
    };

    /**
     * @brief getPreconditioning
     * @param searchPrecond Nom d'un solveur dans le fichier de commande
     * @return une valeur dans l'enum Preconditioning
     */
    Preconditioning getPreconditioning( std::string searchPrecond ) const
        throw( std::runtime_error ) {
        MapStrIntIter curIter = _precond.find( searchPrecond );
        if ( curIter == _precond.end() )
            throw std::runtime_error( "Unknown preconditioning" );
        return ( Preconditioning )( curIter->second );
    };

    /**
     * @brief getSolver
     * @param searchSol Nom d'un solveur dans le fichier de commande
     * @return une valeur dans l'enum LinearSolverEnum
     */
    LinearSolverEnum getSolver( std::string searchSol ) const throw( std::runtime_error ) {
        MapStrIntIter curIter = _strToInt.find( searchSol );
        if ( curIter == _strToInt.end() )
            throw std::runtime_error( "Unknown linear solver" );
        return ( LinearSolverEnum )( curIter->second );
    };
};

extern Glossary *fortranGlossary2;

Glossary *getGlossary();

const Glossary &getReferenceToGlossary();

#endif /* CPPTOFORTRANGLOSSARY_H_ */
