/**
 * @file MaterialBehaviour.cxx
 * @brief Implementation de GeneralMaterialBehaviourInstance
 * @author Nicolas Sellenet
 * @todo autoriser le type Function pour les paramètres matériau
 * @section LICENCE
 *   Copyright (C) 1991 - 2019  EDF R&D                www.code-aster.org
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
#include "Materials/MaterialBehaviour.h"

bool GeneralMaterialBehaviourInstance::buildJeveuxVectors(
    JeveuxVectorComplex &complexValues, JeveuxVectorDouble &doubleValues,
    JeveuxVectorChar16 &char16Values, JeveuxVectorChar16 &ordr, JeveuxVectorLong &kOrd,
    std::vector< JeveuxVectorDouble > &userDoubles,
    std::vector< JeveuxVectorChar8 > &userFunctions )
{
    const int nbOfMaterialProperties = getNumberOfPropertiesWithValue();
    complexValues->allocate( Permanent, nbOfMaterialProperties );
    doubleValues->allocate( Permanent, nbOfMaterialProperties );
    char16Values->allocate( Permanent, 2 * nbOfMaterialProperties );

    typedef std::map< std::string, int > MapStrInt;
    MapStrInt mapTmp;
    bool bOrdr = false;
    if ( _vectOrdr.size() != 0 ) {
        ordr->allocate( Permanent, _vectOrdr.size() );
        for ( int i = 0; i < _vectOrdr.size(); ++i ) {
            ( *ordr )[i] = _vectOrdr[i];
            mapTmp[_vectOrdr[i]] = i + 1;
        }
        kOrd->allocate( Permanent, 2 + 4 * nbOfMaterialProperties );
        ( *kOrd )[0] = _vectOrdr.size();
        ( *kOrd )[1] = nbOfMaterialProperties;
        bOrdr = true;
    }

    int position = 0, position2 = nbOfMaterialProperties, pos3 = 0;
    for ( int i = 0; i < _vectKW.size() / 2; ++i ) {
        auto nameOfProperty2 = _vectKW[2 * i];
        auto nameOfProperty = _vectKW[2 * i + 1];
        auto curIter1 = _mapOfDoubleMaterialProperties.find( nameOfProperty2 );
        if ( curIter1 == _mapOfDoubleMaterialProperties.end() )
            continue;

        auto curIter = *curIter1;
        if ( curIter.second.hasValue() ) {
            if ( bOrdr ) {
                const int curPos = 2 + nbOfMaterialProperties + i;
                ( *kOrd )[curPos] = position + 1;
                const int curPos2 = 2 + i;
                ( *kOrd )[curPos2] = mapTmp[nameOfProperty];
            }
            nameOfProperty.resize( 16, ' ' );
            ( *char16Values )[position] = nameOfProperty.c_str();
            ( *doubleValues )[position] = curIter.second.getValue();
            ++position;
        }

        if ( curIter.second.isMandatory() && !curIter.second.hasValue() )
            throw std::runtime_error( "Mandatory material property " + nameOfProperty2 +
                                      " is missing" );
    }

    for ( auto curIter : _mapOfConvertibleMaterialProperties ) {
        std::string nameOfProperty = curIter.second.getName();
        if ( curIter.second.hasValue() ) {
            nameOfProperty.resize( 16, ' ' );
            ( *char16Values )[position] = nameOfProperty.c_str();
            ( *doubleValues )[position] = curIter.second.getValue();
            ++position;
        }

        if ( curIter.second.isMandatory() && !curIter.second.hasValue() )
            throw std::runtime_error( "Mandatory material property " + nameOfProperty +
                                      " is missing" );
    }
    doubleValues->setUsedSize( position );

    for ( auto curIter : _mapOfComplexMaterialProperties ) {
        std::string nameOfProperty = curIter.second.getName();
        if ( curIter.second.hasValue() ) {
            nameOfProperty.resize( 16, ' ' );
            ( *char16Values )[position] = nameOfProperty.c_str();
            ( *complexValues )[position] = curIter.second.getValue();
            ++position;
            ++pos3;
            if ( bOrdr )
                throw std::runtime_error( "ORDRE_PARAM with complex values not allowed" );
        }

        if ( curIter.second.isMandatory() && !curIter.second.hasValue() )
            throw std::runtime_error( "Mandatory material property " + nameOfProperty +
                                      " is missing" );
    }
    if ( pos3 != 0 )
        complexValues->setUsedSize( position );
    else
        complexValues->setUsedSize( pos3 );

    for ( auto curIter : _mapOfTableMaterialProperties ) {
        std::string nameOfProperty = curIter.second.getName();
        if ( curIter.second.hasValue() ) {
            nameOfProperty.resize( 16, ' ' );
            ( *char16Values )[position] = nameOfProperty.c_str();
            ( *char16Values )[position2] = curIter.second.getValue()->getName();
            ++position;
            ++position2;
        }

        if ( curIter.second.isMandatory() && !curIter.second.hasValue() )
            throw std::runtime_error( "Mandatory material property " + nameOfProperty +
                                      " is missing" );
    }

    for ( int i = 0; i < _vectKW.size() / 2; ++i ) {
        auto nameOfProperty2 = _vectKW[2 * i];
        auto nameOfProperty = _vectKW[2 * i + 1];
        auto curIter1 = _mapOfFunctionMaterialProperties.find( nameOfProperty2 );
        if ( curIter1 == _mapOfFunctionMaterialProperties.end() )
            continue;

        auto curIter = *curIter1;
        if ( curIter.second.hasValue() ) {
            if ( bOrdr ) {
                const int curPos = 2 + 3 * nbOfMaterialProperties + i;
                ( *kOrd )[curPos] = position + 1;
                const int curPos2 = 2 + i;
                ( *kOrd )[curPos2] = mapTmp[nameOfProperty];
            }
            nameOfProperty.resize( 16, ' ' );
            ( *char16Values )[position] = nameOfProperty.c_str();
            ( *char16Values )[position2] = curIter.second.getValue()->getName();
            ++position;
            ++position2;
        }

        if ( curIter.second.isMandatory() && !curIter.second.hasValue() )
            throw std::runtime_error( "Mandatory material property " + nameOfProperty +
                                      " is missing" );
    }

    int position3 = 0;
    for ( auto curIter : _mapOfVectorDoubleMaterialProperties ) {
        std::string nameOfProperty = curIter.second.getName();
        if ( curIter.second.hasValue() ) {
            nameOfProperty.resize( 16, ' ' );
            ( *char16Values )[position] = nameOfProperty.c_str();
            ( *char16Values )[position2] = userDoubles[position3]->getName();

            auto values = curIter.second.getValue();
            userDoubles[position3]->allocate( Permanent, values.size() );
            ( *userDoubles[position3] ) = values;
            ++position;
            ++position2;
            ++position3;
        }

        if ( curIter.second.isMandatory() && !curIter.second.hasValue() )
            throw std::runtime_error( "Mandatory material property " + nameOfProperty +
                                      " is missing" );
    }

    if ( _mapOfVectorFunctionMaterialProperties.size() > 1 )
        throw std::runtime_error( "Unconsistent size" );
    for ( auto curIter : _mapOfVectorFunctionMaterialProperties ) {
        std::string nameOfProperty = curIter.second.getName();
        if ( curIter.second.hasValue() ) {
            nameOfProperty.resize( 16, ' ' );
            ( *char16Values )[position] = nameOfProperty.c_str();
            ( *char16Values )[position2] = userFunctions[0]->getName();

            auto values = curIter.second.getValue();
            userFunctions[0]->allocate( Permanent, values.size() );
            for ( int i = 0; i < values.size(); ++i )
                ( *userFunctions[0] )[i] = values[i]->getName();
            ++position;
            ++position2;
        }

        if ( curIter.second.isMandatory() && !curIter.second.hasValue() )
            throw std::runtime_error( "Mandatory material property " + nameOfProperty +
                                      " is missing" );
    }
    char16Values->setUsedSize( position2 );

    return true;
};

bool GeneralMaterialBehaviourInstance::buildTractionFunction( FunctionPtr &doubleValues ) const
    {
    return true;
};

bool TractionMaterialBehaviourInstance::buildTractionFunction( FunctionPtr &doubleValues ) const
    {
    ASTERINTEGER maxSize = 0, maxSize2 = 0;
    std::string resName;
    for ( auto curIter : _mapOfFunctionMaterialProperties ) {
        std::string nameOfProperty = curIter.second.getName();
        if ( curIter.second.hasValue() ) {
            const auto func = curIter.second.getValue();
            CALLO_RCSTOC_VERIF( func->getName(), nameOfProperty, _asterName, &maxSize2 );
            const auto size = func->maximumSize();
            if ( size > maxSize )
                maxSize = size;
            resName = curIter.second.getValue()->getResultName();
        }
    }
    doubleValues->allocate( Permanent, maxSize );
    doubleValues->setParameterName( "EPSI" );
    doubleValues->setResultName( resName );
    return true;
};

bool MetaTractionMaterialBehaviourInstance::buildTractionFunction( FunctionPtr &doubleValues ) const
    {
    ASTERINTEGER maxSize = 0, maxSize2 = 0;
    std::string resName;
    for ( auto curIter : _mapOfFunctionMaterialProperties ) {
        std::string nameOfProperty = curIter.second.getName();
        if ( curIter.second.hasValue() ) {
            const auto func = curIter.second.getValue();
            CALLO_RCSTOC_VERIF( func->getName(), nameOfProperty, _asterName, &maxSize2 );
            const auto size = func->maximumSize();
            if ( size > maxSize )
                maxSize = size;
            resName = curIter.second.getValue()->getResultName();
        }
    }
    doubleValues->allocate( Permanent, maxSize );
    doubleValues->setParameterName( "EPSI" );
    doubleValues->setResultName( resName );
    return true;
};

int GeneralMaterialBehaviourInstance::getNumberOfPropertiesWithValue() const {
    int toReturn = 0;
    for ( auto curIter : _mapOfDoubleMaterialProperties )
        if ( curIter.second.hasValue() )
            ++toReturn;

    for ( auto curIter : _mapOfComplexMaterialProperties )
        if ( curIter.second.hasValue() )
            ++toReturn;

    for ( auto curIter : _mapOfStringMaterialProperties )
        if ( curIter.second.hasValue() )
            ++toReturn;

    for ( auto curIter : _mapOfTableMaterialProperties )
        if ( curIter.second.hasValue() )
            ++toReturn;

    for ( auto curIter : _mapOfFunctionMaterialProperties )
        if ( curIter.second.hasValue() )
            ++toReturn;

    for ( auto curIter : _mapOfVectorDoubleMaterialProperties )
        if ( curIter.second.hasValue() )
            ++toReturn;

    for ( auto curIter : _mapOfVectorFunctionMaterialProperties )
        if ( curIter.second.hasValue() )
            ++toReturn;

    for ( auto curIter : _mapOfConvertibleMaterialProperties )
        if ( curIter.second.hasValue() )
            ++toReturn;

    return toReturn;
};


bool TherNlMaterialBehaviourInstance::buildJeveuxVectors(
    JeveuxVectorComplex &complexValues, JeveuxVectorDouble &doubleValues,
    JeveuxVectorChar16 &char16Values, JeveuxVectorChar16 &ordr, JeveuxVectorLong &kOrd,
    std::vector< JeveuxVectorDouble > &userDoubles,
    std::vector< JeveuxVectorChar8 > &userFunctions )
{
    const auto curIter = _mapOfFunctionMaterialProperties.find( "Beta" )->second;

    if( ! curIter.hasValue() )
    {
        const auto curIter2 = _mapOfFunctionMaterialProperties.find( "Rho_cp" );
        const auto name = std::string( complexValues->getName(), 0, 8 );
        auto func = curIter2->second.getValue();
        const std::string method( "TRAPEZE" );
        const std::string nameIn = func->getName();
        double val = 0.;
        const std::string nameOut = _enthalpyFunction->getName();
        const std::string base( "G" );
        CALLO_FOCAIN( method, nameIn, &val, nameOut, base );
        setFunctionValue( "Beta", _enthalpyFunction );
        auto prop = func->getProperties();
        auto prop2 = _enthalpyFunction->getProperties();
        std::string prol( prop2[4] );
        if( prop[4][0] == 'C' )
            prol[0] = 'L';
        if( prop[4][1] == 'C' )
            prol[1] = 'L';
        _enthalpyFunction->setExtrapolation( prol );
    }
    return GeneralMaterialBehaviourInstance::buildJeveuxVectors(complexValues,
                                                                doubleValues,
                                                                char16Values,
                                                                ordr,
                                                                kOrd,
                                                                userDoubles,
                                                                userFunctions);
};
