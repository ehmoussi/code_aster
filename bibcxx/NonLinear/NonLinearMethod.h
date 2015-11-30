#ifndef NONLINEARMETHOD_H_
#define NONLINEARMETHOD_H_

/**
 * @file StaticNonLinearSolver.h
 * @brief Definition of the static mechanical solver
 * @author Natacha Béreux
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

/* person_in_charge: natacha.bereux at edf.fr */
#include "astercxx.h"

#include "LinearAlgebra/LinearSolver.h"
#include "NonLinear/NonLinearControl.h" 
#include "NonLinear/LineSearchMethod.h"

/** @todo définir un enum avec les méthodes nonlinéaires Newton, Newton-Krylov, Implex
*/

class NonLinearMethodInstance
{
    private:
        /** @brief Name of the nonlinear method */
        std::string _name; 
        /** @brief Contrôle de la convergence de la méthode  */
        NonLinearControlPtr _control; 
        /** @brief Solveur lineaire */
        LinearSolverPtr    _linearSolver;
        /** @brief Méthode de recherche linéaire */
        LineSearchMethodPtr _lineSearch;
    public:
        /**
         * @brief Constructeur
         */
        NonLinearMethodInstance( std::string name="NEWTON" ): 
        _name(name), _linearSolver( LinearSolverPtr() )
        {};
        /**
         * @brief Methode permettant de definir le solveur lineaire
         * @param currentSolver Solveur lineaire
         */
        void setLinearSolver( const LinearSolverPtr& currentSolver )
        {
            _linearSolver = currentSolver;
        };
        /**
         * @brief Methode retournant le solveur lineaire
         */
        LinearSolverPtr&  getLinearSolver()
        {
             return _linearSolver;
        };
        /**
         * @brief Methode permettant de definir la méthode de recherche lineaire
         * @param currentLineSearch méthode de recherche lineaire
         */
        void setLineSearchMethod( const LineSearchMethodPtr& currentLineSearch )
        {
            _lineSearch = currentLineSearch;
        };
        
        /** @brief Construction de la sd solveur pour le solveur linéaire 
        */
        void build()
        {
            _linearSolver->build(); 
        };
        
        /** @brief  Check convergence status of the nonlinear method
        */
        ConvergenceState check ( DiscreteProblemPtr& dProblem, FieldOnNodesDoublePtr& uField, int niter )
        {
            return _control-> check( dProblem, uField, niter );
        }
        /** @brief  Clean history data in control object 
        */
        void cleanLog ()
        {
            _control-> cleanLog();
        }
};

/**
 * @typedef NonLinearMethodPtr
 * @brief Enveloppe d'un pointeur intelligent vers un NonLinearMethodInstance
 */
typedef boost::shared_ptr< NonLinearMethodInstance > NonLinearMethodPtr;

#endif /* NONLINEARMETHOD_H_ */
