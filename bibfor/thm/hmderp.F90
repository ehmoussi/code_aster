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
! person_in_charge: sylvie.granet at edf.fr
! aslint: disable=W1504
!
subroutine hmderp(yavp  , t     ,&
                  pvp   , pad   ,&
                  rho11 , rho12 , h11  , h12,&
                  dp11p1, dp11p2, dp11t,&
                  dp12p1, dp12p2, dp12t,&
                  dp21p1, dp21p2, dp21t,&
                  dp22p1, dp22p2, dp22t,&
                  dp1pp1, dp2pp1, dtpp1,&
                  dp1pp2, dp2pp2, dtpp2,&
                  dp1pt , dp2pt , dtpt)
!
use THM_type
use THM_module
!
implicit none
!
#include "asterf_types.h"
!
aster_logical, intent(in) :: yavp
real(kind=8), intent(in) :: t, pvp, pad
real(kind=8), intent(in) :: rho11, rho12, h11, h12
real(kind=8), intent(out) :: dp11p1, dp11p2, dp11t
real(kind=8), intent(out) :: dp12p1, dp12p2, dp12t
real(kind=8), intent(out) :: dp21p1, dp21p2, dp21t
real(kind=8), intent(out) :: dp22p1, dp22p2, dp22t
real(kind=8), intent(out) :: dp1pp1(2), dp2pp1(2), dtpp1(2)
real(kind=8), intent(out) :: dp1pp2(2), dp2pp2(2), dtpp2(2)
real(kind=8), intent(out) :: dp1pt(2), dp2pt(2), dtpt(2)
!
! --------------------------------------------------------------------------------------------------
!
! THM
!
! Compute some derivatives for LIQU_AD_GAZ_VAPE and LIQU_AD_GAZ
!
! --------------------------------------------------------------------------------------------------
!
! In  yavp             : flag for steam
! In  t                : temperature - At end of current step
! In  pvp              : steam pressure
! In  pad              : dissolved air pressure
! In  rho11            : current volumic mass of liquid
! In  rho12            : current volumic mass of steam
! In  h11              : enthalpy of liquid
! In  h12              : enthalpy of steam
! Out dp11p1           : derivative of P11 by P1
! Out dp11p2           : derivative of P11 by P2
! Out dp11t            : derivative of P11 by T
! Out dp12p1           : derivative of P12 by P1
! Out dp12p2           : derivative of P12 by P2
! Out dp12t            : derivative of P12 by T
! Out dp21p1           : derivative of P21 by P1
! Out dp21p2           : derivative of P21 by P2
! Out dp21t            : derivative of P21 by T
! Out dp22p1           : derivative of P22 by P1
! Out dp22p2           : derivative of P22 by P2
! Out dp22t            : derivative of P22 by T
! Out dp1pp1           : second derivative of P1 by P1²
! Out dp2pp1           : second derivative of P2 by P1²
! Out dtpp1            : second derivative of T by P1²
! Out dp1pp2           : second derivative of P1 by P2²
! Out dp2pp2           : second derivative of P2 by P2²
! Out dtpp2            : second derivative of T by P2²
! Out dp1pt            : derivative of P1 by T
! Out dp2pt            : derivative of P2 by T
! Out dtpt             : derivative of T by T
!
! --------------------------------------------------------------------------------------------------
!
    real(kind=8) :: cliq, alpliq, rgaz, kh
    real(kind=8) :: a1, a2, a3, a4, l
    real(kind=8), parameter :: zero = 0.d0
!
! --------------------------------------------------------------------------------------------------
!
    dp11p1 = zero
    dp11p2 = zero
    dp11t  = zero
    dp12p1 = zero
    dp12p2 = zero
    dp12t  = zero
    dp21p1 = zero
    dp21p2 = zero
    dp21t  = zero
    dp22p1 = zero
    dp22p2 = zero
    dp22t  = zero
    dp1pp1(:) = zero
    dp2pp1(:) = zero
    dtpp1(:)  = zero
    dp1pp2(:) = zero
    dp2pp2(:) = zero
    dtpp2(:)  = zero
    dp1pt(:)  = zero
    dp2pt(:)  = zero
    dtpt(:)   = zero
!
! - Get parameters
!
    rgaz   = ds_thm%ds_material%solid%r_gaz
    cliq   = ds_thm%ds_material%liquid%unsurk
    alpliq = ds_thm%ds_material%liquid%alpha
    kh     = ds_thm%ds_material%ad%coef_henry
