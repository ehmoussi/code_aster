/**
 * @file DataStructure.cxx
 * @brief Implementation des fonctions membres de DataStructure
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
#include <string>

#include "DataStructure/DataStructure.h"
#include "MemoryManager/JeveuxString.h"

mapStrSD mapNameDataStructure = mapStrSD();

DataStructure::DataStructure( std::string name, std::string type ): _name( name ), _type( type )
{
    mapNameDataStructure.insert( mapStrSDValue( _name, this ) );
};

DataStructure::~DataStructure() throw ( std::runtime_error )
{
#ifdef __DEBUG_GC__
    std::cout << "DataStructure.destr: " << this->getName() << std::endl;
#endif
    mapStrSDIterator curIter = mapNameDataStructure.find( _name );
    if ( curIter == mapNameDataStructure.end() )
        throw std::runtime_error( "Problem !!!" );
    mapNameDataStructure.erase( curIter );
};

void DataStructure::debugPrint( int logicalUnit ) const
{
    INTEGER unit, niveau, ipos, True, False;
    unit = INTEGER( logicalUnit );
    niveau = 2;
    True = 1;
    False = 0;
    ipos = 1;
    JeveuxString< 1 > base( "G" );
    JeveuxString< 3 > no( "NON" );
    try {
        CALL_UTIMSD( &unit, &niveau, &False, &True, this->getName().c_str(),
                     &ipos, base.c_str(), no.c_str() );
    }
    catch (...)
    {
        throw std::runtime_error( "debugPrint failed!" );
    }
};
