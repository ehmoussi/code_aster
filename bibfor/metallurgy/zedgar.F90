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
subroutine zedgar(jv_mater ,&
                  tm       , tp,&
                  time_curr, time_incr,&
                  vari_prev, vari_curr)
!
use Metallurgy_type
!
implicit none
!
#include "asterf_types.h"
#include "asterc/r8prem.h"
#include "asterc/r8t0.h"
#include "asterfort/assert.h"
#include "asterfort/utmess.h"
#include "asterfort/zevolu.h"
#include "asterfort/metaZircGetParameters.h"
#include "asterfort/metaZircGetTime.h"
#include "asterfort/Metallurgy_type.h"
!
integer, intent(in) :: jv_mater
real(kind=8), intent(in) :: tm, tp
real(kind=8), intent(in) :: time_curr, time_incr
real(kind=8), intent(in) :: vari_prev(4)
real(kind=8), intent(out) :: vari_curr(4)
!
! --------------------------------------------------------------------------------------------------
!
! METALLURGY -  Compute phase
!
! Main law for zircaloy
!
! --------------------------------------------------------------------------------------------------
!
! In  jv_mater            : coded material address
! In  tm                  : previous temperature
! In  tp                  : current temperature
! In  time_curr           : current time
! In  time_incr           : increment of time
! In  vari_prev           : previous internal state variable
! In  vari_curr           : current internal state variable
!
! --------------------------------------------------------------------------------------------------
!
    integer :: iter
    real(kind=8) :: tdeq, tfeq, k, n, t1c, t2c, ac, m, qsr, coeffc
    real(kind=8) :: t1r, t2r, ar, br, tabs
    real(kind=8) :: zbetap, zbetam, zalphm, zalphp, zalph1p, zalph2p
    real(kind=8) :: zeq, zinf, zsup
    real(kind=8) :: g, dg
    real(kind=8) :: zero, time_tran, time_tran_p
    integer :: kine_type
    aster_logical :: l_integ
    type(META_ZircParameters) :: metaZircPara
!
! --------------------------------------------------------------------------------------------------
!
    zero = r8prem()
    tabs = r8t0() 
!
! - Get material parameters
!
    call metaZircGetParameters(jv_mater, tp, metaZircPara)
    tdeq   = metaZircPara%tdeq
    k      = metaZircPara%k
    n      = metaZircPara%n
    t1c    = metaZircPara%t1c
    t2c    = metaZircPara%t2c
    ac     = metaZircPara%ac
    m      = metaZircPara%m
    qsr    = metaZircPara%qsrk
    t1r    = metaZircPara%t1r
    t2r    = metaZircPara%t2r
    ar     = metaZircPara%ar
    br     = metaZircPara%br
    coeffc = ac*exp(-qsr/(tp+tabs))
!
! - Get previous phases
!
    zalphm = vari_prev(PALPHA1)+vari_prev(PALPHA2)
    zbetam = 1.d0-zalphm
    if (abs(zbetam) .le. zero) then
        zbetam = 0.d0
    endif
    if (abs(zalphm) .le. zero) then
        zbetam = 1.d0
    endif
    if ((zbetam.le.1.d-05) .and. (tp.le.tdeq)) then
        zbetam = 0.d0
    endif
!
! - Compute final temperature of transformation
!
    tfeq = tdeq+log(1.d0/0.01d0)**(1.d0/n)/k
    if (tp .le. tdeq) then
        zeq = 0.d0
    else if (tp .gt. tdeq .and. tp .le. tfeq) then
        zeq = 1.d0-exp(-((k*(tp-tdeq))**n))
    else
        zeq = 1.d0
    endif
!
! - Type of kinematic
!
    if (zbetam .le. 0.d0) then
        kine_type = HEATING
    else if ((zbetam .gt. 0.d0) .and. (zbetam .lt. 1.d0)) then
        if (zbetam .lt. zeq) then
            kine_type = HEATING
        else
            kine_type = COOLING
        endif
    else if (zbetam .ge. 1.d0) then
        kine_type = COOLING
    endif
