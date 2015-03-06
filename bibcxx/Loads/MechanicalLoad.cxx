/**
 * @file MechanicalLoad.cxx
 * @brief Implementation de MechanicalLoad
 * @author Natacha Bereux
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

#include "Loads/MechanicalLoad.h"

const std::string LoadTraits< NodalForce >::factorKeyword = "FORCE_NODALE";

const std::string LoadTraits< ForceOnFace >::factorKeyword = "FORCE_FACE";

const std::string LoadTraits< ForceOnEdge >::factorKeyword = "FORCE_ARETE";

const std::string LoadTraits< LineicForce >::factorKeyword = "FORCE_CONTOUR";

const std::string LoadTraits< InternalForce >::factorKeyword = "FORCE_INTERNE";

const std::string LoadTraits< ForceOnBeam >::factorKeyword = "FORCE_POUTRE";

const std::string LoadTraits< ForceOnShell >::factorKeyword = "FORCE_COQUE";

const std::string LoadTraits< ImposedDoF >::factorKeyword = "DDL_IMPO";

const std::string LoadTraits< DistributedPressure >::factorKeyword = "PRES_REP"; 

const std::string LoadTraits< ImpedanceOnFace >::factorKeyword = "IMPE_FACE";

const std::string LoadTraits< NormalSpeedOnFace >::factorKeyword = "VITE_FACE";

const std::string LoadTraits< WavePressureOnFace >::factorKeyword = "ONDE_FLUI";
