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
    subroutine lchbr2(typmod, option, imate, carcri, sigm,&
                      epsm, depsm,&
                      vim, vip, dspdp1, dspdp2, sipp,&
                      sigp, dsidep, dsidp1, dsidp2, iret)
        character(len=8) :: typmod(*)
        character(len=16) :: option
        integer :: imate
        real(kind=8) :: carcri(*)
        real(kind=8) :: sigm(6)
        real(kind=8) :: epsm(6)
        real(kind=8) :: depsm(6)
        real(kind=8) :: vim(*)
        real(kind=8) :: vip(*)
        real(kind=8) :: dspdp1
        real(kind=8) :: dspdp2
        real(kind=8) :: sipp
        real(kind=8) :: sigp(6)
        real(kind=8) :: dsidep(6, 6)
        real(kind=8) :: dsidp1(6)
        real(kind=8) :: dsidp2(6)
        integer :: iret
    end subroutine lchbr2
end interface
