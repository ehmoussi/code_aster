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

const char* ComponentNames[nbComponent] = { "DX", "DY", "DZ", "DRX", "DRY", "DRZ", "TEMP", "TEMP_MIL", "PRES", "FX", "FY", "FZ", "MX", "MY","MZ",
 "N", "VY", "VZ", "MT", "MFY", "MFZ", "F1", "F2", "F3", "MF1", "MF2", "IMPE", "VNOR", "FLUN", "FLUN_HYDR1", "FLUN_HYDR2"};

/* Init const data */

/* Force */
const PhysicalQuantityComponent ForceComponents[nbForceComponents] = { Fx, Fy, Fz };
const std::string PhysicalQuantityTraits <Force>::name = "Force"; 
const std::set< PhysicalQuantityComponent > PhysicalQuantityTraits<Force>::components( ForceComponents, ForceComponents + nbForceComponents );

/* StructuralForce */
const PhysicalQuantityComponent StructuralForceComponents[nbStructuralForceComponents] = { Fx, Fy, Fz, Mx, My, Mz };
const std::string PhysicalQuantityTraits <StructuralForce>::name = "StructuralForce"; 
const std::set< PhysicalQuantityComponent > PhysicalQuantityTraits<StructuralForce>::components( StructuralForceComponents, StructuralForceComponents + nbStructuralForceComponents );

/* LocalBeamForce */
const PhysicalQuantityComponent LocalBeamForceComponents[nbLocalBeamForceComponents] = { N, Vy, Vz, Mt, Mfy, Mfz };
const std::string PhysicalQuantityTraits <LocalBeamForce>::name = "LocalBeamForce"; 
const std::set< PhysicalQuantityComponent > PhysicalQuantityTraits<LocalBeamForce>::components( LocalBeamForceComponents, LocalBeamForceComponents + nbLocalBeamForceComponents );

/* LocalShellForce */
const PhysicalQuantityComponent LocalShellForceComponents[nbLocalShellForceComponents] = { F1, F2, F3, Mf1, Mf2 };
const std::string PhysicalQuantityTraits <LocalShellForce>::name = "LocalShellForce"; 
const std::set< PhysicalQuantityComponent > PhysicalQuantityTraits<LocalShellForce>::components( LocalShellForceComponents, LocalShellForceComponents + nbLocalShellForceComponents );

/* Displacement */
const PhysicalQuantityComponent DisplacementComponents[nbDisplacementComponents] = { Dx, Dy, Dz, Drx, Dry, Drz };
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

/* Impedance */
const PhysicalQuantityComponent ImpedanceComponents[nbImpedanceComponents] = { Impe };
const std::string PhysicalQuantityTraits <Impedance>::name = "Impedance"; 
const std::set< PhysicalQuantityComponent > PhysicalQuantityTraits<Impedance>::components( ImpedanceComponents, ImpedanceComponents + nbImpedanceComponents );

/* NormalSpeed */
const PhysicalQuantityComponent NormalSpeedComponents[nbNormalSpeedComponents] = { Impe };
const std::string PhysicalQuantityTraits <NormalSpeed>::name = "NormalSpeed"; 
const std::set< PhysicalQuantityComponent > PhysicalQuantityTraits<NormalSpeed>::components( NormalSpeedComponents, NormalSpeedComponents + nbNormalSpeedComponents );

/* HeatFlux */
const PhysicalQuantityComponent HeatFluxComponents[nbHeatFluxComponents] = { Flun };
const std::string PhysicalQuantityTraits <HeatFlux>::name = "HeatFlux"; 
const std::set< PhysicalQuantityComponent > PhysicalQuantityTraits<HeatFlux>::components( HeatFluxComponents, HeatFluxComponents + nbHeatFluxComponents );

/* HydraulicFlux */
const PhysicalQuantityComponent HydraulicFluxComponents[nbHydraulicFluxComponents] = { FlunHydr1, FlunHydr2 };
const std::string PhysicalQuantityTraits <HydraulicFlux>::name = "HydraulicFlux"; 
const std::set< PhysicalQuantityComponent > PhysicalQuantityTraits<HydraulicFlux>::components( HydraulicFluxComponents, HydraulicFluxComponents + nbHydraulicFluxComponents );
