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
! aslint: disable=W1504,W1306
! person_in_charge: sylvie.granet at edf.fr
!
subroutine calcft(option, thmc, imate, ndim, dimdef,&
                  dimcon, yamec, yap1, yap2, addete,&
                  addeme, addep1, addep2, adcote, congep,&
                  dsde, t, grat, phi, pvp,&
                  rgaz, tbiot, sat, dsatp1, lambp,&
                  dlambp, lambs, dlambs, tlambt, tdlamt,&
                  mamolv, tlamct, rho11, h11, h12,&
                  angmas)
! ======================================================================
! ======================================================================

! ROUTINE CALC_FLUX_THERM ----------------------------------------------
! CALCULE LES CONTRAINTES GENERALISEES ET LA MATRICE TANGENTE DES FLUX -
! ======================================================================

    implicit none
#include "asterfort/dilata.h"
#include "asterfort/matini.h"
#include "asterfort/unsmfi.h"
    integer :: ndim, dimdef, dimcon, imate
    integer :: yamec, yap1, yap2
    integer :: addete, addeme, addep1, addep2, adcote
    real(kind=8) :: congep(1:dimcon)
    real(kind=8) :: dsde(1:dimcon, 1:dimdef), mamolv
    integer :: i, j, k
    real(kind=8) :: t, grat(3), phi, sat, dsatp1, pvp
    real(kind=8) :: rgaz, tbiot(6), biot(3, 3)
    real(kind=8) :: lambp, dlambp
    real(kind=8) :: lambs, dlambs
    real(kind=8) :: rho11, h11, h12, rho12
    real(kind=8) :: angmas(3)
    real(kind=8) :: tlambt(ndim, ndim), tlamct(ndim, ndim)
    real(kind=8) :: tdlamt(ndim, ndim)
    real(kind=8) :: alphfi, cs, kron(ndim, ndim)
    real(kind=8) :: lamdt1(ndim, ndim), lamdt2(ndim, ndim)
    real(kind=8) :: lamdt3(ndim, ndim)
    real(kind=8) :: lamdt4(ndim, ndim), lamdt5(ndim, ndim)
    character(len=16) :: option, thmc
! =====================================================================
! --- DEFINITION DU SYMBOLE DE KRONECKER ------------------------------
! =====================================================================
    do i = 1, ndim
        do j = 1, ndim
            kron(i,j) = 0.d0
        end do
    end do
    do i = 1, ndim
        kron(i,i) = 1.d0
    end do
!
    call matini(ndim, ndim, 0.d0, lamdt1)
    call matini(ndim, ndim, 0.d0, lamdt2)
    call matini(ndim, ndim, 0.d0, lamdt3)
    call matini(ndim, ndim, 0.d0, lamdt4)
    call matini(ndim, ndim, 0.d0, lamdt5)
!
! =====================================================================
! --- REDEFINITION DU TENSEUR DE BIOT ---------------------------------
! =====================================================================
    biot(1,1)=tbiot(1)
    biot(2,2)=tbiot(2)
    biot(3,3)=tbiot(3)
    biot(1,2)=tbiot(4)
    biot(1,3)=tbiot(5)
    biot(2,3)=tbiot(6)
    biot(2,1)=biot(1,2)
    biot(3,1)=biot(1,3)
    biot(3,2)=biot(2,3)
! =====================================================================
! --- RECUPERATION DES COEFFICIENTS MECANIQUES ALPHAFI ET CS-----------
! =====================================================================
    if (yamec .eq. 1) then
        call dilata(angmas, phi, tbiot, alphfi)
        call unsmfi(imate, phi, t, tbiot, cs)
    else
! =====================================================================
! --- EN ABSENCE DE MECA ALPHA0 = 0 et 1/KS = 0 -----------------------
! =====================================================================
        alphfi = 0.d0
        cs = 0.d0
    endif
    if (thmc .eq. 'GAZ') then
        sat = 0.d0
        dsatp1 = 0.d0
    else if (thmc.eq.'LIQU_SATU') then
        sat = 1.d0
        dsatp1 = 0.d0
    endif
