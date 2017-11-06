/**
 * @file PhysicalQuantityManager.cxx
 * @brief Implementation de PhysicalQuantityManager
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2017  EDF R&D                www.code-aster.org
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

#include "Modeling/PhysicalQuantityManager.h"
#include "aster_fort.h"

PhysicalQuantityManager::PhysicalQuantityManager():
    _nameOfCmp( JeveuxCollectionChar8( "&CATA.GD.NOMCMP" ) ),
    _nameOfPhysicalQuantity( JeveuxBidirectionalMapChar8( "&CATA.GD.NOMGD" ) )
{};

const JeveuxCollectionObjectChar8& PhysicalQuantityManager::getComponentNames
    ( const long& quantityNumber ) const
{
    _nameOfCmp->buildFromJeveux();
    return _nameOfCmp->getObject( quantityNumber );
};

long PhysicalQuantityManager::getNumberOfEncodedInteger( const long& quantityNumber ) const
{
    long toReturn = 0;
    toReturn = CALL_NBEC( &quantityNumber );
    return toReturn;
};

std::string PhysicalQuantityManager::getPhysicalQuantityName( const long& quantityNumber ) const
    throw( std::runtime_error )
{
    if( quantityNumber <= 0 || quantityNumber > _nameOfPhysicalQuantity->size() )
        throw std::runtime_error( "Not a known physical quantity" );
    return _nameOfPhysicalQuantity->findStringOfElement( quantityNumber );
};