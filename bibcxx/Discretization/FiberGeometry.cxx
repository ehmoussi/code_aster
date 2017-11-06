/**
 * @file FiberGeometry.cxx
 * @brief Implementation de FiberGeometryInstance
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2016  EDF R&D                www.code-aster.org
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

#include "Discretization/FiberGeometry.h"
#include "Supervis/ResultNaming.h"

FiberGeometryInstance::FiberGeometryInstance():
    DataStructure( ResultNaming::getNewResultName(), "GFIBRE" ),
    _nomsGroupes( JeveuxBidirectionalMapChar24( getName() + ".NOMS_GROUPES" ) ),
    _nbFibreGroupe( JeveuxVectorLong( getName() + ".NB_FIBRE_GROUPE" ) ),
    _pointeur( JeveuxVectorLong( getName() + ".POINTEUR" ) ),
    _typeGroupe( JeveuxVectorLong( getName() + ".TYPE_GROUPE" ) ),
    _carfi( JeveuxVectorDouble( getName() + ".CARFI" ) ),
    _gfma( JeveuxVectorChar8( getName() + ".GFMA" ) ),
    _caracsd( JeveuxVectorLong( getName() + ".CARACSD" ) ),
    _isEmpty( true )
{};