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
! person_in_charge: sylvie.granet at edf.fr
!
subroutine calcme(option, j_mater, ndim  , typmod, angl_naut,&
                  compor, carcri , instam, instap,&
                  addeme, adcome , dimdef, dimcon,&
                  defgem, deps   ,&
                  congem, vintm  ,&
                  congep, vintp  ,&
                  dsdeme, retcom )
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/nmcomp.h"
#include "asterfort/lcidbg.h"
!
character(len=16), intent(in) :: option, compor(*)
integer, intent(in) :: j_mater
character(len=8), intent(in) :: typmod(2)
real(kind=8), intent(in) :: carcri(*)
real(kind=8), intent(in) :: instam, instap
integer, intent(in) :: ndim, dimdef, dimcon, addeme, adcome
real(kind=8), intent(in) :: vintm(*)
real(kind=8), intent(in) :: angl_naut(3)
real(kind=8), intent(in) :: defgem(dimdef), deps(6), congem(dimcon)
real(kind=8), intent(inout) :: congep(dimcon)
real(kind=8), intent(inout) :: vintp(*)
real(kind=8), intent(out) :: dsdeme(6, 6)
integer, intent(out) :: retcom
!
! --------------------------------------------------------------------------------------------------
!
! THM
!
! Standard mechanical behaviour
!
! --------------------------------------------------------------------------------------------------
!
! In  option           : option to compute
! In  j_mater          : coded material address
! In  ndim             : dimension of space (2 or 3)
! In  typmod           : type of modelization (TYPMOD2)
! In  angl_naut        : nautical angles
!                        (1) Alpha - clockwise around Z0
!                        (2) Beta  - counterclockwise around Y1
!                        (3) Gamma - clockwise around X
! In  compor           : behaviour
! In  carcri           : parameters for comportment
! In  instam           : time at beginning of time step
! In  instap           : time at end of time step
! In  addeme           : adress of mechanic dof in vector and matrix (generalized quantities)
! In  adcome           : adress of mechanic stress in generalized stresses vector
! In  dimdef           : dimension of generalized strains vector
! In  dimcon           : dimension of generalized stresses vector
! In  defgem           : generalized strains - At begin of current step
! In  deps             : increment of mechanic strains
! In  congem           : generalized stresses - At begin of current step
! In  vintm            : internal state variables - At begin of current step
! IO  congep           : generalized stresses - At end of current step
! IO  vintp            : internal state variables - At end of current step
! Out dsdeme           : derivative of sigma/stress for mechanics
! Out retcom           : return code
!
! --------------------------------------------------------------------------------------------------
!
    integer, parameter :: nwkin = 1
    integer, parameter :: nwkout = 1
    real(kind=8), parameter :: wkin(1) = 0.d0
    real(kind=8), parameter :: wkout(1) = 0.d0
    integer, parameter :: nsig = 6
    integer, parameter :: neps = 6
    integer, parameter :: ndsdeme = 36
    integer ::  kpg, ksp
    character(len=8) :: fami
!
! --------------------------------------------------------------------------------------------------
!
    fami        = 'FPG1'
    kpg         = 1
    ksp         = 1
    dsdeme(:,:) = 0.d0
    retcom      = 0
!
! - Integration of mechanical behaviour
!
    call nmcomp(fami          , kpg                , ksp      , ndim  , typmod        ,&
                j_mater       , compor             , carcri   , instam, instap        ,&
                neps          , defgem(addeme+ndim), deps     , nsig  , congem(adcome),&
                vintm         , option             , angl_naut, nwkin , wkin          ,&
                congep(adcome), vintp              , ndsdeme  , dsdeme, nwkout        ,&
                wkout         , retcom)
!
! - If integration has failed
!
    if (retcom .eq. 1) then
        call lcidbg(fami  , kpg   , ksp           , typmod, compor             ,&
                    carcri, instam, instap        , neps  , defgem(addeme+ndim),&
                    deps  , nsig  , congem(adcome), vintm , option) 
    endif
!
end subroutine
