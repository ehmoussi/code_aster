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
! person_in_charge: sylvie.granet at edf.fr
! aslint: disable=W1504,W1306
!
subroutine comthm_vf(option   , j_mater  ,&
                     type_elem, angl_naut,&
                     ndim     , nbvari   ,&
                     dimdef   , dimcon   ,&
                     ifa      , valfac   , valcen, &
                     adcome   , adcote   , adcp11, adcp12, adcp21, adcp22,&
                     addeme   , addete   , addep1, addep2,&
                     carcri   ,&
                     defgem   , defgep   ,& 
                     congem   , congep   ,&
                     vintm    , vintp    ,&
                     time_prev, time_curr,&
                     dsde     , gravity  , retcom)
!
use THM_type
use THM_module
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/calcco.h"
#include "asterfort/calcfh_vf.h"
#include "asterfort/calcft.h"
#include "asterfort/thmSelectMeca.h"
#include "asterfort/calcva.h"
#include "asterfort/thmGetParaBiot.h"
#include "asterfort/thmGetParaElas.h"
#include "asterfort/thmGetParaTher.h"
#include "asterfort/thmGetParaHydr.h"
#include "asterfort/thmMatrHooke.h"
#include "asterfort/tebiot.h"
#include "asterfort/thmEvalSatuFinal.h"
#include "asterfort/thmGetPermeabilityTensor.h"
#include "asterfort/thmEvalGravity.h"
#include "asterfort/thmEvalConductivity.h"
#include "asterfort/THM_type.h"
!
character(len=16), intent(in) :: option
integer, intent(in) :: j_mater
character(len=8), intent(in) :: type_elem(2)
real(kind=8), intent(in) :: angl_naut(3)
integer, intent(in) :: ndim, nbvari
integer, intent(in) :: dimdef, dimcon
integer, intent(in) :: adcome, adcote, adcp11, adcp12, adcp21, adcp22
integer, intent(in) :: addeme, addete, addep1, addep2
real(kind=8), intent(in) :: carcri(*)
real(kind=8), intent(in) :: defgem(1:dimdef), defgep(1:dimdef)
real(kind=8), intent(in) :: congem(1:dimcon)
real(kind=8), intent(inout) :: congep(1:dimcon)
real(kind=8), intent(in) :: vintm(1:nbvari)
real(kind=8), intent(inout) :: vintp(nbvari)
real(kind=8), intent(in) :: time_prev, time_curr
real(kind=8), intent(inout) :: dsde(1:dimcon, 1:dimdef)
real(kind=8), intent(out) :: gravity(3)
integer, intent(out) :: retcom
integer, intent(in) :: ifa
integer, parameter :: maxfa = 6
real(kind=8), intent(inout) :: valcen(14, 6)
real(kind=8), intent(inout) :: valfac(maxfa, 14, 6)
!
! --------------------------------------------------------------------------------------------------
!
! THM - Compute
!
! Compute generalized stresses and derivatives
!
! --------------------------------------------------------------------------------------------------
!
! In  l_steady         : flag for no-transient problem
! In  option           : name of option- to compute
! In  j_mater          : coded material address
! In  type_elem        : type of modelization (TYPMOD2)
! In  angl_naut        : nautical angles
! In  ndim             : dimension of space (2 or 3)
! In  nbvari           : total number of internal state variables
! In  dimdef           : dimension of generalized strains vector
! In  dimcon           : dimension of generalized stresses vector
! In  ifa              : index of current face
! IO  valfac           : values at faces
! IO  valcen           : values at nodes
! In  adcome           : adress of mechanic components in generalized stresses vector
! In  adcote           : adress of thermic components in generalized stresses vector
! In  adcp11           : adress of first component and first phase in generalized stresses vector
! In  adcp12           : adress of first component and second phase in generalized stresses vector
! In  adcp21           : adress of second component and first phase in generalized stresses vector
! In  adcp22           : adress of second component and second phase in generalized stresses vector
! In  addeme           : adress of mechanic components in generalized strains vector
! In  addete           : adress of thermic components in generalized strains vector
! In  addep1           : adress of capillary pressure in generalized strains vector
! In  addep2           : adress of gaz pressure in generalized strains vector
! In  carcri           : parameters for comportment
! In  defgem           : generalized strains - At begin of current step
! In  defgep           : generalized strains - At end of current step
! In  congem           : generalized stresses - At begin of current step
! IO  congep           : generalized stresses - At end of current step
! In  vintm            : internal state variables - At begin of current step
! IO  vintp            : internal state variables - At end of current step
! In  time_prev        : time at beginning of step
! In  time_curr        : time at end of step
! Out dsde             : derivative matrix stress/strain (behaviour only)
! Out gravity          : gravity
! Out retcom           : return code for error
!
! --------------------------------------------------------------------------------------------------
!
    integer :: masse, dmasp1, dmasp2
    integer :: eau, air, kpi
    integer :: vkint, kxx, kyy, kzz, kxy, kyz, kzx
    parameter     (masse=10,dmasp1=11,dmasp2=12)
    parameter     (vkint=13)
    parameter     (kxx=1,kyy=2,kzz=3,kxy=4,kyz=5,kzx=6)
    parameter     (eau=1,air=2)
    real(kind=8) :: p1, dp1, grad_p1(3), p2, dp2, grad_p2(3), temp, dtemp, grad_temp(3)
    real(kind=8) :: phi, pvp, pad, h11, h12, rho11, epsv, deps(6), depsv
    real(kind=8) :: tbiot(6), satur, dsatur
    real(kind=8) :: tperm(ndim, ndim)
    real(kind=8) :: lambp, dlambp
    real(kind=8) :: lambs, dlambs
    real(kind=8) :: tlambt(ndim, ndim), tlamct(ndim, ndim), tdlamt(ndim, ndim)
    real(kind=8) :: deltat
    aster_logical :: l_steady
