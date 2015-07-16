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
#include "Utilities/SyntaxDictionary.h"


class LineSearchMethodInstance
{
    private:
        /** @brief Name of the linesearch method */
        std::string _name; 
        /** @brief Contrôle de la convergence de la méthode  */
        SolverControlPtr _control;
        /** Intervalle de recherche de rho */ 
        double _rhoMin ;
        double _rhoMax ; 
        double _rhoExcl ; 
    public:
        /**
         * @brief Constructeur
         */
        LineSearchMethodInstance( std::string name="CORDE", double rTol = 1.e-1, int nIterMax=3, double rhoMin=1.e-2, 
            double rhoMax=1.e1, double rhoExcl=9.e-3 ): _name(name), 
            _control( SolverControlPtr( new SolverControlInstance( rTol, nIterMax ))),
            _rhoMin(rhoMin), _rhoMax(rhoMax), _rhoExcl(rhoExcl)
            {};

        std::string getName() const
        {
            return _name; 
        }
        ListSyntaxMapContainer buildListLineSearch() throw ( std::runtime_error ); 
};

/**
 * @typedef NonLinearMethodPtr
 * @brief Enveloppe d'un pointeur intelligent vers un LineSearchMethodInstance
 */
typedef boost::shared_ptr< LineSearchMethodInstance > LineSearchMethodPtr;

#endif /* LINESEARCHMETHOD_H_ */
