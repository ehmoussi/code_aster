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

#include "aster_fort.h"

#include "DataStructures/DataStructure.h"
#include "MemoryManager/JeveuxString.h"
#include "DataStructures/TemporaryDataStructureName.h"
#include "Utilities/Tools.h"

TemporaryDataStructure tempName = TemporaryDataStructure();

DataStructure::DataStructure( const std::string name, const int nameLength,
                              const std::string type, const JeveuxMemory memType ):
    _name( name ),
    _memoryType( memType )
{
    _name.resize(nameLength, ' ');

    std::string name19( _name );
    name19.resize(19, ' ');
    _tco = JeveuxVectorChar24( name19 + "._TCO" );
    if ( ! _tco->isAllocated() ) {
        _tco->allocate( _memoryType, 1 );
        std::cout << "settco: '" << name19 + "._TCO" << "', type: '" << type << "'" << std::endl;
        (*_tco)[0] = type;
    }
}

DataStructure::DataStructure( const std::string type,
                              const JeveuxMemory memType, int nameLength ):
    DataStructure::DataStructure( DataStructureNaming::getNewName( memType, nameLength ),
                                  nameLength, type, memType )
{
}

DataStructure::~DataStructure()// throw ( std::runtime_error )
{
#ifdef __DEBUG_GC__
    std::cout << "DataStructure.destr: " << this->getName() << std::endl;
#endif
    std::string nameWithoutBlanks = trim( _name );
    if ( nameWithoutBlanks == "" || _memoryType == Temporary )
        return;
#ifdef _DEBUG_CXX
    std::string base( " " );
    long pos = 0;
    long nbval2 = 0;
    long retour = 0;
    JeveuxChar24 nothing( " " );
    CALLO_JELSTC( base, nameWithoutBlanks, &pos,
                  &nbval2, nothing, &retour );
    if ( nbval2 != 0 )
        throw std::runtime_error( "Remaining jeveux objects in " + _name );
#endif
};

void DataStructure::debugPrint( int logicalUnit ) const
{
    ASTERINTEGER unit, niveau, ipos, True, False;
    unit = ASTERINTEGER( logicalUnit );
    niveau = 2;
    True = 1;
    False = 0;
    ipos = 1;
    JeveuxString< 1 > base( " " );
    JeveuxString< 3 > no( "NON" );
    try {
        CALLO_UTIMSD( &unit, &niveau, &False, &True, this->getName(),
                      &ipos, base, no );
    }
    catch (...)
    {
        throw std::runtime_error( "debugPrint failed!" );
    }
};
