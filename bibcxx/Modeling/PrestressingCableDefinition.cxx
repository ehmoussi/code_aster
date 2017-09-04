/**
 * @file PrestressingCableDefinition.cxx
 * @brief Implementation de PrestressingCableDefinitionInstance
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 20146 EDF R&D                www.code-aster.org
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

#include "Modeling/PrestressingCableDefinition.h"

PrestressingCableDefinitionInstance::PrestressingCableDefinitionInstance():
    DataStructure( getNewResultObjectName(), "CABL_PRECONT" ),
    _sigin( new PCFieldOnMeshInstanceDouble( getName() + ".CHME.SIGIN" ) ),
    _cableBP( new TableInstance( getName() + "CABLEBP    " ) ),
    _cableGL( new TableInstance( getName() + "CABLEGL    " ) ),
    _lirela( new ListOfLinearRelationsDouble( getName() + ".LIRELA    " ) ),
    _isEmpty( true )
{};