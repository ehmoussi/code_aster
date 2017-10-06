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
subroutine calcft(option, angl_naut,&
                  ndim  , dimdef   , dimcon,&
                  adcote, &
                  addeme, addete   , addep1, addep2,&
                  temp  , grad_temp,&
                  tbiot ,&
                  phi   , rho11    , satur_, dsatur_,&
                  pvp   , h11      , h12   ,&
                  lambs , dlambs   , lambp , dlambp,&
                  tlambt, tlamct   , tdlamt,&
                  congep, dsde)
!
use THM_type
use THM_module
!
implicit none
!
#include "asterfort/dilata.h"
#include "asterfort/unsmfi.h"
#include "asterfort/THM_type.h"
!
character(len=16), intent(in) :: option
real(kind=8), intent(in) :: angl_naut(3)
integer, intent(in) :: ndim, dimdef, dimcon
integer, intent(in) :: adcote
integer, intent(in) :: addeme, addete, addep1, addep2
real(kind=8), intent(in) :: temp, grad_temp(3)
real(kind=8), intent(in) :: tbiot(6)
real(kind=8), intent(in) :: phi, rho11, satur_, dsatur_
real(kind=8), intent(in) :: pvp, h11, h12
real(kind=8), intent(in) :: lambs, dlambs
real(kind=8), intent(in) :: lambp, dlambp
real(kind=8), intent(in) :: tlambt(ndim, ndim)
real(kind=8), intent(in) :: tlamct(ndim, ndim)
real(kind=8), intent(in) :: tdlamt(ndim, ndim)
real(kind=8), intent(inout) :: congep(1:dimcon), dsde(1:dimcon, 1:dimdef)
!
! --------------------------------------------------------------------------------------------------
!
! THM
!
! Compute flux and stress for thermic
!
! --------------------------------------------------------------------------------------------------
!
! In  option           : name of option- to compute
! In  angl_naut        : nautical angles
! In  ndim             : dimension of space (2 or 3)
! In  dimdef           : dimension of generalized strains vector
! In  dimcon           : dimension of generalized stresses vector
! In  adcote           : adress of thermic components in generalized stresses vector
! In  addeme           : adress of mechanic components in generalized strains vector
! In  addete           : adress of thermic components in generalized strains vector
! In  addep1           : adress of capillary pressure in generalized strains vector
! In  addep2           : adress of gaz pressure in generalized strains vector
! In  temp             : temperature - At end of current step
! In  grad_temp        : gradient of temperature
! In  tbiot            : Biot tensor
! In  phi              : porosity
! In  rho11            : volumic mass for liquid
! In  satur            : saturation
! In  dsatur           : derivative of saturation (/pc)
! In  pvp              : steam pressure
! In  h11              : enthalpy of liquid
! In  h12              : enthalpy of steam
! In  lambs            : thermal conductivity depending on saturation
! In  dlambs           : derivative of thermal conductivity depending on saturation
! In  lambp            : thermal conductivity depending on porosity
! In  dlambp           : derivative of thermal conductivity depending on porosity
! In  tlambt           : tensor of thermal conductivity
! In  tlamct           : tensor of thermal conductivity (constant part)
! In  tdlamt           : tensor of derivatives for thermal conductivity
! IO  congep           : generalized stresses - At end of current step
! IO  dsde             : derivative matrix
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nume_thmc
    integer :: i, j, k
    real(kind=8) :: biot(3, 3)
    real(kind=8) :: rgaz, rho12, mamolv
    real(kind=8) :: alphfi, cs, kron(ndim, ndim)
    real(kind=8) :: lamdt1(ndim, ndim), lamdt2(ndim, ndim)
    real(kind=8) :: lamdt3(ndim, ndim)
    real(kind=8) :: lamdt4(ndim, ndim), lamdt5(ndim, ndim)
    real(kind=8) :: satur, dsatur
!
! --------------------------------------------------------------------------------------------------
!
    kron(1:ndim,1:ndim) = 0.d0
    do i = 1, ndim
        kron(i,i) = 1.d0
    end do
    lamdt1(1:ndim, 1:ndim) = 0.d0
    lamdt2(1:ndim, 1:ndim) = 0.d0
    lamdt3(1:ndim, 1:ndim) = 0.d0
    lamdt4(1:ndim, 1:ndim) = 0.d0
    lamdt5(1:ndim, 1:ndim) = 0.d0
!
! - Get storage parameters for behaviours
!
    nume_thmc = ds_thm%ds_behaviour%nume_thmc
!
! - Get parameters
!
    rgaz   = ds_thm%ds_material%solid%r_gaz
    mamolv = ds_thm%ds_material%steam%mass_mol
