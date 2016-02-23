/**
 * @file TimeStepper.cxx
 * @brief Implementation de TimeStepper
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2015  EDF R&D                www.code-aster.org
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

#include "Algorithms/TimeStepper.h"

/* person_in_charge: nicolas.sellenet at edf.fr */

bool TimeStepperInstance::setValues( const VectorDouble& values ) throw ( std::runtime_error )
{
    if( _values->isAllocated() )
        _values->deallocate();

//     _values->allocate( getMemoryType(), values.size() + 1 );
    _values->allocate( getMemoryType(), values.size() );
    if ( ! _values->updateValuePointer() )
        throw std::runtime_error( "Unable to update pointers of TimeStepperInstance" );

    int compteur = 0;
    double save = 0.;
    for( VectorDoubleCIter tmp = values.begin();
            tmp != values.end();
            ++tmp )
    {
        ( *_values )[ compteur ] = *tmp;
        const double& curVal = *tmp;
        if ( compteur != 0 && save >= curVal )
            throw std::runtime_error( "Time function not strictly increasing" );
        save = *tmp;
        ++compteur;
    }
//     ( *_values )[ compteur ] = -9999.;
    return true;
};
