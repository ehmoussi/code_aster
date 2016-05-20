#ifndef LINESEARCHMETHOD_H_
#define LINESEARCHMETHOD_H_

/**
 * @file LineSearchMethod.h
 * @brief Definition of the linesearch method 
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

#include "LinearAlgebra/SolverControl.h"
#include "Utilities/GenericParameter.h"  

enum LineSearchEnum { Corde, Mixte, Pilotage };
const int nbLineSearch = 4;
extern const char* LineSearchNames[nbLineSearch];

class LineSearchMethodInstance
{
    private:
        /** @brief LineSearch Method */
        LineSearchEnum _lineSearchMethod; 
        /** @brief Contrôle de la convergence de la méthode  */
        SolverControlPtr _control;
        /** LineSearch method name */
        GenParam _methode;
        /** Intervalle de recherche de rho */ 
        GenParam _rhoMin ;
        GenParam _rhoMax ; 
        GenParam _rhoExcl ; 
        /** Control */
        GenParam _resi_line_rela;
        GenParam _iter_line_maxi; 
        
        ListGenParam _listOfParameters;
    public:
        /**
         * @brief Constructeur
         */
        LineSearchMethodInstance(  LineSearchEnum curLineSearch = Corde ):
            _lineSearchMethod ( curLineSearch ), 
            _control ( SolverControlPtr( new SolverControlInstance())), 
            _methode( "METHODE", false),
            _rhoMin( "RHO_MIN", false ),
            _rhoMax( "RHO_MAX", false ),
            _rhoExcl("RHO_EXCL", false ), 
            _resi_line_rela( "RESI_LINE_RELA", false ), 
            _iter_line_maxi( "ITER_LINE_MAXI", false )
        {
            _control->setRelativeTolerance( 1.e-1 );   
            _control->setMaximumNumberOfIterations( 3 );

            _methode = std::string( LineSearchNames[ (int)curLineSearch ] );
            _rhoMin = 1.e-2;
            _rhoMax = 1.e1;
            _rhoExcl = 9.e-3; 
            
            _resi_line_rela = _control->getRelativeTolerance();
            _iter_line_maxi = _control->getMaximumNumberOfIterations();
            
            _listOfParameters.push_back( &_methode );
            _listOfParameters.push_back( &_rhoMin );
            _listOfParameters.push_back( &_rhoMax );
            _listOfParameters.push_back( &_rhoExcl );
            _listOfParameters.push_back( &_resi_line_rela );
            _listOfParameters.push_back( &_iter_line_maxi ); 
        };
        
        void setMinimumRhoValue( double rhoMin )
        {
            _rhoMin = rhoMin ;
        }; 
        void setMaximumRhoValue( double rhoMax )
        {
            _rhoMax = rhoMax ;
        }; 
        void setExclRhoValue( double rhoExcl )
        {
            _rhoExcl = rhoExcl;
        };
        void setMaximumNumberOfIterations( int nIterMax )
        {
            _iter_line_maxi = nIterMax;
            _control->setMaximumNumberOfIterations( nIterMax );
        };
        void setRelativeTolerance( double reslin )
        {
            _resi_line_rela = reslin ; 
            _control->setRelativeTolerance( reslin );
        };
        /**
         * @brief Récupération de la liste des paramètres
         * @return Liste constante des paramètres déclarés
         */
        const ListGenParam&  getListOfParameters()
        {
            return _listOfParameters;
        };
};

/**
 * @typedef NonLinearMethodPtr
 * @brief Enveloppe d'un pointeur intelligent vers un LineSearchMethodInstance
 */
typedef boost::shared_ptr< LineSearchMethodInstance > LineSearchMethodPtr;

#endif /* LINESEARCHMETHOD_H_ */
