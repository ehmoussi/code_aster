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
    subroutine digric(option, nomte, ndim, nbt, nno,&
                      nc, ulm, dul, pgl, iret)
        character(len=*) :: option
        character(len=*) :: nomte
        integer :: ndim
        integer :: nbt
        integer :: nno
        integer :: nc
        real(kind=8) :: ulm(12)
        real(kind=8) :: dul(12)
        real(kind=8) :: pgl(3, 3)
        integer :: iret
    end subroutine digric
end interface
