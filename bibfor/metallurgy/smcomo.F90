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
subroutine smcomo(coef, fmod, temp_curr, nb_hist,&
                  ftrc, trc)
!
use Metallurgy_type
!
implicit none
!
real(kind=8), intent(in) :: coef(*), fmod(*), temp_curr
integer, intent(in) :: nb_hist
real(kind=8), intent(out) :: ftrc((3*nb_hist), 3), trc((3*nb_hist), 5)
!
! --------------------------------------------------------------------------------------------------
!
! METALLURGY -  Compute phase
!
! Compute functions from TRC diagram
!
! --------------------------------------------------------------------------------------------------
!
! In  coef                : parameters from TRC diagrams (P5 polynom)
! In  fmod                : experimental function from TRC diagrams
! In  temp_curr           : current temperature
! In  nb_hist             : number of graph in TRC diagram
! Out trc                 : values of functions for TRC diagram
!                          At T
!                           trc(1=>nb_hist,1) : phase 1 
!                           trc(1=>nb_hist,2) : phase 2
!                           trc(1=>nb_hist,3) : phase 3
!                           trc(1=>nb_hist,4) : derivative (by time) of temperature
!                           trc(1=>nb_hist,5) : temperature
!                          At T+5
!                           trc(nb_hist=>2*nb_hist,1) : phase 1 
!                           trc(nb_hist=>2*nb_hist,2) : phase 2
!                           trc(nb_hist=>2*nb_hist,3) : phase 3
!                           trc(nb_hist=>2*nb_hist,4) : derivative (by time) of temperature
!                           trc(nb_hist=>2*nb_hist,5) : temperature
!                          At T-5
!                           trc(2*nb_hist=>3*nb_hist,1) : phase 1 
!                           trc(2*nb_hist=>3*nb_hist,2) : phase 2
!                           trc(2*nb_hist=>3*nb_hist,3) : phase 3
!                           trc(2*nb_hist=>3*nb_hist,4) : derivative (by time) of temperature
!                           trc(2*nb_hist=>3*nb_hist,5) : temperature
! Out ftrc                : values of derivatives (by temperature) of functions for TRC diagram
!                           ftrc(3*nbhist,5)
!                          At T
!                           ftrc(1=>nb_hist,1) : derivative of phase 1 by temperature
!                           ftrc(1=>nb_hist,2) : derivative of phase 2 by temperature
!                           ftrc(1=>nb_hist,3) : derivative of phase 3 by temperature
!                          At T+5
!                           ftrc(nb_hist=>2*nb_hist,1) : derivative of phase 1 by temperature
!                           ftrc(nb_hist=>2*nb_hist,2) : derivative of phase 2 by temperature
!                           ftrc(nb_hist=>2*nb_hist,3) : derivative of phase 3 by temperature
!                          At T-5
!                           ftrc(2*nb_hist=>3*nb_hist,1) : derivative of phase 1 by temperature
!                           ftrc(2*nb_hist=>3*nb_hist,2) : derivative of phase 2 by temperature
!                           ftrc(2*nb_hist=>3*nb_hist,3) : derivative of phase 3 by temperature
!
! --------------------------------------------------------------------------------------------------
!
    real(kind=8), parameter :: t_700 = 700.d0
    real(kind=8), parameter :: t_5 = 5.d0
    real(kind=8), parameter :: zero = 0.d0
    real(kind=8), parameter :: un = 1.d0
    integer :: i_hist, i_exp, k, lg, nb_exp
    real(kind=8) :: time, coeffz, fp_700, f_700, ft, fpt, a, b, c, d, e, f
    real(kind=8) :: temp_exp_prev, temp_exp_curr, tempe
!
! --------------------------------------------------------------------------------------------------
!
    tempe = temp_curr
!
! - Get temperature and derivative of temperature (T)
!
    do i_hist = 1, nb_hist
