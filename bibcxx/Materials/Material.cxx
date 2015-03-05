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

#include "astercxx.h"

#include "Materials/Material.h"

MaterialInstance::MaterialInstance(): DataStructure( getNewResultObjectName(), "MATER" ),
                    _jeveuxName( getResultObjectName() ),
                    _materialBehaviourNames( JeveuxVectorChar32( _jeveuxName + ".MATERIAU.NOMRC " ) ),
                    _nbMaterialBehaviour( 0 )
{};

bool MaterialInstance::build() throw( std::runtime_error )
{
    // Recuperation du nombre de GeneralMaterialBehaviourPtr ajoutes par l'utilisateur
    const int nbMCF = _vecMatBehaviour.size();
    if( nbMCF != _vectorOfComplexValues.size() || nbMCF != _vectorOfDoubleValues.size() ||
        nbMCF != _vectorOfChar16Values.size() )
        throw std::runtime_error( "Bad number of material properties" );

    // Creation du vecteur Jeveux ".MATERIAU.NOMRC"
    _materialBehaviourNames->allocate( Permanent, nbMCF );
    int num = 0;
    // Boucle sur les GeneralMaterialBehaviourPtr
    for( VectorOfGeneralMaterialIter curIter = _vecMatBehaviour.begin();
         curIter != _vecMatBehaviour.end();
         ++curIter )
    {
        // Recuperation du nom Aster (ELAS, ELAS_FO, ...) du GeneralMaterialBehaviourPtr
        // sur lequel on travaille
        std::string curStr( (*curIter)->getAsterName().c_str() );
        curStr.resize( 32, ' ' );
        // Recopie dans le ".MATERIAU.NOMRC"
        (*_materialBehaviourNames)[ num ] = curStr.c_str();
        ++num;

        // Construction des objets Jeveux .CPT.XXXXXX.VALR, .CPT.XXXXXX.VALK, ...
        JeveuxVectorComplex& vec1 = _vectorOfComplexValues[ num ];
        JeveuxVectorDouble& vec2 = _vectorOfDoubleValues[ num ];
        JeveuxVectorChar16& vec3 = _vectorOfChar16Values[ num ];
        const bool retour = (*curIter)->buildJeveuxVectors( vec1, vec2, vec3 );
        if ( !retour ) return false;
    }
    return true;
};
