! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
! This file is part of code_aster.
!
! code_aster is free software: you can redistribute it and/or modify
! it under the terms of the GNU General Public License as published by
! the Free Software Foundation, either version 3 of the License, or
! (at your option) any later version.
!
! code_aster is distributed in the hope that it will be useful,
! but WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
! GNU General Public License for more details.
!
! You should have received a copy of the GNU General Public License
! along with code_aster.  If not, see <http://www.gnu.org/licenses/>.
! --------------------------------------------------------------------
!
! person_in_charge: nicolas.pignet at edf.fr
!
function isParallelMesh(mesh) result(l_parallel_mesh)
!
    implicit none
!
#include "asterf_types.h"
#include "asterfort/gettco.h"
!
    character(len=*), intent(in) :: mesh
    aster_logical                :: l_parallel_mesh
!
!---------------------------------------------------------------------------------------------------
!   But :
!     To know if the mesh is parallel_mesh
!
!   IN:
!     mesh      : name of the mesh
!
!   OUT:
!     l_parallel_mesh : the mesh is a parallel_mesh ?
!
!---------------------------------------------------------------------------------------------------
    character(len=16) :: mesh_type
    character(len=8) :: meshz
!-----------------------------------------------------------------------
!
    meshz = mesh
    call gettco(meshz, mesh_type)
!
    if (mesh_type .eq. 'MAILLAGE_P') then
        l_parallel_mesh = ASTER_TRUE
    else
        l_parallel_mesh = ASTER_FALSE
    end if
!
end function
