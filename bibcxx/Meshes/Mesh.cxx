/**
 * @file Mesh.cxx
 * @brief Implementation de BaseMeshClass
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

// emulate_LIRE_MAILLAGE_MED.h is auto-generated and requires Mesh.h and Python.h
#include "Meshes/Mesh.h"
#include "Python.h"
#include "PythonBindings/LogicalUnitManager.h"
#include "Supervis/CommandSyntax.h"
#include "Supervis/Exceptions.h"
#include "Supervis/ResultNaming.h"
#include "Utilities/CapyConvertibleValue.h"
#include "Utilities/Tools.h"

int BaseMeshClass::getNumberOfNodes() const {
    if ( isEmpty() )
        return 0;
    if ( !_dimensionInformations->updateValuePointer() )
        return 0;
    return ( *_dimensionInformations )[0];
}

int BaseMeshClass::getNumberOfCells() const {
    if ( isEmpty() )
        return 0;
    if ( !_dimensionInformations->updateValuePointer() )
        return 0;
    return ( *_dimensionInformations )[2];
}

int BaseMeshClass::getDimension() const {
    if ( isEmpty() )
        return 0;
    if ( !_dimensionInformations->updateValuePointer() )
        return 0;

    const int dimGeom = ( *_dimensionInformations )[5];

    if ( dimGeom == 3 ) {
        const std::string typeco( "MAILLAGE" );
        ASTERINTEGER repi = 0, ier = 0;
        JeveuxChar32 repk( " " );
        const std::string arret( "F" );
        const std::string questi( "DIM_GEOM" );

        CALLO_DISMOI( questi, getName(), typeco, &repi, repk, arret, &ier );

        return repi;
    }
    return dimGeom;
}

bool BaseMeshClass::readMeshFile( const std::string &fileName, const std::string &format ) {
    FileType type = Ascii;
    if ( format == "MED" )
        type = Binary;
    LogicalUnitFile file1( fileName, type, Old );

    SyntaxMapContainer syntax;

    if ( format == "GIBI" || format == "GMSH" ) {
        // Fichier temporaire
        LogicalUnitFile file2( "", Ascii, New );
        std::string preCmd = "PRE_" + format;
        ASTERINTEGER op2 = 47;
        if ( format == "GIBI" )
            op2 = 49;

        CommandSyntax *cmdSt2 = new CommandSyntax( preCmd );
        SyntaxMapContainer syntax2;
        syntax2.container["UNITE_" + format] = file1.getLogicalUnit();
        syntax2.container["UNITE_MAILLAGE"] = file2.getLogicalUnit();
        cmdSt2->define( syntax2 );

        try {
            CALL_EXECOP( &op2 );
        } catch ( ... ) {
            throw;
        }
        delete cmdSt2;
        syntax.container["FORMAT"] = "ASTER";
        syntax.container["UNITE"] = file2.getLogicalUnit();

        CommandSyntax cmdSt( "LIRE_MAILLAGE" );
        cmdSt.setResult( ResultNaming::getCurrentName(), "MAILLAGE" );

        cmdSt.define( syntax );

        try {
            ASTERINTEGER op = 1;
            CALL_EXECOP( &op );
        } catch ( ... ) {
            throw;
        }
    } else {
        syntax.container["FORMAT"] = format;
        syntax.container["UNITE"] = file1.getLogicalUnit();

        CommandSyntax cmdSt( "LIRE_MAILLAGE" );
        cmdSt.setResult( ResultNaming::getCurrentName(), "MAILLAGE" );

        cmdSt.define( syntax );

        ASTERINTEGER op = 1;
        CALL_EXECOP( &op );
    }

    return true;
}

bool BaseMeshClass::readMedFile( const std::string &fileName ) {
    readMeshFile( fileName, "MED" );

    return true;
}

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

bool MeshClass::hasGroupOfCells( const std::string &name ) const {
    if ( _groupsOfCells->size() < 0 && !_groupsOfCells->buildFromJeveux() ) {
        return false;
    }
    return _groupsOfCells->existsObject( name );
}

bool MeshClass::hasGroupOfNodes( const std::string &name ) const {
    if ( _groupsOfNodes->size() < 0 && !_groupsOfNodes->buildFromJeveux() ) {
        return false;
    }
    return _groupsOfNodes->existsObject( name );
}

VectorString MeshClass::getGroupsOfCells() const {
    ASTERINTEGER size = _nameOfGrpCells->size();
    VectorString names;
    for ( int i = 0; i < size; i++ ) {
        names.push_back( trim( _nameOfGrpCells->getStringFromIndex( i + 1 ) ) );
    }
    return names;
}

VectorString MeshClass::getGroupsOfNodes() const {
    ASTERINTEGER size = _nameOfGrpNodes->size();
    VectorString names;
    for ( int i = 0; i < size; i++ ) {
        names.push_back( trim( _nameOfGrpNodes->getStringFromIndex( i + 1 ) ) );
    }
    return names;
}

const VectorLong MeshClass::getCells( const std::string name ) const {
    if ( !hasGroupOfCells( name ) ) {
        return VectorLong();
    }
    return _groupsOfCells->getObjectFromName( name ).toVector();
}

const VectorLong MeshClass::getNodes( const std::string name ) const {
    if ( !hasGroupOfNodes( name ) ) {
        return VectorLong();
    }
    return _groupsOfNodes->getObjectFromName( name ).toVector();
}