!
! - Compute
!
    if (yavp) then
        dp11p1 = rho11*kh/(rho12*rgaz*t-rho11*kh)
        dp11p2 = rho11*kh*(rgaz*t/kh - 1.d0)/(rho12*rgaz*t-rho11*kh)
        dp12p1 = rho12/(rho12*rgaz*t/kh-(rho11))
        dp12p2 = (rgaz*t/kh-1.d0)*dp12p1
        dp21p1 = - dp12p1
        dp21p2 = 1.d0 - dp12p2
        dp22p1 = -1.d0- dp11p1
        dp22p2 = 1.d0- dp11p2
        if (ds_thm%ds_elem%l_dof_ther) then
            l = (h12-h11)
            dp11t = (-l*rgaz*rho12/kh+pad/t)/ ((rho12*rgaz*t/rho11/kh)-1)
            dp12t = (-l*rho11+pad)/t*dp12p1
            dp21t = - dp12t
            dp22t = - dp11t
        endif
        a1 = rgaz*t/kh - rho11/rho12
        a2 = rho11/rho12*(rgaz*t/kh - 1)
        if (ds_thm%ds_elem%l_dof_ther) then
            a3 = dp12t/pvp-1/t-cliq*dp22t-3*alpliq
            a4 = -dp12t/pvp+1/t+cliq*dp22t-3*alpliq
        else
            a3 = dp12t/pvp-1/t-cliq*dp22t
            a4 = -dp12t/pvp+1/t+cliq*dp22t
        endif
        dp1pp2(1) = a2/a1/a1*(cliq*dp11p1-1/pvp*dp12p1)
        dp2pp2(1) = a2/a1/a1*(cliq*dp11p2-1/pvp*dp12p2)
        dp1pp2(2) = rgaz*t*a2/a1/a1/kh*(-cliq*dp11p1+1/pvp*dp12p1)
        dp2pp2(2) = rgaz*t*a2/a1/a1/kh*(-cliq*dp11p2+1/pvp*dp12p2)
        dp1pp1(1) = -rho11/rho12/a1/a1*(dp12p1/pvp-cliq*dp11p1)
        dp2pp1(1) = -rho11/rho12/a1/a1*(dp12p2/pvp-cliq*dp11p2)
        dp1pp1(2) = rgaz*t/kh*rho11/rho12/a1/a1*(dp12p1/pvp-cliq*dp11p1)
        dp2pp1(2) = rgaz*t/kh*rho11/rho12/a1/a1*(dp12p2/pvp-cliq*dp11p2)
        if (ds_thm%ds_elem%l_dof_ther) then
            dtpp2(1) = rgaz/a1/kh - (rgaz*t/kh-1)/a1/a1*(rgaz/kh-a4*rho11/ rho12)
            dtpp1(1) = -1.d0/a1/a1*(rgaz/kh-rho11/rho12*a4)
            dtpp2(2) = rgaz/a1/kh*rho11/rho12 +&
                       (rho11/rho12)*(rho11/ rho12)* a2*rgaz/kh/a1/a1*(1.d0+a3*t)
            dtpp1(2) = rgaz/kh/a1/a1*rho11/rho12*(1.d0+a3*t)
            dp1pt(1) = -1.d0/t/a1/a1*(&
                           a1*(1.d0-dp11p1*(1.d0+l*rho11*cliq)) +&
                           (pad-l*rho11)*rho11/rho12*(cliq*dp11p1-dp12p1/pvp)&
                       )
            dp2pt(1) = -1.d0/t/a1/a1*(&
                           a1*(1.d0-dp11p2*(1.d0+l*rho11*cliq)) +&
                           (pad-l*rho11)*rho11/rho12*(cliq*dp11p2-dp12p2/pvp)&
                       )
            dtpt(1)  = +1.d0/t/a1*(dp22t-l*(rho11*dp11t*cliq-3.d0* alpliq*rho11))-&
                       1.d0/t/t/a1/a1*(rgaz*t/kh-rho11/rho12+t*(rgaz/ kh-rho11/rho12*a4))*&
                      (pad-l*rho11)
            dp1pt(2) = 1.d0/a1*rho11/rho12*(l*rgaz/kh*rho12/pvp*dp12p1-dp22p1/t)-&
                       rgaz*t/kh*rho11/rho12/a1/a1*(l*rgaz/kh*rho12-pad/t)*a3
            dp2pt(2) = 1.d0/a1*rho11/rho12*(l*rgaz/kh*rho12/pvp*dp12p2-dp22p2/t)-&
                       rgaz*t/kh*rho11/rho12/a1/a1*(l*rgaz/kh*rho12-pad/t)*a3
            dtpt(2)  = rho11/rho12/a1*(&
                            l*rgaz*rho12/kh*(dp12t/pvp-1.d0/t)+&
                            pad/t/t -dp12t/t&
                       )-&
                       rgaz*t/kh*rho11/rho12/a1/a1*(l*rgaz*rho12/kh-pad/t)*(a3+1.d0/t)
        endif
    else
        dp11p1 = rho11*kh/(rho12*rgaz*t-rho11*kh)
        dp11p2 = rho11*kh*(rgaz*t/kh - 1.d0)/(rho12*rgaz*t-rho11*kh)
        dp12p1 = zero
        dp12p2 = zero
        dp21p1 = - dp12p1
        dp21p2 = 1.d0 - dp12p2
        dp22p1 = -1.d0- dp11p1
        dp22p2 = 1.d0- dp11p2
        if (ds_thm%ds_elem%l_dof_ther) then
            l = (h12-h11)
            dp11t = (-l*rgaz*rho12/kh+pad/t)*rho11*kh/ (rho12*rgaz*t-rho11* kh)
            dp12t = zero
            dp21t = - dp12t
            dp22t = - dp11t
        endif
    endif
!
end subroutine
