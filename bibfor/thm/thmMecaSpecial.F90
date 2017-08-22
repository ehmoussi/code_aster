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
! aslint: disable=W1504
!
subroutine thmMecaSpecial(option , meca     , nume_thmc,&
                          yate   , yap1     , yap2     ,&
                          p1     , dp1      , p2       , dp2   , satur, tbiot,&
                          j_mater, ndim     , typmod   , carcri,&
                          addeme , adcome   , addep1   , addep2,&
                          dimdef , dimcon   ,&
                          defgem , deps     ,&
                          congem , vintm    ,&
                          congep , vintp    ,&
                          dsde   , ther_meca, retcom)
!
use THM_type
use THM_module
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/utmess.h"
#include "asterfort/nmbarc.h"
#include "asterfort/elagon.h"
#include "asterfort/dsipdp.h"
#include "asterfort/lchbr2.h"
!
character(len=16), intent(in) :: option, meca
integer, intent(in) :: yate, yap1, yap2
integer, intent(in) :: j_mater, nume_thmc
real(kind=8), intent(in) :: p1, dp1, p2, dp2, satur, tbiot(6)
character(len=8), intent(in) :: typmod(2)
real(kind=8), intent(in) :: carcri(*)
integer, intent(in) :: ndim, dimdef, dimcon
integer, intent(in) :: addeme, adcome, addep1, addep2
real(kind=8), intent(in) :: vintm(*)
real(kind=8), intent(in) :: defgem(dimdef), deps(6), congem(dimcon)
real(kind=8), intent(inout) :: congep(dimcon)
real(kind=8), intent(inout) :: vintp(*)
real(kind=8), intent(inout) :: dsde(dimcon, dimdef)
real(kind=8), intent(out) :: ther_meca(6)
integer, intent(out) :: retcom
!
! --------------------------------------------------------------------------------------------------
!
! THM
!
! Special mechanical behaviours (only for THM)
!
! --------------------------------------------------------------------------------------------------
!
! In  option           : option to compute
! In  meca             : mechanical law for THM
! In  nume_thmc        : index of coupling law for THM
! In  yate             : 1 if thermic dof
! In  yap1             : 1 if first pressure dof
! In  yap2             : 1 if second pressure dof
! In  p1               : first pressure - At end of current step
! In  dp1              : increment of first pressure
! In  p2               : first pressure - At end of current step
! In  dp2              : increment of first pressure
! In  satur            : saturation
! In  tbiot            : tensor of Biot
! In  j_mater          : coded material address
! In  ndim             : dimension of space (2 or 3)
! In  typmod           : type of modelization (TYPMOD2)
! In  carcri           : parameters for comportment
! In  addeme           : adress of mechanic dof in vector and matrix (generalized quantities)
! In  adcome           : adress of mechanic stress in generalized stresses vector
! In  addep1           : adress of p1 dof in vector and matrix (generalized quantities)
! In  addep2           : adress of p2 dof in vector and matrix (generalized quantities)
! In  dimdef           : dimension of generalized strains vector
! In  dimcon           : dimension of generalized stresses vector
! In  defgem           : generalized strains - At begin of current step
! In  deps             : increment of mechanic strains
! In  congem           : generalized stresses - At begin of current step
! In  vintm            : internal state variables - At begin of current step
! IO  congep           : generalized stresses - At end of current step
! IO  vintp            : internal state variables - At end of current step
! IO  dsde             : derivative matrix
! Out ther_meca        : product [Elas] {alpha}
! Out retcom           : return code
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i, j
    real(kind=8) :: alpha0, young, nu
    aster_logical :: l_matrix, l_dspdp2
    real(kind=8) :: dsdeme(6, 6), dsidp1(6), dsidp2(6), dspdp1, dspdp2
    real(kind=8) :: sipm, sipp
!
! --------------------------------------------------------------------------------------------------
!
    dsdeme(:, :)   = 0.d0
    dsidp1(:)      = 0.d0
    dsidp2(:)      = 0.d0 
    dspdp1         = 0.d0 
    dspdp2         = 0.d0
    ther_meca(:)   = 0.d0
    retcom         = 0
    l_dspdp2       = ASTER_FALSE
    l_matrix       = (option(1:9).eq.'RIGI_MECA') .or. (option(1:9) .eq.'FULL_MECA')
    young          = ds_thm%ds_material%elas%e
    nu             = ds_thm%ds_material%elas%nu
    alpha0         = ds_thm%ds_material%ther%alpha

    if (meca .eq. 'BARCELONE') then
