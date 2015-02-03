/**
 * @file MaterialBehaviour.cxx
 * @brief Implementation de GeneralMaterialBehaviourInstance
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
#include "Materials/MaterialBehaviour.h"

bool GeneralMaterialBehaviourInstance::build() throw ( std::runtime_error )
{
    const int nbOfMaterialProperties = _listOfNameOfMaterialProperties.size();
    _complexValues->allocate( "G", nbOfMaterialProperties );
    _doubleValues->allocate( "G", nbOfMaterialProperties );
    _char16Values->allocate( "G", 2*nbOfMaterialProperties );

    int position = 0;
    for ( list< string >::iterator curIter = _listOfNameOfMaterialProperties.begin();
          curIter != _listOfNameOfMaterialProperties.end();
          ++curIter )
    {
        mapStrEMPDIterator curIter2 = _mapOfDoubleMaterialProperties.find(*curIter);
        mapStrEMPCIterator curIter3 = _mapOfComplexMaterialProperties.find(*curIter);
        if ( curIter2 != _mapOfDoubleMaterialProperties.end() )
        {
            (*_doubleValues)[position] = (*curIter2).second.getValue();

            string nameOfProperty = (*curIter2).second.getName();
            nameOfProperty.resize( 16, ' ' );
            (*_char16Values)[position] = nameOfProperty.c_str();
        }
        else if ( curIter3 != _mapOfComplexMaterialProperties.end() )
        {
            throw std::runtime_error( "Pas encore implemente" );
        }
        else
            throw std::runtime_error( "Le parametre materiau doit etre un double ou un complexe");
        ++position;
    }

    return true;
};
