! --------------------------------------------------------------------
! Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
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
!
#include "asterf_types.h"
!
interface
    subroutine char_xfem(mesh, model, l_xfem, connex_inv, ch_xfem_stat, &
                         ch_xfem_node, ch_xfem_lnno, ch_xfem_ltno, ch_xfem_heav)
        character(len=8), intent(in) :: mesh
        character(len=8), intent(in) :: model
        aster_logical, intent(out) :: l_xfem
        character(len=19), intent(out) :: connex_inv
        character(len=19), intent(out) :: ch_xfem_node
        character(len=19), intent(out) :: ch_xfem_stat
        character(len=19), intent(out) :: ch_xfem_lnno
        character(len=19), intent(out) :: ch_xfem_ltno
        character(len=19), intent(out) :: ch_xfem_heav
    end subroutine char_xfem
end interface
