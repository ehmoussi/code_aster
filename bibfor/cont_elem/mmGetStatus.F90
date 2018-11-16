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
subroutine mmGetStatus(indco       ,&
                       l_prev_cont_, l_prev_fric_ ,&
                       indco_prev_ , indadhe_prev_, indadhe2_prev_)
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/jevech.h"
!
integer, intent(out) :: indco
aster_logical, optional, intent(out) :: l_prev_cont_, l_prev_fric_
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
! Out l_prev_cont      : flag to manage cycling (previous iteration) - Contact
! Out l_prev_fric      : flag to manage cycling (previous iteration) - Friction
! Out indco            : flag for contact status
! Out indco_prev       : flag for contact status (previous iteration)
! Out indadhe_prev
! Out indadhe2_prev
!
! --------------------------------------------------------------------------------------------------
!
    integer :: jpcf
    aster_logical :: l_prev_cont, l_prev_fric
    integer :: indco_prev, indadhe_prev, indadhe2_prev
!
! --------------------------------------------------------------------------------------------------
!
    call jevech('PCONFR', 'L', jpcf)
    l_prev_cont   = (nint(zr(jpcf-1+30)) .eq. 1)
    l_prev_fric   = (nint(zr(jpcf-1+44)) .eq. 1)
    indco         = nint(zr(jpcf-1+12))
    indco_prev    = nint(zr(jpcf-1+27))
    indadhe_prev  = nint(zr(jpcf-1+44))
    indadhe2_prev = nint(zr(jpcf-1+47))
    if (present(l_prev_cont_))   l_prev_cont_ = l_prev_cont
    if (present(l_prev_fric_))   l_prev_fric_ = l_prev_fric
    if (present(indco_prev_))    indco_prev_ = indco_prev
    if (present(indadhe_prev_))  indadhe_prev_ = indadhe_prev
    if (present(indadhe2_prev_)) indadhe2_prev_ = indadhe2_prev
!
end subroutine
