/**
 * @file LineSearchMethod.cxx
 * @brief Implementation of LineSearch 
 * @author Nicolas Sellenet
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

#include <stdexcept>
#include <typeinfo>
#include "astercxx.h"

#include "NonLinear/LineSearchMethod.h"


/* buildListLineSearch : construit la liste des mots-clés simples qui servent à définir RECH_LINEAIRE 
dans STAT_NON_LINE. C'est une méthode temporaire qui disparaîtra avec la réécriture d'op0070 */
ListSyntaxMapContainer LineSearchMethodInstance::buildListLineSearch() throw ( std::runtime_error )
{
    ListSyntaxMapContainer listLineSearch;
    SyntaxMapContainer dict2; 
    dict2.container["METHODE"] = _name;
    dict2.container["RESI_LINE_RELA"] = _control->getRelativeTol();
    dict2.container["ITER_LINE_MAXI"] = _control->getNIterMax();
    dict2.container["RHO_MIN"]= _rhoMin;
    dict2.container["RHO_MAX"]= _rhoMax;
    dict2.container["RHO_EXCL"]= _rhoExcl;
    listLineSearch.push_back( dict2 );
    return listLineSearch;
};