! ----- Get factor for each polynom (1 => 5)
        a = coef(3+9*(i_hist-1))
        b = coef(4+9*(i_hist-1))
        c = coef(5+9*(i_hist-1))
        d = coef(6+9*(i_hist-1))
        e = coef(7+9*(i_hist-1))
        f = coef(8+9*(i_hist-1))
        if ((a.ne.zero) .and. (b.ne.zero) .and. (c.ne.zero) .and. (d.ne.zero) .and.&
            (e.ne.zero) .and. (f.ne.zero)) then
! --------- Value of polynom (for T=700 and T)
            f_700 = a + b*t_700 + c*t_700**2 + d*t_700**3 + e*t_700**4 + f*t_700**5
            ft    = a + b*tempe + c*tempe**2 + d*tempe**3 + e*tempe**4 + f*tempe**5
! --------- Derivative (by temperature) of polynom (for T=700 and T)
            fpt    = b + 2*c*tempe + 3*d*tempe**2 + 4*e*tempe**3 + 5*f*tempe**4
            fp_700 = b + 2*c*t_700 + 3*d*t_700**2 + 4*e*t_700**3 + 5*f*t_700**4
            time   = ft - f_700 - log(fp_700*coef(1+9*(i_hist-1)))
            trc(i_hist,4) = un/(fpt*exp(time))
        else
            trc(i_hist,4) = coef(1+9*(i_hist-1))
        endif
        trc(i_hist,5) = tempe
    end do
!
! - Function of each phase (1 = 3) and derivatives (T)
!
    lg = 0
    do i_hist = 1, nb_hist
! ----- Number of experimental points
        nb_exp = nint( coef(9+9*(i_hist-1)) )
        do i_exp = 1, nb_exp-1
            temp_exp_prev = fmod(4*(lg+i_exp))
            temp_exp_curr = fmod(4*(lg+i_exp+1))
            if ((tempe .le. temp_exp_prev) .and.&
                (tempe .ge. (temp_exp_curr-1.d-9))) then
                coeffz         = (tempe-temp_exp_prev) / (temp_exp_curr-temp_exp_prev)
                trc(i_hist,1)  = fmod(4*(lg+i_exp)-3) +&
                                 (fmod(4*(lg+i_exp+1)-3)-fmod(4*(lg+i_exp)-3))*coeffz
                trc(i_hist,2)  = fmod(4*(lg+i_exp)-2) +&
                                 (fmod(4*(lg+i_exp+1)-2)-fmod(4*(lg+i_exp)-2))*coeffz
                trc(i_hist,3)  = fmod(4*(lg+i_exp)-1) +&
                                 (fmod(4*(lg+i_exp+1)-1)-fmod(4*(lg+i_exp)-1))*coeffz
                ftrc(i_hist,1) = (fmod(4*(lg+i_exp)-3)-fmod(4*(lg+i_exp+1)-3)) /&
                                 (temp_exp_prev-temp_exp_curr)
                ftrc(i_hist,2) = (fmod(4*(lg+i_exp)-2)-fmod(4*(lg+i_exp+1)-2)) /&
                                 (temp_exp_prev-temp_exp_curr)
                ftrc(i_hist,3) = (fmod(4*(lg+i_exp)-1)-fmod(4*(lg+i_exp+1)-1)) /&
                                 (temp_exp_prev-temp_exp_curr)
            else
                if (tempe .lt. temp_exp_prev) then
                    trc(i_hist,1)  = fmod(4*(nb_exp+lg)-3)
                    trc(i_hist,2)  = fmod(4*(nb_exp+lg)-2)
                    trc(i_hist,3)  = fmod(4*(nb_exp+lg)-1)
                    ftrc(i_hist,1) = zero
                    ftrc(i_hist,2) = zero
                    ftrc(i_hist,3) = zero
                endif
            endif
        end do
        lg = lg + nb_exp
    end do
!
! - Get temperature and derivative of temperature (T+5)
!
    tempe = tempe + t_5
    do i_hist = nb_hist+1, (2*nb_hist)
        k      = i_hist - nb_hist
        nb_exp = nint(coef(9+9*(k-1)))
