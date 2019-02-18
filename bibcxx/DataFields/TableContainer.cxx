/**
 * @file TableContainer.cxx
 * @brief Implementation de TableContainer
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2019  EDF R&D                www.code-aster.org
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

#include "DataFields/TableContainer.h"
#include <iostream>

/* person_in_charge: nicolas.sellenet at edf.fr */

void TableContainerInstance::addObject( const std::string& a,
                                        ElementaryMatrixDisplacementDoublePtr b )
{
    _mapEMDD[a] = b;
};

void TableContainerInstance::addObject( const std::string& a,
                                        ElementaryMatrixTemperatureDoublePtr b )
{
    _mapEMTD[a] = b;
};

void TableContainerInstance::addObject( const std::string& a,
                                        ElementaryVectorDisplacementDoublePtr b )
{
    _mapEVDD[a] = b;
};

void TableContainerInstance::addObject( const std::string& a,
                                        ElementaryVectorTemperatureDoublePtr b )
{
    _mapEVTD[a] = b;
};

void TableContainerInstance::addObject( const std::string& a,
                                        FieldOnElementsDoublePtr b )
{
    _mapFOED[a] = b;
};

void TableContainerInstance::addObject( const std::string& a,
                                        FieldOnNodesDoublePtr b )
{
    _mapFOND[a] = b;
};

void TableContainerInstance::addObject( const std::string& a,
                                        FunctionPtr b )
{
    _mapF[a] = b;
};

void TableContainerInstance::addObject( const std::string& a,
                                        FunctionComplexPtr b )
{
    _mapFC[a] = b;
};

void TableContainerInstance::addObject( const std::string& a,
                                        GeneralizedAssemblyMatrixDoublePtr b )
{
    _mapGAMD[a] = b;
};

void TableContainerInstance::addObject( const std::string& a,
                                        GenericDataFieldPtr b )
{
    _mapGDF[a] = b;
};

void TableContainerInstance::addObject( const std::string& a,
                                        MechanicalModeContainerPtr b )
{
    _mapMMC[a] = b;
};

void TableContainerInstance::addObject( const std::string& a,
                                        PCFieldOnMeshDoublePtr b )
{
    _mapPCFOMD[a] = b;
};

void TableContainerInstance::addObject( const std::string& a,
                                        SurfacePtr b )
{
    _mapS[a] = b;
};

void TableContainerInstance::addObject( const std::string& a,
                                        TablePtr b )
{
    _mapT[a] = b;
};

ElementaryMatrixDisplacementDoublePtr
TableContainerInstance::getElementaryMatrixDisplacementDouble( const std::string& a ) const
{
    const auto aa = trim(a); 
    const auto curIter = _mapEMDD.find(aa);
    if( curIter == _mapEMDD.end() )
        return ElementaryMatrixDisplacementDoublePtr( nullptr );
    return curIter->second;
};

ElementaryMatrixTemperatureDoublePtr
TableContainerInstance::getElementaryMatrixTemperatureDouble( const std::string& a ) const
{
    const auto aa = trim(a); 
    const auto curIter = _mapEMTD.find(aa);
    if( curIter == _mapEMTD.end() )
        return ElementaryMatrixTemperatureDoublePtr( nullptr );
    return curIter->second;
};

ElementaryVectorDisplacementDoublePtr TableContainerInstance::getElementaryVectorDisplacementDouble
    ( const std::string& a ) const
{
    const auto aa = trim(a); 
    const auto curIter = _mapEVDD.find(aa);
    if( curIter == _mapEVDD.end() )
        return ElementaryVectorDisplacementDoublePtr( nullptr );
    return curIter->second;
};

ElementaryVectorTemperatureDoublePtr
TableContainerInstance::getElementaryVectorTemperatureDouble( const std::string& a ) const
{
    const auto aa = trim(a); 
    const auto curIter = _mapEVTD.find(aa);
    if( curIter == _mapEVTD.end() )
        return ElementaryVectorTemperatureDoublePtr( nullptr );
    return curIter->second;
};

FieldOnElementsDoublePtr TableContainerInstance::getFieldOnElementsDouble
    ( const std::string& a ) const
{
    const auto aa = trim(a); 
    const auto curIter = _mapFOED.find(aa);
    if( curIter == _mapFOED.end() )
        return FieldOnElementsDoublePtr( nullptr );
    return curIter->second;
};

FieldOnNodesDoublePtr
TableContainerInstance::getFieldOnNodesDouble( const std::string& a ) const
{
    const auto aa = trim(a); 
    const auto curIter = _mapFOND.find(aa);
    if( curIter == _mapFOND.end() )
        return FieldOnNodesDoublePtr( nullptr );
    return curIter->second;
};

FunctionPtr TableContainerInstance::getFunction( const std::string& a ) const
{
    const auto aa = trim(a); 
    const auto curIter = _mapF.find(aa);
    if( curIter == _mapF.end() )
        return FunctionPtr( nullptr );
    return curIter->second;
};

FunctionComplexPtr TableContainerInstance::getFunctionComplex( const std::string& a ) const
{
    const auto aa = trim(a); 
    const auto curIter = _mapFC.find(aa);
    if( curIter == _mapFC.end() )
        return FunctionComplexPtr( nullptr );
    return curIter->second;
};

