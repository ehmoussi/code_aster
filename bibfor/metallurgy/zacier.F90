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
subroutine zacier(jv_mater ,&
                  nb_hist  , ftrc     , trc ,&
                  coef     , fmod     ,&
                  nbtrc    , ckm      ,&
                  tpg0     , tpg1     , tpg2,&
                  dt10     , dt21     ,&
                  vari_prev, vari_curr)
!
use Metallurgy_type
!
implicit none
!
#include "asterf_types.h"
#include "asterc/r8prem.h"
#include "asterfort/metaSteelGetParameters.h"
#include "asterfort/assert.h"
#include "asterfort/smcarc.h"
#include "asterfort/utmess.h"
#include "asterfort/metaSteelGrainSize.h"
#include "asterfort/Metallurgy_type.h"
!
integer, intent(in) :: jv_mater
integer, intent(in) :: nb_hist
real(kind=8), intent(inout) :: ftrc((3*nb_hist), 3), trc((3*nb_hist), 5)
real(kind=8), intent(in)  :: coef(*), fmod(*)
integer, intent(in) :: nbtrc
real(kind=8), intent(in) :: ckm(6*nbtrc)
real(kind=8), intent(in) :: tpg0, tpg1, tpg2
real(kind=8), intent(in) :: dt10, dt21
real(kind=8), intent(in) :: vari_prev(8)
real(kind=8), intent(out) :: vari_curr(8)
!
! --------------------------------------------------------------------------------------------------
!
! METALLURGY -  Compute phase
!
! Main law for steel
!
! --------------------------------------------------------------------------------------------------
!
! In  jv_mater            : coded material address
! In  nb_hist             : number of graph in TRC diagram
! IO  trc                 : values of functions for TRC diagram
! IO  ftrc                : values of derivatives (by temperature) of functions for TRC diagram
! In  coef                : parameters from TRC diagrams (P5 polynom)
! In  fmod                : experimental function from TRC diagrams
! In  nbtrc               : size of TEMP_TRC parameters
! In  ckm                 : TEMP_TRC parameters
! In  tpg0                : temperature at time N-1
! In  tpg1                : temperature at time N
! In  tpg2                : temperature at time N+1
! In  dt10                : increment of time [N-1, N]
! In  dt21                : increment of time [N, N+1]
!
! --------------------------------------------------------------------------------------------------
!
    real(kind=8) :: vari_dumm(8)
    real(kind=8) :: dmoins
    real(kind=8) :: tpoint, zero, ti, tpi
    real(kind=8) :: zeq1, zeq2, zaust, z2, epsi, dt21_mod
    real(kind=8) :: un, coef_phase
    real(kind=8) :: zeq1i, zeq2i, ti1, ti2, taux
    integer :: i, j, nbpas
    aster_logical :: l_cold
    type(META_SteelParameters) :: metaSteelPara
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
    call metaSteelGetParameters(jv_mater, metaSteelPara)
!
! - Temperature
!
    vari_curr(STEEL_TEMP) = tpg2
    vari_curr(TEMP_MARTENSITE) = vari_prev(TEMP_MARTENSITE)
    tpoint = (tpg1-tpg0)/dt10
!
! - Proportion of austenite
!
    zaust   = un - (vari_prev(PFERRITE) + vari_prev(PPERLITE) +&
                    vari_prev(PBAINITE) + vari_prev(PMARTENS))
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
            vari_dumm(:) = vari_prev(:)
            do i = 1, nbpas
                ti                    = tpg1+(tpg2-tpg1)*dble(i-1)/dble(nbpas)
                vari_curr(STEEL_TEMP) = tpg1+(dble(i)*(tpg2-tpg1))/dble(nbpas)
                tpi                   = (vari_curr(STEEL_TEMP)-ti)/dt21_mod
                call smcarc(nb_hist      , ftrc     , trc ,&
                            coef         , fmod     ,&
                            metaSteelPara, nbtrc    , ckm ,&
                            ti           , tpi      , dt10,&
                            vari_dumm    , vari_curr)
                vari_dumm(:) = vari_curr(:)
            end do
        else
            call smcarc(nb_hist      , ftrc     , trc ,&
                        coef         , fmod     ,&
                        metaSteelPara, nbtrc    , ckm ,&
                        tpg1         , tpoint   , dt10,&
                        vari_prev    , vari_curr)
        endif
    else
        if (abs(tpg2-tpg1) .gt. 5.001d0) then
! ----------------SUBDIVISION EN PAS DE CING DEGRE MAX
            nbpas    = int(abs(tpg2-tpg1)/5.d0-0.001d0)+1
            dt21_mod = dt21/dble(nbpas)
            dmoins   = vari_prev(SIZE_GRAIN)
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
                coef_phase = (1.d0-(z2-zaust)/z2)
                call metaSteelGrainSize(metaSteelPara, nbtrc     , ckm ,&
                                        ti1          , dt10      , dt21,&
                                        z2           , coef_phase,&
                                        dmoins       , vari_curr(SIZE_GRAIN))
                if (metaSteelPara%l_grain_size) then
                    zaust  = z2
                    dmoins = vari_curr(SIZE_GRAIN)
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
            call metaSteelGrainSize(metaSteelPara        , nbtrc      , ckm ,&
                                    tpg1                 , dt10       , dt21,&
                                    z2                   , coef_phase ,&
                                    vari_prev(SIZE_GRAIN), vari_curr(SIZE_GRAIN))
        endif
!           REPARTITION DE DZGAMMA SUR DZALPHA
        if (z2 .gt. (un-epsi)) then
            z2 = un
        endif
        if (zaust .ne. un) then
            do j = 1, 4
                vari_curr(j) = vari_prev(j)*(un-(z2-zaust)/(un-zaust))
            end do
        else
            do j = 1, 4
                vari_curr(j) = vari_prev(j)
            end do
        endif
    endif
!
! - Compute austenite
!
    zaust = un - vari_curr(1) - vari_curr(2) - vari_curr(3) - vari_curr(4)
    if (zaust .le. r8prem()) then
        zaust = 0.d0
    endif
    if (zaust .ge. 1.d0) then
        zaust = 1.d0
    endif
    vari_curr(PAUSTENITE) = zaust
!
end subroutine
