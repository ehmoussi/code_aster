/**
 * @file DataStructure.cxx
 * @brief Implementation des fonctions membres de DataStructure
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

#include <stdexcept>
#include <string>

#include "aster_fort.h"
#include "shared_vars.h"

#include "DataStructures/DataStructure.h"
#include "DataStructures/TemporaryDataStructureName.h"
#include "MemoryManager/JeveuxString.h"
#include "Utilities/Tools.h"

TemporaryDataStructure tempName = TemporaryDataStructure();

DataStructure::DataStructure( const std::string name, const int nameLength, const std::string type,
                              const JeveuxMemory memType )
    : _name( name ), _memoryType( memType ) {
    _name.resize( nameLength, ' ' );

    std::string name19( _name );
    name19.resize( 19, ' ' );
    _tco = JeveuxVectorChar24( name19 + "._TCO" );
    if ( !_tco->isAllocated() && name != "" ) {
        _tco->allocate( _memoryType, 1 );
        if ( type.size() <= 8 && type != "FORMULE" )
            ( *_tco )[0] = std::string( trim( type ) + "_SDASTER" );
        else
            ( *_tco )[0] = type;
    }
}

DataStructure::DataStructure( const std::string type, const JeveuxMemory memType, int nameLength )
    : DataStructure::DataStructure( DataStructureNaming::getNewName( memType, nameLength ),
                                    nameLength, type, memType ) {}

DataStructure::~DataStructure() {
// #ifdef _DEBUG_CXX
//     std::cout << "DEBUG: DataStructure.destr: " << this->getName() << std::endl;
// #endif
    std::string nameWithoutBlanks = trim( _name );
    // empty name or no memory manager : skip silently
    if ( nameWithoutBlanks == "" || get_sh_jeveux_status() != 1 )
        return;
#ifdef _DEBUG_CXX
    _tco->deallocate();
    std::string base( " " );
    ASTERINTEGER pos = 1;
    ASTERINTEGER nbval2 = 0;
    ASTERINTEGER retour = 0;
    JeveuxChar24 nothing( " " );
    if ( nameWithoutBlanks == "&2" ) {
        retour = 1;
    }
    CALLO_JELSTC( base, nameWithoutBlanks, &pos, &nbval2, nothing, &retour );
    if ( retour != 0 ) {
        JeveuxVectorChar24 test( "&&TMP" );
        test->allocate( Temporary, -retour );
        ASTERINTEGER nbval2 = -retour;
        CALLO_JELSTC( base, nameWithoutBlanks, &pos, &nbval2, ( *test )[0], &retour );
        std::cout << "DEBUG: Remaining jeveux objects in " << _name << std::endl;
        std::cout << "DEBUG: List of objects:" << std::endl;
        for ( int i = 0; i < retour; ++i )
            std::cout << "DEBUG:   - " << ( *test )[i].toString() << std::endl;
    }
#endif
};

void DataStructure::addDependency( const DataStructurePtr &ds ) {
    _depsVector.push_back( ds );
}

std::vector< DataStructure::DataStructurePtr > DataStructure::getDependencies() const {
    return _depsVector;
}

void DataStructure::debugPrint( int logicalUnit ) const {
    ASTERINTEGER unit, niveau, ipos, True, False;
    unit = ASTERINTEGER( logicalUnit );
    niveau = 2;
    True = 1;
    False = 0;
    ipos = 1;
    JeveuxString< 1 > base( " " );
    JeveuxString< 3 > no( "NON" );
    std::string nameWithoutBlanks = trim( _name );
    try {
        CALLO_UTIMSD( &unit, &niveau, &False, &True, nameWithoutBlanks, &ipos, base, no );
    } catch ( ... ) {
        throw std::runtime_error( "debugPrint failed!" );
    }
};

void DataStructure::setType( const std::string newType ) {
    _tco->updateValuePointer();
    if ( newType.size() <= 8 && newType != "FORMULE" )
        ( *_tco )[0] = std::string( trim( newType ) + "_SDASTER" );
    else
        ( *_tco )[0] = newType;
};

void DataStructure::setUserName( const std::string name ) { _user_name = name; }
