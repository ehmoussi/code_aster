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

subroutine thmMatrHooke(angl_naut)
!
use THM_type
use THM_module
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/matrHooke3d.h"
!
!
    real(kind=8), intent(in) :: angl_naut(3)

!
! --------------------------------------------------------------------------------------------------
!
! THM
!
! Compute Hooke elastic matrix
!
! --------------------------------------------------------------------------------------------------
!
! In  angl_naut        : nautical angles
!                        (1) Alpha - clockwise around Z0
!                        (2) Beta  - counterclockwise around Y1
!                        (1) Gamma - clockwise around X
!
! --------------------------------------------------------------------------------------------------
!
    real(kind=8) :: repere(7)
!
! --------------------------------------------------------------------------------------------------
!
    repere(:) = 0.d0
    repere(1) = 1.d0
    repere(2) = angl_naut(1)
    repere(3) = angl_naut(2)
    repere(4) = angl_naut(3)
!
! - Compute matrix
!
    call matrHooke3d(ds_thm%ds_material%elas%id, repere,&
                     ds_thm%ds_material%elas%e ,&
                     ds_thm%ds_material%elas%nu,&
                     ds_thm%ds_material%elas%g,&
                     e1 = ds_thm%ds_material%elas%e_l,&
                     e2 = ds_thm%ds_material%elas%e_t,&
                     e3 = ds_thm%ds_material%elas%e_n,&
                     nu12 = ds_thm%ds_material%elas%nu_lt,&
                     nu13 = ds_thm%ds_material%elas%nu_ln,&
                     nu23 = ds_thm%ds_material%elas%nu_tn,&
                     g1 = ds_thm%ds_material%elas%g_lt,&
                     g2 = ds_thm%ds_material%elas%g_ln,&
                     g3 = ds_thm%ds_material%elas%g_tn,&
                     matr_elas = ds_thm%ds_material%elas%d)
!
end subroutine