!
! - Evaluate value of time for temperature of transformation
!
    time_tran_p = vari_prev(TIME_TRAN)
    call metaZircGetTime(zbetam   ,&
                         t1c      , t2c  ,&
                         t1r      , t2r  ,&
                         tm       , tp   ,&
                         tdeq     , tfeq ,&
                         time_curr    , time_incr, time_tran_p,&
                         time_tran, l_integ)
!
! - Compute new value of beta phase
!
    if (.not.l_integ) then
        if (zbetam .eq. 0.d0) then
            zbetap = 0.d0
        endif
        if (zbetam .eq. 1.d0) then
            zbetap = 1.d0
        endif
    else
! ----- Heating and phase beta is near 1 (icnreasing or decreasing ?)
        if (kine_type .eq. HEATING) then
            if (zeq .gt. 0.99d0) then
                call zevolu(kine_type,&
                            0.99d0   , zbetam,&
                            time_incr    , tp    ,&
                            k        , n     ,&
                            tdeq     , tfeq  ,&
                            coeffc   ,&
                            m        , ar    , br,&
                            g        , dg)
                if (g .lt. 0.d0) then
                    zbetap = 1.d0
                    goto 100
                endif
            endif
        endif
! ----- Newton method to compute: bounds
        if (kine_type .eq. HEATING) then
            zinf = zbetam
            zsup = zeq
        else
            zinf = zeq
            zsup = zbetam
        endif
! ----- Newton method to compute: initialization
        zbetap = zbetam
        if (zbetam .eq. 0.d0) then
            zbetap = zeq/2.d0
        endif
        if (zbetam .eq. 1.d0) then
            zbetap = (zbetam+zeq)/2.d0
        endif
! ----- Newton method to compute: initial G function (evolution of beta phase)
        call zevolu(kine_type,&
                    zbetap   , zbetam,&
                    time_incr    , tp    ,&
                    k        , n     ,&
                    tdeq     , tfeq  ,&
                    coeffc   ,&
                    m        , ar    , br,&
                    g        , dg)
! ----- Newton method to compute: iterations
        do iter = 1, 15
            if (abs(g) .le. 1.d-06) then
                goto 100
            endif
            if (dg .eq. 0.d0) then
                call utmess('F', 'METALLURGY1_96')
            endif
            zbetap = zbetap - g/dg
            if (zbetap .le. zinf .or. zbetap .ge. zsup) then
                zbetap=(zinf+zsup)/2.d0
            endif
! --------- Compute G function (evolution of beta phase)
            call zevolu(kine_type,&
                        zbetap   , zbetam,&
                        time_incr    , tp    ,&
                        k        , n     ,&
                        tdeq     , tfeq  ,&
                        coeffc   ,&
                        m        , ar    , br,&
                        g        , dg)
! --------- Newton method to compute: update bounds
            if (g .ge. 0.d0) then
                zsup = zbetap
            endif
            if (g .le. 0.d0) then
                zinf = zbetap
            endif
        end do
        call utmess('F', 'METALLURGY1_96')
100     continue
    endif
!
! - Compute alpha phases
!
    zalphp  = 1.d0 - zbetap
    if (zbetap .gt. 0.1d0) then
        zalph1p = 0.d0
    else
        zalph1p = 10.d0*(zalphp-0.9d0)*zalphp
    endif
    if (zalph1p .le. zero) then
        zalph1p = 0.d0
    endif
    zalph2p = zalphp-zalph1p
    if (zalph2p .le. zero) then
        zalph2p = 0.d0
    endif
!
! - Update internal variables
!
    vari_curr(PALPHA1)   = zalph1p
    vari_curr(PALPHA2)   = zalph2p
    vari_curr(ZIRC_TEMP) = tp
    vari_curr(TIME_TRAN) = time_tran
!
end subroutine
