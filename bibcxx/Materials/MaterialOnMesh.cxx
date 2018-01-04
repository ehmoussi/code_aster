/**
 * @file MaterialOnMesh.cxx
 * @brief Implementation de MaterialOnMesh
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

/* person_in_charge: nicolas.sellenet at edf.fr */

#include <stdexcept>
#include <typeinfo>
#include "astercxx.h"

#include "Materials/MaterialOnMesh.h"
#include "Utilities/SyntaxDictionary.h"
#include "Supervis/CommandSyntax.h"


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

SyntaxMapContainer MaterialOnMeshInstance::getCppCommandKeywords() throw ( std::runtime_error )
{
    SyntaxMapContainer dict;

    if ( ! _supportMesh )
        throw std::runtime_error("Support mesh is undefined");
    dict.container["MAILLAGE"] = _supportMesh->getName();

    ListSyntaxMapContainer listeAFFE;
    for ( listOfMatsAndGrpsIter curIter = _materialsOnMeshEntity.begin();
          curIter != _materialsOnMeshEntity.end();
          ++curIter )
    {
        SyntaxMapContainer dict2;
        dict2.container["MATER"] = curIter->first->getName();
        const MeshEntityPtr& tmp = curIter->second;
        if ( tmp->getType() == AllMeshEntitiesType )
        {
            dict2.container["TOUT"] = "OUI";
        }
        else
        {
            if ( tmp->getType() == GroupOfElementsType )
                dict2.container["GROUP_MA"] = (curIter->second)->getName();
            else if ( tmp->getType() == GroupOfNodesType  )
                dict2.container["GROUP_NO"] = (curIter->second)->getName();
            else
                throw std::runtime_error("Support entity undefined");
        }
        listeAFFE.push_back( dict2 );
    }
    dict.container["AFFE"] = listeAFFE;

    ListSyntaxMapContainer listeAFFE_COMPOR;
    for ( auto& curIter : _behaviours )
    {
        SyntaxMapContainer dict2;
        dict2.container["COMPOR"] = curIter.first->getName();
        const MeshEntityPtr& tmp = curIter.second;
        if ( tmp->getType() == AllMeshEntitiesType )
        {
            dict2.container["TOUT"] = "OUI";
        }
        else
        {
            if ( tmp->getType() == GroupOfElementsType )
                dict2.container["GROUP_MA"] = (curIter.second)->getName();
            else
                throw std::runtime_error("Support entity undefined");
        }
        listeAFFE_COMPOR.push_back( dict2 );
    }
    dict.container["AFFE_COMPOR"] = listeAFFE_COMPOR;

    ListSyntaxMapContainer listeAFFE_VARC;
    for ( auto& curIter : _inputVars )
    {
        SyntaxMapContainer dict2;

        const auto& inputVar = (*curIter.first);
        dict2.container["NOM_VARC"] = inputVar.getVariableName();
        dict2.container["CHAM_GD"] = inputVar.getInputValuesField()->getName();
        if( inputVar.existsReferenceValue() )
            dict2.container["VALE_REF"] = inputVar.getReferenceValue();

        const MeshEntityPtr& tmp = curIter.second;
        if ( tmp->getType() == AllMeshEntitiesType )
        {
            dict2.container["TOUT"] = "OUI";
        }
        else
        {
            if ( tmp->getType() == GroupOfElementsType )
                dict2.container["GROUP_MA"] = (curIter.second)->getName();
            else
                throw std::runtime_error("Support entity undefined");
        }
        listeAFFE_VARC.push_back( dict2 );
    }
    dict.container["AFFE_VARC"] = listeAFFE_VARC;
    return dict;
};

PyObject* MaterialOnMeshInstance::getCommandKeywords() throw ( std::runtime_error )
{
    SyntaxMapContainer dict = getCppCommandKeywords();

    PyObject* returnDict = dict.convertToPythonDictionnary();
    return returnDict;
};

bool MaterialOnMeshInstance::build() throw ( std::runtime_error )
{
    auto syntax = CommandSyntax( "AFFE_MATERIAU" );
    syntax.setResult( getName(), getType() );
    auto keywords = getCppCommandKeywords();
    syntax.define( keywords );
    // Maintenant que le fichier de commande est pret, on appelle OP006
    try
    {
        ASTERINTEGER op = 6;
        CALL_EXECOP( &op );
    }
    catch( ... )
    {
        throw;
    }
    // Attention, la connection des objets a leur image JEVEUX n'est pas necessaire
    _listOfMaterials->updateValuePointers();

    return true;
};

bool MaterialOnMeshInstance::build_deprecated() throw ( std::runtime_error )
{
    // Maintenant que le fichier de commande est pret, on appelle OP006
    try
    {
        ASTERINTEGER op = 6;
        CALL_EXECOP( &op );
    }
    catch( ... )
    {
        throw;
    }
    // Attention, la connection des objets a leur image JEVEUX n'est pas necessaire
    _listOfMaterials->updateValuePointers();

    return true;
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
