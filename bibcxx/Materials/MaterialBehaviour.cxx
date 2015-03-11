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
    for( ListStringConstIter curIter = _listOfNameOfMaterialProperties.begin();
         curIter != _listOfNameOfMaterialProperties.end();
         ++curIter )
    {
        mapStrEMPDConstIterator curIter2 = _mapOfDoubleMaterialProperties.find(*curIter);
        if( curIter2 != _mapOfDoubleMaterialProperties.end() )
        {
            (*doubleValues)[position] = (*curIter2).second.getValue();

            std::string nameOfProperty = (*curIter2).second.getName();
            nameOfProperty.resize( 16, ' ' );
            (*char16Values)[position] = nameOfProperty.c_str();
        }
        else
            throw std::runtime_error( "Le parametre materiau doit etre un double" );
        ++position;
    }

    return true;
};
