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
    subroutine xxlag4(ffc, idepl, idepm, lact, ndim,&
                      nnol, pla, lamb, nvec, champ)
        real(kind=8) :: ffc(8)
        integer :: idepl
        integer :: idepm
        integer :: lact(8)
        integer :: ndim
        integer :: nnol
        integer :: pla(27)
        real(kind=8) :: lamb(3)
        integer :: nvec
        character(len=8) :: champ
    end subroutine xxlag4
end interface