!
! - Change biot tensor with thermic
!
    biot(1,1) = tbiot(1)
    biot(2,2) = tbiot(2)
    biot(3,3) = tbiot(3)
    biot(1,2) = tbiot(4)
    biot(1,3) = tbiot(5)
    biot(2,3) = tbiot(6)
    biot(2,1) = biot(1,2)
    biot(3,1) = biot(1,3)
    biot(3,2) = biot(2,3)
!
    if (ds_thm%ds_elem%l_dof_meca) then
        call dilata(angl_naut, phi, tbiot, alphfi)
        call unsmfi(phi, tbiot, cs)
    else
        alphfi = 0.d0
        cs = 0.d0
    endif
!
! - Set saturation
!
    if (nume_thmc .eq. GAZ) then
        satur  = 0.d0
        dsatur = 0.d0
    else if (nume_thmc .eq. LIQU_SATU) then
        satur  = 1.d0
        dsatur = 0.d0
    else
        satur  = satur_
        dsatur = dsatur_
    endif
!
! - Compute tensor of thermic conductivity
!
    if (nume_thmc .eq. LIQU_VAPE) then
        rho12  = mamolv*pvp/rgaz/temp
        do i = 1, ndim
            do j = 1, ndim
                lamdt1(i,j) = lamdt1(i,j)+&
                              lambs*lambp*tlambt(i,j)+&
                              tlamct(i,j)
                lamdt2(i,j) = lamdt2(i,j)+&
                              (biot(i,j)-phi*kron(i,j))*tlambt(j,i)*dlambp*lambs
                lamdt3(i,j) = lamdt3(i,j)+&
                              (rho12/rho11-1.d0)*lambp*dlambs*tlambt(i,j)*dsatur +&
                              cs*(satur+(1.d0-satur)*rho12/rho11)*dlambp*lambs*tlambt(i,j)
                lamdt4(i,j) = 0.d0
                lamdt5(i,j) = lamdt5(i,j)+&
                              lambs*lambp*tdlamt(i,j)+&
                              (-3.d0*alphfi+cs*(1.d0-satur)*rho12*(h12-h11)/temp)*&
                               dlambp*lambs*tlambt(i,j) +&
                              lambp*dlambs*tlambt(i,j)*dsatur*rho12*(h12-h11)/temp
            end do
        end do
    else
        do i = 1, ndim
            do j = 1, ndim
                lamdt1(i,j) = lamdt1(i,j)+&
                              lambs*lambp*tlambt(i,j)+&
                              tlamct(i,j)
                lamdt2(i,j) = lamdt2(i,j)+&
                              (biot(i,j)-phi*kron(i,j))*tlambt(j,i)*dlambp*lambs
                lamdt3(i,j) = lamdt3(i,j)+&
                              lambp*dlambs*tlambt(i,j)*dsatur-&
                              satur*cs*dlambp*lambs*tlambt(i,j)
                lamdt4(i,j) = lamdt4(i,j)+&
                              cs*dlambp*lambs*tlambt(i,j)
                lamdt5(i,j) = lamdt5(i,j)+&
                              lambs*lambp*tdlamt(i,j)-&
                              3.d0*alphfi*dlambp*lambs*tlambt(i,j)
            end do
        end do
    endif
!
! - Compute matrix
!
    if ((option(1:9).eq.'RIGI_MECA') .or. (option(1:9).eq.'FULL_MECA')) then
        do i = 1, ndim
            do j = 1, ndim
                dsde(adcote+i,addete+j) = dsde(adcote+i,addete+j)-lamdt1(i,j)
                dsde(adcote+i,addete)   = dsde(adcote+i,addete)- lamdt5(i,j)*grad_temp(j)
            end do
            if (ds_thm%ds_elem%l_dof_meca) then
                do j = 1, 6
                    do k = 1, ndim
                        dsde(adcote+i,addeme+ndim-1+j) = dsde(adcote+i,addeme+ndim-1+j)-&
                                                         lamdt2(i,k)*grad_temp(k)
                    end do
                end do
            endif
            if (ds_thm%ds_elem%l_dof_pre1) then
                do j = 1, ndim
                    dsde(adcote+i,addep1) = dsde(adcote+i,addep1)-&
                                            lamdt3(i,j)*grad_temp(j)
                end do
                if (ds_thm%ds_elem%l_dof_pre2) then
                    do j = 1, ndim
                        dsde(adcote+i,addep2) = dsde(adcote+i,addep2)-&
                                                lamdt4(i,j)*grad_temp(j)
                    end do
                endif
            endif
        end do
    endif
!
! - Compute generalized stress
!
    if ((option(1:9).eq.'RAPH_MECA') .or. (option(1:9).eq.'FULL_MECA')) then
        do i = 1, ndim
            congep(adcote+i) = 0.d0
            do j = 1, ndim
                congep(adcote+i) = congep(adcote+i)-lamdt1(i,j)*grad_temp(j)
            end do
        end do
    endif
!
end subroutine