!
! --------------------------------------------------------------------------------------------------
!
    retcom   = 0
    l_steady = ASTER_FALSE
    kpi      = 1
!
! - Update unknowns
!
    call calcva(kpi   , ndim  ,&
                defgem, defgep,&
                addeme, addep1 , addep2   , addete,&
                depsv , epsv   , deps     ,&
                temp  , dtemp  , grad_temp,&
                p1    , dp1    , grad_p1  ,&
                p2    , dp2    , grad_p2  ,&
                retcom)
    if (retcom .ne. 0) then
        goto 99
    endif
!
! - Get hydraulic parameters
!
    call thmGetParaHydr(j_mater)
!
! - Get Biot parameters (for porosity evolution)
!
    call thmGetParaBiot(j_mater)
!
! - Compute Biot tensor
!
    call tebiot(angl_naut, tbiot)
!
! - Get elastic parameters
!
    if (ds_thm%ds_elem%l_dof_meca .or. ds_thm%ds_elem%l_weak_coupling) then
        call thmGetParaElas(j_mater, kpi, temp, ndim)
        call thmMatrHooke(angl_naut)
    endif
!
! - Get thermic parameters
!
    call thmGetParaTher(j_mater, kpi, temp)
!
! - Compute generalized stresses and matrix for coupled quantities
!
    call calcco(l_steady,&
                option  , angl_naut,&
                j_mater  ,&
                ndim    , nbvari   ,&
                dimdef  , dimcon   ,&
                adcome  , adcote   , adcp11, adcp12, adcp21, adcp22,&
                addeme  , addete   , addep1, addep2,&
                temp    , p1       , p2    ,&
                dtemp   , dp1      , dp2   ,&
                deps    , epsv     , depsv ,&
                tbiot   ,&
                phi     , rho11    , satur ,&
                pad     , pvp      , h11   , h12   ,&
                congem  , congep   ,&
                vintm   , vintp    , dsde  ,& 
                retcom)
    if (retcom .ne. 0) then
        goto 99
    endif
