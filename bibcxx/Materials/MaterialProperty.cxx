/**
 * @file MaterialProperty.cxx
 * @brief Implementation de GenericMaterialPropertyClass
 * @author Nicolas Sellenet
 * @todo autoriser le type Function pour les paramètres matériau
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

/* person_in_charge: nicolas.sellenet at edf.fr */
#include "astercxx.h"

#include "aster_fort_material.h"
#include <stdexcept>
#include "Materials/MaterialProperty.h"
#include "Materials/BaseMaterialProperty.h"


bool MaterialPropertyClass::buildTractionFunction( FunctionPtr &doubleValues ) const
{
    if( this->hasTractionFunction( ))
    {
        ASTERINTEGER maxSize = 0, maxSize2 = 0;
        std::string resName;
        for ( auto curIter : _mapOfFunctionMaterialProperties ) {
            std::string nameOfProperty = curIter.second.getName();
            if ( curIter.second.hasValue() ) {
                const auto func = curIter.second.getValue();
                CALLO_RCSTOC_VERIF( func->getName(), nameOfProperty, _asterName, &maxSize2 );
                const auto size = func->maximumSize();
                if ( size > maxSize )
                    maxSize = size;
                resName = curIter.second.getValue()->getResultName();
            }
        }
        doubleValues->allocate( Permanent, maxSize );
        doubleValues->setParameterName( "EPSI" );
        doubleValues->setResultName( resName );
    }

    return true;
};
