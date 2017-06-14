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

subroutine lc0021(fami, kpg, ksp, ndim, imate,&
                  compor, carcri, instam, instap, epsm,&
                  deps, sigm, vim, option, angmas,&
                  sigp, vip, typmod, icomp,&
                  nvi, dsidep, codret)
!
implicit none
!
#include "asterfort/lcumfp.h"
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
    real(kind=8), intent(in) :: carcri(*)
    real(kind=8), intent(in) :: instam
    real(kind=8), intent(in) :: instap
    real(kind=8), intent(in) :: epsm(6)
    real(kind=8), intent(in) :: deps(6)
    real(kind=8), intent(in) :: sigm(6)
    real(kind=8), intent(in) :: vim(*)
    character(len=16), intent(in) :: option
    real(kind=8), intent(in) :: angmas(*)
    real(kind=8), intent(out) :: sigp(6)
    real(kind=8), intent(out) :: vip(*)
    character(len=8), intent(in) :: typmod(*)
    integer, intent(in) :: icomp
    integer, intent(in) :: nvi
    real(kind=8), intent(out) :: dsidep(6, 6)
    integer, intent(out) :: codret
!
! --------------------------------------------------------------------------------------------------
!
! Behaviour
!
! Beton_UMLV
!
! --------------------------------------------------------------------------------------------------
!
    character(len=16) :: rela_plas
!
! --------------------------------------------------------------------------------------------------
!
    if (compor(CREEP_NAME) .eq. 'BETON_UMLV') then
        rela_plas = compor(PLAS_NAME)
    else
        rela_plas = ' '
    endif
    codret    = 0
    call lcumfp(fami, kpg, ksp, ndim, typmod,&
                imate, compor, instam, instap, epsm,&
                deps, sigm, vim, option, rela_plas,&
                sigp, vip, dsidep)
end subroutine
