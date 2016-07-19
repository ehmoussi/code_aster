/**
 * @file Driving.cxx
 * @brief Driving implementation
 * @author Natacha Béreux 
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

#include "NonLinear/Driving.h"

const std::vector< DrivingTypeEnum > allDrivingType = { DisplacementValue, DisplacementNorm, JumpOnCrackValue, JumpOnCrackNorm, LimitLoad, MonotonicStrain,  ElasticityLimit };
const std::vector< std::string > allDrivingTypeNames = { "DDL_IMPO", "LONG_ARC", "SAUT_IMPO", "SAUT_LONG_ARC", "ANA_LIM", "DEFORMATION", "PRED_ELAS"  };


const std::vector<SelectionCriterionEnum> allSelectionCriterion = { SmallestDisplacementIncrement, SmallestAngleIncrement, SmallestResidual, MixedCriterion };
const std::vector< std::string > allSelectionCriterionNames = { "NORM_INCR_DEPL", "ANGL_INCR_DEPL", "RESIDU", "MIXTE"}; 

const std::vector< PhysicalQuantityComponent > allDisplacementComponent (std::begin(DisplacementComponents), std::end(DisplacementComponents));
const std::vector< std::string > allDisplacementComponentNames ( ComponentNames, ComponentNames + nbDisplacementComponents); 
