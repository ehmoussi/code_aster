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
    subroutine calnor(chdim, geom, iare, nnos, nnoa,&
                      orien, nno, npg, noe, ifa,&
                      tymvol, idfde, jac, nx, ny,&
                      nz, tx, ty, hf)
        character(len=2) :: chdim
        real(kind=8) :: geom(*)
        integer :: iare
        integer :: nnos
        integer :: nnoa
        real(kind=8) :: orien
        integer :: nno
        integer :: npg
        integer :: noe(9, 6, 4)
        integer :: ifa
        integer :: tymvol
        integer :: idfde
        real(kind=8) :: jac(9)
        real(kind=8) :: nx(9)
        real(kind=8) :: ny(9)
        real(kind=8) :: nz(9)
        real(kind=8) :: tx(3)
        real(kind=8) :: ty(3)
        real(kind=8) :: hf
    end subroutine calnor
end interface
