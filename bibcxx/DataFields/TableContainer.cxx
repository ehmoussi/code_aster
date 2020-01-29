/**
 * @file TableContainer.cxx
 * @brief Implementation de TableContainer
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

#include "DataFields/TableContainer.h"
#include <iostream>

/* person_in_charge: nicolas.sellenet at edf.fr */

void TableContainerClass::addObject( const std::string& a,
                                        ElementaryMatrixDisplacementDoublePtr b )
{
    _mapEMDD[a] = b;
};

void TableContainerClass::addObject( const std::string& a,
                                        ElementaryMatrixTemperatureDoublePtr b )
{
    _mapEMTD[a] = b;
};

void TableContainerClass::addObject( const std::string& a,
                                        ElementaryVectorDisplacementDoublePtr b )
{
    _mapEVDD[a] = b;
};

void TableContainerClass::addObject( const std::string& a,
                                        ElementaryVectorTemperatureDoublePtr b )
{
    _mapEVTD[a] = b;
};

void TableContainerClass::addObject( const std::string& a,
                                        FieldOnCellsDoublePtr b )
{
    _mapFOED[a] = b;
};

void TableContainerClass::addObject( const std::string& a,
                                        FieldOnNodesDoublePtr b )
{
    _mapFOND[a] = b;
};

void TableContainerClass::addObject( const std::string& a,
                                        FunctionPtr b )
{
    _mapF[a] = b;
};

void TableContainerClass::addObject( const std::string& a,
                                        FunctionComplexPtr b )
{
    _mapFC[a] = b;
};

void TableContainerClass::addObject( const std::string& a,
                                        GeneralizedAssemblyMatrixDoublePtr b )
{
    _mapGAMD[a] = b;
};

void TableContainerClass::addObject( const std::string& a,
                                        DataFieldPtr b )
{
    _mapGDF[a] = b;
};

void TableContainerClass::addObject( const std::string& a,
                                        MechanicalModeContainerPtr b )
{
    _mapMMC[a] = b;
};

void TableContainerClass::addObject( const std::string& a,
                                        PCFieldOnMeshDoublePtr b )
{
    _mapPCFOMD[a] = b;
};

void TableContainerClass::addObject( const std::string& a,
                                        SurfacePtr b )
{
    _mapS[a] = b;
};

void TableContainerClass::addObject( const std::string& a,
                                        TablePtr b )
{
    _mapT[a] = b;
};

ElementaryMatrixDisplacementDoublePtr
TableContainerClass::getElementaryMatrixDisplacementDouble( const std::string& a ) const
{
    const auto aa = trim(a);
    const auto curIter = _mapEMDD.find(aa);
    if( curIter == _mapEMDD.end() )
        return ElementaryMatrixDisplacementDoublePtr( nullptr );
    return curIter->second;
};

ElementaryMatrixTemperatureDoublePtr
TableContainerClass::getElementaryMatrixTemperatureDouble( const std::string& a ) const
{
    const auto aa = trim(a);
    const auto curIter = _mapEMTD.find(aa);
    if( curIter == _mapEMTD.end() )
        return ElementaryMatrixTemperatureDoublePtr( nullptr );
    return curIter->second;
};

ElementaryVectorDisplacementDoublePtr TableContainerClass::getElementaryVectorDisplacementDouble
    ( const std::string& a ) const
{
    const auto aa = trim(a);
    const auto curIter = _mapEVDD.find(aa);
    if( curIter == _mapEVDD.end() )
        return ElementaryVectorDisplacementDoublePtr( nullptr );
    return curIter->second;
};

ElementaryVectorTemperatureDoublePtr
TableContainerClass::getElementaryVectorTemperatureDouble( const std::string& a ) const
{
    const auto aa = trim(a);
    const auto curIter = _mapEVTD.find(aa);
    if( curIter == _mapEVTD.end() )
        return ElementaryVectorTemperatureDoublePtr( nullptr );
    return curIter->second;
};

FieldOnCellsDoublePtr TableContainerClass::getFieldOnCellsDouble
    ( const std::string& a ) const
{
    const auto aa = trim(a);
    const auto curIter = _mapFOED.find(aa);
    if( curIter == _mapFOED.end() )
        return FieldOnCellsDoublePtr( nullptr );
    return curIter->second;
};

