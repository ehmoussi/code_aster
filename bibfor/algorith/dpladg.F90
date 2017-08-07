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

subroutine dpladg(yate, rho11, rho12, r, temp,&
                  kh, congem, dimcon, adcp11, ndim,&
                  padp, dp11p1, dp11p2, dp21p1, dp21p2,&
                  dp11t, dp21t)
!
implicit none
!
real(kind=8), intent(in) :: temp
!
    integer :: yate, adcp11, ndim, dimcon
    real(kind=8) :: rho11, rho12, r, kh, congem(dimcon), padp
    real(kind=8) :: dp11p1, dp11p2, dp21p1, dp21p2
    real(kind=8) :: dp11t, dp21t
    real(kind=8), parameter :: zero = 0.d0
!
!      BUT :
!           CALCUL DES DERIVEES PARTIELLES DES PRESSIONS
!           UNIQUEMENT DANS LE CAS LIQU_AD_GAZ
!
! ----------------------------------------------------------------------
!
    real(kind=8) :: l
!
! ----------------------------------------------------------------------
!
    dp11p1 = 1.d0/((rho12*r*temp/rho11/kh)-1.d0)
    dp11p2 = (r*temp/kh - 1.d0)/((rho12*r*temp/rho11/kh)-1.d0)
    dp21p1 = zero
    dp21p2 = 1.d0
!
    if (yate .eq. 1.d0) then
        l = -congem(adcp11+ndim+1)
        dp11t = (-l*r*rho12/kh+padp/temp)/((rho12*r*temp/rho11/kh)-1.d0)
        dp21t = zero
    endif
!
end subroutine
