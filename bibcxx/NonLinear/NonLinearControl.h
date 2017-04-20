#ifndef NONLINEARCONTROL_H_
#define NONLINEARCONTROL_H_

/**
 * @file NonLinearControl.h
 * @brief Fichier entete de la classe NonLinearControl
 * @author Natacha Béreux
 * @section LICENCE
 *   Copyright (C) 1991 - 2015  EDF R&D                www.code-aster.org
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

#include <vector> 

#include "Discretization/DiscreteProblem.h"
#include "LinearAlgebra/SolverControl.h"


/**
 * @class NonLinearControl
 * @brief Control class used to check convergence of Newton solver 
 * @author Natacha Béreux 
 */

class NonLinearControlInstance : public SolverControlInstance
{
    public:
    NonLinearControlInstance( double rTol=1.e-6, int nIterMax=10, double maxTol=1.e-6, double relMaxTol=0.0, double relTolCmp=0.0);

    ~NonLinearControlInstance()
    {}

    /** @brief Eval convergence status
        @param dProblem discrete problem 
        @param uField solution candidate 
        @param nIter current step 
    */
    virtual  ConvergenceState check( const DiscreteProblemPtr& dProblem, const FieldOnNodesDoublePtr& uField, int nIter ); 
    
    /** @brief Print convergence history */
    void printLog();

    /** @brief Clean convergence history */
    void cleanLog();

    protected:
/* resi_glob_maxi*/
    double _maxTol;
/* resi_glob_rela */ 
    double _relativeMaxTol;
/* resi_comp_rela */
    double _relativeTolByComponent;
/* TODO resi_refe_rela */

   private: 
   std::vector<double> _relResNorm;
};

/**
 * @typedef NonLinearControlPtr
 * @brief Pointeur intelligent vers un NonLinearControl
 */
typedef boost::shared_ptr< NonLinearControlInstance > NonLinearControlPtr;
#endif
