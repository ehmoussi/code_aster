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

subroutine permvg(satur,&
                  krl  , dkrl_dsatur, krg, dkrg_dsatur)
!
use THM_type
use THM_module
!
implicit none
!
#include "asterfort/kfomvg.h"
#include "asterfort/regup1.h"
#include "asterfort/regup2.h"
!
real(kind=8), intent(in) :: satur
real(kind=8), intent(out) :: krl, dkrl_dsatur
real(kind=8), intent(out) :: krg, dkrg_dsatur
!
! --------------------------------------------------------------------------------------------------
!
! THM - Permeability (HYDR_VGM)
!
! Evaluate permeability for liquid and gaz
!
! --------------------------------------------------------------------------------------------------
!
! In  satur            : saturation
! Out krl              : value of kr(liquid)
! Out dkrl_dsatur      : value of d(kr(liquid))/dSatur
! Out krg              : value of kr(gaz)
! Out dkrg_dsatur      : value of d(kr(gaz))/dSatur
!
! --------------------------------------------------------------------------------------------------
!
    real(kind=8) :: n, sr, satur_max
    real(kind=8) :: m, s1, usm, s1max
    real(kind=8) :: y0w, y0wp, y0g, y0gp, y1, a1, b1, c1
    real(kind=8) :: satur_min, s1min, ar, br
!
! --------------------------------------------------------------------------------------------------
!
    krl         = 0.d0
    dkrl_dsatur = 0.d0
    krg         = 0.d0
    dkrg_dsatur = 0.d0
!
! - Get parameters
!
    n          = ds_thm%ds_material%n
    sr         = ds_thm%ds_material%sr
    satur_max  = ds_thm%ds_material%smax
    m          = 1.d0-1.d0/n
    usm        = 1.d0/m
    s1         = (satur-sr)/(1.d0-sr)
    s1max      = (satur_max-sr)/(1.d0-sr)
    s1min      = 1.d0-satur_max
    satur_min  = sr+(1.d0-sr)*s1min
! 
    if ((satur .lt. satur_max) .and. (satur .gt. satur_min)) then
        call kfomvg(sr , m  , usm        , s1         ,&
                    krl, krg, dkrl_dsatur, dkrg_dsatur)
    else if (satur .ge. satur_max) then
        call kfomvg(sr , m  , usm , s1max,&
                    y0w, y0g, y0wp, y0gp)
        y1 = 1.d0
        call regup2(satur_max, y0w, y0wp, y1, a1,&
                    b1, c1)
        krl         = a1*satur*satur+b1*satur+c1
        dkrl_dsatur = 2.d0*a1*satur+b1
        y1 = 0.d0
        call regup2(satur_max, y0g, y0gp, y1, a1,&
                    b1, c1)
        krg         = a1*satur*satur+b1*satur+c1
        dkrg_dsatur = 2.d0*a1*satur+b1
    else if (satur.le.satur_min) then
        call kfomvg(sr , m  , usm , s1min,&
                    y0w, y0g, y0wp, y0gp)
        call regup1(satur_min, y0w, y0wp, ar, br)
        krl         = ar*satur+br
        dkrl_dsatur = ar
        call regup1(satur_min, y0g, y0gp, ar, br)
        krg         = ar*satur+br
        dkrg_dsatur = ar
    endif
!
end subroutine
