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
subroutine zacier(metaSteelPara,&
                  tpg0         , tpg1     , tpg2,&
                  dt10         , dt21     ,&
                  meta_prev    , meta_curr)
!
use Metallurgy_type
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterc/r8prem.h"
#include "asterfort/metaSteelGetParameters.h"
#include "asterfort/assert.h"
#include "asterfort/smcarc.h"
#include "asterfort/utmess.h"
#include "asterfort/metaSteelGrainSize.h"
#include "asterfort/Metallurgy_type.h"
!
type(META_SteelParameters), intent(in) :: metaSteelPara
real(kind=8), intent(in) :: tpg0, tpg1, tpg2
real(kind=8), intent(in) :: dt10, dt21
real(kind=8), intent(in) :: meta_prev(8)
real(kind=8), intent(out) :: meta_curr(8)
!
! --------------------------------------------------------------------------------------------------
!
! METALLURGY -  Compute phase
!
! Main law for steel
!
! --------------------------------------------------------------------------------------------------
!
! In  metaSteelPara       : material parameters for metallurgy of steel
! In  tpg0                : temperature at time N-1
! In  tpg1                : temperature at time N
! In  tpg2                : temperature at time N+1
! In  dt10                : increment of time [N-1, N]
! In  dt21                : increment of time [N, N+1]
! In  meta_prev           : value of internal state variable at previous time step
! Out meta_prev           : value of internal state variable at current time step
!
! --------------------------------------------------------------------------------------------------
!
    real(kind=8) :: vari_dumm(8)
    real(kind=8) :: dmoins
    real(kind=8) :: tpoint, zero, ti, tpi
    real(kind=8) :: zeq1, zeq2, zaust, z2, epsi, dt21_mod
    real(kind=8) :: un, coef_phase
    real(kind=8) :: zeq1i, zeq2i, ti1, ti2, taux
    integer :: i, j, nbpas, nb_hist, nb_trc
    aster_logical :: l_cold
!
! --------------------------------------------------------------------------------------------------
!
    zero = 0.d0
    epsi = 1.d-10
    un   = 1.d0
    ASSERT(STEEL_NBVARI .eq. 8)
!
! - Get material parameters for steel
!
    nb_hist = metaSteelPara%trc%nb_hist
    nb_trc  = metaSteelPara%trc%nb_trc
!
! - Temperature
!
    meta_curr(STEEL_TEMP) = tpg2
    meta_curr(TEMP_MARTENSITE) = meta_prev(TEMP_MARTENSITE)
    tpoint = (tpg1-tpg0)/dt10
!
! - Proportion of austenite
!
    zaust   = un - (meta_prev(PFERRITE) + meta_prev(PPERLITE) +&
                    meta_prev(PBAINITE) + meta_prev(PMARTENS))
!
! - Colding or not ?
!
    zeq1    = min((tpg1-metaSteelPara%ac1)/(metaSteelPara%ac3-metaSteelPara%ac1) , un )
    zeq2    = min((tpg2-metaSteelPara%ac1)/(metaSteelPara%ac3-metaSteelPara%ac1) , un )
    if (tpoint .gt. zero) then
        l_cold = ASTER_FALSE
    else if (tpg2 .gt. metaSteelPara%ar3) then
        l_cold = ASTER_FALSE
    else if (tpg2 .lt. metaSteelPara%ac1) then
        l_cold = ASTER_TRUE
    else if (tpoint .lt. zero) then
        l_cold = ASTER_TRUE
    else if (zaust .le. zeq2) then
        l_cold = ASTER_FALSE
    else
        l_cold = ASTER_TRUE
    endif
!
    if (l_cold) then
        if (abs(tpg2-tpg1) .gt. 5.001d0) then
            nbpas = int(abs(tpg2-tpg1)/5.d0-0.001d0)+1
            dt21_mod     = dt21/dble(nbpas)
            vari_dumm(:) = meta_prev(:)
            do i = 1, nbpas
                ti                    = tpg1+(tpg2-tpg1)*dble(i-1)/dble(nbpas)
                meta_curr(STEEL_TEMP) = tpg1+(dble(i)*(tpg2-tpg1))/dble(nbpas)
                tpi                   = (meta_curr(STEEL_TEMP)-ti)/dt21_mod
                call smcarc(nb_hist      , &
                            zr(metaSteelPara%trc%jv_ftrc),&
                            zr(metaSteelPara%trc%jv_trc),&
                            zr(metaSteelPara%trc%iadtrc+3),&
                            zr(metaSteelPara%trc%iadtrc+metaSteelPara%trc%iadexp), &
                            metaSteelPara,&
                            nb_trc    ,&
                            zr(metaSteelPara%trc%iadtrc+metaSteelPara%trc%iadckm),&
                            ti           , tpi      , dt10,&
                            vari_dumm    , meta_curr)
                vari_dumm(:) = meta_curr(:)
            end do
        else
            call smcarc(nb_hist      , &
                        zr(metaSteelPara%trc%jv_ftrc),&
                        zr(metaSteelPara%trc%jv_trc),&
                        zr(metaSteelPara%trc%iadtrc+3),&
                        zr(metaSteelPara%trc%iadtrc+metaSteelPara%trc%iadexp), &
                        metaSteelPara,&
                        nb_trc    ,&
                        zr(metaSteelPara%trc%iadtrc+metaSteelPara%trc%iadckm),&
                        tpg1         , tpoint   , dt10,&
                        meta_prev    , meta_curr)
        endif
    else
        if (abs(tpg2-tpg1) .gt. 5.001d0) then
