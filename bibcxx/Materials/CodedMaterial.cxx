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
