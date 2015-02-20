/**
 * @file PhysicalQuantity.cxx
 * @brief Initialisation de tableaux de coordonnees autorisees
 * @author Natacha Béreux
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



#include "Loads/PhysicalQuantity.h"

const char* ComponentNames[15] = { "DX", "DY", "DZ", "DRX", "DRY", "DRZ", "TEMP", "TEMP_MIL", "PRES", "FX", "FY", "FZ", "MX", "MY","MZ"};

/* Init const data */

/* Force */
const PhysicalQuantityComponent ForceComponents[nbForceComponents] = { Fx, Fy, Fz };
const std::string PhysicalQuantityTraits <Force>::name = "Force"; 
const std::set< PhysicalQuantityComponent > PhysicalQuantityTraits<Force>::components( ForceComponents, ForceComponents + nbForceComponents );

/* ForceAndMomentum */
const PhysicalQuantityComponent ForceAndMomentumComponents[nbForceAndMomentumComponents] = { Fx, Fy, Fz, Mx, My, Mz };
const std::string PhysicalQuantityTraits <ForceAndMomentum>::name = "ForceAndMomentum"; 
const std::set< PhysicalQuantityComponent > PhysicalQuantityTraits<ForceAndMomentum>::components( ForceAndMomentumComponents, ForceAndMomentumComponents + nbForceAndMomentumComponents );

/* Displacement */
const PhysicalQuantityComponent DisplacementComponents[nbDisplacementComponents] = { Dx, Dy, Dz, Dx, Dy, Dz };
const std::string PhysicalQuantityTraits <Displacement>::name = "Displacement"; 
const std::set< PhysicalQuantityComponent > PhysicalQuantityTraits<Displacement>::components( DisplacementComponents, DisplacementComponents + nbDisplacementComponents );

/* Pressure */
const PhysicalQuantityComponent PressureComponents[nbPressureComponents] = { Pres };
const std::string PhysicalQuantityTraits <Pressure>::name = "Pressure"; 
const std::set< PhysicalQuantityComponent > PhysicalQuantityTraits<Pressure>::components( PressureComponents, PressureComponents + nbPressureComponents );

/* Temperature */
const PhysicalQuantityComponent TemperatureComponents[nbTemperatureComponents] = { Temp, MiddleTemp };
const std::string PhysicalQuantityTraits <Temperature>::name = "Temperature"; 
const std::set< PhysicalQuantityComponent > PhysicalQuantityTraits<Temperature>::components( TemperatureComponents, TemperatureComponents + nbTemperatureComponents );
