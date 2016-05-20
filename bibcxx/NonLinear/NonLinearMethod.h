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

#include "Utilities/GenericParameter.h"  


enum NonLinearMethodEnum { Newton, Implex, NewtonKrylov };
const int nbMethod = 3;
extern const char* NonLinearMethodNames[nbMethod];

enum PredictionEnum { Tangente, Elastique, Extrapole, DeplCalcule };
const int nbPrediction = 4;
extern const char* PredictionNames[nbPrediction];

enum MatrixEnum { MatriceTangente, MatriceElastique };
const int nbMatrix = 2;
extern const char* MatrixNames[nbMatrix];

class NonLinearMethodInstance
{
    private:
        /** @brief Nonlinear method */
        NonLinearMethodEnum _nonLinearMethod;
        /** @brief Prediction method */
        PredictionEnum _pred;
        /** @brief Iteration Matrix */
        MatrixEnum _mat;
        // mot-clé simple METHODE 
        GenParam     _methode; 
        // mot-cle facteur NEWTON 
        GenParam     _prediction;
        // evol_noli 
        GenParam     _matr_rigi_syme;
        GenParam     _matrice;
        GenParam     _reac_incr;
        GenParam     _reac_iter;
        GenParam     _reac_iter_elas;
        GenParam     _pas_mini_elas;
        
        ListGenParam _listOfMethodParameters;
        ListGenParam _listOfNewtonParameters;
    public:
        /**
         * @brief Constructeur
         */
        NonLinearMethodInstance( const NonLinearMethodEnum curNLMethod = Newton): 
            _nonLinearMethod( curNLMethod ),
            _methode("METHODE", false), 
            _prediction( "PREDICTION", false), 
            _matr_rigi_syme("MATR_RIGI_SYME", false), 
            _matrice( "MATRICE", false),
            _reac_incr("REAC_INCR",false),
            _reac_iter("REAC_ITER", false),
            _reac_iter_elas("REAC_ITER_ELAS", false),
            _pas_mini_elas("PAS_MINI_ELAS", false)
        {
            _methode = std::string( NonLinearMethodNames[ (int)_nonLinearMethod ] );
            _listOfMethodParameters.push_back( &_methode );

            if ( ( _nonLinearMethod == Newton ) or (  _nonLinearMethod == NewtonKrylov ) )
                {
                _prediction = "TANGENTE";
                _matrice = "TANGENTE";
                _reac_incr = 1;
                _reac_iter = 0;
                _reac_iter_elas = 0;
                _pas_mini_elas = 0;
                _matr_rigi_syme = "NON"; 
                _listOfNewtonParameters.push_back( &_prediction );
                _listOfNewtonParameters.push_back( &_matrice );
                _listOfNewtonParameters.push_back( &_reac_incr );
                _listOfNewtonParameters.push_back( &_reac_iter );
                _listOfNewtonParameters.push_back( &_reac_iter_elas );
                _listOfNewtonParameters.push_back( &_pas_mini_elas );
                _listOfNewtonParameters.push_back( &_matr_rigi_syme );
                }
        };
        
        /**
        * @brief Define prediction method 
        */
        void setPrediction( PredictionEnum pred )
        {
          _pred = pred;
          _prediction = std::string( PredictionNames[ (int)_pred ] );
        };        
        
        /**
        * @brief Define which matrix is used for the Newton iterations 
        */
        void setMatrix( MatrixEnum matrix )
        {
          _mat = matrix;
          _matrice = std::string( MatrixNames[ (int)_mat ] );
        };  
        /**
        * @brief Force Symetry of the stiffness matrix during Newton iterations 
        */
        void forceStiffnessSymetry( bool force_symetry ) 
        {
            if ( force_symetry )
               _matr_rigi_syme = "OUI" ;
            else
               _matr_rigi_syme = "NON" ;
        };

        /**
        * @brief Récupération de la liste des paramètres de la methode non-lineaire
        * en fait il n'y a qu'un seul parametre (le nom de la methode)
        * @return Liste constante des paramètres déclarés
        */
        const ListGenParam&  getListOfMethodParameters()
        {
            return _listOfMethodParameters;
        };
        /**
        * @brief Récupération de la liste des paramètres du Newton
        * @return Liste constante des paramètres déclarés
        */
        const ListGenParam&  getListOfNewtonParameters()
        {
            return _listOfNewtonParameters;
        };
};

/**
 * @typedef NonLinearMethodPtr
 * @brief Enveloppe d'un pointeur intelligent vers un NonLinearMethodInstance
 */
typedef boost::shared_ptr< NonLinearMethodInstance > NonLinearMethodPtr;

#endif /* NONLINEARMETHOD_H_ */
