/**
 * @file Mesh.cxx
 * @brief Implementation de MeshClass
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

/* person_in_charge: nicolas.sellenet at edf.fr */

#include "astercxx.h"

#include "Meshes/Mesh.h"
#include "Utilities/Tools.h"


bool MeshClass::readAsterFile( const std::string &fileName ) {
    readMeshFile( fileName, "ASTER" );
    return true;
}

bool MeshClass::readGibiFile( const std::string &fileName ) {
    readMeshFile( fileName, "GIBI" );
    return true;
}

bool MeshClass::readGmshFile( const std::string &fileName ) {
    readMeshFile( fileName, "GMSH" );
    return true;
}

bool MeshClass::hasGroupOfCells( const std::string &name, const bool local ) const {
    if ( _groupsOfCells->size() < 0 && !_groupsOfCells->buildFromJeveux() ) {
        return false;
    }
    return _groupsOfCells->existsObject( name );
}

bool MeshClass::hasGroupOfNodes( const std::string &name, const bool local ) const {
    if ( _groupsOfNodes->size() < 0 && !_groupsOfNodes->buildFromJeveux() ) {
        return false;
    }
    return _groupsOfNodes->existsObject( name );
}

VectorString MeshClass::getGroupsOfCells(const bool local) const {
    ASTERINTEGER size = _nameOfGrpCells->size();
    VectorString names;
    for ( int i = 0; i < size; i++ ) {
        names.push_back( trim( _nameOfGrpCells->getStringFromIndex( i + 1 ) ) );
    }
    return names;
}

VectorString MeshClass::getGroupsOfNodes(const bool local) const {
    ASTERINTEGER size = _nameOfGrpNodes->size();
    VectorString names;
    for ( int i = 0; i < size; i++ ) {
        names.push_back( trim( _nameOfGrpNodes->getStringFromIndex( i + 1 ) ) );
    }
    return names;
}

const VectorLong MeshClass::getCells( const std::string name ) const {

    if ( name.empty())
    {
        return irange(long(1), long(getNumberOfCells()));
    }
    else if ( !hasGroupOfCells( name ) ) {
        return VectorLong();
    }

    return _groupsOfCells->getObjectFromName( name ).toVector();
}

const VectorLong MeshClass::getNodes( const std::string name, const bool local,
                                      const bool same_rank) const {
    if ( name.empty())
    {
        return irange(long(1), long(getNumberOfNodes()));
    }
    else if ( !hasGroupOfNodes( name ) ) {
        return VectorLong();
    }
    return _groupsOfNodes->getObjectFromName( name ).toVector();
}
