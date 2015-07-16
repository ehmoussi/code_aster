#ifndef SOLVERCONTROL_H_
#define SOLVERCONTROL_H_

/**
 * @file SolverControl.h
 * @brief Control class to check if an iterative solver has converged
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

enum ConvergenceState { failure, success, iterate };

/**
 * @class SolverControl
 * @brief Base control class used to check convergence of an iterative solver 
 * @author Natacha Béreux 
 */
class SolverControlInstance
{
    public:
    SolverControlInstance( double rTol=1.e-6, int nIterMax=100 ): 
    _relativeTol( rTol ), _nIterMax(nIterMax) 
    {}
    ~SolverControlInstance()
    {}
    virtual ConvergenceState check( const double relativeResNorm, const int iter) const
    {
     if ( abs(relativeResNorm) <= _relativeTol ) {
        return success; 
     }
     if ( iter >= _nIterMax ){
        return failure;
     }
     return iterate; 
    }
    double getRelativeTol() const
    {
        return _relativeTol; 
    }
    int getNIterMax() const
    {
        return _nIterMax; 
    }
    protected: 
    /* iter_glob_maxi*/
    int _nIterMax;
    /* resi_rela*/
    double _relativeTol; 
};
/**
 * @class NonLinearControl
 * @brief Control class used to check convergence of Newton solver 
 * @author Natacha Béreux 
 */

class NonLinearControlInstance : public SolverControlInstance
{
    public:
    NonLinearControlInstance( double rTol=1.e-6, int nIterMax=10, double maxTol=1.e-6, double relMaxTol=0.0, double relTolCmp=0.0):
    //SolveurControlInstance(rTol, nIterMax),
     _maxTol(maxTol), _relativeMaxTol(relMaxTol), _relativeTolByComponent(relTolCmp)
    { 
     _relativeTol = rTol;
     _nIterMax = nIterMax;
     }
    ~NonLinearControlInstance()
    {}
    
    virtual ConvergenceState check( const double checkValue, const int iter ) const 
    {
        return failure; 
    }
    protected: 
/* resi_glob_maxi*/
    double _maxTol;
/* resi_glob_rela */ 
    double _relativeMaxTol;
/* resi_comp_rela */
    double _relativeTolByComponent;
/* TODO resi_refe_rela */
   
};

/**
 * @typedef SolverControlPtr
 * @brief Pointeur intelligent vers un SolverControl
 */
typedef boost::shared_ptr< SolverControlInstance > SolverControlPtr;

/**
 * @typedef NonLinearControlPtr
 * @brief Pointeur intelligent vers un NonLinearControl
 */
typedef boost::shared_ptr< NonLinearControlInstance > NonLinearControlPtr;
#endif
