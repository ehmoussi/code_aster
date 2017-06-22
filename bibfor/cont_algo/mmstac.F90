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

subroutine mmstac(dist_cont, pres_cont, coef_cont, indi_cont_eval,cycling_type)
!
implicit none
!
#include "asterc/r8prem.h"
!
! person_in_charge: ayaovi-dzifa.kudawoo at edf.fr
!
    real(kind=8), intent(in) :: dist_cont
    real(kind=8), intent(in) :: pres_cont
    real(kind=8), intent(in) :: coef_cont
    integer, intent(out) :: indi_cont_eval
    integer, intent(in), optional :: cycling_type
!
! --------------------------------------------------------------------------------------------------
!
! Contact (continue method)
!
! Evaluate contact status
!
! --------------------------------------------------------------------------------------------------
!
! In  dist_cont        : contact gap
! In  pres_cont        : contact pressure
! In  coef_cont        : augmented ratio for contact
! Out indi_cont_eval   : evaluation of new contact status
!
! --------------------------------------------------------------------------------------------------
!
    real(kind=8) :: laug_cont
!
! --------------------------------------------------------------------------------------------------
!
!
!
! - Augmented lagrangian for contact
!
    laug_cont = pres_cont - coef_cont * dist_cont
!
! - New status of contact (sign of augmented lagrangian)
!
!    if (laug_cont .lt. r8prem()) then
    if (laug_cont .lt. 0.0) then
        indi_cont_eval = 1
        if (present(cycling_type)) then
            if (abs(pres_cont) .lt. abs(-coef_cont*dist_cont) ) then
                    indi_cont_eval = 0
            endif
        endif
    else
        indi_cont_eval = 0
        if (present(cycling_type)) then
            if (abs(dist_cont) .lt. 1.d6*r8prem() ) then
                indi_cont_eval = 1
            endif
        endif
    endif
    
    
!    if (present(cycling_type)) then
!       if (cycling_type .eq. -4)  indi_cont_eval = 0
!       if (cycling_type .eq. -5)  indi_cont_eval = 0
!       if (cycling_type .eq. -6)  indi_cont_eval = 0
!       if (cycling_type .eq. -7)  indi_cont_eval = 0
!       if (cycling_type .eq. -8)  indi_cont_eval = 0
!    endif
    
end subroutine