! =====================================================================
!           LAMDT1 : LAMBDA
!           LAMDT2 : DLAMB / DEPSV
!           LAMDT3 : DLAMB / DP1
!           LAMDT4 : DLAMB / DP2
!           LAMDT5 : DLAMB / DT
! =====================================================================
    if (thmc .eq. 'LIQU_VAPE') then
        rho12=mamolv*pvp/rgaz/t
        do i = 1, ndim
            do j = 1, ndim
                lamdt1(i,j) =lamdt1(i,j)+lambs*lambp*tlambt(i,j)&
                + tlamct(i,j)
                lamdt2(i,j) =lamdt2(i,j)+(biot(i,j)-phi*kron(i,j))&
                *tlambt(j,i)*dlambp*lambs
                lamdt3(i,j) =lamdt3(i,j)+(rho12/rho11-1.d0)*lambp&
                *dlambs*tlambt(i,j)*dsatp1 +cs*(sat+(1.d0-sat)*rho12/&
                rho11)* dlambp*lambs*tlambt(i,j)
                lamdt4(i,j) = 0.d0
                lamdt5(i,j) =lamdt5(i,j)+lambs*lambp*tdlamt(i,j)&
                +(-3.d0*alphfi+cs*(1.d0-sat)* rho12*(h12-h11)/t)*&
                dlambp*lambs* tlambt(i,j) +lambp*dlambs*tlambt(i,j)*&
                dsatp1*rho12* (h12-h11)/t
            end do
        end do
    else
        do i = 1, ndim
            do j = 1, ndim
                lamdt1(i,j) =lamdt1(i,j)+lambs*lambp*tlambt(i,j)&
                + tlamct(i,j)
                lamdt2(i,j) =lamdt2(i,j)+(biot(i,j)-phi*kron(i,j))&
                *tlambt(j,i)*dlambp*lambs
                lamdt3(i,j) =lamdt3(i,j)+lambp*dlambs*tlambt(i,j)*&
                dsatp1 -sat*cs*dlambp*lambs*tlambt(i,j)
                lamdt4(i,j) =lamdt4(i,j)+ cs*dlambp*lambs*tlambt(i,j)
                lamdt5(i,j) =lamdt5(i,j)+ lambs*lambp*tdlamt(i,j)&
                -3.d0*alphfi*dlambp*lambs*tlambt(i,j)
            end do
        end do
    endif
!
! =====================================================================
! --- CALCUL DU FLUX THERMIQUE ----------------------------------------
! =====================================================================
    if ((option(1:9).eq.'RIGI_MECA') .or. (option(1:9).eq.'FULL_MECA')) then
        do i = 1, ndim
            do j = 1, ndim
                dsde(adcote+i,addete+j)=dsde(adcote+i,addete+j)-&
                lamdt1(i,j)
                dsde(adcote+i,addete)=dsde(adcote+i,addete)- lamdt5(i,&
                j)*grat(j)
            end do
            if (yamec .eq. 1) then
                do j = 1, 6
                    do k = 1, ndim
                        dsde(adcote+i,addeme+ndim-1+j)= dsde(adcote+i,&
                        addeme+ndim-1+j)-lamdt2(i,k)*grat(k)
                    end do
                end do
            endif
            if (yap1 .eq. 1) then
                do j = 1, ndim
                    dsde(adcote+i,addep1)=dsde(adcote+i,addep1)&
                    - lamdt3(i,j)*grat(j)
                end do
                if (yap2 .eq. 1) then
                    do j = 1, ndim
                        dsde(adcote+i,addep2)=dsde(adcote+i,addep2)&
                        -lamdt4(i,j)*grat(j)
                    end do
                endif
            endif
        end do
    endif
    if ((option(1:9).eq.'RAPH_MECA') .or. (option(1:9).eq.'FULL_MECA')) then
        do i = 1, ndim
            congep(adcote+i)=0.d0
            do j = 1, ndim
                congep(adcote+i)=congep(adcote+i)-lamdt1(i,j)*grat(j)
            end do
        end do
    endif
! =====================================================================
end subroutine