FieldOnNodesDoublePtr
TableContainerClass::getFieldOnNodesDouble( const std::string& a ) const
{
    const auto aa = trim(a);
    const auto curIter = _mapFOND.find(aa);
    if( curIter == _mapFOND.end() )
        return FieldOnNodesDoublePtr( nullptr );
    return curIter->second;
};

FunctionPtr TableContainerClass::getFunction( const std::string& a ) const
{
    const auto aa = trim(a);
    const auto curIter = _mapF.find(aa);
    if( curIter == _mapF.end() )
        return FunctionPtr( nullptr );
    return curIter->second;
};

FunctionComplexPtr TableContainerClass::getFunctionComplex( const std::string& a ) const
{
    const auto aa = trim(a);
    const auto curIter = _mapFC.find(aa);
    if( curIter == _mapFC.end() )
        return FunctionComplexPtr( nullptr );
    return curIter->second;
};

GeneralizedAssemblyMatrixDoublePtr
TableContainerClass::getGeneralizedAssemblyMatrix( const std::string& a ) const
{
    const auto aa = trim(a);
    const auto curIter = _mapGAMD.find(aa);
    if( curIter == _mapGAMD.end() )
        return GeneralizedAssemblyMatrixDoublePtr( nullptr );
    return curIter->second;
};

DataFieldPtr TableContainerClass::getDataField( const std::string& a ) const
{
    const auto aa = trim(a);
    const auto curIter = _mapGDF.find(aa);
    if( curIter == _mapGDF.end() )
        return DataFieldPtr( nullptr );
    return curIter->second;
};

MechanicalModeContainerPtr
TableContainerClass::getMechanicalModeContainer( const std::string& a ) const
{
    const auto aa = trim(a);
    const auto curIter = _mapMMC.find(aa);
    if( curIter == _mapMMC.end() )
        return MechanicalModeContainerPtr( nullptr );
    return curIter->second;
};

PCFieldOnMeshDoublePtr TableContainerClass::getPCFieldOnMeshDouble( const std::string& a ) const
{
    const auto aa = trim(a);
    const auto curIter = _mapPCFOMD.find(aa);
    if( curIter == _mapPCFOMD.end() )
        return PCFieldOnMeshDoublePtr( nullptr );
    return curIter->second;
};

SurfacePtr TableContainerClass::getSurface( const std::string& a ) const
{
    const auto aa = trim(a);
    const auto curIter = _mapS.find(aa);
    if( curIter == _mapS.end() )
        return SurfacePtr( nullptr );
    return curIter->second;
};

TablePtr TableContainerClass::getTable( const std::string& a ) const
{
    const auto aa = trim(a);
    const auto curIter = _mapT.find(aa);
    if( curIter == _mapT.end() )
        return TablePtr( nullptr );
    return curIter->second;
};

