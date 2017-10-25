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

subroutine lcstco(algo_reso_geom, indi_cont, l_upda_jaco, lagrc_,&
            gap_curr, mesure, rho_n, eval,l_previous)
!
implicit none
!
#include "jeveux.h"
#include "asterfort/jevech.h"
#include "asterf_types.h"
!
    integer, intent(out) :: algo_reso_geom
    integer, intent(out) :: indi_cont
    aster_logical, intent(out) :: l_upda_jaco
    aster_logical, intent(in) :: l_previous
    real(kind=8), optional, intent(out) :: lagrc_
    real(kind=8), intent(out) :: gap_curr
    real(kind=8), intent(out) :: mesure
    real(kind=8), intent(out) :: rho_n
    real(kind=8), intent(out) :: eval
!
! --------------------------------------------------------------------------------------------------
!
! Contact (LAC) - Elementary computations
!
! Get indicators
!
! --------------------------------------------------------------------------------------------------
!
! Out indi_cont        : contact indicator
!                        -1 No pairing
!                         0 Paired - No contact
!                        +1 Paired - Contact
! Out algo_reso_geom   : algorithm for geometry loop
!                         0 - fixed point
!                         1 - Newton
! Out l_upda_jaco      : .true. to use updated jacobian
! Out lagrc            : value of contact lagrangian
!
! --------------------------------------------------------------------------------------------------
!
    integer :: jpcf
    real(kind=8) :: lagrc
!
! --------------------------------------------------------------------------------------------------
!
    call jevech('PCONFR', 'L', jpcf)
    algo_reso_geom = nint(zr(jpcf-1+25))
    
    if(l_previous) then 
       indi_cont      = nint(zr(jpcf-1+12+25))
       lagrc          =     (zr(jpcf-1+13+25))
       l_upda_jaco    = nint(zr(jpcf-1+2+25 )).eq.1
       mesure         =     (zr(jpcf-1+16+25))
       rho_n          =     (zr(jpcf-1+17+25))
       eval           =     (zr(jpcf-1+18+25))
       gap_curr       =     (zr(jpcf-1+15+25))   
    else 
       indi_cont      = nint(zr(jpcf-1+12))
       lagrc          =     (zr(jpcf-1+13))
       l_upda_jaco    = nint(zr(jpcf-1+2 )).eq.1
       mesure         =     (zr(jpcf-1+16))
       rho_n          =     (zr(jpcf-1+17))
       eval           =     (zr(jpcf-1+18))
       gap_curr       =     (zr(jpcf-1+15))  
    end if 
    if (present(lagrc_)) then
        lagrc_ = lagrc
    endif
!
end subroutine
