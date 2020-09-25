/**
 * @file MPIInfos.cxx
 * @brief Implementation de ParallelMeshClass
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

/* person_in_charge: nicolas.pignet at edf.fr */


#include "aster_fort_material.h"

#include "Materials/create_enthalpy.h"


bool create_enthalpy(const FunctionPtr &rho_cp_func, const FunctionPtr &beta_func)
{
    const std::string name_in = (*rho_cp_func).getName();
    const std::string name_out = (*beta_func).getName();

    CALLO_CREATE_ENTHALPY( name_in, name_out );
};
