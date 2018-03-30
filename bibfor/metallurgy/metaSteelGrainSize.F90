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
subroutine metaSteelGrainSize(metaSteelPara, nb_trc    , ckm       ,&
                              temp         , time_incr1, time_incr2,&
                              zaustenite   , coef_phase,&
                              d_prev       , d_curr)
!
use Metallurgy_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
!
type(META_SteelParameters), intent(in) :: metaSteelPara
integer, intent(in) :: nb_trc
real(kind=8), intent(in) :: ckm(6*nb_trc)
real(kind=8), intent(in) :: d_prev, temp, time_incr1, time_incr2
real(kind=8), intent(in) :: zaustenite, coef_phase
real(kind=8), intent(out) :: d_curr
!
! --------------------------------------------------------------------------------------------------
!
! METALLURGY - Steel
!
! Compute size of grain
!
! --------------------------------------------------------------------------------------------------
!
! In  metaSteelPara       : parameters for metallurgy of steel
! In  nbtrc               : size of TEMP_TRC parameters
! In  ckm                 : TEMP_TRC parameters
! In  temp                : temperature
! In  time_incr1          : increment of time
! In  time_incr2          : increment of time
! In  zaustenite          : proportion of austenite phase
! In  coef_phase          : multiplicative coefficient for phase
! In  d_prev              : previous size of grain
! Out vari_curr           : current size of grain
!
! --------------------------------------------------------------------------------------------------
!
    real(kind=8) :: lambda, unsurl, d_limi
    real(kind=8) :: a, b, c, delta
!            
! --------------------------------------------------------------------------------------------------
!
    if (metaSteelPara%l_grain_size) then
        if (zaustenite .lt. 1.d-3) then
            d_curr = 0.d0
        else
            lambda = metaSteelPara%austenite%lambda0*&
                     exp(metaSteelPara%austenite%qsr_k/(temp+273.d0))
            unsurl = 1.d0/lambda
            d_limi = metaSteelPara%austenite%d10*&
                     exp(-metaSteelPara%austenite%wsr_k/(temp+273.d0))
            a      = 1.d0
            b      = d_prev*coef_phase-(time_incr1*unsurl/d_limi)
            c      = time_incr2*unsurl
            delta  = (b**2)+(4.d0*a*c)
            d_curr = (b+delta**0.5d0)/(2.d0*a)
        endif
    else
        d_curr = ckm(5)
    endif
!
end subroutine
