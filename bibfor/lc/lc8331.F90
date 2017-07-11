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

subroutine lc8331(fami, kpg, ksp, ndim, imate,&
                  compor, mult_comp, carcri, instam, instap, neps,&
                  epsm, deps, nsig, sigm, vim,&
                  option, angmas,sigp, nvi, vip, nwkin,&
                  wkin, typmod,icomp, ndsde,&
                  dsidep, nwkout, wkout, codret)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/nmcomp.h"
#include "asterfort/kitPrepBehaviour.h"
!
! aslint: disable=W1504,W0104
!
    character(len=*), intent(in) :: fami
    integer, intent(in) :: kpg
    integer, intent(in) :: ksp
    integer, intent(in) :: ndim
    integer, intent(in) :: imate
    character(len=16), intent(in) :: compor(*)
    character(len=16), intent(in) :: mult_comp
    real(kind=8), intent(in) :: carcri(*)
    real(kind=8), intent(in) :: instam
    real(kind=8), intent(in) :: instap
    integer, intent(in) :: neps
    real(kind=8), intent(in) :: epsm(*)
    real(kind=8), intent(in) :: deps(*)
    integer, intent(in) :: nsig
    real(kind=8), intent(in) :: sigm(*)
    real(kind=8), intent(in) :: vim(*)
    character(len=16), intent(in) :: option
    real(kind=8), intent(in) :: angmas(*)
    real(kind=8), intent(out) :: sigp(*)
    integer, intent(in) :: nvi
    real(kind=8), intent(out) :: vip(*)
    integer, intent(in) :: nwkin
    real(kind=8), intent(in) :: wkin(nwkin)
    character(len=8), intent(in) :: typmod(*)
    integer, intent(in) :: nwkout
    real(kind=8), intent(out) :: wkout(nwkout)
    integer, intent(in) :: icomp
    integer, intent(in) :: ndsde
    real(kind=8), intent(out) :: dsidep(*)
    integer, intent(out) :: codret
!
! --------------------------------------------------------------------------------------------------
!
! Behaviour
!
! KIT_DDI: FLUA_PORO_BETON/ENDO_PORO_BETON
!
! --------------------------------------------------------------------------------------------------
!
    real(kind=8) :: wkinp(10)
    character(len=16) :: compor_creep(20), compor_plas(20)
!
! --------------------------------------------------------------------------------------------------
!
    call kitPrepBehaviour(compor, compor_creep, compor_plas)
!
    if ((option(1:9).eq.'RAPH_MECA') .or. (option(1:9) .eq.'FULL_MECA')) then
        wkinp(1)  = 1.d0
        call nmcomp(fami, kpg, ksp, ndim, typmod,&
                    imate, compor_creep, carcri, instam, instap  ,&
                    neps, epsm, deps, nsig, sigm,&
                    vim, option, angmas, nwkin, wkinp,&
                    sigp, vip, ndsde, dsidep, nwkout,&
                    wkout, codret)
        call nmcomp(fami, kpg, ksp, ndim, typmod,&
                    imate, compor_plas, carcri, instam, instap  ,&
                    neps, epsm, deps, nsig, sigm,&
                    vim, option, angmas, nwkin, wkinp,&
                    sigp, vip, ndsde, dsidep, nwkout,&
                    wkout, codret)
    else if (option(1:9).eq.'RIGI_MECA') then
        wkinp(1)  = 1.d0
        call nmcomp(fami, kpg, ksp, ndim, typmod,&
                    imate, compor_creep, carcri, instam, instap  ,&
                    neps, epsm, deps, nsig, sigm,&
                    vim, option, angmas, nwkin, wkinp,&
                    sigp, vip, ndsde, dsidep, nwkout,&
                    wkout, codret)
    endif
!
end subroutine
