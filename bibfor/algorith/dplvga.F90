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

subroutine dplvga(yate, rho11, rho12, r, t,&
                  kh, congem, dimcon, adcp11, adcp12,&
                  ndim, padp, dp11p1, dp11p2, dp12p1,&
                  dp12p2, dp21p1, dp21p2, dp11t, dp12t,&
                  dp21t)
! aslint: disable=W1504
    implicit      none
    integer :: yate, adcp11, adcp12, ndim, dimcon
    real(kind=8) :: rho11, rho12, r, t, kh, congem(dimcon), padp
    real(kind=8) :: dp11p1, dp11p2, dp12p1, dp12p2, dp21p1, dp21p2
    real(kind=8) :: dp11t, dp12t, dp21t
! --- CALCUL DES DERIVEES PARTIELLES DES PRESSIONS ---------------------
! --- UNIQUEMENT DANS LE CAS LIQU_AD_GAZ_VAPE --------------------------
! ======================================================================
    real(kind=8) :: l
    dp11p1 = 1/((rho12*r*t/rho11/kh)-1)
    dp11p2 = (r*t/kh - 1)/((rho12*r*t/rho11/kh)-1)
    dp12p1 = 1/(r*t/kh-(rho11/rho12))
    dp12p2 = (r*t/kh-1)*dp12p1
    dp21p1 = - dp12p1
    dp21p2 = 1 - dp12p2
!C      DP22P1 = -1- DP11P1
!C      DP22P2 = 1- DP11P2
    if ((yate.eq.1)) then
        l = (congem(adcp12+ndim+1)-congem(adcp11+ndim+1))
        dp11t = (-l*r*rho12/kh+padp/t)/((rho12*r*t/rho11/kh)-1)
        dp12t = (-l*rho11+padp)/t*dp12p1
        dp21t = - dp12t
!C         DP22T =  - DP11T
    endif
! ======================================================================
end subroutine
