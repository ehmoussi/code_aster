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
interface
    subroutine lcdsbe(fami, ndim, imate,&
                      epstm, depst, vim, option, sig,&
                      vip, dsidpt, proj)
        character(len=*) :: fami
        integer :: ndim
        integer :: imate
        real(kind=8) :: epstm(12)
        real(kind=8) :: depst(12)
        real(kind=8) :: vim(2)
        character(len=16) :: option
        real(kind=8) :: sig(6)
        real(kind=8) :: vip(2)
        real(kind=8) :: dsidpt(6, 6, 2)
        real(kind=8) :: proj(6, 6)
    end subroutine lcdsbe
end interface
