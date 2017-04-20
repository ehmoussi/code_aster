#ifndef NORMALMODEANALYSIS_H_
#define NORMALMODEANALYSIS_H_

/**
 * @file NormalModeAnalysis.h
 * @brief Definition of the normal mode solver
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2016  EDF R&D                www.code-aster.org
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

#include "Solvers/GenericSolver.h"
#include "LinearAlgebra/AssemblyMatrix.h"
#include "Utilities/CapyConvertibleValue.h"
#include "Results/MechanicalModeContainer.h"

class NormalModeAnalysisInstance: public GenericSolver
{
private:
    AssemblyMatrixDoublePtr  _rigidity;
    AssemblyMatrixDoublePtr  _mass;
    int                      _numberOfFreq;

    CapyConvertibleContainer _container;
    CapyConvertibleContainer _containerCalcFreq;

public:
    /**
     * @brief Constructeur
     */
    NormalModeAnalysisInstance(): _numberOfFreq( 10 ),
                                  _containerCalcFreq( "CALC_FREQ" )
    {
        _container.add( new CapyConvertibleValue< AssemblyMatrixDoublePtr >
                            ( false, "MATR_RIGI", _rigidity, false ) );
        _container.add( new CapyConvertibleValue< AssemblyMatrixDoublePtr >
                            ( false, "MATR_MASS", _mass, false ) );
        _container.add( new CapyConvertibleValue< int >
                            ( false, "NMAX_FREQ", _numberOfFreq, true ) );
    };

    MechanicalModeContainerPtr execute();

    void setMassMatrix( const AssemblyMatrixDoublePtr& matr )
    {
        _container[ "MATR_MASS" ]->enable();
        _mass = matr;
    };

    void setNumberOfFrequencies( const int& number )
    {
        _numberOfFreq = number;
    };

    void setRigidityMatrix( const AssemblyMatrixDoublePtr& matr )
    {
        _container[ "MATR_RIGI" ]->enable();
        _rigidity = matr;
    };
};

/**
 * @typedef NormalModeAnalysisPtr
 * @brief Enveloppe d'un pointeur intelligent vers un NormalModeAnalysisInstance
 */
typedef boost::shared_ptr< NormalModeAnalysisInstance > NormalModeAnalysisPtr;

#endif /* NORMALMODEANALYSIS_H_ */
