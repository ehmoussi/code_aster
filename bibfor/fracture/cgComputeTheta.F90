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
subroutine cgComputeTheta(cgField, cgTheta)
!
use calcG_type
!
    implicit none
!
#include "asterf_types.h"
#include "asterfort/utmess.h"
#include "asterfort/assert.h"
#include "asterfort/gcou2d.h"
!
    type(CalcG_field), intent(in) :: cgField
    type(CalcG_theta), intent(inout) :: cgTheta
!
! --------------------------------------------------------------------------------------------------
!
!     CALC_G --- Utilities
!
!    Compute Theta Field
!
! --------------------------------------------------------------------------------------------------
!
    if(cgField%level_info>1) then
        call utmess('I', 'RUPTURE3_2')
    end if
!
    if (cgField%ndim .eq. 2) then
!
       call gcou2d('G', cgTheta%theta_field, cgTheta%mesh, cgTheta%nomNoeud, cgTheta%fondNoeud(1), &
                    cgTheta%coorNoeud, cgTheta%r_inf, cgTheta%r_sup, ASTER_TRUE)
        cgTheta%nb_theta_field = 1
    elseif (cgField%ndim .eq. 3) then
        !
        ! if(cgTheta%lxfem) then
        !   ASSERT(ASTER_FALSE)
        !     call gcour3(cgTheta%theta, cgTheta%mesh, cgTheta%coorNoeud, cgTheta%nb_fondNoeud, &
        !             trav1, &
        !             trav2, trav3, chfond, cgTheta%l_closed, grlt,&
        !             cgTheta%discretization, basfon, cdTheta%nombre, milieu,&
        !             ndimte, cdTheta%nombre, cgTheta%crack)
        ! else
        !     call gcour2(cgTheta%theta, cgTheta%mesh, cgTheta%nomNoeud, cgTheta%coorNoeud,&
        !             cdTheta%nb_fondNoeud, trav1, trav2, trav3, cgTheta%fon, chfond, basfon,&
        !             cgTheta%crack, cgTheta%l_closed, stok4, cgTheta%discretization,&
        !             cdTheta%nombre, milieu, ndimte, norfon)
        ! end if
!
        cgTheta%nb_theta_field = 0
    else
        ASSERT(ASTER_FALSE)
    endif
!
end subroutine
