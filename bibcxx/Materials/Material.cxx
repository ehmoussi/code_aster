/**
 * @file Material.cxx
 * @brief Implementation de MaterialInstance
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2018  EDF R&D                www.code-aster.org
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

#include "Supervis/ResultNaming.h"
#include "Materials/Material.h"
#include "Supervis/ResultNaming.h"

void MaterialInstance::addMaterialBehaviour( const GeneralMaterialBehaviourPtr& curMaterBehav )
{
    ++_nbMaterialBehaviour;

    std::ostringstream numString;
    numString << std::setw( 6 ) << std::setfill( '0' ) << _nbMaterialBehaviour;
    const std::string currentName = _jeveuxName + ".CPT." + numString.str();
    _vectorOfComplexValues.push_back( JeveuxVectorComplex( currentName + ".VALC" ) );
    _vectorOfDoubleValues.push_back( JeveuxVectorDouble( currentName + ".VALR" ) );
    _vectorOfChar16Values.push_back( JeveuxVectorChar16( currentName + ".VALK" ) );
    _vectorOrdr.push_back( JeveuxVectorChar16( currentName + ".ORDR" ) );
    _vectorKOrdr.push_back( JeveuxVectorLong( currentName + ".KORD" ) );

    auto test1 = curMaterBehav->hasVectorOfDoubleParameters();
    auto test2 = curMaterBehav->hasVectorOfFunctionParameters();
    const auto cP = _vectorOfUserDoubleValues.size();
    _vectorOfUserDoubleValues.push_back( VectorOfJeveuxVectorDouble() );
    _vectorOfUserFunctionValues.push_back( VectorOfJeveuxVectorChar8() );
    if( test1 || test2 )
    {
        const int num1 = curMaterBehav->getNumberOfListOfDoubleProperties();
        const int num2 = curMaterBehav->getNumberOfListOfFunctionProperties();
        const int numTot = num1 + num2;
        for( int pos = 0; pos < numTot; ++pos )
        {
            ++_nbUserMaterialBehaviour;
            std::ostringstream numUser2;
            numUser2 << std::setw( 7 ) << std::setfill( '0' ) << _nbUserMaterialBehaviour;
            std::string currentName2 = _jeveuxName + "." + numUser2.str() + ".LISV_R8";
            auto o1 = JeveuxVectorDouble( currentName2 );
            _vectorOfUserDoubleValues[cP].push_back( o1 );
            std::string currentName3 = _jeveuxName + "." + numUser2.str() + ".LISV_FO";
            auto o2 = JeveuxVectorChar8( currentName3 );
            _vectorOfUserFunctionValues[cP].push_back( o2 );
        }
    }
    else
    {
        ++_nbUserMaterialBehaviour;
        auto o1 = JeveuxVectorDouble( "EMPTY" );
        _vectorOfUserDoubleValues[cP].push_back( o1 );
        auto o2 = JeveuxVectorChar8( "EMPTY" );
        _vectorOfUserFunctionValues[cP].push_back( o2 );
    }

    _vecMatBehaviour.push_back( curMaterBehav );
};

bool MaterialInstance::build() {
    // Recuperation du nombre de GeneralMaterialBehaviourPtr ajoutes par l'utilisateur
    const int nbMCF = _vecMatBehaviour.size();
    if ( nbMCF != _vectorOfComplexValues.size() || nbMCF != _vectorOfDoubleValues.size() ||
         nbMCF != _vectorOfChar16Values.size() )
        throw std::runtime_error( "Bad number of material properties" );

    // Creation du vecteur Jeveux ".MATERIAU.NOMRC"
    _materialBehaviourNames->allocate( Permanent, nbMCF );
    int num = 0;
    // Boucle sur les GeneralMaterialBehaviourPtr
    for ( const auto &curIter : _vecMatBehaviour ) {
        // Recuperation du nom Aster (ELAS, ELAS_FO, ...) du GeneralMaterialBehaviourPtr
        // sur lequel on travaille
        std::string curStr;
        if ( curIter->getAsterNewName() == "" )
            curStr = std::string( curIter->getAsterName().c_str() );
        else
            curStr = std::string( curIter->getAsterNewName().c_str() );
        curStr.resize( 32, ' ' );
        // Recopie dans le ".MATERIAU.NOMRC"
        ( *_materialBehaviourNames )[num] = curStr.c_str();

        // Construction des objets Jeveux .CPT.XXXXXX.VALR, .CPT.XXXXXX.VALK, ...
        JeveuxVectorComplex &vec1 = _vectorOfComplexValues[num];
        JeveuxVectorDouble &vec2 = _vectorOfDoubleValues[num];
        JeveuxVectorChar16 &vec3 = _vectorOfChar16Values[num];
        JeveuxVectorChar16 &vec4 = _vectorOrdr[num];
        JeveuxVectorLong &vec5 = _vectorKOrdr[num];
        auto &vec6 = _vectorOfUserDoubleValues[num];
        auto &vec7 = _vectorOfUserFunctionValues[num];
        const bool retour = curIter->buildJeveuxVectors( vec1, vec2, vec3, vec4, vec5, vec6, vec7 );
        const bool retour2 = curIter->buildTractionFunction( _doubleValues );
        if ( !retour )
            return false;
        ++num;
    }
    return true;
};
