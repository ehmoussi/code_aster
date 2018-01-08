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

subroutine zacier(jv_mater ,&
                  nbhist, ftrc, trc, coef,&
                  fmod, ckm, nbtrc, tpg0, tpg1,&
                  tpg2, dt10, dt21, tamp, metapg)
!
use Metallurgy_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/metaSteelGetParameters.h"
#include "asterfort/smcarc.h"
#include "asterfort/utmess.h"
!
integer, intent(in) :: jv_mater
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
!
!       EVOLUTION METALLURGIQUE POUR ACIER
!
!   - FONCTION :                                                       C
!       CALCUL DE Z(N+1) CONNAISSANT T(N), TPOINT(N), Z(N) ET T(N+1)
!   - ENTREES :
!       NBHIST           : NBRE D HISTOIRES EXPERIMENTALE DE DEFI_TRC  C
!       FTRC(3*NBHIST,3) : VECTEUR DZ/DT EXPERIMENTAUX (VIDE EN ENTREE)C
!       TRC (3*NBHIST,5) : VECTEUR Z,T EXPERIMENTAUX (VIDE EN ENTREE)  C
!       FMOD(*)          : ENSEMBLE DES HISTOIRES EXPERIMENTALES       C
!       CKM(6*NBTRC)     : VECTEUR DES LOIS MS(Z) SEUIL,AKM,BKM,TPLM C
!                          ET TAILLE DE GRAIN AUSTENITIQUE DREF,A     C
!       NBTRC            : NBRE DE LOIS MS(Z)                          C
!       TPG0             : TEMPERATURE AU POINT DE GAUSS INSTANT N-1   C
!       TPG1             : TEMPERATURE AU POINT DE GAUSS INSTANT N     C
!       TPG2             : TEMPERATURE AU POINT DE GAUSS INSTANT N+1   C
!       DT10             : DELTATT ENTRE N-1 ET N                      C
!       DT21             : DELTATT ENTRE N  ET N+                      C
!       TAMP(7)          : PHASMETA(N) ZF,ZP,ZB,ZM,P,T,MS           C
!   - SORTIES :                                                        C
!       METAPG(7)          : PHASMETA(N+1) ZF,ZP,ZB,ZM,P,T,MS          C
!
!-----------------------------------------------------------------------
!
    real(kind=8) :: metapg(7), tamp(7), tempo(7)
    integer :: nbhist, nbtrc
    real(kind=8) :: ftrc((3*nbhist), 3), trc((3*nbhist), 5), fmod(*)
    real(kind=8) :: ckm(6*nbtrc), coef(*), dt10, dt21, tpg0, tpg1, tpg2
    real(kind=8) :: lambda, unsurl, dmoins
    real(kind=8) :: dlim, dz
    real(kind=8) :: tpoint, zero, ti, tpi
    real(kind=8) :: zeq1, zeq2, z1, z2, epsi
    real(kind=8) :: un
    real(kind=8) :: zeq1i, zeq2i, ti1, ti2, taux, z1i
    real(kind=8) :: a, b, c, delta
    integer :: i, j, nbpas
    aster_logical :: lrefr
    type(META_SteelParameters) :: metaSteelPara
!
! --------------------------------------------------------------------------------------------------
!
    zero = 0.d0
    epsi = 1.d-10
    un = 1.d0
!
! - Get material parameters for steel
!
    call metaSteelGetParameters(jv_mater, metaSteelPara)

    metapg(6) = tpg2
    metapg(7) = tamp(7)
    tpoint = (tpg1-tpg0)/dt10
    z1 = zero
    do j = 1, 4
        z1 = z1+tamp(j)
    end do
    z1 = un - z1
    zeq1 = min((tpg1-metaSteelPara%ac1)/(metaSteelPara%ac3-metaSteelPara%ac1) , un )
    zeq2 = min((tpg2-metaSteelPara%ac1)/(metaSteelPara%ac3-metaSteelPara%ac1) , un )
    if (tpoint .gt. zero) then
        lrefr = ASTER_FALSE
    else if (tpg2 .gt. metaSteelPara%ar3) then
        lrefr = ASTER_FALSE
    else if (tpg2 .lt. metaSteelPara%ac1) then
        lrefr = ASTER_TRUE
    else if (tpoint .lt. zero) then
        lrefr = ASTER_TRUE
    else if (z1 .le. zeq2) then
        lrefr = ASTER_FALSE
    else
        lrefr = ASTER_TRUE
    endif
!
    if (lrefr) then
        if (abs(tpg2-tpg1) .gt. 5.001d0) then
            nbpas = int(abs(tpg2-tpg1)/5.d0-0.001d0)+1
            dt21 = dt21/dble(nbpas)
            do j = 1, 7
                tempo(j) = tamp(j)
            end do
            do i = 1, nbpas
                ti = tpg1+(tpg2-tpg1)*dble(i-1)/dble(nbpas)
                metapg(6) = tpg1+(dble(i)*(tpg2-tpg1)) /dble(nbpas)
                tpi = (metapg(6)-ti)/dt21
                call smcarc(nbhist       , ftrc , trc ,&
                            coef         , fmod ,&
                            metaSteelPara, nbtrc, ckm ,&
                            ti           , tpi  , dt10,&
                            tempo        , metapg)
                do j = 1, 7
                    tempo(j) = metapg(j)
                end do
            end do
        else
            call smcarc(nbhist       , ftrc  , trc  ,&
                        coef         , fmod  ,&
                        metaSteelPara, nbtrc , ckm ,&
                        tpg1         , tpoint, dt10,&
                        tamp         , metapg)
