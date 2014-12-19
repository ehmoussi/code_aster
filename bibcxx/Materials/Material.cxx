/**
 * @file Material.cxx
 * @brief Implementation de MaterialInstance
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

#include "Materials/Material.h"

MaterialInstance::MaterialInstance(): DataStructure( initAster->getNewResultObjectName(), "MATER" ),
                    _jeveuxName( initAster->getResultObjectName() ),
                    _materialBehaviourNames( JeveuxVectorChar32( _jeveuxName + ".MATERIAU.NOMRC " ) ),
                    _nbMaterialBehaviour( 0 )
{};

bool MaterialInstance::build()
{
    // Recuperation du nombre de GeneralMaterialBehaviour ajoutes par l'utilisateur
    const int nbMCF = _vecMatBehaviour.size();
    // Creation du vecteur Jeveux ".MATERIAU.NOMRC"
    _materialBehaviourNames->allocate( "G", nbMCF );
    int num = 0;
    // Boucle sur les GeneralMaterialBehaviour
    for ( vector< GeneralMaterialBehaviour >::iterator curIter = _vecMatBehaviour.begin();
          curIter != _vecMatBehaviour.end();
          ++curIter )
    {
        // Recuperation du nom Aster (ELAS, ELAS_FO, ...) du GeneralMaterialBehaviour
        // sur lequel on travaille
        string curStr( (*curIter)->getAsterName().c_str() );
        curStr.resize( 32, ' ' );
        // Recopie dans le ".MATERIAU.NOMRC"
        (*_materialBehaviourNames)[num] = curStr.c_str();
        ++num;

        // Construction des objets Jeveux .CPT.XXXXXX.VALR, .CPT.XXXXXX.VALK, ...
        const bool retour = (*curIter)->build();
        if ( !retour ) return false;
    }
    return true;
};
