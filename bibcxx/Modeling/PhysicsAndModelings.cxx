/**
 * @file PhysicsAndModelings.cxx
 * @brief Initialisation des modelisations autorisees pour chaque physique
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2020  EDF R&D                www.code-aster.org
 *
 *   This file is part of Code_Aster.
 *
 *   Code_Aster is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 3 of the License, or
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

#include "PhysicsAndModelings.h"

const char *const PhysicNames[nbPhysics] = {"MECANIQUE", "THERMIQUE", "ACOUSTIQUE"};
const char *const ModelingNames[nbModelings] = {"AXIS",   "3D",  "3D_ABSO", "PLAN",    "D_PLAN",
                                                "C_PLAN", "DKT", "DKTG",    "2D_BARRE"};

const Modelings MechanicsModelings[nbModelingsMechanics] = {
    Axisymmetrical, Tridimensional, TridimensionalAbsorbingBoundary, PlaneStrain,
    PlaneStress,    DKT,            DKTG,                            PlanarBar};

const Modelings ThermalModelings[nbModelingsThermal] = {Axisymmetrical, Tridimensional, Planar};

const Modelings AcousticModelings[nbModelingsAcoustic] = {Tridimensional, Planar};
