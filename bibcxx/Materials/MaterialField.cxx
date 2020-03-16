/**
 * @file MaterialField.cxx
 * @brief Implementation de MaterialField
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

#include "Materials/MaterialField.h"
#include "Utilities/SyntaxDictionary.h"
#include "Supervis/CommandSyntax.h"

#include "Materials/MaterialFieldBuilder.h"

MaterialFieldClass::MaterialFieldClass( const std::string &name,
                                                const MeshPtr& mesh ):
    _mesh( mesh ),
    _model( nullptr ),
    DataStructure( name, 8, "CHAM_MATER" ),
    _listOfMaterials( ConstantFieldOnCellsChar8Ptr(
        new ConstantFieldOnCellsChar8Class( getName() + ".CHAMP_MAT ", mesh ) ) ),
    _listOfTemperatures( ConstantFieldOnCellsRealPtr(
        new ConstantFieldOnCellsRealClass( getName() + ".TEMPE_REF ", mesh ) ) ),
    _behaviourField( ConstantFieldOnCellsRealPtr(
        new ConstantFieldOnCellsRealClass( getName() + ".COMPOR ", mesh ) ) ),
    _cvrcNom( JeveuxVectorChar8( getName() + ".CVRCNOM" ) ),
    _cvrcGd( JeveuxVectorChar8( getName() + ".CVRCGD" ) ),
    _cvrcVarc( JeveuxVectorChar8( getName() + ".CVRCVARC" ) ),
    _cvrcCmp( JeveuxVectorChar8( getName() + ".CVRCCMP" ) )
{};

MaterialFieldClass::MaterialFieldClass( const std::string &name,
                                                const SkeletonPtr& mesh ):
    _mesh( mesh ),
    _model( nullptr ),
    DataStructure( name, 8, "CHAM_MATER" ),
    _listOfMaterials( ConstantFieldOnCellsChar8Ptr(
        new ConstantFieldOnCellsChar8Class( getName() + ".CHAMP_MAT ", mesh ) ) ),
    _listOfTemperatures( ConstantFieldOnCellsRealPtr(
        new ConstantFieldOnCellsRealClass( getName() + ".TEMPE_REF ", mesh ) ) ),
    _behaviourField( ConstantFieldOnCellsRealPtr(
        new ConstantFieldOnCellsRealClass( getName() + ".COMPOR ", mesh ) ) ),
    _cvrcNom( JeveuxVectorChar8( getName() + ".CVRCNOM" ) ),
    _cvrcGd( JeveuxVectorChar8( getName() + ".CVRCGD" ) ),
    _cvrcVarc( JeveuxVectorChar8( getName() + ".CVRCVARC" ) ),
    _cvrcCmp( JeveuxVectorChar8( getName() + ".CVRCCMP" ) )
{};

#ifdef _USE_MPI
MaterialFieldClass::MaterialFieldClass( const std::string &name,
                                                const ParallelMeshPtr& mesh ):
    _mesh( mesh ),
    _model( nullptr ),
    DataStructure( name, 8, "CHAM_MATER" ),
    _listOfMaterials( ConstantFieldOnCellsChar8Ptr(
        new ConstantFieldOnCellsChar8Class( getName() + ".CHAMP_MAT ", mesh ) ) ),
    _listOfTemperatures( ConstantFieldOnCellsRealPtr(
        new ConstantFieldOnCellsRealClass( getName() + ".TEMPE_REF ", mesh ) ) ),
    _behaviourField( ConstantFieldOnCellsRealPtr(
        new ConstantFieldOnCellsRealClass( getName() + ".COMPOR ", mesh ) ) ),
    _cvrcNom( JeveuxVectorChar8( getName() + ".CVRCNOM" ) ),
    _cvrcGd( JeveuxVectorChar8( getName() + ".CVRCGD" ) ),
    _cvrcVarc( JeveuxVectorChar8( getName() + ".CVRCVARC" ) ),
    _cvrcCmp( JeveuxVectorChar8( getName() + ".CVRCCMP" ) )
{};
#endif /* _USE_MPI */

bool MaterialFieldClass::buildWithoutExternalVariable()
{
    MaterialFieldBuilderClass::buildClass(*this);

    return true;
};

std::vector< MaterialPtr > MaterialFieldClass::getVectorOfMaterial() const
{
    std::vector< MaterialPtr > toReturn;
    for( const auto& curIter : _materialsFieldEntity )
        for( const auto& curIter2 : curIter.first )
            toReturn.push_back( curIter2 );
    return toReturn;
};

std::vector< PartOfMaterialFieldPtr >
MaterialFieldClass::getVectorOfPartOfMaterialField() const
{
    std::vector< PartOfMaterialFieldPtr > toReturn;
    for( const auto& curIter : _materialsFieldEntity )
    {
        PartOfMaterialFieldPtr toPush( new PartOfMaterialFieldClass( curIter.first,
                                                                          curIter.second ) );
        toReturn.push_back( toPush );
    }
    return toReturn;
};

bool MaterialFieldClass::existsExternalVariablesComputation( const std::string& name )
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
