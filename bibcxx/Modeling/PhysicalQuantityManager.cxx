/**
 * @file PhysicalQuantityManager.cxx
 * @brief Implementation de PhysicalQuantityManager
 * @author Nicolas Sellenet
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

#include "aster_fort_utils.h"
#include "Modeling/PhysicalQuantityManager.h"

PhysicalQuantityManager::PhysicalQuantityManager()
    : _nameOfCmp( JeveuxCollectionChar8( "&CATA.GD.NOMCMP" ) ),
      _nameOfPhysicalQuantity( NamesMapChar8( "&CATA.GD.NOMGD" ) ){};

const JeveuxCollectionObjectChar8 &
PhysicalQuantityManager::getComponentNames( const ASTERINTEGER &quantityNumber ) const {
    _nameOfCmp->buildFromJeveux();
    return _nameOfCmp->getObject( quantityNumber );
};

ASTERINTEGER
PhysicalQuantityManager::getNumberOfEncodedInteger( const ASTERINTEGER &quantityNumber ) const {
    ASTERINTEGER toReturn = 0;
    toReturn = CALL_NBEC( &quantityNumber );
    return toReturn;
};

std::string
PhysicalQuantityManager::getPhysicalQuantityName( const ASTERINTEGER &quantityNumber ) const
    {
    if ( quantityNumber <= 0 || quantityNumber > _nameOfPhysicalQuantity->size() )
        throw std::runtime_error( "Not a known physical quantity" );
    return _nameOfPhysicalQuantity->getStringFromIndex( quantityNumber );
};
