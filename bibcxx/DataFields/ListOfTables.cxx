/**
 * @file ListOfTables.cxx
 * @brief Implementation de ListOfTables
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

#include "aster_fort_jeveux.h"

#include "DataFields/ListOfTables.h"
#include "Utilities/Tools.h"


ListOfTablesClass::ListOfTablesClass( const std::string &name ) : _name( name ) {
    _name.resize( 19, ' ' );
    _dsId = JeveuxVectorChar16( _name + ".LTNT" );
    _dsName = JeveuxVectorChar24( _name + ".LTNS" );
}

bool ListOfTablesClass::update_tables() {
    CALL_JEMARQ();

    if ( ! _dsId->updateValuePointer() || ! _dsName->updateValuePointer() ) {
        CALL_JEDEMA();
        return false;
    }

    const int size = _dsId->usedSize();
    for ( int i = 0; i < size; i++ ) {
        const auto id = trim( ( *_dsId )[i].toString() );
        const auto name = trim( ( *_dsName )[i].toString() );
        if ( id == "" )
            continue;
        if ( _mapTables[id] == nullptr )
            _mapTables[id] = TablePtr( new TableClass( name ) );
    }
    // todo: remove previously registered and not yet available

    CALL_JEDEMA();
    return true;
}

TablePtr ListOfTablesClass::getTable( const std::string id ) {
    this->update_tables();
    const auto id_ = trim ( id );
    const auto curIter = _mapTables.find( id_ );
    if ( curIter == _mapTables.end() )
        return TablePtr( nullptr );
    return curIter->second;
}
