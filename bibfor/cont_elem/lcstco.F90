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
!
subroutine lcstco(l_previous, l_upda_jaco  ,&
                  lagrc_prev, lagrc_curr   ,&
                  gap_prev  , gap_curr     ,&
                  indi_cont , l_norm_smooth)
!
implicit none
!
#include "jeveux.h"
#include "asterfort/jevech.h"
#include "asterf_types.h"
!
aster_logical, intent(out) :: l_previous
real(kind=8), intent(out) :: lagrc_curr, lagrc_prev
real(kind=8), intent(out) :: gap_curr, gap_prev
aster_logical, intent(out) :: l_upda_jaco
integer, intent(out) :: indi_cont
aster_logical, intent(out) :: l_norm_smooth
!
! --------------------------------------------------------------------------------------------------
!
! Contact (LAC) - Elementary computations
!
! Get indicators
!
! --------------------------------------------------------------------------------------------------
!
! Out l_upda_jaco      : .true. to use updated jacobian
! Out l_previous       : .true. to get previous parameters
! Out indi_cont        : contact indicator
!                        -1 No pairing
!                         0 Paired - No contact
!                        +1 Paired - Contact
! Out lagrc_curr       : current value of contact lagrangian
! Out lagrc_prev       : previous value of contact lagrangian
! Out gap_curr         : current value of gap
! Out gap_prev         : previous value of gap
! Out l_norm_smooth    : indicator for normals smoothing
!
! --------------------------------------------------------------------------------------------------
!
    integer :: jpcf
!
! --------------------------------------------------------------------------------------------------
!
    call jevech('PCONFR', 'L', jpcf)
!
    l_previous     = nint(zr(jpcf-1+10 )) .eq. 1
    lagrc_prev     =     (zr(jpcf-1+13+25))
    gap_prev       =     (zr(jpcf-1+15+25)) 
    indi_cont      = nint(zr(jpcf-1+12))
    lagrc_curr     =     (zr(jpcf-1+13))
    l_upda_jaco    = nint(zr(jpcf-1+2 )) .eq. 1
    gap_curr       =     (zr(jpcf-1+15))
    l_norm_smooth  = nint(zr(jpcf-1+1)) .eq. 1
! On s'assure que le patch n'a pas change de maille maitre. 
    l_previous     = l_previous  .and. (nint(zr(jpcf-1+28 )) .eq. 1)
!
end subroutine
