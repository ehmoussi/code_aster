/**
 * @file PhysicalQuantity.cxx
 * @brief Initialisation de tableaux de coordonnees autorisees
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

#include "Loads/PhysicalQuantity.h"

const char* AsterCoordinatesNames[9] = { "DX", "DY", "DZ", "DRX", "DRY", "DRZ", "TEMP", "TEMP_MIL", "PRES" };

const AsterCoordinates DeplCoordinates[nbDisplacementCoordinates] = { Dx, Dy, Dz, Drx, Dry, Drz };

const AsterCoordinates TempCoordinates[nbThermalCoordinates] = { Temperature, MiddleTemperature };

const AsterCoordinates PresCoordinates[nbPressureCoordinates] = { Pressure };

const set< AsterCoordinates >WrapDepl::setOfCoordinates( DeplCoordinates, DeplCoordinates + nbDisplacementCoordinates );

const set< AsterCoordinates >WrapTemp::setOfCoordinates( TempCoordinates, TempCoordinates + nbThermalCoordinates );

const set< AsterCoordinates >WrapPres::setOfCoordinates( PresCoordinates, PresCoordinates + nbPressureCoordinates );
