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
subroutine equthp(option   , j_mater  ,&
                  typmod   , angl_naut,&
                  ndim     , nbvari   ,&
                  kpi      , npg      ,&
                  dimdef   , dimcon   ,&
                  mecani   , press1   , press2, tempe ,&
                  compor   , carcri   ,&
                  thmc     , hydr     ,&
                  advihy   , advico   ,&
                  vihrho   , vicphi   , vicpvp, vicsat,&
                  defgem   , defgep   ,&
                  congem   , congep   ,&
                  vintm    , vintp    ,&
                  time_prev, time_curr,&
                  r        , drds     , dsde  , retcom)
!
use THM_type
use THM_module
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/comthm.h"
!
character(len=16), intent(in) :: option
integer, intent(in) :: j_mater
character(len=8), intent(in) :: typmod(2)
real(kind=8), intent(in)  :: angl_naut(3)
integer, intent(in) :: ndim, nbvari
integer, intent(in) :: npg, kpi
integer, intent(in) :: dimdef, dimcon
integer, intent(in) :: mecani(5), press1(7), press2(7), tempe(5)
character(len=16), intent(in)  :: compor(*)
real(kind=8), intent(in) :: carcri(*)
character(len=16), intent(in) :: thmc, hydr
integer, intent(in) :: advihy, advico
integer, intent(in) :: vihrho, vicphi, vicpvp, vicsat
real(kind=8), intent(in) :: defgem(1:dimdef), defgep(1:dimdef)
real(kind=8), intent(inout) :: congem(1:dimcon), congep(1:dimcon)
real(kind=8), intent(in) :: vintm(1:nbvari)
real(kind=8), intent(inout) :: vintp(1:nbvari)
real(kind=8), intent(in) :: time_prev, time_curr
real(kind=8), intent(out) :: r(1:dimdef+1)
real(kind=8), intent(out) :: drds(1:dimdef+1, 1:dimcon), dsde(1:dimcon, 1:dimdef)
integer, intent(out) :: retcom
!
! --------------------------------------------------------------------------------------------------
!
! THM - Compute
!
! Compute generalized stresses and derivatives at current Gauss point - Steady version
!
! --------------------------------------------------------------------------------------------------
!
! In  option           : name of option- to compute
! In  j_mater          : coded material address
! In  typmod           : type of modelization (TYPMOD2)
! In  angl_naut        : nautical angles
! In  ndim             : dimension of space (2 or 3)
! In  nbvari           : total number of internal state variables
! In  kpi              : current Gauss point
! In  npg              : number of Gauss points
! In  dimdef           : dimension of generalized strains vector
! In  dimcon           : dimension of generalized stresses vector
! In  mecani           : parameters for mechanic
! In  press1           : parameters for hydraulic (capillary pressure)
! In  press2           : parameters for hydraulic (gaz pressure)
! In  tempe            : parameters for thermic
! In  compor           : behaviour
! In  carcri           : parameters for comportment
! In  thmc             : coupling law
! In  hydr             : hydraulic law
! In  advihy           : index of internal state variable for hydraulic law 
! In  advico           : index of first internal state variable for coupling law
! In  vihrho           : index of internal state variable for volumic mass of liquid
! In  vicphi           : index of internal state variable for porosity
! In  vicpvp           : index of internal state variable for pressure of steam
! In  vicsat           : index of internal state variable for saturation
! In  defgem           : generalized strains - At begin of current step
! In  defgep           : generalized strains - At end of current step
! IO  congem           : generalized stresses - At begin of current step
! IO  congep           : generalized stresses - At end of current step
! In  vintm            : internal state variables - At begin of current step
! IO  vintp            : internal state variables - At end of current step
! In  time_prev        : time at beginning of step
! In  time_curr        : time at end of step
! Out r                : non-linear residual vector
! Out drds             : derivative matrix (residual/stress)
! Out dsde             : derivative matrix (stress/strain)
! Out retcom           : return code for error
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i
    integer :: addeme, addete, addep1, addep2
    integer :: adcp11, adcp12, adcp21, adcp22
    integer :: adcome, adcote
    real(kind=8) :: gravity(3)
    aster_logical :: l_steady
    real(kind=8), parameter :: rac2 = sqrt(2.d0)
