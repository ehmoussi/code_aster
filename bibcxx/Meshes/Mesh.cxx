/**
 * @file Mesh.cxx
 * @brief Implementation de BaseMeshInstance
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

/* person_in_charge: nicolas.sellenet at edf.fr */

#include "astercxx.h"

// emulate_LIRE_MAILLAGE_MED.h is auto-generated and requires Mesh.h and Python.h
#include "Python.h"
#include "Meshes/Mesh.h"
#include "Utilities/CapyConvertibleValue.h"
#include "RunManager/CommandSyntaxCython.h"
#include "RunManager/LogicalUnitManagerCython.h"

BaseMeshInstance::BaseMeshInstance( const std::string& type ):
                        DataStructure( getNewResultObjectName(), type ),
                        _dimensionInformations( JeveuxVectorLong( getName() + ".DIME      " ) ),
                        _nameOfNodes( JeveuxBidirectionalMap( getName() + ".NOMNOE    " ) ),
                        _coordinates( new MeshCoordinatesFieldInstance( getName() + ".COORDO    " ) ),
                        _groupsOfNodes( JeveuxCollectionLong( getName() + ".GROUPENO  " ) ),
                        _connectivity( JeveuxCollectionLong( getName() + ".CONNEX    " ) ),
                        _nameOfElements( JeveuxBidirectionalMap( getName() + ".NOMMAI    " ) ),
                        _elementsType( JeveuxVectorLong( getName() + ".TYPMAIL   " ) ),
                        _groupsOfElements( JeveuxCollectionLong( getName() + ".GROUPEMA  " ) ),
                        _isEmpty( true )
{
    assert(getName().size() == 8);
};

bool MeshInstance::addGroupOfNodesFromNodes( const std::string& name, const VectorString& vec )
    throw( std::runtime_error )
{
    CommandSyntaxCython cmdSt( "DEFI_GROUP" );
    cmdSt.setResult( getResultObjectName(), "MAILLAGE" );

    CapyConvertibleContainer toCapyConverter;
    toCapyConverter.add( new CapyConvertibleValue< std::string >
                                ( false, "MAILLAGE", getName(), true ) );

    CapyConvertibleContainer toCapyConverter2( "CREA_GROUP_NO" );
    toCapyConverter2.add( new CapyConvertibleValue< VectorString >
                                ( false, "NOEUD", vec, true ) );
    toCapyConverter2.add( new CapyConvertibleValue< std::string >
                                ( false, "NOM", name, true ) );

    CapyConvertibleSyntax syntax;
    syntax.setSimpleKeywordValues( toCapyConverter );
    syntax.addCapyConvertibleContainer( toCapyConverter2 );

    cmdSt.define( syntax );
    try
    {
        ASTERINTEGER op = 104;
        CALL_EXECOP( &op );
    }
    catch( ... )
    {
        throw;
    }
    return true;
};

bool BaseMeshInstance::readMeshFile( const std::string& fileName, const std::string& format )
    throw ( std::runtime_error )
{
    LogicalUnitFileCython file1( fileName, Binary, Old );

    CommandSyntaxCython cmdSt( "LIRE_MAILLAGE" );
    cmdSt.setResult( getResultObjectName(), "MAILLAGE" );

    SyntaxMapContainer syntax;
    syntax.container[ "FORMAT" ] = format;

    if( format == "GIBI" || format == "GMSH" )
    {
        const std::string tmpFileName = getTemporaryFileName( "." );
        // Fichier temporaire
        LogicalUnitFileCython file2( tmpFileName, Binary, New );
        std::string preCmd = "PRE_" + format;
        ASTERINTEGER op2 = 47;
        if( format == "GIBI" ) op2 = 49;

        CommandSyntaxCython cmdSt2( preCmd );
        SyntaxMapContainer syntax2;
        syntax2.container[ "UNITE_" + format ] = file1.getLogicalUnit();
        syntax2.container[ "UNITE_MAILLAGE" ] = file2.getLogicalUnit();
        cmdSt2.define( syntax2 );

        try
        {
            CALL_EXECOP( &op2 );
        }
        catch( ... )
        {
            throw;
        }
        syntax.container[ "UNITE" ] = file2.getLogicalUnit();
    }
    else
    {
        syntax.container[ "UNITE" ] = file1.getLogicalUnit();
    }

    cmdSt.define( syntax );

    try
    {
        ASTERINTEGER op = 1;
        CALL_EXECOP( &op );
    }
    catch( ... )
    {
        throw;
    }
    _isEmpty = false;

    return true;
};

bool MeshInstance::readAsterMeshFile( const std::string& fileName )
    throw ( std::runtime_error )
{
    readMeshFile( fileName, "ASTER" );

    return true;
};

bool MeshInstance::readGibiFile( const std::string& fileName )
    throw ( std::runtime_error )
{
    readMeshFile( fileName, "GIBI" );

    return true;
};

bool MeshInstance::readGmshFile( const std::string& fileName )
    throw ( std::runtime_error )
{
    readMeshFile( fileName, "GMSH" );

    return true;
};

bool BaseMeshInstance::readMedFile( const std::string& fileName )
    throw ( std::runtime_error )
{
    readMeshFile( fileName, "MED" );

    return true;
};