bool TableContainerClass::update()
{

    _parameterDescription->updateValuePointer();
    const int size = _parameterDescription->size() / 4;
    for( int i = 0; i < size; ++i )
    {
        const auto test = trim( (*_parameterDescription)[ i*4 ].toString() );
        const auto name = trim( (*_parameterDescription)[ i*4 + 2 ].toString() );
        const auto name2 = trim( (*_parameterDescription)[ i*4 + 3 ].toString() );
        const auto type = trim( (*_parameterDescription)[ i*4 + 1 ].toString() );
        if( test == "NOM_OBJET" )
        {
            if ( _objectName.isEmpty() )
                _objectName = JeveuxVectorChar16( name );
        }
        else if( test == "TYPE_OBJET" )
        {
            if ( _objectType.isEmpty() )
                _objectType = JeveuxVectorChar16( name );
        }
        else if( test == "NOM_SD" )
        {
            if( type == "K8" )
            {
                if ( _dsName1.isEmpty() )
                     _dsName1 = JeveuxVectorChar8( name );
            }
            else
            {
                if ( _dsName2.isEmpty() )
                    _dsName2 = JeveuxVectorChar24( name );
            }
        }
        else
          _others.push_back( JeveuxVectorLong( name ) );
        _vecOfSizes.push_back( JeveuxVectorLong( name2 ) );
    }
    const bool test1 = _dsName1.isEmpty();
    const bool test2 = _dsName2.isEmpty();
    const bool test3 = test1 && test2;
    if( !test3 && !_objectType.isEmpty() && !_objectName.isEmpty() )
    {
        int usedSize = 0;
        if( !test1 )
        {
            _dsName1->updateValuePointer();
            usedSize = _dsName1->usedSize();
        }
        else
        {
            _dsName2->updateValuePointer();
            usedSize = _dsName2->usedSize();
        }
        _objectType->updateValuePointer();
        _objectName->updateValuePointer();

        if( usedSize != _objectType->usedSize() )
            throw std::runtime_error( "Unconsistent sizes" );
        if( usedSize != _objectName->usedSize() )
            throw std::runtime_error( "Unconsistent sizes" );
        for( int i = 0; i < usedSize; ++i )
        {
            const auto type = trim( (*_objectType)[i].toString() );
            std::string sdName("");
            if( !test1 )
                sdName = trim( (*_dsName1)[i].toString() );
            else
                sdName = trim( (*_dsName2)[i].toString() );
            const auto name = trim( (*_objectName)[i].toString() );
            if( type == "MATR_ASSE_GENE_R" )
                {
                if ( _mapGAMD[name] == nullptr )
                _mapGAMD[name] = GeneralizedAssemblyMatrixDoublePtr
                                    ( new GeneralizedAssemblyMatrixDoubleClass( sdName ) );
                }
            else if( type == "MATR_ELEM_DEPL_R" )
                {
                if (  _mapEMDD[name]  == nullptr )
                _mapEMDD[name] = ElementaryMatrixDisplacementDoublePtr
                                    ( new ElementaryMatrixDisplacementDoubleClass( sdName ) );
                }
            else if( type == "MATR_ELEM_TEMP_R" )
                {
                if ( _mapEMTD[name] == nullptr )
                _mapEMTD[name] = ElementaryMatrixTemperatureDoublePtr
                                    ( new ElementaryMatrixTemperatureDoubleClass( sdName ) );
                }
            else if( type == "VECT_ELEM_DEPL_R" )
                {
                if (  _mapEVDD[name] == nullptr )
                _mapEVDD[name] = ElementaryVectorDisplacementDoublePtr
                                    ( new ElementaryVectorDisplacementDoubleClass( sdName ) );
                }
            else if( type == "VECT_ELEM_TEMP_R" )
                {
                if ( _mapEVTD[name] == nullptr )
                _mapEVTD[name] = ElementaryVectorTemperatureDoublePtr
                                    ( new ElementaryVectorTemperatureDoubleClass( sdName ) );
                }
            else if( type == "CHAM_GD_SDASTER" )
                {
                if ( _mapGDF[name] == nullptr )
                _mapGDF[name] = DataFieldPtr
                                    ( new DataFieldClass( sdName ) );
                }
            else if( type == "CHAM_NO_SDASTER" )
                {
                if ( _mapFOND[name] == nullptr )
                _mapFOND[name] = FieldOnNodesDoublePtr
                                    ( new FieldOnNodesDoubleClass( sdName ) );
                }
//             else if( type == "CARTE_SDASTER" )
//                 _mapPCFOMD[name] = PCFieldOnMeshDoublePtr
//                                     ( new PCFieldOnMeshDoubleClass( sdName ) );
            else if( type == "CHAM_ELEM" )
                {
                if ( _mapFOED[name] == nullptr )
                _mapFOED[name] = FieldOnCellsDoublePtr
                                    ( new FieldOnCellsDoubleClass( sdName ) );
                }
            else if( type == "MODE_MECA" )
                {
                if ( _mapMMC[name] == nullptr )
                    _mapMMC[name] = MechanicalModeContainerPtr
                                    ( new MechanicalModeContainerClass( sdName ) );
                }
            else if( type == "TABLE_SDASTER" )
                {
                if ( _mapT[name] == nullptr )
                _mapT[name] = TablePtr
                                    ( new TableClass( sdName ) );
                }
            else if( type == "FONCTION_SDASTER" )
                {
                if (  _mapF[name] == nullptr )
                _mapF[name] = FunctionPtr
                                    ( new FunctionClass( sdName ) );
                }
            else if( type == "FONCTION_C" )
                {
                if ( _mapFC[name] == nullptr )
                _mapFC[name] = FunctionComplexPtr
                                    ( new FunctionComplexClass( sdName ) );
                }
            else if( type == "NAPPE_SDASTER" )
                {
                if ( _mapS[name] == nullptr )
                _mapS[name] = SurfacePtr
                                    ( new SurfaceClass( sdName ) );
                }
            else
                throw std::runtime_error( "Type not implemented " + type );
        }
    }
    else
        return false;
    return true;
};
