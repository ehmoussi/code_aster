#ifndef STATICMECHANICCONTEXT_H_
#define STATICMECHANICCONTEXT_H_

/**
 * @file StaticMechanicalContext.h
 * @brief Fichier entete de la classe StaticMechanicalContext
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2019  EDF R&D                www.code-aster.org
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

#include "Discretization/DiscreteProblem.h"
#include "LinearAlgebra/LinearSolver.h"
#include "Results/ResultsContainer.h"
#include "Loads/ListOfLoads.h"
#include "Materials/CalculationInputVariables.h"

class StaticMechanicalAlgorithm;

/**
 * @class StaticMechanicalContext
 * @brief Context around static mechanical algorithm
 * @author Nicolas Sellenet
 */
class StaticMechanicalContext {
  private:
    /** @brief Problème discret */
    DiscreteProblemPtr _discreteProblem;
    /** @brief Solveur linéaire */
    BaseLinearSolverPtr _linearSolver;
    /** @brief Sd de stockage des résultats */
    ResultsContainerPtr _results;
    /** @brief Chargements */
    ListOfLoadsPtr _listOfLoads;
    /** @brief Pas de temps courant */
    double _time;
    /** @brief rank */
    int _rank;
    /** @brief Assembly matrix */
    AssemblyMatrixDisplacementDoublePtr _aMatrix;
    /** @brief Are elastic properties constant */
    bool _isConst;
    /** @brief Input variables */
    CalculationInputVariablesPtr _varCom;

  public:
    /**
     * @brief Constructeur
     * @param DiscreteProblemPtr Problème discret a résoudre par l'algo
     * @param BaseLinearSolverPtr Sovleur linéaire qui sera utilisé
     * @param ResultContainerPtr Résultat pour le stockage des déplacements
     */
    StaticMechanicalContext( const DiscreteProblemPtr &curPb, const BaseLinearSolverPtr linSolv,
                             const ResultsContainerPtr container )
        : _discreteProblem( curPb ), _linearSolver( linSolv ),
          _listOfLoads( _discreteProblem->getStudyDescription()->getListOfLoads() ),
          _results( container ), _time( 0. ), _rank( 1 ),
          _aMatrix( new AssemblyMatrixDisplacementDoubleInstance( Temporary ) ),
          _isConst( _discreteProblem->getStudyDescription()->getCodedMaterial()->constant() ),
          _varCom( new CalculationInputVariablesInstance(
              _discreteProblem->getStudyDescription()->getModel(),
              _discreteProblem->getStudyDescription()->getMaterialOnMesh(),
              _discreteProblem->getStudyDescription()->getElementaryCharacteristics(),
              _discreteProblem->getStudyDescription()->getCodedMaterial() ) ){};

    /**
     * @brief Function to set the "position" of the context
     * @param time time value
     * @param rank number of iteration
     */
    void setStep( const double &time, const int &rank ) {
        _time = time;
        _rank = rank;
    };

    friend class StaticMechanicalAlgorithm;
};

#endif /* STATICMECHANICCONTEXT_H_ */
