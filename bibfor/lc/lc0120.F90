! --------------------------------------------------------------------
! Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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
! aslint: disable=W1504,W0104
!
subroutine lc0120(BEHinteg,&
                  fami, kpg, ksp, ndim, imate, l_epsi_varc,&
                  compor, crit, instam, instap, epsm,&
                  deps, sigm, vim, option, angmas,&
                  sigp, vip, typmod, icomp,&
                  nvi, dsidep, codret)
!
use Behaviour_type
!
implicit none
!
#include "asterfort/plasbe.h"
!
type(Behaviour_Integ), intent(in) :: BEHinteg
integer :: imate, ndim, kpg, ksp, codret, icomp, nvi
real(kind=8) :: crit(*), angmas(*)
real(kind=8) :: instam, instap
real(kind=8) :: epsm(6), deps(6)
real(kind=8) :: sigm(6), sigp(6)
real(kind=8) :: vim(*), vip(*)
real(kind=8) :: dsidep(6, 6)
character(len=16) :: compor(*), option
character(len=8) :: typmod(*)
character(len=*) :: fami
aster_logical, intent(in) :: l_epsi_varc
!
    call plasbe(BEHinteg,&
                fami, kpg, ksp, typmod, imate, l_epsi_varc,&
                crit, epsm, deps, sigm, vim,&
                option, sigp, vip, dsidep,&
                icomp, nvi, codret)
end subroutine
