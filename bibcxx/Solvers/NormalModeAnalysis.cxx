/**
 * @file NormalModeAnalysis.cxx
 * @brief Fichier source contenant le source du solveur de calcul de modes propres
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

/* person_in_charge: nicolas.sellenet at edf.fr */

#include "Solvers/NormalModeAnalysis.h"

MechanicalModeContainerPtr NormalModeAnalysisInstance::execute()
{
    MechanicalModeContainerPtr result( new MechanicalModeContainerInstance() );

    CommandSyntaxCython cmdSt( "MODE_ITER_SIMULT" );
    cmdSt.setResult( result->getName(), result->getType() );

    CapyConvertibleSyntax syntax;
    syntax.setSimpleKeywordValues( _container );
    syntax.addCapyConvertibleContainer( _containerCalcFreq );

    SyntaxMapContainer test = syntax.toSyntaxMapContainer();
    cmdSt.define( test );

    try
    {
        ASTERINTEGER op = 45;
        CALL_EXECOP( &op );
    }
    catch( ... )
    {
        throw;
    }
    return result;
};
