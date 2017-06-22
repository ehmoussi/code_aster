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
    subroutine ermes2(ino, typema, typmav, iref1, ivois,&
                      isig, nbcmp, dsg11, dsg22, dsg12)
        integer :: ino
        character(len=8) :: typema
        character(len=8) :: typmav
        integer :: iref1
        integer :: ivois
        integer :: isig
        integer :: nbcmp
        real(kind=8) :: dsg11(3)
        real(kind=8) :: dsg22(3)
        real(kind=8) :: dsg12(3)
    end subroutine ermes2
end interface
