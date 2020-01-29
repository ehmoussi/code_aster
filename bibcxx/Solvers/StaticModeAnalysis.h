#ifndef STATICMODEANALYSIS_H_
#define STATICMODEANALYSIS_H_

/**
 * @file StaticModeAnalysis.h
 * @brief Definition of the static mode solver
 * @author Guillaume Drouet
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

/* person_in_charge: guillaume.drouet at edf.fr */
#include "astercxx.h"

#include "LinearAlgebra/AssemblyMatrix.h"
#include "LinearAlgebra/LinearSolver.h"
#include "Solvers/GenericSolver.h"
#include "Utilities/GenericParameter.h"

/**
 @brief the StaticModeAnalysis class is used to perform
 a static mode analysis from ....
*/

class StaticModeAnalysisClass : public GenericSolver {
  protected:
    /** @brief Mass Matrix */
    AssemblyMatrixDisplacementDoublePtr _MassMatrix;
    /** @brief Stiffness Matrix */
    AssemblyMatrixDisplacementDoublePtr _StiffMatrix;
    /** @brief Solveur lineaire */
    BaseLinearSolverPtr _linearSolver;
    /** @brief factor keyword composant description */
    GenParam _cmp;
    GenParam _loc;

  public:
    /**
     * @brief Constructeur
     */
    StaticModeAnalysisClass() : _cmp( "TOUT_CMP", true ), _loc( "TOUT", true ){};

    /**
     * @brief Set GROUP_NO
     * @param listloc wanted groups of nodes
     */
    void enableOnAllMesh() { _loc = GenParam( "TOUT", "OUI", true ); };

    /**
     * @brief Set GROUP_NO
     * @param listloc wanted groups of nodes
     */
    void setAllComponents() { _cmp = GenParam( "TOUT_CMP", "OUI", true ); };

    /**
    * @brief Set GROUP_NO
    * @param listloc wanted groups of nodes
    */
    void WantedGroupOfNodes( const std::vector< std::string > listloc ) {
        _loc = GenParam( "GROUP_NO", listloc, true );
    };

    /**
     * @brief Set AVEC_CMP
     * @param listcmp wanted component
     */
    void WantedComponent( const std::vector< std::string > listcmp ) {
        _cmp = GenParam( "AVEC_CMP", listcmp, true );
    };

    /**
     * @brief Set SANS_CMP
     * @param listcmp unwanted component
     */
    void UnwantedComponent( const std::vector< std::string > listcmp ) {
        _cmp = GenParam( "SANS_CMP", listcmp, true );
    };

    /**
     * @brief Lancement de la resolution en appelant op0093
     */
    virtual ResultsContainerPtr execute() = 0;

    /**
    * @brief Methode permettant de definir la matrice de masse
    * @param currentMatrix Matrice de masse
    */
    void setMassMatrix( const AssemblyMatrixDisplacementDoublePtr &currentMatrix ) {
        _MassMatrix = currentMatrix;
    };

    /**
     * @brief Methode permettant de definir la matrice de rigidite
     * @param currentMatrix Matrice de masse
     */
    void setStiffMatrix( const AssemblyMatrixDisplacementDoublePtr &currentMatrix ) {
        _StiffMatrix = currentMatrix;
    };

    /**
     * @brief Methode permettant de definir le solveur lineaire
     * @param currentSolver Solveur lineaire
     */
    void setLinearSolver( const BaseLinearSolverPtr &currentSolver ) {
        _linearSolver = currentSolver;
    };
};

class StaticModeDeplClass : public StaticModeAnalysisClass {
  protected:
  public:
    /**
     * @brief Constructeur
     */
    StaticModeDeplClass(){};

    /**
     * @brief Lancement de la resolution en appelant op0093
     */
    ResultsContainerPtr execute() ;
};

class StaticModeForcClass : public StaticModeAnalysisClass {
  protected:
  public:
    /**
     * @brief Constructeur
     */
    StaticModeForcClass(){};

    /**
     * @brief Lancement de la resolution en appelant op0093
     */
    ResultsContainerPtr execute() ;
};

class StaticModePseudoClass : public StaticModeAnalysisClass {
  protected:
    /** @brief keyword NOM_DIR description */
    GenParam _dirname;

  public:
    /**
     * @brief Constructeur
     */
    StaticModePseudoClass() : _dirname( "NOM_DIR", false ){};

    /**
     * @brief Setdir
     * @param dir wanted direction
     */
    void WantedDirection( const std::vector< double > dir ) {
        _loc = GenParam( "DIRECTION", dir, true );
    };

    /**
     * @brief Set axe
     * @param listaxe wanted axes
     */
    void WantedAxe( const std::vector< std::string > listaxe ) {
        _loc = GenParam( "AXE", listaxe, true );
    };

    /**
     * @brief Set dirname
     * @param name the Wanted_dir
     */
    void setNameForDirection( const std::string dirname ) {
        _dirname = GenParam( "NOM_DIR", dirname, false );
    };

    /**
     * @brief Lancement de la resolution en appelant op0093
     */
    ResultsContainerPtr execute() ;
};

class StaticModeInterfClass : public StaticModeAnalysisClass {
  protected:
    /** @brief keyword diranme description */
    GenParam _shift;
    GenParam _nbmod;

  public:
    /**
     * @brief Constructeur
     */
    StaticModeInterfClass()
        : _nbmod( "NB_MODE", (ASTERINTEGER)1, true ), _shift( "SHIFT", 1.0, true ){};

    /**
     * @brief Set dirname
     * @param name the Wanted_dir
     */
    void setNumberOfModes( const ASTERINTEGER nb ) { _nbmod = GenParam( "NB_MODE", nb, true ); };

    /**
     * @brief Set dirname
     * @param name the Wanted_dir
     */
    void setShift( const double shift ) { _shift = GenParam( "SHIFT", shift, true ); };

    /**
     * @brief Lancement de la resolution en appelant op0093
     */
    ResultsContainerPtr execute() ;
};
/**
 * @typedef StaticNonLinearAnalysisPtr
 * @brief Enveloppe d'un pointeur intelligent vers un StaticModeAnalysisClass
 */
typedef boost::shared_ptr< StaticModeDeplClass > StaticModeDeplPtr;
typedef boost::shared_ptr< StaticModeForcClass > StaticModeForcPtr;
typedef boost::shared_ptr< StaticModePseudoClass > StaticModePseudoPtr;
typedef boost::shared_ptr< StaticModeInterfClass > StaticModeInterfPtr;

#endif /* STATICMODEANALYSIS_H_ */
