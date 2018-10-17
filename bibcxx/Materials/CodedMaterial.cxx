/**
 * @file CodedMaterial.cxx
 * @brief Implementation de CodedMaterialInstance
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2017  EDF R&D                www.code-aster.org
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

#include "Materials/CodedMaterial.h"
#include "aster_fort.h"

CodedMaterialInstance::CodedMaterialInstance( const MaterialOnMeshPtr& mater,
                                              const ModelPtr& model ):
    _name( mater->getName() ),
    _type( "MATER_CODE" ),
    _mater( mater ),
    _model( model ),
    _field( new PCFieldOnMeshLongInstance( getName() + ".MATE_CODE",
                                           _model->getSupportMesh(),
                                           Permanent ) ),
    _grp( JeveuxVectorChar8( getName() + ".MATE_CODE.GRP" ) ),
    _nGrp( JeveuxVectorLong( getName() + ".MATE_CODE.NGRP" ) )
{};

bool CodedMaterialInstance::allocate()
{
    if( _field->exists() ) return false;
    std::string blanc( 24, ' ' );
    std::string materName = _mater->getName();
    materName.resize(24, ' ');
    std::string mate = blanc;
    ASTERINTEGER thm = 0;
    if( _model->existsThm() ) thm = 1;
    std::string strJeveuxBase( "G" );
    CALLO_RCMFMC_WRAP( materName, mate, &thm, getName(), strJeveuxBase );

    auto vecOfMater = _mater->getVectorOfMaterial();
    int compteur = 0;
    for( auto curIter : vecOfMater )
    {
        std::string nameWithoutBlanks = trim( curIter->getName() ) + ".0";
        std::string base( " " );
        ASTERINTEGER pos = 1;
        ASTERINTEGER nbval2 = 0;
        ASTERINTEGER retour = 0;
        JeveuxChar24 nothing( " " );
        CALLO_JELSTC( base, nameWithoutBlanks, &pos,
                      &nbval2, nothing, &retour );
        if ( retour != 0 )
        {
            JeveuxVectorChar24 test( "&&TMP" );
            test->allocate( Temporary, -retour );
            ASTERINTEGER nbval2 = -retour;
            CALLO_JELSTC( base, nameWithoutBlanks, &pos,
                        &nbval2, (*test)[0], &retour );
            for( int i = 0; i < retour; ++i )
            {
                std::string name = (*test)[i].toString();
                std::string name2( name, 19, 5 );
                if( name2 == ".CODI" )
                    _vecOfCodiVectors.push_back( JeveuxVectorLong( name ) );
            }
        }
    }
    return true;
};

bool CodedMaterialInstance::constant() const
{
    const std::string typeco( "CHAM_MATER" );
    ASTERINTEGER repi = 0, ier = 0;
    JeveuxChar32 repk(" ");
    const std::string arret( "C" );
    const std::string questi( "ELAS_FO" );

    CALLO_DISMOI( questi, _mater->getName(), typeco,
                  &repi, repk, arret, &ier );
    auto retour = trim( repk.toString() );
    if( retour == "OUI" ) return false;
    return true;
};