! ----- Get factor for each polynom (1 => 5)
        a      = coef(3+9*(k-1))
        b      = coef(4+9*(k-1))
        c      = coef(5+9*(k-1))
        d      = coef(6+9*(k-1))
        e      = coef(7+9*(k-1))
        f      = coef(8+9*(k-1))
        if ((a.ne.zero) .and. (b.ne.zero) .and. (c.ne.zero) .and. (d.ne.zero) .and.&
            (e.ne.zero) .and. (f.ne.zero)) then
! --------- Values of polynom (for T=700 and T+5)
            f_700  = a + b*t_700 + c*t_700**2 + d*t_700**3 + e*t_700**4 + f*t_700**5
            ft     = a + b*tempe + c*tempe**2 + d*tempe**3 + e*tempe**4 + f*tempe**5
! --------- Derivative (by temperature) of polynom (for T=700 and T+5)
            fpt    = b + 2*c*tempe + 3*d*tempe**2 + 4*e*tempe**3 + 5*f*tempe**4
            fp_700 = b + 2*c*t_700 + 3*d*t_700**2 + 4*e*t_700**3 + 5*f*t_700**4
            time   = ft - f_700 - log( fp_700*coef(1+9*(k-1)) )
            trc(i_hist,4) = un/(fpt*exp(time))
        else
            trc(i_hist,4) = coef(1+9*(k-1))
        endif
        trc(i_hist,5) = tempe
    end do
    tempe = tempe - t_5
!
! - Function of each phase (1 = 3) and derivative (T+5)
!
    lg = 0
    do i_hist = nb_hist+1, (2*nb_hist)
        k      = i_hist - nb_hist
        nb_exp = nint( coef(9+9*(k-1)) )
        do i_exp = 1, nb_exp - 1
            temp_exp_prev = fmod(4*(lg+i_exp))
            temp_exp_curr = fmod(4*(lg+i_exp+1))
            if ((tempe+t_5 .le. temp_exp_prev) .and.&
                (tempe+t_5 .ge. (temp_exp_curr-1.d-9))) then
                coeffz         = (tempe+t_5-temp_exp_prev) / (temp_exp_curr-temp_exp_prev)
                trc(i_hist,1)  = fmod(4*(lg+i_exp)-3) +&
                                 (fmod(4*(lg+i_exp+1)-3)-fmod(4*(lg+i_exp)-3))*coeffz
                trc(i_hist,2)  = fmod(4*(lg+i_exp)-2) +&
                                 (fmod(4*(lg+i_exp+1)-2)-fmod(4*(lg+i_exp)-2))*coeffz
                trc(i_hist,3)  = fmod(4*(lg+i_exp)-1) +&
                                 (fmod(4*(lg+i_exp+1)-1)-fmod(4*(lg+i_exp)-1))*coeffz
                ftrc(i_hist,1) = (fmod(4*(lg+i_exp)-3)-fmod(4*(lg+i_exp+1)-3)) /&
                                 (temp_exp_prev-temp_exp_curr)
                ftrc(i_hist,2) = (fmod(4*(lg+i_exp)-2)-fmod(4*(lg+i_exp+1)-2)) /&
                                 (temp_exp_prev-temp_exp_curr)
                ftrc(i_hist,3) = (fmod(4*(lg+i_exp)-1)-fmod(4*(lg+i_exp+1)-1)) /&
                                 (temp_exp_prev-temp_exp_curr)
            else
                if (tempe+t_5 .lt. fmod(4*(nb_exp+lg))) then
                    trc(i_hist,1)  = fmod(4*(nb_exp+lg)-3)
                    trc(i_hist,2)  = fmod(4*(nb_exp+lg)-2)
                    trc(i_hist,3)  = fmod(4*(nb_exp+lg)-1)
                    ftrc(i_hist,1) = zero
                    ftrc(i_hist,2) = zero
                    ftrc(i_hist,3) = zero
                endif
            endif
        end do
        lg = lg + nb_exp
    end do
!
! - Get temperature and derivative of temperature (T-5)
!
    tempe = tempe - t_5
    do i_hist = (2*nb_hist)+1, (3*nb_hist)
        k = i_hist - 2*nb_hist