! ----- Compute behaviour
        sipm = congem(adcome+6)
        sipp = congep(adcome+6)
        call nmbarc(ndim  , j_mater       , carcri, satur   , tbiot(1),&
                    deps  , congem(adcome), vintm ,&
                    option, congep(adcome), vintp , dsdeme, p1      ,&
                    p2    , dp1           , dp2   , dsidp1, sipm    ,&
                    sipp  , retcom)
! ----- Add mecanic and p1 matrix
        if (l_matrix) then
            do i = 1, 2*ndim
                dsde(adcome+i-1,addep1) = dsde(adcome+i-1,addep1) + dsidp1(i)
                do j = 1, 2*ndim
                    dsde(adcome+i-1,addeme+ndim+j-1) = dsde(adcome+i-1,addeme+ndim+j-1) + &
                                                       dsdeme(i,j)
                end do
            end do
        endif
! ----- Compute thermic dilatation
        if (yate .eq. 1) then
            do i = 1, 3
                ther_meca(i) = -alpha0*(&
                                dsde(adcome-1+i,addeme+ndim-1+1)+&
                                dsde(adcome-1+i,addeme+ndim-1+2)+&
                                dsde(adcome-1+i,addeme+ndim-1+3))/3.d0
            end do
        endif   
    elseif (meca .eq. 'GONF_ELAS') then
! ----- Compute behaviour
        sipm = congem(adcome+6)
        sipp = congep(adcome+6)
        call elagon(ndim  , j_mater       , tbiot(1),&
                    alpha0, deps          , young   , &
                    nu    , congem(adcome), option  , congep(adcome), dsdeme,&
                    p1    , dp1           , dsidp1  , dsidp2)
! ----- Add mecanic and p1 matrix
        if (l_matrix) then
            do i = 1, 2*ndim
                dsde(adcome+i-1,addep1) = dsde(adcome+i-1,addep1) + dsidp1(i)
                do j = 1, 2*ndim
                    dsde(adcome+i-1,addeme+ndim+j-1) = dsde(adcome+i-1,addeme+ndim+j-1) +&
                                                       dsdeme(i,j)
                end do
            end do
        endif
! ----- Add p2 matrix
        if (l_matrix) then
            if (yap2 .ge. 1) then
                do i = 1, 2*ndim
                    dsde(adcome+i-1,addep2) = dsde(adcome+i-1,addep2) + dsidp2(i)
                end do
            endif
        endif
! ----- Compute thermic dilatation
        if (yate .eq. 1) then
            do i = 1, 3
                ther_meca(i) = -alpha0*(&
                                dsde(adcome-1+i,addeme+ndim-1+1)+&
                                dsde(adcome-1+i,addeme+ndim-1+2)+&
                                dsde(adcome-1+i,addeme+ndim-1+3))/3.d0
            end do
        endif
    elseif (meca .eq. 'HOEK_BROWN_TOT') then
! ----- Preparation for HOEK_BROWN_TOT
        call dsipdp(nume_thmc,&
                    adcome, addep1, addep2  ,&
                    dimcon, dimdef, dsde    ,&
                    dspdp1, dspdp2, l_dspdp2)
! ----- Compute behaviour
        sipm = congem(adcome+6)
        sipp = congep(adcome+6)
        call lchbr2(typmod        , option             , j_mater, carcri,&
                    congem(adcome), defgem(addeme+ndim), deps   , vintm ,&
                    vintp         , dspdp1             , dspdp2 , sipp  , congep(adcome),&
                    dsdeme        , dsidp1             , dsidp2 , retcom)
        if (l_matrix) then
            do i = 1, 2*ndim
                if (yap1 .ge. 1) then
                    dsde(adcome+i-1,addep1) = dsde(adcome+i-1,addep1) + dsidp1(i)
                endif
                if (l_dspdp2) then
                    dsde(adcome+i-1,addep2) = dsde(adcome+i-1,addep2) + dsidp2(i)
                endif
                do j = 1, 2*ndim
                    dsde(adcome+i-1,addeme+ndim+j-1) = dsde(adcome+i-1,addeme+ndim+j-1) +&
                                                       dsdeme(i,j)
                end do
            end do
        endif
! ----- Compute thermic dilatation
        if (yate .eq. 1) then
            do i = 1, 3
                ther_meca(i) = -alpha0*(&
                                dsde(adcome-1+i,addeme+ndim-1+1)+&
                                dsde(adcome-1+i,addeme+ndim-1+2)+&
                                dsde(adcome-1+i,addeme+ndim-1+3))/3.d0
            end do
        endif
    else
        call utmess('F', 'THM1_1', sk = meca)
    endif
!
end subroutine