!
        endif
    else
        if (abs(tpg2-tpg1) .gt. 5.001d0) then
! ----------------SUBDIVISION EN PAS DE CING DEGRE MAX
            nbpas = int(abs(tpg2-tpg1)/5.d0-0.001d0)+1
            dt21 = dt21/dble(nbpas)
            z1i = z1
            dmoins=tamp(5)
            do i = 1, nbpas
                ti1 = tpg1+(tpg2-tpg1)*dble(i-1)/dble(nbpas)
                ti2 = tpg1+(tpg2-tpg1)*dble(i)/dble(nbpas)
                tpoint = (ti2-ti1)/dt21
                zeq1i = min( (ti1-metaSteelPara%ac1)/(metaSteelPara%ac3-metaSteelPara%ac1) , un )
                zeq2i = min( (ti2-metaSteelPara%ac1)/(metaSteelPara%ac3-metaSteelPara%ac1) , un )
                taux = metaSteelPara%taux_1 + (metaSteelPara%taux_3-metaSteelPara%taux_1)*zeq1i
                if ((ti1.lt.(metaSteelPara%ac1-epsi)) .or. (z1i.ge.un)) then
                    z2 = z1i
                else
                    if (zeq2i .ge. (un-epsi)) tpoint = zero
                    if (z1i .gt. zeq1i) then
                        z2 = (taux*tpoint/(metaSteelPara%ac3-metaSteelPara%ac1))
                        z2 = z2*exp(-dt21/taux)
                        z2 = ((-taux*tpoint/(metaSteelPara%ac3-metaSteelPara%ac1))+zeq2i+z2-zeq1i)*&
                              (un-z1i )/(un-zeq1i )
                        z2 = z2+z1i
                    else
                        z2 = (taux*tpoint/(metaSteelPara%ac3-metaSteelPara%ac1))-zeq1i+z1i
                        z2 = z2*exp(-dt21/taux)
                        z2 = (-taux*tpoint/(metaSteelPara%ac3-metaSteelPara%ac1))+zeq2i+z2
                    endif
                endif
!
!                 CALCUL TAILLE DE GRAIN
!
                if (.not. metaSteelPara%l_grain_size) then
                    unsurl = 0.d0
                    metapg(5) = ckm(5)
                else
                    if (z2 .lt. 1.d-3) then
                        metapg(5)=0.d0
                    else
                        lambda = metaSteelPara%austenite%lambda0*&
                                 exp(metaSteelPara%austenite%qsr_k/(ti1+273.d0))
                        unsurl = 1/lambda
                        dlim = metaSteelPara%austenite%d10*&
                               exp(-metaSteelPara%austenite%wsr_k/(ti1+273.d0))
                        dz = z2-z1i
                        a = 1.d0
                        b = dmoins*(1-dz/z2)-(dt10*unsurl/dlim)
                        c = dt21*unsurl
                        delta = (b**2)+(4.d0*a*c)
                        metapg(5) = (b+delta**0.5d0)/(2.d0*a)
                    endif
                    z1i = z2
                    dmoins = metapg(5)
                endif
            end do
        else
!
            taux = metaSteelPara%taux_1 + (metaSteelPara%taux_3-metaSteelPara%taux_1)*zeq1
            if ((tpg1.lt.(metaSteelPara%ac1-epsi)) .or. (z1.ge.un)) then
                z2 = z1
            else
                if (zeq2 .ge. (un-epsi)) tpoint = zero
                if (z1 .gt. zeq1) then
                    z2 = (taux*tpoint/(metaSteelPara%ac3-metaSteelPara%ac1))
                    z2 = z2*exp(-dt21/taux)
                    z2 = ((-taux*tpoint/(metaSteelPara%ac3-metaSteelPara%ac1))+zeq2+z2-zeq1)*&
                         (un-z1 )/(un-zeq1 )
                    z2 = z2+z1
                else
                    z2 = (taux*tpoint/(metaSteelPara%ac3-metaSteelPara%ac1))-zeq1+z1
                    z2 = z2*exp(-dt21/taux)
                    z2 = (-taux*tpoint/(metaSteelPara%ac3-metaSteelPara%ac1))+zeq2+z2
                endif
            endif
! ---          CALCUL TAILLE DE GRAIN
            if (.not. metaSteelPara%l_grain_size) then
                unsurl = 0.d0
                metapg(5) = ckm(5)
            else
                if (z2 .lt. 1.d-3) then
                    metapg(5)=0.d0
                else
                    dmoins = tamp(5)
                    lambda = metaSteelPara%austenite%lambda0*&
                             exp(metaSteelPara%austenite%qsr_k/(tpg1+273.d0))
                    unsurl = 1/lambda
                    dlim = metaSteelPara%austenite%d10*&
                           exp(-metaSteelPara%austenite%wsr_k/(tpg1+273.d0))
                    dz = z2-z1
                    a = 1.d0
                    b = dmoins*(1-dz/z2)-(dt10*unsurl/dlim)
                    c = dt21*unsurl
                    delta = (b**2)+(4.d0*a*c)
                    metapg(5) = (b+delta**0.5d0)/(2.d0*a)
                endif
            endif
        endif
!           REPARTITION DE DZGAMMA SUR DZALPHA
        if (z2 .gt. (un-epsi)) z2 = un
        if (z1 .ne. un) then
            do j = 1, 4
                metapg(j) = tamp(j)*(un-(z2-z1)/(un-z1))
            end do
        else
            do j = 1, 4
                metapg(j) = tamp(j)
            end do
        endif
    endif
end subroutine
