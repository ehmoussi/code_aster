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
subroutine metaSteelTRCPolynom(coef_poly, tplm, temp,&
                               dtemp_trc)
!
implicit none
!
real(kind=8), intent(in) :: coef_poly(6), tplm, temp
real(kind=8), intent(out) :: dtemp_trc
!
! --------------------------------------------------------------------------------------------------
!
! METALLURGY - Steel
!
! Compute derivative of temperature from polynomial order 5 approximation for TRC
!
! --------------------------------------------------------------------------------------------------
!
! In  coef_poly           : coefficient of P5 polynom for TRC curve
! In  temp                : temperature
! Out dtemp_trc           : derivative of temperature from TRC diagram
!
! --------------------------------------------------------------------------------------------------
!
    real(kind=8), parameter :: t_700 = 700.d0
    real(kind=8), parameter :: zero = 0.d0
    real(kind=8) :: time,fp_700, f_700, ft, fpt
!
! --------------------------------------------------------------------------------------------------
!

    if ((coef_poly(1).ne.zero) .and. (coef_poly(2).ne.zero) .and.&
        (coef_poly(3).ne.zero) .and. (coef_poly(4).ne.zero) .and.&
        (coef_poly(5).ne.zero) .and. (coef_poly(6).ne.zero)) then
! ----- Value of polynom (for T=700 and T)
        f_700     = coef_poly(1) + coef_poly(2)*t_700 + coef_poly(3)*t_700**2 +&
                    coef_poly(4)*t_700**3 + coef_poly(5)*t_700**4 + coef_poly(6)*t_700**5
        ft        = coef_poly(1) + coef_poly(2)*temp + coef_poly(3)*temp**2 +&
                    coef_poly(4)*temp**3 + coef_poly(5)*temp**4 + coef_poly(6)*temp**5
! ----- Derivative (by temperature) of polynom (for T=700 and T)
        fpt       = coef_poly(2) + 2*coef_poly(3)*temp + 3*coef_poly(4)*temp**2 +&
                    4*coef_poly(5)*temp**3 + 5*coef_poly(6)*temp**4
        fp_700    = coef_poly(2) + 2*coef_poly(3)*t_700 + 3*coef_poly(4)*t_700**2 +&
                    4*coef_poly(5)*t_700**3 + 5*coef_poly(6)*t_700**4
        time      = ft - f_700 - log(fp_700*tplm)
        dtemp_trc = 1.d0/(fpt*exp(time))
    else
        dtemp_trc = tplm
    endif
!
end subroutine
