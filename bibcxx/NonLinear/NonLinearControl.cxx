/**
 * @file NonLinearControl.cxx
 * @brief NonLinearControl class is derived from SolverControl class. It evals the convergence
 *status of
 * a nonlinear iterative method
 * @author Natacha Béreux
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

/* person_in_charge: natacha.bereux at edf.fr */

#include "NonLinear/NonLinearControl.h"

/**
 * @class  NonLinearControl
 * @brief  Control class used to check convergence of Newton solver
 * @author Natacha Béreux
 */

NonLinearControlClass::NonLinearControlClass( double rTol, int nIterMax, double maxTol,
                                                    double relMaxTol, double relTolCmp )
    : SolverControlClass( rTol, nIterMax ), _maxTol( maxTol ), _relativeMaxTol( relMaxTol ),
      _relativeTolByComponent( relTolCmp ) {
    std::vector< double > v( nIterMax, 0. );
    _relResNorm = v;
}

ConvergenceState NonLinearControlClass::check( const DiscreteProblemPtr &dProblem,
                                                  const FieldOnNodesRealPtr &uField, int nIter ) {
    double relativeResNorm( 0.0 );
    // Get the residual
    /* Aucune de ces fonctions  n'existe encore ...
    FieldOnNodesRealPtr res =  dProblem->buildResidual( uField );
    resnorm = res-> getNorm( "NORM2" );
    // Normalisation ??
    double relativeResNorm = dProblem-> getRelativeResidualNorm( "NORM2" );
    */
    // Store the residual norm
    if ( nIter < _relResNorm.size() ) {
        _relResNorm[nIter] = relativeResNorm;
    }
    // Has the linear solver converged?
    ConvergenceState status( iterate );
    if ( relativeResNorm < _relativeTol ) {
        status = success;
    }
    if ( nIter >= _nIterMax ) {
        status = failure;
    }
    std::cout << " Check -> status = " << status << std::endl;
    return status;
}

/* Clean convergence history */
void NonLinearControlClass::cleanLog() {
    for ( std::vector< double >::iterator it( _relResNorm.begin() ); it < _relResNorm.end();
          it++ ) {
        *it = 0.0;
    }
}

/* Print convergence history */
void NonLinearControlClass::printLog() {
    for ( int ii( 0 ); ii < _relResNorm.size(); ii++ ) {
        if ( _relResNorm[ii] > 0.0 )
            std::cout << " Résidu à l'itération  " << ii << " : " << _relResNorm[ii] << std::endl;
    }
}
