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

subroutine lc8057(fami, kpg, ksp, ndim, imate,&
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
#include "asterfort/Behaviour_type.h"
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
! KIT_DDI: BETON_UMLV / ENDO_ISOT_BETON
!
! --------------------------------------------------------------------------------------------------
!
    character(len=16) :: rela_flua, rela_plas
    character(len=16) :: compor_ext(20)
    integer :: nume_flua, nvi_flua
!
! --------------------------------------------------------------------------------------------------
!
    rela_flua   = compor(CREEP_NAME)
    rela_plas   = compor(PLAS_NAME)
    read (compor(CREEP_NVAR),'(I16)') nvi_flua
    read (compor(CREEP_NUME),'(I16)') nume_flua
    compor_ext(NAME) = rela_flua
    write (compor_ext(NVAR),'(I16)') nvi_flua
    compor_ext(DEFO) = compor(DEFO)
    write (compor_ext(NUME),'(I16)') nume_flua
    compor_ext(CREEP_NAME) = rela_flua
    compor_ext(PLAS_NAME) = rela_plas
!
    call nmcomp(fami, kpg, ksp, ndim, typmod,&
                imate, compor_ext, carcri, instam, instap  ,&
                neps, epsm, deps, nsig, sigm,&
                vim, option, angmas, nwkin, wkin,&
                sigp, vip, ndsde, dsidep, nwkout,&
                wkout, codret)
!
end subroutine