! ----------------SUBDIVISION EN PAS DE CING DEGRE MAX
            nbpas    = int(abs(tpg2-tpg1)/5.d0-0.001d0)+1
            dt21_mod = dt21/dble(nbpas)
            dmoins   = meta_prev(SIZE_GRAIN)
            do i = 1, nbpas
                ti1    = tpg1+(tpg2-tpg1)*dble(i-1)/dble(nbpas)
                ti2    = tpg1+(tpg2-tpg1)*dble(i)/dble(nbpas)
                tpoint = (ti2-ti1)/dt21_mod
                zeq1i  = min( (ti1-metaSteelPara%ac1)/(metaSteelPara%ac3-metaSteelPara%ac1) , un )
                zeq2i  = min( (ti2-metaSteelPara%ac1)/(metaSteelPara%ac3-metaSteelPara%ac1) , un )
                taux   = metaSteelPara%taux_1 + (metaSteelPara%taux_3-metaSteelPara%taux_1)*zeq1i
                if ((ti1.lt.(metaSteelPara%ac1-epsi)) .or. (zaust.ge.un)) then
                    z2 = zaust
                else
                    if (zeq2i .ge. (un-epsi)) then
                        tpoint = zero
                    endif
                    if (zaust .gt. zeq1i) then
                        z2 = (taux*tpoint/(metaSteelPara%ac3-metaSteelPara%ac1))
                        z2 = z2*exp(-dt21_mod/taux)
                        z2 = ((-taux*tpoint/(metaSteelPara%ac3-metaSteelPara%ac1))+zeq2i+z2-zeq1i)*&
                              (un-zaust)/(un-zeq1i)
                        z2 = z2+zaust
                    else
                        z2 = (taux*tpoint/(metaSteelPara%ac3-metaSteelPara%ac1))-zeq1i+zaust
                        z2 = z2*exp(-dt21_mod/taux)
                        z2 = (-taux*tpoint/(metaSteelPara%ac3-metaSteelPara%ac1))+zeq2i+z2
                    endif
                endif
! ------------- Compute size of grain
                coef_phase = 1.d0
                if (abs(z2) .ge. epsi) then
                    coef_phase = (1.d0-(z2-zaust)/z2)
                endif
                call metaSteelGrainSize(metaSteelPara,&
                                        nb_trc     ,&
                                        zr(metaSteelPara%trc%iadtrc+metaSteelPara%trc%iadckm),&
                                        ti1          , dt10      , dt21,&
                                        z2           , coef_phase,&
                                        dmoins       , meta_curr(SIZE_GRAIN))
                if (metaSteelPara%l_grain_size) then
                    zaust  = z2
                    dmoins = meta_curr(SIZE_GRAIN)
                endif
            end do
        else
            dt21_mod = dt21
            taux = metaSteelPara%taux_1 + (metaSteelPara%taux_3-metaSteelPara%taux_1)*zeq1
            if ((tpg1.lt.(metaSteelPara%ac1-epsi)) .or. (zaust.ge.un)) then
                z2 = zaust
            else
                if (zeq2 .ge. (un-epsi)) then
                    tpoint = zero
                endif
                if (zaust .gt. zeq1) then
                    z2 = (taux*tpoint/(metaSteelPara%ac3-metaSteelPara%ac1))
                    z2 = z2*exp(-dt21_mod/taux)
                    z2 = ((-taux*tpoint/(metaSteelPara%ac3-metaSteelPara%ac1))+zeq2+z2-zeq1)*&
                         (un-zaust )/(un-zeq1 )
                    z2 = z2+zaust
                else
                    z2 = (taux*tpoint/(metaSteelPara%ac3-metaSteelPara%ac1))-zeq1+zaust
                    z2 = z2*exp(-dt21_mod/taux)
                    z2 = (-taux*tpoint/(metaSteelPara%ac3-metaSteelPara%ac1))+zeq2+z2
                endif
            endif
! --------- Compute size of grain
            coef_phase = 1.d0
            if (abs(z2) .ge. epsi) then
                coef_phase = (1.d0-(z2-zaust)/z2)
            endif
            call metaSteelGrainSize(metaSteelPara,&
                                    nb_trc       ,&
                                    zr(metaSteelPara%trc%iadtrc+metaSteelPara%trc%iadckm),&
                                    tpg1         , dt10       , dt21,&
                                    z2           , coef_phase ,&
                                    meta_prev(SIZE_GRAIN), meta_curr(SIZE_GRAIN))
        endif
!           REPARTITION DE DZGAMMA SUR DZALPHA
        if (z2 .gt. (un-epsi)) then
            z2 = un
        endif
        if (zaust .ne. un) then
            do j = 1, 4
                meta_curr(j) = meta_prev(j)*(un-(z2-zaust)/(un-zaust))
            end do
        else
            do j = 1, 4
                meta_curr(j) = meta_prev(j)
            end do
        endif
    endif
!
! - Compute austenite
!
    zaust = un - meta_curr(1) - meta_curr(2) - meta_curr(3) - meta_curr(4)
    if (zaust .le. r8prem()) then
        zaust = 0.d0
    endif
    if (zaust .ge. 1.d0) then
        zaust = 1.d0
    endif
    meta_curr(PAUSTENITE) = zaust
!
end subroutine
