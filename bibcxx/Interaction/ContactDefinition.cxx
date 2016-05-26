/**
 * @file ContactDefinition.cxx
 * @brief Implementation de ContactDefinition
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

#include "Interaction/ContactDefinition.h"

const std::vector< ContactFormulationEnum > allContactFormulation = { Discretized, Continuous,
                                                                      Xfem, UnilateralConnexion };
const std::vector< std::string > allContactFormulationNames = { "DISCRET", "CONTINUE", "XFEM", "LIAISON_UNIL" };

const std::vector< FrictionEnum > allFrictionParameters = { Coulomb, WithoutFriction };
const std::vector< std::string > allFrictionParametersNames = { "COULOMB", "SANS" };

const std::vector< GeometricResolutionAlgorithmEnum > allGeometricResolutionAlgorithm = { FixPoint, Newton };
const std::vector< std::string > allGeometricResolutionAlgorithmNames = { "POINT_FIXE", "NEWTON" };

const std::vector< GeometricUpdateEnum > allGeometricUpdate = { Auto, Controlled, WithoutGeometricUpdate };
const std::vector< std::string > allGeometricUpdateNames = { "AUTOMATIQUE", "CONTROLE", "SANS" };

const std::vector< ContactPrecondEnum > allContactPrecond = { Dirichlet, WithoutPrecond };
const std::vector< std::string > allContactPrecondNames = { "DIRICHLET", "SANS" };
