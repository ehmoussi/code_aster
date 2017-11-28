/**
 * @file MaterialBehaviour.cxx
 * @brief Implementation de GeneralMaterialBehaviourInstance
 * @author Nicolas Sellenet
 * @todo autoriser le type Function pour les paramètres matériau 
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
#include "Materials/MaterialBehaviour.h"

bool GeneralMaterialBehaviourInstance::buildJeveuxVectors( JeveuxVectorComplex& complexValues,
                                                           JeveuxVectorDouble& doubleValues,
                                                           JeveuxVectorChar16& char16Values ) const
    throw( std::runtime_error )
{
    const int nbOfMaterialProperties = _listOfNameOfMaterialProperties.size();
    complexValues->allocate( Permanent, nbOfMaterialProperties );
    doubleValues->allocate( Permanent, nbOfMaterialProperties );
    char16Values->allocate( Permanent, 2*nbOfMaterialProperties );

    int position = 0;
    for( auto curIter : _mapOfDoubleMaterialProperties){
        std::string nameOfProperty = curIter.second.getName();
        nameOfProperty.resize( 16, ' ' );
        (*char16Values)[position] = nameOfProperty.c_str();
        
        if( curIter.second.hasValue() )
            (*doubleValues)[position] = curIter.second.getValue();
        
        if( curIter.second.isMandatory() && ! curIter.second.hasValue() )
            throw std::runtime_error( "Mandatory material property " + nameOfProperty + " is missing" );
        
        ++position;
    }
    doubleValues->setLonUti(position);
    complexValues->setLonUti(0);
    for( auto curIter : _mapOfTableMaterialProperties){
        std::string nameOfProperty = curIter.second.getName();
        nameOfProperty.resize( 16, ' ' );
        (*char16Values)[position] = nameOfProperty.c_str();
        
        if( curIter.second.hasValue() )
            (*char16Values)[position+_mapOfTableMaterialProperties.size()] = curIter.second.getValue()->getName();
        
        if( curIter.second.isMandatory() && ! curIter.second.hasValue() )
            throw std::runtime_error( "Mandatory material property " + nameOfProperty + " is missing" );
        
        ++position;
    }
    char16Values->setLonUti(position+_mapOfTableMaterialProperties.size());
    
    return true;
};
