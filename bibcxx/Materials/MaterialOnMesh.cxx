/**
 * @file MaterialOnMesh.cxx
 * @brief Implementation de MaterialOnMesh
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2018  EDF R&D                www.code-aster.org
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

#include <stdexcept>
#include <typeinfo>
#include "astercxx.h"

#include "Materials/MaterialOnMesh.h"
#include "Utilities/SyntaxDictionary.h"
#include "Supervis/CommandSyntax.h"

#include "Materials/MaterialOnMeshBuilder.h"

MaterialOnMeshInstance::MaterialOnMeshInstance( const std::string &name,
                                                const MeshPtr& mesh ):
    _supportMesh( mesh ),
    DataStructure( name, 8, "CHAM_MATER" ),
    _listOfMaterials( PCFieldOnMeshChar8Ptr(
        new PCFieldOnMeshChar8Instance( getName() + ".CHAMP_MAT ", mesh ) ) ),
    _listOfTemperatures( PCFieldOnMeshDoublePtr(
        new PCFieldOnMeshDoubleInstance( getName() + ".TEMPE_REF ", mesh ) ) ),
    _behaviourField( PCFieldOnMeshDoublePtr(
        new PCFieldOnMeshDoubleInstance( getName() + ".COMPOR ", mesh ) ) ),
    _cvrcNom( JeveuxVectorChar8( getName() + ".CVRCNOM" ) ),
    _cvrcGd( JeveuxVectorChar8( getName() + ".CVRCGD" ) ),
    _cvrcVarc( JeveuxVectorChar8( getName() + ".CVRCVARC" ) ),
    _cvrcCmp( JeveuxVectorChar8( getName() + ".CVRCCMP" ) )
{};

MaterialOnMeshInstance::MaterialOnMeshInstance( const std::string &name,
                                                const SkeletonPtr& mesh ):
    _supportMesh( mesh ),
    DataStructure( name, 8, "CHAM_MATER" ),
    _listOfMaterials( PCFieldOnMeshChar8Ptr(
        new PCFieldOnMeshChar8Instance( getName() + ".CHAMP_MAT ", mesh ) ) ),
    _listOfTemperatures( PCFieldOnMeshDoublePtr(
        new PCFieldOnMeshDoubleInstance( getName() + ".TEMPE_REF ", mesh ) ) ),
    _behaviourField( PCFieldOnMeshDoublePtr(
        new PCFieldOnMeshDoubleInstance( getName() + ".COMPOR ", mesh ) ) ),
    _cvrcNom( JeveuxVectorChar8( getName() + ".CVRCNOM" ) ),
    _cvrcGd( JeveuxVectorChar8( getName() + ".CVRCGD" ) ),
    _cvrcVarc( JeveuxVectorChar8( getName() + ".CVRCVARC" ) ),
    _cvrcCmp( JeveuxVectorChar8( getName() + ".CVRCCMP" ) )
{};

#ifdef _USE_MPI
MaterialOnMeshInstance::MaterialOnMeshInstance( const std::string &name,
                                                const ParallelMeshPtr& mesh ):
    _supportMesh( mesh ),
    DataStructure( name, 8, "CHAM_MATER" ),
    _listOfMaterials( PCFieldOnMeshChar8Ptr(
        new PCFieldOnMeshChar8Instance( getName() + ".CHAMP_MAT ", mesh ) ) ),
    _listOfTemperatures( PCFieldOnMeshDoublePtr(
        new PCFieldOnMeshDoubleInstance( getName() + ".TEMPE_REF ", mesh ) ) ),
    _behaviourField( PCFieldOnMeshDoublePtr(
        new PCFieldOnMeshDoubleInstance( getName() + ".COMPOR ", mesh ) ) ),
    _cvrcNom( JeveuxVectorChar8( getName() + ".CVRCNOM" ) ),
    _cvrcGd( JeveuxVectorChar8( getName() + ".CVRCGD" ) ),
    _cvrcVarc( JeveuxVectorChar8( getName() + ".CVRCVARC" ) ),
    _cvrcCmp( JeveuxVectorChar8( getName() + ".CVRCCMP" ) )
{};
#endif /* _USE_MPI */

bool MaterialOnMeshInstance::buildWithoutInputVariables() throw ( std::runtime_error )
{
    MaterialOnMeshBuilderInstance::buildInstance(*this);

    return true;
};

std::vector< MaterialPtr > MaterialOnMeshInstance::getVectorOfMaterial() const
{
    std::vector< MaterialPtr > toReturn;
    for( const auto& curIter : _materialsOnMeshEntity )
        for( const auto& curIter2 : curIter.first )
            toReturn.push_back( curIter2 );
    return toReturn;
};

bool MaterialOnMeshInstance::existsCalculationInputVariable( const std::string& name )
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
