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
subroutine mmGetStatus(option    ,&
                       l_previous, indco, indco_prev, indadhe_prev, indadhe2_prev)
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/jevech.h"
!
character(len=16), intent(in) :: option
aster_logical, intent(out) :: l_previous
integer, intent(out) :: indco, indco_prev, indadhe_prev, indadhe2_prev
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Elementary computations
!
! Get status
!
! --------------------------------------------------------------------------------------------------
!
! In  option           : option to compute
! Out l_previous       : flag to manage cycling (previous iteration)
! Out indco            : flag for contact status
! Out indco_prev       : flag for contact status (previous iteration)
! Out indadhe_prev
! Out indadhe2_prev
!
! --------------------------------------------------------------------------------------------------
!
    integer :: jpcf
    aster_logical :: l_previous_cont, l_previous_fric
!
! --------------------------------------------------------------------------------------------------
!
    call jevech('PCONFR', 'L', jpcf)
    l_previous_cont = (nint(zr(jpcf-1+30)) .eq. 1 )
    l_previous_fric = (nint(zr(jpcf-1+44)) .eq. 1 )
    if (option .eq. 'RIGI_CONT') l_previous = l_previous_cont
    if (option .eq. 'RIGI_FROT') l_previous = l_previous_fric
    indco         = nint(zr(jpcf-1+12))
    indco_prev    = nint(zr(jpcf-1+27))
    indadhe_prev  = nint(zr(jpcf-1+44))
    indadhe2_prev = nint(zr(jpcf-1+47))
!
end subroutine
