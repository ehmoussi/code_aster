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
interface
    subroutine nmcpl2(compor, typmod, option, optio2, cp,&
                      nvv, crit, deps, dsidep, ndim,&
                      sigp, vip, iret)
        character(len=16) :: compor(*)
        character(len=8) :: typmod(*)
        character(len=16) :: option
        character(len=16) :: optio2
        integer :: cp
        integer :: nvv
        real(kind=8) :: crit(*)
        real(kind=8) :: deps(*)
        real(kind=8) :: dsidep(6, *)
        integer :: ndim
        real(kind=8) :: sigp(*)
        real(kind=8) :: vip(*)
        integer :: iret
    end subroutine nmcpl2
end interface
