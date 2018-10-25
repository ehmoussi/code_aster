/**
 * @file MechanicalModeComplexContainer.cxx
 * @brief Implementation de MechanicalModeComplexContainer
 * @author Natacha Béreux
 * @section LICENCE
 *   Copyright (C) 1991 - 2018  EDF R&D                www.code-aster.org
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

#include "aster_fort.h"

#include "Results/MechanicalModeComplexContainer.h"
#include "Supervis/CommandSyntax.h"
#include "Utilities/Tools.h"

FieldOnNodesComplexPtr MechanicalModeComplexContainerInstance::getEmptyFieldOnNodesComplex(
    const std::string name, const int rank ) throw( std::runtime_error ) {
    const ASTERINTEGER nbRanks = getNumberOfRanks();
    if ( rank > nbRanks || rank <= 0 )
        throw std::runtime_error( "Order number out of range" );
    ASTERINTEGER retour;
    retour = 0;
    const ASTERINTEGER rankLong = rank;
    std::string null( " " );
    std::string returnName( 19, ' ' );
    CALLO_RSEXCH( null, getName(), name, &rankLong, returnName, &retour );
    CALLO_RSNOCH( getName(), name, &rankLong );
    std::string bis( returnName.c_str(), 19 );
    FieldOnNodesComplexPtr result( new FieldOnNodesComplexInstance( bis ) );

    auto curIter = _dictOfVectorOfComplexFieldsNodes.find( name );
    if ( curIter == _dictOfVectorOfComplexFieldsNodes.end() ) {
        _dictOfVectorOfComplexFieldsNodes[name] = VectorOfComplexFieldsNodes( nbRanks );
    }
    _dictOfVectorOfComplexFieldsNodes[name][rank - 1] = result;
    return result;
};

FieldOnNodesComplexPtr MechanicalModeComplexContainerInstance::getComplexFieldOnNodes(
    const std::string name, const int rank ) const throw( std::runtime_error ) {
    const ASTERINTEGER nbRanks = getNumberOfRanks();
    if ( rank > nbRanks || rank <= 0 )
        throw std::runtime_error( "Order number out of range" );

    auto curIter = _dictOfVectorOfComplexFieldsNodes.find( trim( name ) );
    if ( curIter == _dictOfVectorOfComplexFieldsNodes.end() )
        throw std::runtime_error( "Field " + name + " unknown in the results container" );

    FieldOnNodesComplexPtr toReturn = curIter->second[rank - 1];
    return toReturn;
};
