#ifndef PHYSICSANDMODELISATIONS_H_
#define PHYSICSANDMODELISATIONS_H_

/**
 * @file PhysicsAndModelings.h
 * @brief Fichier definissant les physiques et les modelisations disponibles
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

/* person_in_charge: nicolas.sellenet at edf.fr */

/**
 * @enum Physics
 * @brief Physiques existantes dans Code_Aster
 * @author Nicolas Sellenet
 */
enum Physics { Mechanics, Thermal, Acoustic };
const int nbPhysics = 3;
/**
 * @var PhysicNames
 * @brief Nom Aster des differentes physiques disponibles
 */
extern const char *const PhysicNames[nbPhysics];

/**
 * @enum Modelings
 * @brief Modelisations existantes dans Code_Aster
 * @author Nicolas Sellenet
 */
enum Modelings {
    Axisymmetrical,
    Tridimensional,
    TridimensionalAbsorbingBoundary,
    Planar,
    PlaneStrain,
    PlaneStress,
    DKT,
    DKTG,
    PlanarBar
};
const int nbModelings = 9;
/**
 * @var ModelingNames
 * @brief Nom Aster des differentes modelisations disponibles
 */
extern const char *const ModelingNames[nbModelings];

const int nbModelingsMechanics = 8;
extern const Modelings MechanicsModelings[nbModelingsMechanics];

const int nbModelingsThermal = 3;
extern const Modelings ThermalModelings[nbModelingsThermal];

const int nbModelingsAcoustic = 2;
extern const Modelings AcousticModelings[nbModelingsAcoustic];

#endif /* PHYSICSANDMODELISATIONS_H_ */
