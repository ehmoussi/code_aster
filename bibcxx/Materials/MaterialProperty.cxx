/**
 * @file MaterialProperty.cxx
 * @brief Implementation de BaseMaterialPropertyClass
 * @author Nicolas Sellenet
 * @todo autoriser le type Function pour les paramètres matériau
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
#include "Materials/MaterialProperty.h"
#include "Materials/BaseMaterialProperty.h"



bool TractionMaterialPropertyClass::buildTractionFunction( FunctionPtr &doubleValues ) const
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

bool MetaTractionMaterialPropertyClass::buildTractionFunction( FunctionPtr &doubleValues ) const
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


bool ThermalNlMaterialPropertyClass::buildJeveuxVectors(
    JeveuxVectorComplex &complexValues, JeveuxVectorReal &doubleValues,
    JeveuxVectorChar16 &char16Values, JeveuxVectorChar16 &ordr, JeveuxVectorLong &kOrd,
    std::vector< JeveuxVectorReal > &userReals,
    std::vector< JeveuxVectorChar8 > &userFunctions )
{
    const auto curIter = _mapOfFunctionMaterialProperties.find( "Beta" )->second;

    if( ! curIter.hasValue() )
    {
        const auto curIter2 = _mapOfFunctionMaterialProperties.find( "Rho_cp" );
        const auto name = std::string( complexValues->getName(), 0, 8 );
        auto func = curIter2->second.getValue();
        const std::string nameIn = func->getName();
        const std::string nameOut = _enthalpyFunction->getName();
        CALLO_CREATE_ENTHALPY( nameIn, nameOut );

        setFunctionValue( "Beta", _enthalpyFunction );
    }
    return BaseMaterialPropertyClass::buildJeveuxVectors(complexValues,
                                                                doubleValues,
                                                                char16Values,
                                                                ordr,
                                                                kOrd,
                                                                userReals,
                                                                userFunctions);
};
