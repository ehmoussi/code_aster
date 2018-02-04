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

subroutine lc0015(fami, kpg, ksp, ndim, imate,&
                  compor, carcri, instam, instap, epsm,&
                  deps, sigm, vim, option, angmas,&
                  sigp, vip, typmod, icomp,&
                  nvi, dsidep, codret)
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/lcgdpm.h"
#include "asterfort/nzcifw.h"
#include "asterfort/nzcizi.h"
#include "asterfort/nzedga.h"
#include "asterfort/nzgdzi.h"
#include "asterfort/nzisfw.h"
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
    real(kind=8), intent(in) :: epsm(*)
    real(kind=8), intent(in) :: deps(*)
    real(kind=8), intent(in) :: sigm(*)
    real(kind=8), intent(in) :: vim(*)
    character(len=16), intent(in) :: option
    real(kind=8), intent(in) :: angmas(*)
    real(kind=8), intent(out) :: sigp(*)
    real(kind=8), intent(out) :: vip(*)
    character(len=8), intent(in) :: typmod(*)
    integer, intent(in) :: icomp
    integer, intent(in) :: nvi
    real(kind=8), intent(out) :: dsidep(*)
    integer, intent(out) :: codret
!
! --------------------------------------------------------------------------------------------------
!
! Behaviour
!
! 'META_*'
!
! --------------------------------------------------------------------------------------------------
!
    if (compor(RELA_NAME)(8:8) .eq. 'I') then
        if (compor(META_NAME) .eq. 'ACIER') then
            call nzisfw(fami, kpg, ksp, ndim, imate,&
                        compor, carcri, instam, instap, epsm,&
                        deps, sigm, vim, option, sigp,&
                        vip, dsidep, codret)
        else if (compor(META_NAME).eq.'ZIRC') then
            call nzedga(fami, kpg, ksp, ndim, imate,&
                        compor, carcri, instam, instap, epsm,&
                        deps, sigm, vim, option, sigp,&
                        vip, dsidep, codret)
        endif
    else if (compor(RELA_NAME)(8:8).eq.'C') then
        if (compor(META_NAME) .eq. 'ACIER') then
            call nzcifw(fami, kpg, ksp, ndim, imate,&
                        compor, carcri, instam, instap, epsm,&
                        deps, sigm, vim, option, sigp,&
                        vip, dsidep, codret)
        else if (compor(META_NAME).eq.'ZIRC') then
            call nzcizi(fami, kpg, ksp, ndim, imate,&
                        compor, carcri, instam, instap, epsm,&
                        deps, sigm, vim, option, sigp,&
                        vip, dsidep, codret)
        endif
    else
        ASSERT(.false.)
    endif
!
end subroutine