! ----- Get factor for each polynom (1 => 5)
        a = coef(3+9*(k-1))
        b = coef(4+9*(k-1))
        c = coef(5+9*(k-1))
        d = coef(6+9*(k-1))
        e = coef(7+9*(k-1))
        f = coef(8+9*(k-1))
        if ((a.ne.zero) .and. (b.ne.zero) .and. (c.ne.zero) .and. (d.ne.zero) .and.&
            (e.ne.zero) .and. (f.ne.zero)) then
! --------- Values of polynom (for T=700 and T-5)
            f_700  = a + b*t_700 + c*t_700**2 + d*t_700**3 + e*t_700**4 + f*t_700**5
            ft     = a + b*tempe + c*tempe**2 + d*tempe**3 + e*tempe**4 + f*tempe**5
! --------- Values of polynom (for T=700 and T-5)
            fpt    = b + 2*c*tempe + 3*d*tempe**2 + 4*e*tempe**3 + 5*f*tempe**4
            fp_700 = b + 2*c*t_700 + 3*d*t_700**2 + 4*e*t_700**3 + 5*f*t_700**4
            time   = ft - f_700 - log( fp_700*coef(1+9*(k-1)) )
            trc(i_hist,4) = un/(fpt*exp(time))
            trc(i_hist,5) = tempe
        else
            trc(i_hist,4) = coef(1+9*(k-1))
        endif
        trc(i_hist,5) = tempe
    end do
    tempe = tempe + t_5
!
! - Function of each phase (1 = 3) and derivative (T-5)
!
    lg = 0
    do i_hist = (2*nb_hist+1), (3*nb_hist)
        k = i_hist - 2*nb_hist
        nb_exp = nint( coef(9+9*(k-1)) )
        do i_exp = 1, nb_exp-1
            temp_exp_prev = fmod(4*(lg+i_exp))
            temp_exp_curr = fmod(4*(lg+i_exp+1))
            if ((tempe-t_5 .le. fmod(4*(lg+i_exp))) .and.&
                (tempe-t_5 .ge. (fmod(4*(lg+i_exp+1))-1.d-9))) then
                coeffz         = (tempe-t_5-temp_exp_prev) / (temp_exp_curr-temp_exp_prev)
                trc(i_hist,1)  = fmod( 4*(lg+i_exp)-3) +&
                                 (fmod(4*(lg+i_exp+1)-3)-fmod(4*(lg+i_exp)-3))*coeffz
                trc(i_hist,2)  = fmod( 4*(lg+i_exp)-2) +&
                                 (fmod(4*(lg+i_exp+1)-2)-fmod(4*(lg+i_exp)-2))*coeffz
                trc(i_hist,3)  = fmod( 4*(lg+i_exp)-1) +&
                                 (fmod(4*(lg+i_exp+1)-1)-fmod(4*(lg+i_exp)-1))*coeffz
                ftrc(i_hist,1) = (fmod(4*(lg+i_exp)-3)-fmod(4*(lg+i_exp+1)-3))/&
                                 (temp_exp_prev-temp_exp_curr)
                ftrc(i_hist,2) = (fmod(4*(lg+i_exp)-2)-fmod(4*(lg+i_exp+1)-2))/&
                                 (temp_exp_prev-temp_exp_curr)
                ftrc(i_hist,3) = (fmod(4*(lg+i_exp)-1)-fmod(4*(lg+i_exp+1)-1))/&
                                 (temp_exp_prev-temp_exp_curr)
            else
                if (tempe-t_5 .lt. fmod(4*(nb_exp+lg))) then
                    trc(i_hist,1)  = fmod(4*(nb_exp+lg)-3)
                    trc(i_hist,2)  = fmod(4*(nb_exp+lg)-2)
                    trc(i_hist,3)  = fmod(4*(nb_exp+lg)-1)
                    ftrc(i_hist,1) = zero
                    ftrc(i_hist,2) = zero
                    ftrc(i_hist,3) = zero
                endif
            endif
        end do
        lg = lg + nb_exp
    end do
!
end subroutine