GeneralizedAssemblyMatrixDoublePtr
TableContainerInstance::getGeneralizedAssemblyMatrix( const std::string& a ) const
{
    const auto aa = trim(a); 
    const auto curIter = _mapGAMD.find(aa);
    if( curIter == _mapGAMD.end() )
        return GeneralizedAssemblyMatrixDoublePtr( nullptr );
    return curIter->second;
};

GenericDataFieldPtr TableContainerInstance::getGenericDataField( const std::string& a ) const
{
    const auto aa = trim(a); 
    const auto curIter = _mapGDF.find(aa);
    if( curIter == _mapGDF.end() )
        return GenericDataFieldPtr( nullptr );
    return curIter->second;
};

MechanicalModeContainerPtr
TableContainerInstance::getMechanicalModeContainer( const std::string& a ) const
{
    const auto aa = trim(a); 
    const auto curIter = _mapMMC.find(aa);
    if( curIter == _mapMMC.end() )
        return MechanicalModeContainerPtr( nullptr );
    return curIter->second;
};

PCFieldOnMeshDoublePtr TableContainerInstance::getPCFieldOnMeshDouble( const std::string& a ) const
{
    const auto aa = trim(a); 
    const auto curIter = _mapPCFOMD.find(aa);
    if( curIter == _mapPCFOMD.end() )
        return PCFieldOnMeshDoublePtr( nullptr );
    return curIter->second;
};

SurfacePtr TableContainerInstance::getSurface( const std::string& a ) const
{
    const auto aa = trim(a); 
    const auto curIter = _mapS.find(aa);
    if( curIter == _mapS.end() )
        return SurfacePtr( nullptr );
    return curIter->second;
};

TablePtr TableContainerInstance::getTable( const std::string& a ) const
{
    const auto aa = trim(a); 
    const auto curIter = _mapT.find(aa);
    if( curIter == _mapT.end() )
        return TablePtr( nullptr );
    return curIter->second;
};

bool TableContainerInstance::update()
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
                                    ( new GeneralizedAssemblyMatrixDoubleInstance( sdName ) );
                }
            else if( type == "MATR_ELEM_DEPL_R" )
                {
                if (  _mapEMDD[name]  == nullptr ) 
                _mapEMDD[name] = ElementaryMatrixDisplacementDoublePtr
                                    ( new ElementaryMatrixDisplacementDoubleInstance( sdName ) );
                }
            else if( type == "MATR_ELEM_TEMP_R" )
                {
                if ( _mapEMTD[name] == nullptr ) 
                _mapEMTD[name] = ElementaryMatrixTemperatureDoublePtr
                                    ( new ElementaryMatrixTemperatureDoubleInstance( sdName ) );
                }
            else if( type == "VECT_ELEM_DEPL_R" )
                {
                if (  _mapEVDD[name] == nullptr ) 
                _mapEVDD[name] = ElementaryVectorDisplacementDoublePtr
                                    ( new ElementaryVectorDisplacementDoubleInstance( sdName ) );
                }
            else if( type == "VECT_ELEM_TEMP_R" )
                {
                if ( _mapEVTD[name] == nullptr ) 
                _mapEVTD[name] = ElementaryVectorTemperatureDoublePtr
                                    ( new ElementaryVectorTemperatureDoubleInstance( sdName ) );
                }
            else if( type == "CHAM_GD_SDASTER" )
                {
                if ( _mapGDF[name] == nullptr ) 
                _mapGDF[name] = GenericDataFieldPtr
                                    ( new GenericDataFieldInstance( sdName ) );
                }
            else if( type == "CHAM_NO_SDASTER" )
                {
                if ( _mapFOND[name] == nullptr ) 
                _mapFOND[name] = FieldOnNodesDoublePtr
                                    ( new FieldOnNodesDoubleInstance( sdName ) );
                }
//             else if( type == "CARTE_SDASTER" )
//                 _mapPCFOMD[name] = PCFieldOnMeshDoublePtr
//                                     ( new PCFieldOnMeshDoubleInstance( sdName ) );
            else if( type == "CHAM_ELEM" )
                {
                if ( _mapFOED[name] == nullptr )
                _mapFOED[name] = FieldOnElementsDoublePtr
                                    ( new FieldOnElementsDoubleInstance( sdName ) );
                }
            else if( type == "MODE_MECA" )
                {
                if ( _mapMMC[name] == nullptr )
                    _mapMMC[name] = MechanicalModeContainerPtr
                                    ( new MechanicalModeContainerInstance( sdName ) );
                }
            else if( type == "TABLE_SDASTER" )
                {
                if ( _mapT[name] == nullptr ) 
                _mapT[name] = TablePtr
                                    ( new TableInstance( sdName ) );
                }
            else if( type == "FONCTION_SDASTER" )
                {
                if (  _mapF[name] == nullptr ) 
                _mapF[name] = FunctionPtr
                                    ( new FunctionInstance( sdName ) );
                }
            else if( type == "FONCTION_C" )
                {
                if ( _mapFC[name] == nullptr ) 
                _mapFC[name] = FunctionComplexPtr
                                    ( new FunctionComplexInstance( sdName ) );
                }
            else if( type == "NAPPE_SDASTER" )
                {
                if ( _mapS[name] == nullptr ) 
                _mapS[name] = SurfacePtr
                                    ( new SurfaceInstance( sdName ) );
                }
            else
                throw std::runtime_error( "Type not implemented " + type );
        }
    }
    else
        return false;
    return true;
};
