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

!
!
#include "asterf_types.h"
!
interface
    subroutine nmfi3d(nno, nddl, npg, lgpg, wref,&
                      vff, dfde, mate, option, geom,&
                      deplm, ddepl, sigm, sigp, fint,&
                      ktan, vim, vip, crit, compor,&
                      matsym, coopg, tm, tp, codret)
        integer :: lgpg
        integer :: npg
        integer :: nddl
        integer :: nno
        real(kind=8) :: wref(npg)
        real(kind=8) :: vff(nno, npg)
        real(kind=8) :: dfde(2, nno, npg)
        integer :: mate
        character(len=16) :: option
        real(kind=8) :: geom(nddl)
        real(kind=8) :: deplm(nddl)
        real(kind=8) :: ddepl(nddl)
        real(kind=8) :: sigm(3, npg)
        real(kind=8) :: sigp(3, npg)
        real(kind=8) :: fint(nddl)
        real(kind=8) :: ktan(*)
        real(kind=8) :: vim(lgpg, npg)
        real(kind=8) :: vip(lgpg, npg)
        real(kind=8) :: crit(*)
        character(len=16) :: compor(*)
        aster_logical :: matsym
        real(kind=8) :: coopg(4, npg)
        real(kind=8) :: tm
        real(kind=8) :: tp
        integer :: codret
    end subroutine nmfi3d
end interface