!
    if (ifa.eq.0) then
        deltat = time_curr-time_prev
        if ((option(1:9).eq.'FULL_MECA') .or. (option(1:9) .eq.'RAPH_MECA')) then
            valcen(masse,eau) = (congep(adcp11)+congep(adcp12)-congem(adcp11)-congem(adcp12))/deltat
            valcen(masse,air) = (congep(adcp21)+congep(adcp22)-congem(adcp21)-congem(adcp22))/deltat
        endif
        if ((option(1:9) .eq. 'RIGI_MECA') .or. (option(1:9) .eq. 'FULL_MECA')) then
            valcen(dmasp1, eau) = (dsde(adcp11, addep1)+ dsde(adcp12, addep1))/deltat
            valcen(dmasp2, eau) = (dsde(adcp11, addep2)+ dsde(adcp12, addep2))/deltat
            valcen(dmasp1, air) = (dsde(adcp22, addep1)+ dsde(adcp21, addep1))/deltat
            valcen(dmasp2, air) = (dsde(adcp22, addep2)+ dsde(adcp21, addep2))/deltat
        endif
    endif
!
! - Main select subroutine to integrate mechanical behaviour
!
    if (ds_thm%ds_elem%l_dof_meca) then
        call thmSelectMeca(p1       , dp1      ,&
                           p2       , dp2      ,&
                           satur    , tbiot    ,&
                           option   , j_mater  , ndim  , type_elem, angl_naut,&
                           carcri   ,&
                           time_prev, time_curr, dtemp ,&
                           addeme   , addete   , adcome, addep1   , addep2   ,&
                           dimdef   , dimcon   ,&
                           defgem   , deps     ,&
                           congem   , vintm    ,&
                           congep   , vintp    ,&
                           dsde     , retcom)
        if (retcom .ne. 0) then
            goto 99
        endif
    endif
!
! - Evaluation of final saturation
!
    call thmEvalSatuFinal(j_mater, p1    ,&
                          satur  , dsatur, retcom)
!
! - Evaluate thermal conductivity
!
    call thmEvalConductivity(angl_naut, ndim  , j_mater, &
                             satur    , phi   , &
                             lambs    , dlambs, lambp , dlambp,&
                             tlambt   , tlamct, tdlamt)
!
! - Get permeability tensor
!
    call thmGetPermeabilityTensor(ndim , angl_naut, j_mater, phi, vintp(1),&
                                  tperm)
!
! - Compute gravity
!
    call thmEvalGravity(j_mater, time_curr, gravity)
!
! - (re)-compute Biot tensor
!
    call tebiot(angl_naut, tbiot)
!
! - Set conductivities
!
    if (ifa .eq. 0) then
        if (ndim .eq. 3) then
            valcen(vkint, kxx) = tperm(1,1)
            valcen(vkint, kyy) = tperm(2,2)
            valcen(vkint, kzz) = tperm(3,3)
            valcen(vkint, kxy) = tperm(1,2)
            valcen(vkint, kyz) = tperm(1,3)
            valcen(vkint, kzx) = tperm(2,3)
        else
            valcen(vkint, kxx) = tperm(1,1)
            valcen(vkint, kyy) = tperm(1,1)
            valcen(vkint, kzz) = tperm(2,2)
            valcen(vkint, kxy) = tperm(1,2)
            valcen(vkint, kyz) = 0.d0
            valcen(vkint, kzx) = 0.d0
        endif
    endif
!
! - Compute flux and stress for hydraulic
!
    if (ds_thm%ds_elem%l_dof_pre1) then
        call calcfh_vf(option, j_mater, ifa,&
                       temp  , p1    , p2     , pvp, pad,&
                       rho11 , h11   , h12    ,&
                       satur , dsatur, & 
                       valfac, valcen)
        if (retcom .ne. 0) then
            goto 99
        endif
    endif
!
! - Compute flux and stress for thermic
!
    if (ds_thm%ds_elem%l_dof_ther) then
        call calcft(option, angl_naut,&
                    ndim  , dimdef   , dimcon,&
                    adcote, &
                    addeme, addete   , addep1, addep2,&
                    temp  , grad_temp,&
                    tbiot ,&
                    phi   , rho11    , satur, dsatur,&
                    pvp   , h11      , h12   ,&
                    lambs , dlambs   , lambp , dlambp,&
                    tlambt, tlamct   , tdlamt,&
                    congep, dsde)
    endif
!
99  continue
!
end subroutine