!
! --------------------------------------------------------------------------------------------------
!
    drds(1:dimdef+1,1:dimcon) = 0.d0
    dsde(1:dimcon,1:dimdef)   = 0.d0
    r(1:dimdef+1)             = 0.d0
    gravity(:)                = 0.d0
    retcom                    = 0
    l_steady                  = ASTER_TRUE
!
! - Address in generalized strains vector
!
    addeme = mecani(2)
    addete = tempe(2)
    addep1 = press1(3)
    addep2 = press2(3)
!
! - Address in generalized stresses vector
!
    adcome = mecani(3)
    adcote = tempe(3)
    adcp11 = press1(4)
    adcp12 = press1(5)
    adcp21 = press2(4)
    adcp22 = press2(5)
!
! - Add sqrt(2) for stresses
!
    if (ds_thm%ds_elem%l_dof_meca) then
        do i = 4, 6
            congem(adcome+i-1) = congem(adcome+i-1)*rac2
        end do
    endif
!
! - Initialization of stresses
!
    if ((option .eq.'RAPH_MECA') .or. (option(1:9).eq.'FULL_MECA')) then
        do i = 1, dimcon
            congep(i) = congem(i)
        end do
    endif
!
! - Compute generalized stresses and derivatives at current Gauss point
!
    call comthm(l_steady ,&
                option   , j_mater  ,&
                typmod   , angl_naut,&
                thmc     , hydr     ,&     
                ndim     , nbvari   ,&
                dimdef   , dimcon   ,&
                adcome   , adcote   , adcp11  , adcp12, adcp21, adcp22,&
                addeme   , addete   , addep1  , addep2,&
                advico   , advihy   ,&
                vihrho   , vicphi   , vicpvp  , vicsat,&
                kpi      , npg      ,&
                compor   , carcri   ,&
                defgem   , defgep   ,& 
                congem   , congep   ,& 
                vintm    , vintp    ,& 
                time_prev, time_curr,&
                dsde     , gravity  , retcom)
    if (retcom .ne. 0) then
        goto 99
    endif
!
! - Compute non-linear residual
!
    if ((option(1:9).eq.'FULL_MECA') .or. (option(1:9).eq.'RAPH_MECA')) then
        if (ds_thm%ds_elem%l_dof_meca) then
            do i = 1, 6
                r(addeme+ndim+i-1) = r(addeme+ndim+i-1) + congep(adcome+i-1)
            end do
            do i = 1, 6
                r(addeme+ndim+i-1) = r(addeme+ndim-1+i) + congep(adcome+6+i-1)
            end do
        endif
        if (ds_thm%ds_elem%l_dof_pre1) then
            do i = 1, ndim
                r(addep1+i) = r(addep1+i) + congep(adcp11+i-1)
            end do
        endif
    endif
!
! - Compute derivative
!
    if ((option(1:9) .eq. 'RIGI_MECA') .or. (option(1:9) .eq. 'FULL_MECA')) then
        if (ds_thm%ds_elem%l_dof_meca) then
            do i = 1, 6
                drds(addeme+ndim-1+i,adcome+i-1)   = drds(addeme+ndim-1+i,adcome+i-1)+1.d0
            end do
            do i = 1, 6
                drds(addeme+ndim-1+i,adcome+6+i-1) = drds(addeme+ndim-1+i,adcome+6+i-1)+1.d0
            end do
        endif
        if (ds_thm%ds_elem%l_dof_pre1) then
            do i = 1, ndim
                drds(addep1+i,adcp11+i-1) = drds(addep1+i,adcp11+i-1)+1.d0
            end do
        endif
    endif
!
! - Add sqrt(2) for stresses
!
    if ((ds_thm%ds_elem%l_dof_meca) .and.&
        ((option .eq.'RAPH_MECA') .or. (option(1:9).eq.'FULL_MECA'))) then
        do i = 4, 6
            congep(adcome+i-1) = congep(adcome+i-1)/rac2
        end do
    endif
!
99  continue
!
end subroutine
