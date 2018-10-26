! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine mmGetStatus(leltf      , indco      ,&
                       l_previous_, indco_prev_, indadhe_prev_, indadhe2_prev_)
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/jevech.h"
!
aster_logical, intent(in) :: leltf
integer, intent(out) :: indco
aster_logical, optional, intent(out) :: l_previous_
integer, optional, intent(out) :: indco_prev_, indadhe_prev_, indadhe2_prev_
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Elementary computations
!
! Get status
!
! --------------------------------------------------------------------------------------------------
!
! In  leltf            : flag for friction
! Out l_previous       : flag to manage cycling (previous iteration)
! Out indco            : flag for contact status
! Out indco_prev       : flag for contact status (previous iteration)
! Out indadhe_prev
! Out indadhe2_prev
!
! --------------------------------------------------------------------------------------------------
!
    integer :: jpcf
    aster_logical :: l_previous_cont, l_previous_fric, l_previous
    integer :: indco_prev, indadhe_prev, indadhe2_prev
!
! --------------------------------------------------------------------------------------------------
!
    call jevech('PCONFR', 'L', jpcf)
    l_previous_cont = (nint(zr(jpcf-1+30)) .eq. 1)
    l_previous_fric = (nint(zr(jpcf-1+44)) .eq. 1)
    if (leltf) then
        l_previous = l_previous_fric
    else
        l_previous = l_previous_cont
    endif
    indco         = nint(zr(jpcf-1+12))
    indco_prev    = nint(zr(jpcf-1+27))
    indadhe_prev  = nint(zr(jpcf-1+44))
    indadhe2_prev = nint(zr(jpcf-1+47))
    if (present(l_previous_)) l_previous_ = l_previous
    if (present(indco_prev_)) indco_prev_ = indco_prev
    if (present(indadhe_prev_)) indadhe_prev_ = indadhe_prev
    if (present(indadhe2_prev_)) indadhe2_prev_ = indadhe2_prev
!
end subroutine
