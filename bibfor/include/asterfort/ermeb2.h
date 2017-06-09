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
    subroutine ermeb2(ino, iref1, iref2, ivois, igeom,&
                      isig, typema, nbcmp, inst, nx,&
                      ny, tx, ty, sig11, sig22,&
                      sig12, chx, chy)
        integer :: ino
        integer :: iref1
        integer :: iref2
        integer :: ivois
        integer :: igeom
        integer :: isig
        character(len=8) :: typema
        integer :: nbcmp
        real(kind=8) :: inst
        real(kind=8) :: nx(3)
        real(kind=8) :: ny(3)
        real(kind=8) :: tx(3)
        real(kind=8) :: ty(3)
        real(kind=8) :: sig11(3)
        real(kind=8) :: sig22(3)
        real(kind=8) :: sig12(3)
        real(kind=8) :: chx(3)
        real(kind=8) :: chy(3)
    end subroutine ermeb2
end interface
