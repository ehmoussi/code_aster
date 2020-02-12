/**
 * @file MaterialOnMesh.cxx
 * @brief Implementation de MaterialOnMesh
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

#include <stdexcept>
#include <typeinfo>
#include "astercxx.h"

#include "Materials/MaterialOnMesh.h"
#include "Utilities/SyntaxDictionary.h"
#include "Supervis/CommandSyntax.h"

#include "Materials/MaterialOnMeshBuilder.h"

MaterialOnMeshClass::MaterialOnMeshClass( const std::string &name,
                                                const MeshPtr& mesh ):
    _mesh( mesh ),
    _model( nullptr ),
    DataStructure( name, 8, "CHAM_MATER" ),
    _listOfMaterials( PCFieldOnMeshChar8Ptr(
        new PCFieldOnMeshChar8Class( getName() + ".CHAMP_MAT ", mesh ) ) ),
    _listOfTemperatures( PCFieldOnMeshRealPtr(
        new PCFieldOnMeshRealClass( getName() + ".TEMPE_REF ", mesh ) ) ),
    _behaviourField( PCFieldOnMeshRealPtr(
        new PCFieldOnMeshRealClass( getName() + ".COMPOR ", mesh ) ) ),
    _cvrcNom( JeveuxVectorChar8( getName() + ".CVRCNOM" ) ),
    _cvrcGd( JeveuxVectorChar8( getName() + ".CVRCGD" ) ),
    _cvrcVarc( JeveuxVectorChar8( getName() + ".CVRCVARC" ) ),
    _cvrcCmp( JeveuxVectorChar8( getName() + ".CVRCCMP" ) )
{};

MaterialOnMeshClass::MaterialOnMeshClass( const std::string &name,
                                                const SkeletonPtr& mesh ):
    _mesh( mesh ),
    _model( nullptr ),
    DataStructure( name, 8, "CHAM_MATER" ),
    _listOfMaterials( PCFieldOnMeshChar8Ptr(
        new PCFieldOnMeshChar8Class( getName() + ".CHAMP_MAT ", mesh ) ) ),
    _listOfTemperatures( PCFieldOnMeshRealPtr(
        new PCFieldOnMeshRealClass( getName() + ".TEMPE_REF ", mesh ) ) ),
    _behaviourField( PCFieldOnMeshRealPtr(
        new PCFieldOnMeshRealClass( getName() + ".COMPOR ", mesh ) ) ),
    _cvrcNom( JeveuxVectorChar8( getName() + ".CVRCNOM" ) ),
    _cvrcGd( JeveuxVectorChar8( getName() + ".CVRCGD" ) ),
    _cvrcVarc( JeveuxVectorChar8( getName() + ".CVRCVARC" ) ),
    _cvrcCmp( JeveuxVectorChar8( getName() + ".CVRCCMP" ) )
{};

#ifdef _USE_MPI
MaterialOnMeshClass::MaterialOnMeshClass( const std::string &name,
                                                const ParallelMeshPtr& mesh ):
    _mesh( mesh ),
    _model( nullptr ),
    DataStructure( name, 8, "CHAM_MATER" ),
    _listOfMaterials( PCFieldOnMeshChar8Ptr(
        new PCFieldOnMeshChar8Class( getName() + ".CHAMP_MAT ", mesh ) ) ),
    _listOfTemperatures( PCFieldOnMeshRealPtr(
        new PCFieldOnMeshRealClass( getName() + ".TEMPE_REF ", mesh ) ) ),
    _behaviourField( PCFieldOnMeshRealPtr(
        new PCFieldOnMeshRealClass( getName() + ".COMPOR ", mesh ) ) ),
    _cvrcNom( JeveuxVectorChar8( getName() + ".CVRCNOM" ) ),
    _cvrcGd( JeveuxVectorChar8( getName() + ".CVRCGD" ) ),
    _cvrcVarc( JeveuxVectorChar8( getName() + ".CVRCVARC" ) ),
    _cvrcCmp( JeveuxVectorChar8( getName() + ".CVRCCMP" ) )
{};
#endif /* _USE_MPI */

bool MaterialOnMeshClass::buildWithoutExternalVariable()
{
    MaterialOnMeshBuilderClass::buildClass(*this);

    return true;
};

std::vector< MaterialPtr > MaterialOnMeshClass::getVectorOfMaterial() const
{
    std::vector< MaterialPtr > toReturn;
    for( const auto& curIter : _materialsOnMeshEntity )
        for( const auto& curIter2 : curIter.first )
            toReturn.push_back( curIter2 );
    return toReturn;
};

std::vector< PartOfMaterialOnMeshPtr >
MaterialOnMeshClass::getVectorOfPartOfMaterialOnMesh() const
{
    std::vector< PartOfMaterialOnMeshPtr > toReturn;
    for( const auto& curIter : _materialsOnMeshEntity )
    {
        PartOfMaterialOnMeshPtr toPush( new PartOfMaterialOnMeshClass( curIter.first,
                                                                          curIter.second ) );
        toReturn.push_back( toPush );
    }
    return toReturn;
};

bool MaterialOnMeshClass::existsCalculationExternalVariable( const std::string& name )
{
    if( _cvrcVarc->exists() )
    {
        _cvrcVarc->updateValuePointer();
        JeveuxChar8 toTest( name );
        auto size = _cvrcVarc->size();
        for( int i = 0; i < size; ++i )
        {
            if( (*_cvrcVarc)[i] == toTest )
                return true;
        }
    }

    return false;
};
