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
subroutine metaZircGetTime(zbetam   ,&
                           t1c      , t2c  ,&
                           t1r      , t2r  ,&
                           tm       , tp   ,&
                           tdeq     , tfeq ,&
                           time_curr, time_incr, time_tran_p,&
                           time_tran, l_integ)
!
use Metallurgy_type
!
implicit none
!
#include "asterf_types.h"
!
real(kind=8), intent(in) :: zbetam
real(kind=8), intent(in) :: t1c, t2c
real(kind=8), intent(in) :: t1r, t2r
real(kind=8), intent(in) :: tm, tp, tdeq, tfeq
real(kind=8), intent(in) :: time_curr, time_incr, time_tran_p
real(kind=8), intent(out) :: time_tran
aster_logical, intent(out) :: l_integ
!
! --------------------------------------------------------------------------------------------------
!
! METALLURGY - Zircaloy
!
! Evaluate value of time for temperature of transformation
!
! --------------------------------------------------------------------------------------------------
!
! In  zbetam              : proportion of beta phase (previous)
! In  t1c                 : material parameter (META_ZIRC)
! In  t2c                 : material parameter (META_ZIRC)
! In  t1r                 : material parameter (META_ZIRC)
! In  t2r                 : material parameter (META_ZIRC)
! In  tm                  : previous temperature
! In  tp                  : current temperature
! In  tdeq                : transformation temperature - Begin
! In  tfeq                : transformation temperature - End
! In  time_curr           : current time
! In  time_incr           : increment of time
! In  time_tran_p         : previous time of transformation
! Out time_tran           : new time of transformation
! Out l_integ             : .true. if evolution must been integrated
!
! --------------------------------------------------------------------------------------------------
!
    real(kind=8) :: dtemp, vitesc, tc, vitesr, tr
!            
! --------------------------------------------------------------------------------------------------
!
    dtemp   = tp - tm
    l_integ = ASTER_TRUE
!
    if (zbetam .eq. 0.d0) then
        if ((tdeq .ge. tm) .and. (tdeq .le. tp)) then
            if (tp .eq. tm) then
                time_tran = time_curr
            else
                time_tran = time_curr+(time_incr/dtemp)*(tdeq-tp)
            endif
        else
            time_tran = time_tran_p
        endif
        if (tp .gt. tdeq) then
            vitesc = (tp-tdeq)/(time_curr-time_tran)
            if (vitesc .lt. 0.d0) then
                l_integ = ASTER_FALSE
            else
                if (vitesc .lt. 0.1d0) then
                    tc = tdeq
                else
                    tc = t1c*(vitesc**t2c)
                endif
                if (tp .le. tc) then
                    l_integ = ASTER_FALSE
                endif
            endif
        else
            l_integ = ASTER_FALSE
        endif
    elseif (zbetam .eq. 1.d0) then
        if ((tfeq .ge. tp) .and. (tfeq .le. tm)) then
            if (tp .eq. tm) then
                time_tran = time_curr
            else
                time_tran = time_curr+(time_incr/dtemp)*(tfeq-tp)
            endif
        else
            time_tran = time_tran_p
        endif
        if (tp .lt. tfeq) then
            vitesr = (tp-tfeq)/(time_curr-time_tran)
            if (vitesr .gt. 0.d0) then
                l_integ = ASTER_FALSE
            else
                if (vitesr .eq. 0.d0) then
                    tr = tfeq
                else
                    tr = t1r+t2r*log(abs(vitesr))
                    if (tr .gt. tfeq) then
                        tr = tfeq
                    endif
                endif
                if (tp .ge. tr) then
                    l_integ = ASTER_FALSE
                endif
            endif
        else
            l_integ = ASTER_FALSE
        endif
    else
        time_tran = time_tran_p
    endif
!
end subroutine
